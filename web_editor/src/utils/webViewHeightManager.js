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
 * Apply foundational height and scrolling styles to the document and the optional element with id "root".
 *
 * Sets html and body to occupy full height, ensures no max-height restriction, and makes body positioned relative.
 * If an element with id "root" exists, sets it to full height, enables scrolling (overflow: auto), positions it relative,
 * and enables WebKit touch scrolling.
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
 * Ensure the page viewport is fixed to device width and disables user scaling.
 *
 * If a <meta name="viewport"> tag exists, its content is set to:
 * "width=device-width, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0, user-scalable=no".
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
 * Ensures the editor selection or focused element is visible when the on-screen keyboard is open.
 *
 * Schedules a check after 200ms and, if the keyboard is open, scrolls the editor selection or the document's active element into view within the element with id "root" when necessary.
 *
 * @param {number} keyboardHeight - Height of the on-screen keyboard in pixels.
 * @param {Object} editor - Editor instance; expected to expose a TipTap editor at `editor._tiptapEditor`.
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
 * Adjusts the WebView layout and scrolling to match the current viewport and keyboard state.
 * @param {number} height - The available viewport height in pixels.
 * @param {number} keyboardHeight - The on-screen keyboard height in pixels (0 if closed).
 * @param {Object} editor - BlockNote editor instance used to compute and apply keyboard-related scrolling.
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