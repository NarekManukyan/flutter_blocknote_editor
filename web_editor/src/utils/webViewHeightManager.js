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
            if (root.style.overflow !== 'auto' && root.style.overflow !== 'scroll') {
              root.style.overflow = 'auto';
            }
          }
          
          // Ensure root has proper height constraint
          if (!root.style.height || root.style.height === 'auto') {
            root.style.height = '100%';
          }
        }
      } catch (err) {
        // Silently fail
      }
    }, 100);
    
    // Update viewport height for proper scrolling
    const viewport = document.querySelector('meta[name="viewport"]');
    if (viewport) {
      viewport.setAttribute('content', 
        'width=device-width, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0, user-scalable=no');
    }
    
    // Trigger resize event for editor to recalculate layout
    window.dispatchEvent(new Event('resize'));
    
    // After size change (especially when keyboard opens/closes), ensure focused block is scrolled into view
    setTimeout(() => {
      try {
        if (editor && editor._tiptapEditor) {
          const proseMirrorView = editor._tiptapEditor.view;
          if (proseMirrorView) {
            // Trigger ProseMirror to scroll selection into view
            proseMirrorView.dispatch(
              proseMirrorView.state.tr.scrollIntoView()
            );
          }
        }
        
        // Also ensure any focused element is scrolled into view as fallback
        const activeElement = document.activeElement;
        if (activeElement && root && root.contains(activeElement)) {
          // Use scrollIntoView with smooth behavior
          activeElement.scrollIntoView({
            behavior: 'smooth',
            block: 'center',
            inline: 'nearest'
          });
        }
      } catch (err) {
        // Silently fail
      }
    }, 200); // Wait for size change animation to complete
  } catch (error) {
    console.error('[BlockNote] Error updating WebView height:', error);
  }
}
