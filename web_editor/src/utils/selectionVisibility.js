/**
 * Selection visibility utilities.
 * Extracted from useEditorReady to reduce complexity.
 */

/**
 * Gets selection visibility information.
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
 * Checks if keyboard is open based on viewport height.
 */
export function isKeyboardOpen() {
  const visualViewport = window.visualViewport;
  if (!visualViewport) return false;
  return visualViewport.height < window.innerHeight - 24;
}

/**
 * Scrolls selection into view if needed.
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
 * Sets up focus listeners for scroll-to-selection.
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
