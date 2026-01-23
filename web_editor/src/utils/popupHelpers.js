/**
 * Popup helper utilities.
 * Extracted from useToolbarPopup to reduce complexity.
 */

/**
 * Hides a popup element.
 */
export function hidePopupElement(element) {
  element.setAttribute('data-bn-flutter-hidden', 'true');
  element.style.setProperty('display', 'none', 'important');
  element.style.setProperty('pointer-events', 'none', 'important');
  element.style.setProperty('visibility', 'hidden', 'important');
  element.style.setProperty('opacity', '0', 'important');
}

/**
 * Removes hidden popups from DOM.
 */
export function removeHiddenPopups() {
  document
    .querySelectorAll('[data-bn-flutter-hidden="true"]')
    .forEach((element) => {
      element.remove();
    });
}

/**
 * Identifies popup type from popup classes.
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
 * Checks if popup is near toolbar.
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
 * Applies selected value to editor based on popup type.
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
