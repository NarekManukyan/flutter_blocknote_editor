/**
 * Selection visibility utilities.
 * Extracted from useEditorReady to reduce complexity.
 */

/**
 * Effective visible bottom when the keyboard is likely open: bottom of the visual viewport.
 * Otherwise the root's bottom is used. This prevents treating content under the keyboard as "visible".
 * @param {DOMRect} rootRect - Root element bounding rect.
 * @returns {number} Vertical coordinate (bottom) of the visible area.
 */
function getEffectiveVisibleBottom(rootRect) {
  const visualViewport = window.visualViewport;
  if (!visualViewport || visualViewport.height >= window.innerHeight - 24) {
    return rootRect.bottom;
  }
  return Math.min(
    rootRect.bottom,
    visualViewport.offsetTop + visualViewport.height,
  );
}

/**
 * Determine whether the editor's current text selection is fully visible within a given root element.
 * When the keyboard is likely open, the visible area uses the visual viewport bottom so content under the keyboard is not considered visible (fixes scroll-up-when-typing).
 * @param {object} view - ProseMirror EditorView that provides the selection and coordinate methods.
 * @param {Element} root - DOM element whose bounding rectangle defines the visible area.
 * @returns {{isVisible: boolean, selectionTop: number, selectionBottom: number, rootTop: number, rootBottom: number}|null} An object containing visibility details, or `null` if `view`, `root`, or the selection is unavailable.
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
  const visibleBottom = getEffectiveVisibleBottom(rootRect);
  const isVisible =
    selectionTop >= rootRect.top && selectionBottom <= visibleBottom;
  return {
    isVisible,
    selectionTop,
    selectionBottom,
    rootTop: rootRect.top,
    rootBottom: visibleBottom,
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

/**
 * Blur the editor after a checklist checkbox is toggled so the editor does not retain focus.
 * BlockNote renders check list items with an input[type="checkbox"] inside the editor; clicking
 * it toggles the state but also focuses the editor. This listener blurs the editor after such a click.
 *
 * @param {object} tiptapEditor - TipTap editor instance (expected to expose a `.view` with a `.dom` and `.commands.blur()`).
 */
export function setupChecklistBlurOnToggle(tiptapEditor) {
  const setup = () => {
    try {
      const proseMirrorView = tiptapEditor.view;
      if (!proseMirrorView || !proseMirrorView.dom) {
        setTimeout(setup, 100);
        return;
      }

      const editorDOM = proseMirrorView.dom;

      const isChecklistCheckbox = (el) =>
        el &&
        el.tagName === 'INPUT' &&
        el.getAttribute('type') === 'checkbox' &&
        editorDOM.contains(el);

      const handleClick = (event) => {
        if (!isChecklistCheckbox(event.target)) return;

        setTimeout(() => {
          try {
            const canBlur =
              tiptapEditor.commands &&
              typeof tiptapEditor.commands.blur === 'function';
            if (canBlur) {
              tiptapEditor.commands.blur();
            }
          } catch {
            // Silently fail
          }
        }, 0);
      };

      editorDOM.addEventListener('click', handleClick, true);
    } catch {
      setTimeout(setup, 200);
    }
  };

  setup();
}
