/**
 * Centralized Flutter communication bridge.
 * All messages to Flutter go through this module to ensure consistent
 * formatting and error handling.
 */

/**
 * Send a typed message to Flutter via BlockNoteChannel.
 * @param {string} type - Message type (e.g. 'ready', 'error', 'transactions')
 * @param {Object} [payload] - Additional fields merged into the message
 */
export function sendToFlutter(type, payload = {}) {
  try {
    const message = { type, ...payload };
    window.BlockNoteChannel.postMessage(JSON.stringify(message));
  } catch (err) {
    // Avoid infinite recursion if error channel itself fails
    if (type !== 'error') {
      console.error('[BlockNote] Error posting message:', err);
    }
  }
}

/**
 * Send an error message to Flutter.
 * @param {string} message - Human-readable error description
 */
export function sendErrorToFlutter(message) {
  sendToFlutter('error', { message });
}

/**
 * Conditionally log a debug message (only when BlockNoteDebugLogging is enabled).
 * @param  {...any} args - Arguments forwarded to console.log
 */
export function debugLog(...args) {
  if (window.BlockNoteDebugLogging) {
    console.log('[BlockNote]', ...args);
  }
}
