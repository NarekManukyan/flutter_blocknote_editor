/**
 * CSS injection utility for custom styles.
 */

import { debugLog } from './flutterBridge';

/**
 * Injects custom CSS into the document head.
 * Creates or updates a dedicated <style> element.
 * @param {string} css - CSS content to inject
 */
export function injectCustomCss(css) {
  try {
    let styleElement = document.getElementById('blocknote-custom-css');
    if (!styleElement) {
      styleElement = document.createElement('style');
      styleElement.id = 'blocknote-custom-css';
      document.head.appendChild(styleElement);
    }
    styleElement.textContent = css;
    debugLog('Custom CSS injected');
  } catch (error) {
    console.error('[BlockNote] Error injecting custom CSS:', error);
  }
}
