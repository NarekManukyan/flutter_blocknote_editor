/**
 * WebView height management utility.
 * Handles updating WebView height and ensuring proper scrolling.
 */

import {
  isKeyboardOpen,
  checkSelectionScrollNeeded,
  checkActiveElementScrollNeeded,
  scrollSelectionIfNeeded,
  scrollActiveElementIfNeeded,
} from './scrollHelpers';

/**
 * Sets up basic height styles for HTML, body, and root elements.
 */
function setupHeightStyles() {
  const html = document.documentElement;
  const body = document.body;
  const root = document.getElementById('root');

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
  }
}

/**
 * Ensures root can scroll if content overflows.
 */
function ensureRootScrollability(root) {
  if (!root) return;

  setTimeout(() => {
    try {
      void root.offsetHeight; // Force reflow

      if (root.scrollHeight > root.clientHeight) {
        if (
          root.style.overflow !== 'auto' &&
          root.style.overflow !== 'scroll'
        ) {
          root.style.overflow = 'auto';
        }
      }

      if (!root.style.height || root.style.height === 'auto') {
        root.style.height = '100%';
      }
    } catch {
      // Silently fail
    }
  }, 100);
}

/**
 * Updates viewport meta tag.
 */
function updateViewportMeta() {
  const viewport = document.querySelector('meta[name="viewport"]');
  if (viewport) {
    viewport.setAttribute(
      'content',
      'width=device-width, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0, user-scalable=no',
    );
  }
}

/**
 * Handles scrolling after keyboard opens/closes.
 */
function handleKeyboardScroll(keyboardHeight, editor) {
  setTimeout(() => {
    try {
      if (!isKeyboardOpen(keyboardHeight)) {
        return;
      }

      const root = document.getElementById('root');
      const proseMirrorView =
        editor && editor._tiptapEditor ? editor._tiptapEditor.view : null;

      const { needed: selectionScrollNeeded } = checkSelectionScrollNeeded(
        proseMirrorView,
        root,
      );

      const activeElement = document.activeElement;
      const activeScrollNeeded = checkActiveElementScrollNeeded(
        activeElement,
        root,
      );

      if (!selectionScrollNeeded && !activeScrollNeeded) {
        return;
      }

      scrollSelectionIfNeeded(editor, selectionScrollNeeded);
      scrollActiveElementIfNeeded(activeElement, root);
    } catch {
      // Silently fail
    }
  }, 200);
}

/**
 * Updates the WebView height to ensure proper scrolling.
 * @param {number} height - Available height in pixels
 * @param {number} keyboardHeight - Keyboard height in pixels
 * @param {Object} editor - The BlockNote editor instance
 */
export function updateWebViewHeight(height, keyboardHeight, editor) {
  try {
    setupHeightStyles();

    const root = document.getElementById('root');
    ensureRootScrollability(root);
    updateViewportMeta();

    window.dispatchEvent(new Event('resize'));
    handleKeyboardScroll(keyboardHeight, editor);
  } catch (error) {
    console.error('[BlockNote] Error updating WebView height:', error);
  }
}
