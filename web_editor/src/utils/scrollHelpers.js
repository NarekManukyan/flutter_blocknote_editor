/**
 * Scroll helper utilities.
 * Extracted from webViewHeightManager to reduce complexity.
 */

import { getSelectionVisibility } from './selectionVisibility';

/**
 * Determine whether the on-screen keyboard is open.
 * @param {number} keyboardHeight - Height of the on-screen keyboard in pixels (0 if unknown or closed).
 * @returns {boolean} `true` if the on-screen keyboard is open, `false` otherwise.
 */
export function isKeyboardOpen(keyboardHeight) {
  const visualViewport = window.visualViewport;
  if (!visualViewport) return keyboardHeight > 0;
  const visualHeight = visualViewport.height;
  const layoutHeight = window.innerHeight;
  return keyboardHeight > 0 || visualHeight < layoutHeight - 24;
}

/**
 * Determine whether the current ProseMirror selection must be scrolled into view.
 *
 * @param {object} proseMirrorView - The ProseMirror view instance containing state and selection.
 * @param {Element} root - The root DOM element used to evaluate selection visibility.
 * @returns {{needed: boolean, data: object|null}} `needed` is true if the selection is not fully visible and should be scrolled; `data` is visibility details when available, `null` when visibility could not be determined, or an object with an `error` message if evaluation failed.
 */
export function checkSelectionScrollNeeded(proseMirrorView, root) {
  if (!proseMirrorView || !root) {
    return { needed: false, data: null };
  }

  try {
    const selection = proseMirrorView.state?.selection;
    if (!selection) {
      return { needed: false, data: null };
    }

    const visibility = getSelectionVisibility(proseMirrorView, root);
    if (!visibility) {
      return { needed: false, data: null };
    }

    return {
      needed: !visibility.isVisible,
      data: visibility,
    };
  } catch (err) {
    return {
      needed: true,
      data: { error: err?.message || 'selection coords failed' },
    };
  }
}

/**
 * Determine whether the active element is fully visible within the root's vertical bounds.
 * @param {Element|null} activeElement - The element that currently has focus (may be null).
 * @param {Element} root - The container element used as the viewport for visibility checks.
 * @returns {boolean} `true` if the element is not fully contained within the root's top/bottom bounds, `false` otherwise.
 */
export function checkActiveElementScrollNeeded(activeElement, root) {
  if (!activeElement || !root || !root.contains(activeElement)) {
    return false;
  }

  const rootRect = root.getBoundingClientRect();
  const elementRect = activeElement.getBoundingClientRect();
  return !(
    elementRect.top >= rootRect.top && elementRect.bottom <= rootRect.bottom
  );
}

/**
 * Scroll the ProseMirror selection into view when the editor is present and scrolling is requested.
 * @param {Object} editor - Editor instance that contains a `_tiptapEditor.view` ProseMirror view.
 * @param {boolean} selectionScrollNeeded - If `true`, perform the scroll; if `false`, no action is taken.
 */
export function scrollSelectionIfNeeded(editor, selectionScrollNeeded) {
  if (!editor || !editor._tiptapEditor || !selectionScrollNeeded) {
    return;
  }

  const proseMirrorView = editor._tiptapEditor.view;
  if (proseMirrorView) {
    proseMirrorView.dispatch(proseMirrorView.state.tr.scrollIntoView());
  }
}

/**
 * Ensure the active element is scrolled into view within the given root when it is not fully vertically visible.
 * @param {Element | HTMLElement} activeElement - The element that should be visible; must be contained by `root`.
 * @param {Element | HTMLElement} root - The scroll container used to test visibility.
 */
export function scrollActiveElementIfNeeded(activeElement, root) {
  if (!activeElement || !root || !root.contains(activeElement)) {
    return;
  }

  const rootRect = root.getBoundingClientRect();
  const elementRect = activeElement.getBoundingClientRect();
  const isVisible =
    elementRect.top >= rootRect.top && elementRect.bottom <= rootRect.bottom;

  if (!isVisible) {
    activeElement.scrollIntoView({
      behavior: 'smooth',
      block: 'end',
      inline: 'nearest',
    });
  }
}