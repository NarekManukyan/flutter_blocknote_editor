/**
 * Selection visibility utilities.
 * Extracted from useEditorReady to reduce complexity.
 */

/**
 * Determine whether the editor's current text selection is fully visible within a given root element.
 * @param {object} view - ProseMirror EditorView that provides the selection and coordinate methods.
 * @param {Element} root - DOM element whose bounding rectangle defines the visible area.
 * @returns {{isVisible: boolean, selectionTop: number, selectionBottom: number, rootTop: number, rootBottom: number}|null} An object containing visibility details, or `null` if `view`, `root`, or the selection is unavailable. `isVisible` is `true` if the selection's top is greater than or equal to `rootTop` and the selection's bottom is less than or equal to `rootBottom`; `selectionTop` and `selectionBottom` are the vertical coordinates of the selection, and `rootTop` and `rootBottom` are the root element's top and bottom coordinates respectively.
 */
export function getSelectionVisibility(view, root) {
  if (!view || !root) return null;
  const selection = view.state?.selection;
  if (!selection) return null;
  const fromCoords = view.coordsAtPos(selection.from);
  const toCoords = view.coordsAtPos(selection.to);
  const selectionTop = Math.min(fromCoords.top, toCoords.top);
  const selectionBottom = Math.max(fromCoords.bottom, toCoords.bottom);
  const rootRect = root.getBoundingClientRect();
  const isVisible =
    selectionTop >= rootRect.top && selectionBottom <= rootRect.bottom;
  return {
    isVisible,
    selectionTop,
    selectionBottom,
    rootTop: rootRect.top,
    rootBottom: rootRect.bottom,
  };
}

/**
 * Determine whether the on-screen keyboard is likely open by comparing viewport heights.
 * @returns {boolean} `true` if the visual viewport height is smaller than the window inner height by more than 24 pixels (indicating the on-screen keyboard is likely open), `false` otherwise. */
export function isKeyboardOpen() {
  const visualViewport = window.visualViewport;
  if (!visualViewport) return false;
  return visualViewport.height < window.innerHeight - 24;
}

/**
 * Ensure the editor selection is scrolled into view when the on-screen keyboard likely obscures it.
 * @param {object} proseMirrorView - The ProseMirror EditorView whose selection will be checked and scrolled.
 * @param {HTMLElement} root - The root DOM element used to determine the visible area for the selection.
 */
export function scrollSelectionIntoView(proseMirrorView, root) {
  if (!proseMirrorView || !root) return;

  const visualViewport = window.visualViewport;
  if (!visualViewport) return;
  if (visualViewport.height >= window.innerHeight - 24) return;

  const visibility = getSelectionVisibility(proseMirrorView, root);
  if (visibility && visibility.isVisible) return;

  proseMirrorView.dispatch(proseMirrorView.state.tr.scrollIntoView());
}

/**
 * Attach focus and click listeners to a TipTap editor to ensure the current selection is scrolled into view when necessary.
 *
 * Initializes repeatedly until the editor DOM is available, then registers capturing `focus` and `click` handlers that
 * check keyboard/viewport state and, if the selection is not visible, dispatch a scroll-into-view transaction.
 *
 * @param {object} tiptapEditor - TipTap editor instance (expected to expose a `.view` with a `.dom` and `.state`).
 * @param {function} getSelectionVisibilityFn - Function that accepts `(view, root)` and returns an object with
 *   visibility data (e.g., `{ isVisible, selectionTop, selectionBottom, rootTop, rootBottom }`) or `null`.
 */
export function setupFocusListeners(tiptapEditor, getSelectionVisibilityFn) {
  const setup = () => {
    try {
      const proseMirrorView = tiptapEditor.view;
      if (!proseMirrorView || !proseMirrorView.dom) {
        setTimeout(setup, 100);
        return;
      }

      const editorDOM = proseMirrorView.dom;
      const handleFocus = () => {
        setTimeout(() => {
          try {
            const currentView = tiptapEditor.view;
            if (currentView && currentView.dom) {
              const visualViewport = window.visualViewport;
              if (!visualViewport) return;
              if (visualViewport.height >= window.innerHeight - 24) return;
              const root = document.getElementById('root');
              const visibility = getSelectionVisibilityFn(currentView, root);
              if (visibility && visibility.isVisible) return;
              currentView.dispatch(currentView.state.tr.scrollIntoView());
            }
          } catch {
            // Silently fail
          }
        }, 50);
      };

      editorDOM.addEventListener('focus', handleFocus, true);
      editorDOM.addEventListener('click', handleFocus, true);
    } catch {
      setTimeout(setup, 200);
    }
  };

  setup();
}
