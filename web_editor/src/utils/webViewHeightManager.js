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
 * Syncs the editor's appearance (light/dark) and background color to the page so the bottom
 * padding area (keyboard/extraBottomPadding) matches the editor. Uses .bn-container's
 * data-color-scheme and --bn-colors-editor-background so it follows the editor's theme.
 * Call this when padding is applied or when theme/appearance may have changed.
 */
export function syncEditorAppearanceToPage() {
  try {
    const container = document.querySelector('.bn-container');
    const html = document.documentElement;
    const body = document.body;
    const root = document.getElementById('root');
    if (!root) return;

    if (!container) {
      // Editor not mounted yet; use Flutter theme if available
      const colors =
        currentTheme?.colors || currentTheme?.light || currentTheme?.dark;
      const editorBg = colors?.editor?.background;
      if (editorBg) {
        const c = editorBg.startsWith('#') ? editorBg : `#${editorBg}`;
        html.style.backgroundColor = c;
        body.style.backgroundColor = c;
        root.style.backgroundColor = c;
      }
      return;
    }

    const scheme = container.getAttribute('data-color-scheme');
    if (scheme) {
      html.setAttribute('data-color-scheme', scheme);
      root.setAttribute('data-color-scheme', scheme);
    }

    const computed = window.getComputedStyle(container);
    let bg =
      computed.getPropertyValue('--bn-colors-editor-background').trim() ||
      computed.backgroundColor;
    if (bg && bg !== 'rgba(0, 0, 0, 0)' && bg !== 'transparent') {
      if (bg.startsWith('var(')) bg = null;
      else if (bg && !bg.startsWith('#')) {
        const hex = rgbToHex(bg);
        if (hex) bg = hex;
      }
    }
    if (!bg || bg === 'rgba(0, 0, 0, 0)' || bg === 'transparent') {
      const editorEl = document.querySelector('.bn-editor');
      if (editorEl) {
        bg = window.getComputedStyle(editorEl).backgroundColor;
        if (
          bg &&
          bg !== 'rgba(0, 0, 0, 0)' &&
          bg !== 'transparent' &&
          !bg.startsWith('var(')
        ) {
          const hex = rgbToHex(bg);
          if (hex) bg = hex;
        } else {
          bg = null;
        }
      } else {
        bg = null;
      }
    }
    const color = bg || '#ffffff';
    html.style.backgroundColor = color;
    body.style.backgroundColor = color;
    root.style.backgroundColor = color;
  } catch {
    // Fallback: ensure a default so padding area is never transparent
    try {
      const c = '#ffffff';
      document.documentElement.style.backgroundColor = c;
      document.body.style.backgroundColor = c;
      const r = document.getElementById('root');
      if (r) r.style.backgroundColor = c;
    } catch {
      // ignore
    }
  }
}

function rgbToHex(rgb) {
  const m = rgb.match(/^rgba?\((\d+),\s*(\d+),\s*(\d+)/);
  if (!m) return null;
  const hex = (x) => {
    const h = parseInt(x, 10).toString(16);
    return h.length === 1 ? '0' + h : h;
  };
  return '#' + hex(m[1]) + hex(m[2]) + hex(m[3]);
}

/** Buffer (px) added to detected keyboard height to account for safe area, browser chrome, and viewport timing. */
const KEYBOARD_HEIGHT_BUFFER = 48;

/**
 * Detects keyboard height using visualViewport API.
 * Uses the obscured region (innerHeight minus visible region) and adds a buffer so padding is not 40–60px short.
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
    if (layoutHeight > baselineHeight + 50) {
      baselineHeight = layoutHeight;
    }

    if (!visualViewport) {
      if (baselineHeight && layoutHeight < baselineHeight - 100) {
        const calculatedHeight = baselineHeight - layoutHeight;
        return calculatedHeight > 100
          ? calculatedHeight + KEYBOARD_HEIGHT_BUFFER
          : 0;
      }
      return 0;
    }

    const visualHeight = visualViewport.height;
    const visualBottom = visualViewport.offsetTop + visualHeight;
    // When keyboard opens, WebView/layout often shrinks (innerHeight drops). Use baseline
    // (pre-keyboard layout height) so we don't under-report keyboard height as layout shrinks.
    const effectiveLayoutHeight =
      baselineHeight && layoutHeight < baselineHeight - 50
        ? baselineHeight
        : layoutHeight;
    const obscuredHeight = effectiveLayoutHeight - visualBottom;
    const heightDiff = effectiveLayoutHeight - visualHeight;

    // Keyboard is open if visual height is significantly less than layout height (50px threshold)
    if (heightDiff > 50) {
      const rawHeight = Math.max(obscuredHeight, heightDiff, 0);
      return rawHeight + KEYBOARD_HEIGHT_BUFFER;
    }

    if (baselineHeight && layoutHeight < baselineHeight - 100) {
      const calculatedHeight = baselineHeight - layoutHeight;
      return calculatedHeight > 100
        ? calculatedHeight + KEYBOARD_HEIGHT_BUFFER
        : 0;
    }

    return 0;
  } catch {
    return 0;
  }
}

/** Timeouts for delayed re-checks when extra padding is set (to pick up keyboard height after viewport updates). */
let delayedRecheckTimeoutIds = [];

/**
 * Updates the WebView bottom padding to ensure proper scrolling when keyboard opens.
 * Total padding is always: detected keyboard height + extraBottomPadding (extra is additive).
 * Keyboard detection is handled internally using visualViewport API.
 * @param {number} extraBottomPadding - Extra bottom padding in pixels (optional, defaults to 0). Always added to keyboard height.
 * @param {Object} editor - The BlockNote editor instance
 */
export function updateWebViewHeight(extraBottomPadding, editor) {
  try {
    editorInstance = editor;

    const padding = extraBottomPadding ?? 0;
    const keyboardHeight = _detectKeyboardHeight();

    if (
      lastKeyboardHeight !== null &&
      lastExtraBottomPadding !== null &&
      Math.abs(keyboardHeight - lastKeyboardHeight) < 5 &&
      Math.abs(padding - lastExtraBottomPadding) < 5
    ) {
      return;
    }

    lastKeyboardHeight = keyboardHeight;
    lastExtraBottomPadding = padding;

    if (heightUpdateRafId !== null) {
      cancelAnimationFrame(heightUpdateRafId);
    }

    heightUpdateRafId = requestAnimationFrame(() => {
      heightUpdateRafId = null;
      _performPaddingUpdate(keyboardHeight, padding, editor);
    });

    if (!isKeyboardListenerSetup) {
      _setupKeyboardListener();
    }

    // When extra padding is provided, viewport may not have updated yet. Re-check after a delay
    // so total padding = keyboard height + extra (we never use extra alone when keyboard is open).
    if (padding > 0) {
      _clearDelayedRechecks();
      const runRecheck = () => {
        const currentKeyboard = _detectKeyboardHeight();
        if (
          currentKeyboard !== lastKeyboardHeight ||
          (lastKeyboardHeight === 0 && currentKeyboard > 0)
        ) {
          lastKeyboardHeight = currentKeyboard;
          _performPaddingUpdate(currentKeyboard, padding, editor);
        }
      };
      delayedRecheckTimeoutIds = [
        setTimeout(runRecheck, 150),
        setTimeout(runRecheck, 400),
      ];
    }
  } catch (error) {
    if (window.BlockNoteDebugLogging) {
      console.error('[BlockNote] Error updating WebView padding:', error);
    }
  }
}

function _clearDelayedRechecks() {
  delayedRecheckTimeoutIds.forEach((id) => clearTimeout(id));
  delayedRecheckTimeoutIds = [];
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
    _clearDelayedRechecks();
    if (heightUpdateRafId !== null) {
      cancelAnimationFrame(heightUpdateRafId);
    }
    heightUpdateRafId = requestAnimationFrame(() => {
      heightUpdateRafId = null;
      updateWebViewHeight(lastExtraBottomPadding, editorInstance);
    });
  }
}

/**
 * Performs the actual bottom padding update DOM manipulation.
 * Total padding is always keyboard height + extraBottomPadding (extra is additive; we never use extra alone when keyboard is open).
 * @private
 */
function _performPaddingUpdate(keyboardHeight, extraBottomPadding, editor) {
  try {
    const html = document.documentElement;
    const body = document.body;
    const root = document.getElementById('root');

    // Always add extra to keyboard height so both apply (never ignore keyboard when extra is provided)
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

      // Sync page background to editor appearance (light/dark) and color from .bn-container
      syncEditorAppearanceToPage();

      // Only apply padding if keyboard is actually open or extra padding is provided
      // This prevents white space when keyboard closes
      if (keyboardHeight > 0 || extraBottomPadding > 0) {
        root.style.paddingBottom = `${totalBottomPadding}px`;
      } else {
        root.style.paddingBottom = '0px';
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
