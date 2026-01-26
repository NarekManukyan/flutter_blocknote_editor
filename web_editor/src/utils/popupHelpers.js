/**
 * Popup helper utilities.
 * Extracted from useToolbarPopup to reduce complexity.
 */

/**
 * Mark a popup element as hidden and make it invisible and non-interactive.
 * @param {HTMLElement} element - The popup DOM element to hide.
 */
export function hidePopupElement(element) {
  element.setAttribute('data-bn-flutter-hidden', 'true');
  element.style.setProperty('display', 'none', 'important');
  element.style.setProperty('pointer-events', 'none', 'important');
  element.style.setProperty('visibility', 'hidden', 'important');
  element.style.setProperty('opacity', '0', 'important');
}

/**
 * Remove all DOM elements marked with data-bn-flutter-hidden="true".
 *
 * Selects elements that were previously hidden via the data-bn-flutter-hidden attribute and removes them from the document.
 */
export function removeHiddenPopups() {
  document
    .querySelectorAll('[data-bn-flutter-hidden="true"]')
    .forEach((element) => {
      element.remove();
    });
}

/**
 * Determine popup semantic type from a list of CSS class names.
 * @param {string[]|DOMTokenList} popupClasses - Array-like collection of class names for the popup element.
 * @returns {{type: 'blockTypeSelect'|'colorStyle'|null, options: any[]}} Object with `type` set to the inferred popup type and `options` initialized as an empty array.
 */
export function identifyPopupType(popupClasses) {
  if (popupClasses.includes('bn-select')) {
    return {
      type: 'blockTypeSelect',
      options: [], // Will be set by caller
    };
  }
  if (popupClasses.includes('bn-color-picker-dropdown')) {
    return {
      type: 'colorStyle',
      options: [], // Will be set by caller
    };
  }
  return { type: null, options: [] };
}

/**
 * Determine whether a popup is vertically near the toolbar.
 *
 * @param {Element} toolbar - The toolbar DOM element to compare against.
 * @param {Element} popup - The popup DOM element to check.
 * @returns {boolean} `true` if the vertical distance between the popup and the toolbar is less than 100 pixels, `false` otherwise.
 */
export function isPopupNearToolbar(toolbar, popup) {
  const toolbarRect = toolbar.getBoundingClientRect();
  const popupRect = popup.getBoundingClientRect();
  return (
    Math.abs(popupRect.top - toolbarRect.bottom) < 100 ||
    Math.abs(popupRect.bottom - toolbarRect.top) < 100
  );
}

/**
 * Apply a popup selection to the editor.
 *
 * For popupType "colorStyle", applies the selected value as the text color.
 * For popupType "blockTypeSelect", updates the current block using the selected value:
 * - If selectedValue is a string that begins with '{', it is parsed as JSON to produce the update payload; on parse failure the string is used as the block `type`.
 * - If selectedValue is an object, it is used directly as the block update payload.
 * - Otherwise the selectedValue is used as the block `type`.
 *
 * If `editor` is falsy the function does nothing. If no current block is available for a block type change, the function does nothing.
 *
 * @param {object} editor - Editor instance providing at least `toggleStyles`, `getTextCursorPosition`, and `updateBlock` methods.
 * @param {string|null} popupType - The popup type identifier (e.g., `"colorStyle"`, `"blockTypeSelect"`) or `null` for unknown.
 * @param {string|object} selectedValue - The value chosen in the popup; may be a JSON string, a plain string representing a block type, or an object describing the block update.
 */
export function applyPopupSelection(editor, popupType, selectedValue) {
  if (!editor) return;

  if (popupType === 'colorStyle') {
    try {
      editor.toggleStyles({ textColor: selectedValue });
    } catch (err) {
      console.error('[BlockNote] Error applying color style:', err);
    }
    return;
  }

  if (popupType === 'blockTypeSelect') {
    try {
      const currentBlock = editor.getTextCursorPosition().block;
      if (!currentBlock) return;

      let blockUpdate = {};
      if (typeof selectedValue === 'string' && selectedValue.startsWith('{')) {
        try {
          blockUpdate = JSON.parse(selectedValue);
        } catch {
          blockUpdate = { type: selectedValue };
        }
      } else if (typeof selectedValue === 'object' && selectedValue !== null) {
        blockUpdate = selectedValue;
      } else {
        blockUpdate = { type: selectedValue };
      }

      editor.updateBlock(currentBlock, blockUpdate);
    } catch (err) {
      console.error('[BlockNote] Error changing block type:', err);
    }
  }
}
