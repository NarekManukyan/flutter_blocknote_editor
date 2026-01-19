/**
 * Toolbar popup response handler utility.
 */

/**
 * Handles toolbar popup response from Flutter.
 * @param {Object} message - Message from Flutter
 * @param {Object} toolbarPopupCallbacksRef - Ref to store popup callbacks
 */
export function handleToolbarPopupResponse(message, toolbarPopupCallbacksRef) {
  const { requestId, selectedValue } = message;
  const callback = toolbarPopupCallbacksRef.current.get(requestId);
  if (callback) {
    // Handle the case where selectedValue might be a JSON string that needs parsing
    let processedValue = selectedValue;
    if (typeof selectedValue === 'string' && selectedValue.startsWith('{')) {
      try {
        processedValue = JSON.parse(selectedValue);
      } catch {
        // If parsing fails, use the string as-is
        processedValue = selectedValue;
      }
    }
    callback(processedValue);
    toolbarPopupCallbacksRef.current.delete(requestId);
  }
}
