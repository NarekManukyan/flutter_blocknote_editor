/**
 * WebView height management utility.
 * Handles updating WebView bottom padding and ensuring proper scrolling.
 * Keyboard detection is handled internally using visualViewport API.
 */

// --- Module state ---
let lastKeyboardHeight = null;
let lastExtraBottomPadding = null;
let heightUpdateRafId = null;
let scrollCheckRafId = null;
let baselineHeight = null;
let editorInstance = null;
let isKeyboardListenerSetup = false;
let transitionEndHandler = null;
let fallbackTimeoutId = null;
let delayedRecheckTimeoutIds = [];
let currentTheme = null;

/** Buffer (px) added to detected keyboard height for safe area / browser chrome. */
const KEYBOARD_HEIGHT_BUFFER = 48;

/**
 * Sets the current theme for background color detection.
 * @param {Object} theme - Theme object from Flutter
 */
export function setTheme(theme) {
  currentTheme = theme;
}

/**
 * Syncs the editor's appearance (light/dark) and background color to html/body/#root
 * so the padding area matches the editor.
 */
export function syncEditorAppearanceToPage() {
  try {
    const html = document.documentElement;
    const body = document.body;
    const root = document.getElementById('root');
    if (!root) return;

    const container = document.querySelector('.bn-container');

    if (!container) {
      // Editor not mounted yet; use Flutter theme if available
      const colors = currentTheme?.colors || currentTheme?.light || currentTheme?.dark;
      const editorBg = colors?.editor?.background;
      if (editorBg) {
        const c = editorBg.startsWith('#') ? editorBg : `#${editorBg}`;
        html.style.backgroundColor = c;
        body.style.backgroundColor = c;
        root.style.backgroundColor = c;
      }
      return;
    }

    // Sync data-color-scheme
    const scheme = container.getAttribute('data-color-scheme');
    if (scheme) {
      html.setAttribute('data-color-scheme', scheme);
      root.setAttribute('data-color-scheme', scheme);
    }

    // Detect background color from editor
    const color = _detectEditorBackground(container) || '#ffffff';
    html.style.backgroundColor = color;
    body.style.backgroundColor = color;
    root.style.backgroundColor = color;
  } catch {
    // Fallback: ensure a default so padding area is never transparent
    _applyFallbackBackground();
  }
}

/**
 * Detect the editor's background color from CSS variables or computed styles.
 * @param {Element} container - The .bn-container element
 * @returns {string|null}
 */
function _detectEditorBackground(container) {
  const computed = window.getComputedStyle(container);
  let bg =
    computed.getPropertyValue('--bn-colors-editor-background').trim() ||
    computed.backgroundColor;

  if (_isValidColor(bg)) return _normalizeColor(bg);

  // Fallback: check .bn-editor
  const editorEl = document.querySelector('.bn-editor');
  if (editorEl) {
    bg = window.getComputedStyle(editorEl).backgroundColor;
    if (_isValidColor(bg)) return _normalizeColor(bg);
  }

  return null;
}

function _isValidColor(bg) {
  return (
    bg &&
    bg !== 'rgba(0, 0, 0, 0)' &&
    bg !== 'transparent' &&
    !bg.startsWith('var(')
  );
}

function _normalizeColor(bg) {
  if (bg.startsWith('#')) return bg;
  return _rgbToHex(bg) || bg;
}

function _applyFallbackBackground() {
  try {
    document.documentElement.style.backgroundColor = '#ffffff';
    document.body.style.backgroundColor = '#ffffff';
    const r = document.getElementById('root');
    if (r) r.style.backgroundColor = '#ffffff';
  } catch {
    // ignore
  }
}

function _rgbToHex(rgb) {
  const m = rgb.match(/^rgba?\((\d+),\s*(\d+),\s*(\d+)/);
  if (!m) return null;
  const hex = (x) => parseInt(x, 10).toString(16).padStart(2, '0');
  return '#' + hex(m[1]) + hex(m[2]) + hex(m[3]);
}

/**
 * Detects keyboard height using visualViewport API.
 * @returns {number} Keyboard height in pixels, or 0 if closed
 */
function _detectKeyboardHeight() {
  try {
    const layoutHeight = window.innerHeight;

    // Initialize / update baseline when keyboard is clearly closed
    if (!baselineHeight && layoutHeight > 500) {
      baselineHeight = layoutHeight;
    }
    if (layoutHeight > baselineHeight + 50) {
      baselineHeight = layoutHeight;
    }

    const vp = window.visualViewport;
    if (!vp) {
      return _fallbackKeyboardDetection(layoutHeight);
    }

    const effectiveLayoutHeight =
      baselineHeight && layoutHeight < baselineHeight - 50
        ? baselineHeight
        : layoutHeight;

    const visualBottom = vp.offsetTop + vp.height;
    const obscuredHeight = effectiveLayoutHeight - visualBottom;
    const heightDiff = effectiveLayoutHeight - vp.height;

    // Keyboard open if visual height < layout height by >50px
    if (heightDiff > 50) {
      return Math.max(obscuredHeight, heightDiff, 0) + KEYBOARD_HEIGHT_BUFFER;
    }

    return _fallbackKeyboardDetection(layoutHeight);
  } catch {
    return 0;
  }
}

function _fallbackKeyboardDetection(layoutHeight) {
  if (baselineHeight && layoutHeight < baselineHeight - 100) {
    const calculated = baselineHeight - layoutHeight;
    return calculated > 100 ? calculated + KEYBOARD_HEIGHT_BUFFER : 0;
  }
  return 0;
}

function _clearDelayedRechecks() {
  delayedRecheckTimeoutIds.forEach((id) => clearTimeout(id));
  delayedRecheckTimeoutIds = [];
}

/**
 * Updates the WebView bottom padding for keyboard handling.
 * Total padding = detected keyboard height + extraBottomPadding.
 * @param {number} extraBottomPadding - Extra bottom padding in pixels (default 0)
 * @param {Object} editor - The BlockNote editor instance
 */
export function updateWebViewHeight(extraBottomPadding, editor) {
  try {
    editorInstance = editor;
    const padding = extraBottomPadding ?? 0;
    const keyboardHeight = _detectKeyboardHeight();

    // Skip if values haven't changed significantly
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

    if (heightUpdateRafId !== null) cancelAnimationFrame(heightUpdateRafId);
    heightUpdateRafId = requestAnimationFrame(() => {
      heightUpdateRafId = null;
      _performPaddingUpdate(keyboardHeight, padding, editor);
    });

    if (!isKeyboardListenerSetup) _setupKeyboardListener();

    // Re-check after delays when extra padding provided (viewport may not have updated yet)
    if (padding > 0) {
      _clearDelayedRechecks();
      const runRecheck = () => {
        const currentKeyboard = _detectKeyboardHeight();
        if (currentKeyboard !== lastKeyboardHeight) {
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

function _setupKeyboardListener() {
  if (isKeyboardListenerSetup) return;

  try {
    window.visualViewport?.addEventListener('resize', _handleKeyboardChange);
  } catch {
    // visualViewport not available
  }
  window.addEventListener('resize', _handleKeyboardChange);
  isKeyboardListenerSetup = true;
}

function _handleKeyboardChange() {
  if (!editorInstance || lastExtraBottomPadding === null) return;

  _clearDelayedRechecks();
  if (heightUpdateRafId !== null) cancelAnimationFrame(heightUpdateRafId);
  heightUpdateRafId = requestAnimationFrame(() => {
    heightUpdateRafId = null;
    updateWebViewHeight(lastExtraBottomPadding, editorInstance);
  });
}

function _performPaddingUpdate(keyboardHeight, extraBottomPadding, editor) {
  try {
    const root = document.getElementById('root');
    const totalBottomPadding = keyboardHeight + extraBottomPadding;

    // Set html/body to full height
    const html = document.documentElement;
    const body = document.body;
    html.style.height = '100%';
    html.style.maxHeight = 'none';
    html.style.minHeight = '100%';
    body.style.height = '100%';
    body.style.maxHeight = 'none';
    body.style.minHeight = '100%';
    body.style.position = 'relative';

    if (root) {
      root.style.height = '100%';
      root.style.maxHeight = 'none';
      root.style.minHeight = '100%';
      root.style.overflow = 'auto';
      root.style.position = 'relative';
      root.style.webkitOverflowScrolling = 'touch';
      root.style.transition = 'padding-bottom 0.25s ease-out';

      syncEditorAppearanceToPage();

      root.style.paddingBottom =
        keyboardHeight > 0 || extraBottomPadding > 0
          ? `${totalBottomPadding}px`
          : '0px';
    }

    // Update viewport meta
    const viewport = document.querySelector('meta[name="viewport"]');
    if (viewport) {
      viewport.setAttribute(
        'content',
        'width=device-width, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0, user-scalable=no',
      );
    }

    window.dispatchEvent(new Event('resize'));

    // Scroll cursor into view after padding animation
    _cleanupScrollHandlers(root);

    if (root && keyboardHeight > 0) {
      _setupScrollAfterTransition(root, keyboardHeight, editor);
    }
  } catch (error) {
    if (window.BlockNoteDebugLogging) {
      console.error('[BlockNote] Error updating WebView padding:', error);
    }
  }
}

function _cleanupScrollHandlers(root) {
  if (scrollCheckRafId !== null) {
    cancelAnimationFrame(scrollCheckRafId);
    scrollCheckRafId = null;
  }
  if (transitionEndHandler && root) {
    root.removeEventListener('transitionend', transitionEndHandler);
    transitionEndHandler = null;
  }
  if (fallbackTimeoutId !== null) {
    clearTimeout(fallbackTimeoutId);
    fallbackTimeoutId = null;
  }
}

function _setupScrollAfterTransition(root, keyboardHeight, editor) {
  let hasScrolled = false;

  const doScroll = () => {
    if (hasScrolled) return;
    hasScrolled = true;
    _cleanupScrollHandlers(root);
    _scrollToSelection(keyboardHeight, editor);
  };

  // Primary: transitionend event
  transitionEndHandler = (event) => {
    if (event.propertyName === 'padding-bottom') doScroll();
  };
  root.addEventListener('transitionend', transitionEndHandler);

  // Fallback: timeout in case transition doesn't fire
  fallbackTimeoutId = setTimeout(doScroll, 300);
}

/**
 * Scrolls to the current selection after height changes.
 */
function _scrollToSelection(keyboardHeight, editor) {
  try {
    if (!editor) return;

    const keyboardOpen = _detectKeyboardHeight() > 0 || keyboardHeight > 0;
    if (!keyboardOpen) return;

    const view = editor._tiptapEditor?.view;
    if (view) {
      view.dispatch(view.state.tr.scrollIntoView());
    }
  } catch {
    // Silently fail
  }
}
