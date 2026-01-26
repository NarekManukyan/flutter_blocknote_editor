/**
 * WebView height management utility.
 * Handles updating WebView bottom padding and ensuring proper scrolling.
 * Keyboard detection is handled internally using visualViewport API.
 */

// Cache last padding values to avoid unnecessary updates
let lastKeyboardHeight = null;
let lastExtraBottomPadding = null;
let heightUpdateRafId = null;
let scrollCheckRafId = null;
let baselineHeight = null;
let editorInstance = null;
let isKeyboardListenerSetup = false;
let transitionEndHandler = null;
let fallbackTimeoutId = null;

// Store theme globally so webViewHeightManager can access it
let currentTheme = null;

/**
 * Sets the current theme for background color detection.
 * Called from useThemeBackground hook when theme changes.
 * @param {Object} theme - Theme object from Flutter
 */
export function setTheme(theme) {
  currentTheme = theme;
}

/**
 * Detects keyboard height using visualViewport API.
 * @returns {number} Keyboard height in pixels, or 0 if keyboard is closed
 */
function _detectKeyboardHeight() {
  try {
    const visualViewport = window.visualViewport;
    const layoutHeight = window.innerHeight;

    // Initialize baseline on first call if not set
    if (!baselineHeight && layoutHeight > 500) {
      baselineHeight = layoutHeight;
    }

    // Update baseline when keyboard is clearly closed (large height)
    // Only update if we're getting a significantly larger height
    if (layoutHeight > baselineHeight + 50) {
      baselineHeight = layoutHeight;
    }

    if (!visualViewport) {
      // Fallback: use baseline comparison if visualViewport is not available
      if (baselineHeight && layoutHeight < baselineHeight - 100) {
        const calculatedHeight = baselineHeight - layoutHeight;
        // Only return if the difference is significant (keyboard is likely open)
        return calculatedHeight > 100 ? calculatedHeight : 0;
      }
      return 0;
    }

    const visualHeight = visualViewport.height;
    const heightDiff = layoutHeight - visualHeight;

    // Keyboard is open if visual height is significantly less than layout height
    // Use 50px threshold to account for browser UI and avoid false positives
    if (heightDiff > 50) {
      return heightDiff;
    }

    // Also check against baseline if available
    // This helps catch cases where visualViewport might not update immediately
    if (baselineHeight && layoutHeight < baselineHeight - 100) {
      const calculatedHeight = baselineHeight - layoutHeight;
      // Only return if the difference is significant
      return calculatedHeight > 100 ? calculatedHeight : 0;
    }

    return 0;
  } catch {
    return 0;
  }
}

/**
 * Updates the WebView bottom padding to ensure proper scrolling when keyboard opens.
 * Keyboard detection is handled internally using visualViewport API.
 * @param {number} extraBottomPadding - Extra bottom padding in pixels (optional, defaults to 0)
 * @param {Object} editor - The BlockNote editor instance
 */
export function updateWebViewHeight(extraBottomPadding, editor) {
  try {
    // Store editor instance for keyboard listener
    editorInstance = editor;

    // Default extraBottomPadding to 0 if not provided
    const padding = extraBottomPadding ?? 0;

    // Detect keyboard height internally
    const keyboardHeight = _detectKeyboardHeight();

    // Skip update if padding hasn't changed significantly (more than 5 pixels)
    // This prevents excessive DOM updates during keyboard animations
    if (
      lastKeyboardHeight !== null &&
      lastExtraBottomPadding !== null &&
      Math.abs(keyboardHeight - lastKeyboardHeight) < 5 &&
      Math.abs(padding - lastExtraBottomPadding) < 5
    ) {
      return;
    }

    // Update cached values
    lastKeyboardHeight = keyboardHeight;
    lastExtraBottomPadding = padding;

    // Cancel any pending padding update
    if (heightUpdateRafId !== null) {
      cancelAnimationFrame(heightUpdateRafId);
    }

    // Use requestAnimationFrame to batch DOM updates
    heightUpdateRafId = requestAnimationFrame(() => {
      heightUpdateRafId = null;
      _performPaddingUpdate(keyboardHeight, padding, editor);
    });

    // Set up keyboard listener if not already set up
    if (!isKeyboardListenerSetup) {
      _setupKeyboardListener();
    }
  } catch (error) {
    if (window.BlockNoteDebugLogging) {
      console.error('[BlockNote] Error updating WebView padding:', error);
    }
  }
}

/**
 * Sets up visualViewport listener to detect keyboard open/close events.
 * @private
 */
function _setupKeyboardListener() {
  if (isKeyboardListenerSetup) return;
  if (!window.visualViewport) {
    // Fallback: use window resize if visualViewport is not available
    window.addEventListener('resize', _handleKeyboardChange);
    isKeyboardListenerSetup = true;
    return;
  }

  try {
    // Listen for viewport resize events (keyboard open/close)
    window.visualViewport.addEventListener('resize', _handleKeyboardChange);
    // Also listen to window resize as fallback
    window.addEventListener('resize', _handleKeyboardChange);

    isKeyboardListenerSetup = true;
  } catch (error) {
    if (window.BlockNoteDebugLogging) {
      console.error('[BlockNote] Error setting up keyboard listener:', error);
    }
    // Fallback to window resize
    window.addEventListener('resize', _handleKeyboardChange);
    isKeyboardListenerSetup = true;
  }
}

/**
 * Handles keyboard open/close events.
 * @private
 */
function _handleKeyboardChange() {
  if (editorInstance && lastExtraBottomPadding !== null) {
    // Use requestAnimationFrame to debounce rapid changes
    if (heightUpdateRafId !== null) {
      cancelAnimationFrame(heightUpdateRafId);
    }
    heightUpdateRafId = requestAnimationFrame(() => {
      heightUpdateRafId = null;
      // Re-detect keyboard and update padding
      updateWebViewHeight(lastExtraBottomPadding, editorInstance);
    });
  }
}

/**
 * Performs the actual bottom padding update DOM manipulation.
 * @private
 */
function _performPaddingUpdate(keyboardHeight, extraBottomPadding, editor) {
  try {
    const html = document.documentElement;
    const body = document.body;
    const root = document.getElementById('root');

    // Calculate total bottom padding (keyboard height + extra padding)
    const totalBottomPadding = keyboardHeight + extraBottomPadding;

    // Set html and body to full height
    html.style.height = '100%';
    html.style.maxHeight = 'none';
    html.style.minHeight = '100%';
    // Don't set overflow: hidden on html to allow popups to render

    body.style.height = '100%';
    body.style.maxHeight = 'none';
    body.style.minHeight = '100%';
    // Don't set overflow: hidden on body - popups are rendered as direct children via React portals
    body.style.position = 'relative';

    // Set root to full height with scrolling enabled and bottom padding
    if (root) {
      root.style.height = '100%';
      root.style.maxHeight = 'none';
      root.style.minHeight = '100%';
      root.style.overflow = 'auto';
      root.style.position = 'relative';
      root.style.webkitOverflowScrolling = 'touch'; // Enable smooth scrolling on iOS

      // Add CSS transition for smooth padding animation (similar to Flutter's viewInsets)
      // 250ms matches typical keyboard animation duration
      root.style.transition = 'padding-bottom 0.25s ease-out';

      // Get editor background color to ensure padding area matches
      // Background color should already be set by useThemeBackground hook
      // #region agent log
      console.log('[DEBUG] Background color detection start', {
        keyboardHeight,
        totalBottomPadding,
        hasRoot: !!root,
        hypothesisId: 'A,B',
      });
      // #endregion
      try {
        const computedStyle = window.getComputedStyle(root);
        const rootComputedBg = computedStyle.backgroundColor;
        const rootStyleBg = root.style.backgroundColor;
        const bodyComputedBg = window.getComputedStyle(
          document.body,
        ).backgroundColor;
        const htmlComputedBg = window.getComputedStyle(
          document.documentElement,
        ).backgroundColor;

        // Try to get background from BlockNote editor container element
        // This is more reliable than root/body/html which might not have background set
        let editorContainerBg = null;
        try {
          const editorContainer = document.querySelector('.bn-container');
          if (editorContainer) {
            editorContainerBg =
              window.getComputedStyle(editorContainer).backgroundColor;
          }
        } catch {
          // Ignore if editor container not found
        }

        // Try to get background from BlockNoteView wrapper
        let editorViewBg = null;
        try {
          const editorView =
            document.querySelector('[data-blocknote-view]') ||
            document.querySelector('.bn-block-content') ||
            document.querySelector('.bn-editor');
          if (editorView) {
            editorViewBg = window.getComputedStyle(editorView).backgroundColor;
          }
        } catch {
          // Ignore if editor view not found
        }

        // Helper function to check if a color is valid (non-transparent)
        const isValidColor = (color) => {
          return (
            color &&
            color !== 'rgba(0, 0, 0, 0)' &&
            color !== 'transparent' &&
            color !== 'initial' &&
            color !== 'inherit' &&
            color !== ''
          );
        };

        // Try to get background color from theme object first (highest priority)
        // This ensures we use the actual theme color even if useThemeBackground hasn't applied it yet
        let themeBgColor = null;
        if (currentTheme) {
          try {
            const colors =
              currentTheme.colors || currentTheme.light || currentTheme.dark;
            const editorBackground = colors?.editor?.background;
            if (editorBackground) {
              themeBgColor = editorBackground.startsWith('#')
                ? editorBackground
                : `#${editorBackground}`;
            }
          } catch {
            // Ignore if theme parsing fails
          }
        }

        // Priority: theme > editor container > editor view > root computed > root style > body > html
        // Only use colors that are valid (non-transparent)
        let bgColor = null;
        if (isValidColor(themeBgColor)) {
          bgColor = themeBgColor;
        } else if (isValidColor(editorContainerBg)) {
          bgColor = editorContainerBg;
        } else if (isValidColor(editorViewBg)) {
          bgColor = editorViewBg;
        } else if (isValidColor(rootComputedBg)) {
          bgColor = rootComputedBg;
        } else if (isValidColor(rootStyleBg)) {
          bgColor = rootStyleBg;
        } else if (isValidColor(bodyComputedBg)) {
          bgColor = bodyComputedBg;
        } else if (isValidColor(htmlComputedBg)) {
          bgColor = htmlComputedBg;
        }

        // #region agent log
        console.log('[DEBUG] Background colors detected', {
          rootComputedBg,
          rootStyleBg,
          bodyComputedBg,
          htmlComputedBg,
          editorContainerBg,
          editorViewBg,
          themeBgColor,
          hasTheme: !!currentTheme,
          selectedBgColor: bgColor,
          isValid:
            bgColor &&
            bgColor !== 'rgba(0, 0, 0, 0)' &&
            bgColor !== 'transparent' &&
            bgColor !== 'initial' &&
            bgColor !== 'inherit',
          hypothesisId: 'A,B',
        });
        // #endregion

        // Ensure root, body, and html all have background color set
        // This ensures padding area matches editor background
        // If no valid color found, use white as fallback (default editor background)
        if (isValidColor(bgColor)) {
          root.style.backgroundColor = bgColor;
          // Also ensure body and html have the same background
          // This prevents white space showing through padding
          body.style.backgroundColor = bgColor;
          html.style.backgroundColor = bgColor;
          // #region agent log
          console.log('[DEBUG] Background color applied', {
            bgColor,
            appliedToRoot: true,
            appliedToBody: true,
            appliedToHtml: true,
            hypothesisId: 'B',
          });
          // #endregion
        } else {
          // Fallback: use white background if no valid color found
          // This prevents white space from showing through padding
          const fallbackBg = '#ffffff';
          root.style.backgroundColor = fallbackBg;
          body.style.backgroundColor = fallbackBg;
          html.style.backgroundColor = fallbackBg;
          // #region agent log
          console.log('[DEBUG] Background color invalid, using fallback', {
            bgColor,
            rootComputedBg,
            rootStyleBg,
            bodyComputedBg,
            editorContainerBg,
            editorViewBg,
            fallbackBg,
            hypothesisId: 'A',
          });
          // #endregion
        }
      } catch (error) {
        // #region agent log
        console.log('[DEBUG] Error getting background color', {
          error: error?.message,
          hypothesisId: 'A',
        });
        // #endregion
        // Fallback: set white background on error
        try {
          const fallbackBg = '#ffffff';
          root.style.backgroundColor = fallbackBg;
          body.style.backgroundColor = fallbackBg;
          html.style.backgroundColor = fallbackBg;
        } catch {
          // Silently fail
        }
      }

      // #region agent log
      console.log('[DEBUG] Padding about to be set', {
        keyboardHeight,
        extraBottomPadding,
        totalBottomPadding,
        rootFinalBg: root?.style?.backgroundColor,
        bodyFinalBg: body?.style?.backgroundColor,
        htmlFinalBg: html?.style?.backgroundColor,
        hypothesisId: 'C,D',
      });
      // #endregion

      // Only apply padding if keyboard is actually open or extra padding is provided
      // This prevents white space when keyboard closes
      if (keyboardHeight > 0 || extraBottomPadding > 0) {
        root.style.paddingBottom = `${totalBottomPadding}px`;
        // #region agent log
        console.log('[DEBUG] Padding applied', {
          totalBottomPadding,
          keyboardHeight,
          extraBottomPadding,
          rootBgAfter: root.style.backgroundColor,
          bodyBgAfter: body.style.backgroundColor,
          htmlBgAfter: html.style.backgroundColor,
          rootComputedBgAfter: window.getComputedStyle(root).backgroundColor,
          hypothesisId: 'C,D',
        });
        // #endregion
      } else {
        // Remove padding when keyboard is closed and no extra padding
        root.style.paddingBottom = '0px';
        // #region agent log
        console.log('[DEBUG] Padding removed', {
          keyboardHeight,
          extraBottomPadding,
          hypothesisId: 'C',
        });
        // #endregion
      }
    }

    // Use requestAnimationFrame for better performance than setTimeout
    requestAnimationFrame(() => {
      try {
        // Force a layout recalculation
        if (root) {
          // Trigger reflow to ensure padding is applied correctly
          void root.offsetHeight;

          // Ensure root can scroll if content overflows
          if (root.scrollHeight > root.clientHeight) {
            if (
              root.style.overflow !== 'auto' &&
              root.style.overflow !== 'scroll'
            ) {
              root.style.overflow = 'auto';
            }
          }
        }
      } catch {
        // Silently fail
      }
    });

    // Update viewport height for proper scrolling
    const viewport = document.querySelector('meta[name="viewport"]');
    if (viewport) {
      viewport.setAttribute(
        'content',
        'width=device-width, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0, user-scalable=no',
      );
    }

    // Trigger resize event for editor to recalculate layout
    window.dispatchEvent(new Event('resize'));

    // After padding change (especially when keyboard opens/closes), ensure focused block is scrolled into view
    // Use transitionend event to trigger scroll after CSS animation completes
    // This ensures smooth scrolling that works with the padding animation
    if (scrollCheckRafId !== null) {
      cancelAnimationFrame(scrollCheckRafId);
    }

    // Remove previous transitionend handler and clear fallback timeout if they exist
    if (transitionEndHandler && root) {
      root.removeEventListener('transitionend', transitionEndHandler);
      transitionEndHandler = null;
    }
    if (fallbackTimeoutId !== null) {
      clearTimeout(fallbackTimeoutId);
      fallbackTimeoutId = null;
    }

    // Set up transitionend handler to trigger scroll after animation
    // Only set up if keyboard is open (padding is being added)
    if (root && keyboardHeight > 0) {
      let hasScrolled = false;

      transitionEndHandler = (event) => {
        // Only handle padding-bottom transitions
        if (event.propertyName === 'padding-bottom' && !hasScrolled) {
          hasScrolled = true;
          if (fallbackTimeoutId !== null) {
            clearTimeout(fallbackTimeoutId);
            fallbackTimeoutId = null;
          }
          if (scrollCheckRafId !== null) {
            cancelAnimationFrame(scrollCheckRafId);
            scrollCheckRafId = null;
          }
          root.removeEventListener('transitionend', transitionEndHandler);
          transitionEndHandler = null;
          _scrollToSelectionAfterHeightChange(keyboardHeight, editor);
        }
      };

      root.addEventListener('transitionend', transitionEndHandler);

      // Fallback: Use reduced RAF calls + timeout if transitionend doesn't fire
      // This handles cases where transitions might be disabled or not supported
      scrollCheckRafId = requestAnimationFrame(() => {
        // Second RAF: Wait for layout recalculation
        scrollCheckRafId = requestAnimationFrame(() => {
          scrollCheckRafId = null;
          // Only trigger scroll if transitionend hasn't already fired
          // Use a timeout to give transitionend a chance to fire first
          fallbackTimeoutId = setTimeout(() => {
            if (transitionEndHandler && root && !hasScrolled) {
              // Transitionend didn't fire, use fallback scroll
              hasScrolled = true;
              root.removeEventListener('transitionend', transitionEndHandler);
              transitionEndHandler = null;
              fallbackTimeoutId = null;
              _scrollToSelectionAfterHeightChange(keyboardHeight, editor);
            }
          }, 300); // 300ms gives transition time to complete (250ms + buffer)
        });
      });
    } else {
      // Keyboard is closed, don't scroll (user might be closing keyboard intentionally)
      scrollCheckRafId = requestAnimationFrame(() => {
        scrollCheckRafId = requestAnimationFrame(() => {
          scrollCheckRafId = null;
          // Don't scroll when keyboard is closing
        });
      });
    }
  } catch (error) {
    if (window.BlockNoteDebugLogging) {
      console.error('[BlockNote] Error updating WebView padding:', error);
    }
  }
}

/**
 * Scrolls to the current selection after height changes have settled.
 * This is called after the DOM has had time to update and recalculate layout.
 * @private
 */
function _scrollToSelectionAfterHeightChange(keyboardHeight, editor) {
  try {
    if (!editor) {
      return;
    }

    // Re-detect keyboard state to ensure accuracy
    const detectedKeyboardHeight = _detectKeyboardHeight();
    const keyboardOpen = detectedKeyboardHeight > 0 || keyboardHeight > 0;

    // Only scroll if keyboard is actually open
    // This prevents unnecessary scrolling when keyboard is closing
    if (!keyboardOpen) {
      return;
    }

    // Use BlockNote's built-in method to get cursor position
    // This is more reliable than accessing internal ProseMirror APIs
    try {
      const cursorPosition = editor.getTextCursorPosition();
      if (cursorPosition && cursorPosition.block) {
        // Use ProseMirror's built-in scrollIntoView which handles everything
        // This is the recommended way according to BlockNote docs
        if (editor._tiptapEditor && editor._tiptapEditor.view) {
          const proseMirrorView = editor._tiptapEditor.view;
          // ProseMirror's scrollIntoView automatically handles visibility checks
          proseMirrorView.dispatch(proseMirrorView.state.tr.scrollIntoView());
        }
      } else {
        // Fallback: if cursor position is not available, try direct scroll
        if (editor._tiptapEditor && editor._tiptapEditor.view) {
          const proseMirrorView = editor._tiptapEditor.view;
          proseMirrorView.dispatch(proseMirrorView.state.tr.scrollIntoView());
        }
      }
    } catch {
      // Fallback: if BlockNote API fails, use ProseMirror directly
      if (editor._tiptapEditor && editor._tiptapEditor.view) {
        const proseMirrorView = editor._tiptapEditor.view;
        proseMirrorView.dispatch(proseMirrorView.state.tr.scrollIntoView());
      }
    }
  } catch {
    // Silently fail
  }
}
