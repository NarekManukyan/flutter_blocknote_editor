/**
 * Toolbar popup response handler utility.
 */

/**
 * Handles toolbar popup response from Flutter.
 * @param {Object} message - Message from Flutter with requestId and selectedValue
 * @param {Map} toolbarPopupCallbacks - Map storing popup callbacks by requestId
 */
export function handleToolbarPopupResponse(message, toolbarPopupCallbacks) {
  const { requestId, selectedValue } = message;
  const callback = toolbarPopupCallbacks.get(requestId);
  if (!callback) return;

  // Parse JSON string values if needed
  let processedValue = selectedValue;
  if (typeof selectedValue === 'string' && selectedValue.startsWith('{')) {
    try {
      processedValue = JSON.parse(selectedValue);
    } catch {
      // Use string as-is if parsing fails
    }
  }

  callback(processedValue);
  toolbarPopupCallbacks.delete(requestId);
}
