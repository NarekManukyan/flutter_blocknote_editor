/**
 * CSS injection utility for custom styles.
 */

/**
 * Injects custom CSS into the document head.
 * @param {string} css - CSS content to inject
 */
export function injectCustomCss(css) {
  try {
    // Create a style element if it doesn't exist
    let styleElement = document.getElementById('blocknote-custom-css');
    if (!styleElement) {
      styleElement = document.createElement('style');
      styleElement.id = 'blocknote-custom-css';
      document.head.appendChild(styleElement);
    }

    // Set the CSS content
    styleElement.textContent = css;
    console.log('[BlockNote] Custom CSS injected');
  } catch (error) {
    console.error('[BlockNote] Error injecting custom CSS:', error);
  }
}
