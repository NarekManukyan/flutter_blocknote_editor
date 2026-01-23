/**
 * Scroll helper utilities.
 * Extracted from webViewHeightManager to reduce complexity.
 */

import { getSelectionVisibility } from './selectionVisibility';

/**
 * Checks if keyboard is open.
 */
export function isKeyboardOpen(keyboardHeight) {
  const visualViewport = window.visualViewport;
  if (!visualViewport) return keyboardHeight > 0;
  const visualHeight = visualViewport.height;
  const layoutHeight = window.innerHeight;
  return keyboardHeight > 0 || visualHeight < layoutHeight - 24;
}

/**
 * Checks if selection needs scrolling.
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
 * Checks if active element needs scrolling.
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
 * Scrolls selection into view if needed.
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
 * Scrolls active element into view if needed.
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
