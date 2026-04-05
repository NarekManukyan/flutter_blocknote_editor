/**
 * Override console methods to forward messages to Flutter via flutterConsole channel.
 * Errors are always forwarded; log/warn only when BlockNoteDebugLogging is enabled.
 */

/**
 * Format an array of arguments into a single string for the Flutter console channel.
 * @param {Array} args
 * @returns {string}
 */
function formatArgs(args) {
  return args
    .map((arg) => (typeof arg === 'object' ? JSON.stringify(arg) : String(arg)))
    .join(' ');
}

/**
 * Create a wrapped console method that forwards to Flutter.
 * @param {Function} originalFn - The original console method
 * @param {string} [prefix] - Optional prefix (e.g. '[ERROR] ', '[WARN] ')
 * @param {boolean} alwaysSend - If true, send even when debug logging is off
 * @returns {Function}
 */
function createConsoleOverride(originalFn, prefix = '', alwaysSend = false) {
  return function (...args) {
    originalFn.apply(console, args);

    const shouldSend =
      alwaysSend ||
      (window.BlockNoteDebugLogging &&
        window.flutterConsole?.postMessage);

    if (shouldSend && window.flutterConsole?.postMessage) {
      window.flutterConsole.postMessage(prefix + formatArgs(args));
    }
  };
}

export function setupConsoleOverrides() {
  if (typeof window.BlockNoteDebugLogging === 'undefined') {
    window.BlockNoteDebugLogging = false;
  }

  const originalLog = console.log;
  const originalError = console.error;
  const originalWarn = console.warn;

  console.log = createConsoleOverride(originalLog);
  console.error = createConsoleOverride(originalError, '[ERROR] ', true);
  console.warn = createConsoleOverride(originalWarn, '[WARN] ');
}
