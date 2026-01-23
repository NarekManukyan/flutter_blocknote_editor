/**
 * WebView height management utility.
 * Handles updating WebView height and ensuring proper scrolling.
 */

/**
 * Updates the WebView height to ensure proper scrolling.
 * @param {number} height - Available height in pixels
 * @param {number} keyboardHeight - Keyboard height in pixels
 * @param {Object} editor - The BlockNote editor instance
 */
export function updateWebViewHeight(height, keyboardHeight, editor) {
  try {
    // Override any CSS (including 100vh) to use 100% of WebView container
    // This ensures the content expands/contracts with the WebView size
    const html = document.documentElement;
    const body = document.body;
    const root = document.getElementById('root');

    // Set html to full height
    html.style.height = '100%';
    html.style.maxHeight = 'none';
    html.style.minHeight = '100%';
    // Don't set overflow: hidden on html to allow popups to render

    // Set body to full height (overrides 100vh from CSS)
    body.style.height = '100%';
    body.style.maxHeight = 'none';
    body.style.minHeight = '100%';
    // Don't set overflow: hidden on body - popups are rendered as direct children via React portals
    body.style.position = 'relative';

    // Set root to full height with scrolling enabled
    if (root) {
      root.style.height = '100%';
      root.style.maxHeight = 'none';
      root.style.minHeight = '100%';
      root.style.overflow = 'auto';
      root.style.position = 'relative';
      root.style.webkitOverflowScrolling = 'touch'; // Enable smooth scrolling on iOS
    }

    // Ensure root can scroll if content overflows
    setTimeout(() => {
      try {
        // Force a layout recalculation
        if (root) {
          // Trigger reflow to ensure height is calculated correctly
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

          // Ensure root has proper height constraint
          if (!root.style.height || root.style.height === 'auto') {
            root.style.height = '100%';
          }
        }
      } catch {
        // Silently fail
      }
    }, 100);

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

    // After size change (especially when keyboard opens/closes), ensure focused block is scrolled into view
    setTimeout(() => {
      try {
        const visualViewport = window.visualViewport;
        const visualHeight = visualViewport ? visualViewport.height : null;
        const layoutHeight = window.innerHeight;
        const keyboardOpen =
          keyboardHeight > 0 ||
          (visualViewport && visualHeight < layoutHeight - 24);

        if (!keyboardOpen) {
          return;
        }

        const rootRect = root ? root.getBoundingClientRect() : null;
        const proseMirrorView =
          editor && editor._tiptapEditor ? editor._tiptapEditor.view : null;
        let selectionScrollNeeded = false;
        let selectionVisibilityData = null;

        if (rootRect && proseMirrorView) {
          try {
            const selection = proseMirrorView.state?.selection;
            if (selection) {
              const fromCoords = proseMirrorView.coordsAtPos(selection.from);
              const toCoords = proseMirrorView.coordsAtPos(selection.to);
              const selectionTop = Math.min(fromCoords.top, toCoords.top);
              const selectionBottom = Math.max(
                fromCoords.bottom,
                toCoords.bottom,
              );
              const isVisible =
                selectionTop >= rootRect.top &&
                selectionBottom <= rootRect.bottom;
              selectionScrollNeeded = !isVisible;
              selectionVisibilityData = {
                selectionTop,
                selectionBottom,
                rootTop: rootRect.top,
                rootBottom: rootRect.bottom,
                isVisible,
              };
            }
          } catch (err) {
            selectionScrollNeeded = true;
            selectionVisibilityData = {
              error: err?.message || 'selection coords failed',
            };
          }
        }

        const activeElement = document.activeElement;
        let activeScrollNeeded = false;
        if (activeElement && root && root.contains(activeElement)) {
          const elementRect = activeElement.getBoundingClientRect();
          const rootBounds = rootRect || root.getBoundingClientRect();
          const isVisible =
            elementRect.top >= rootBounds.top &&
            elementRect.bottom <= rootBounds.bottom;
          activeScrollNeeded = !isVisible;
        }

        if (selectionVisibilityData) {
          activeScrollNeeded = false;
        }

        if (!selectionScrollNeeded && !activeScrollNeeded) {
          return;
        }

        if (editor && editor._tiptapEditor) {
          const proseMirrorView = editor._tiptapEditor.view;
          if (proseMirrorView && selectionScrollNeeded) {
            // Trigger ProseMirror to scroll selection into view
            proseMirrorView.dispatch(proseMirrorView.state.tr.scrollIntoView());
          }
        }

        // Also ensure any focused element is scrolled into view as fallback
        if (activeElement && root && root.contains(activeElement)) {
          const rootRect = root.getBoundingClientRect();
          const elementRect = activeElement.getBoundingClientRect();
          const isVisible =
            elementRect.top >= rootRect.top &&
            elementRect.bottom <= rootRect.bottom;
          if (!isVisible) {
            // Use scrollIntoView with smooth behavior
            activeElement.scrollIntoView({
              behavior: 'smooth',
              block: 'end',
              inline: 'nearest',
            });
          }
        }
      } catch {
        // Silently fail
      }
    }, 200); // Wait for size change animation to complete
  } catch (error) {
    console.error('[BlockNote] Error updating WebView height:', error);
  }
}
