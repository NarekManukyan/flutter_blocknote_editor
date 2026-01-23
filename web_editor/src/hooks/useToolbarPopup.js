/**
 * Custom hook for handling toolbar popup interception.
 */

import { useEffect } from 'react';
import { TOOLBAR_POPUP_OPTIONS } from '../constants/toolbarOptions';
import {
  hidePopupElement,
  removeHiddenPopups,
  identifyPopupType,
  isPopupNearToolbar,
  applyPopupSelection,
} from '../utils/popupHelpers';

/**
 * Custom hook to intercept toolbar popups and send requests to Flutter.
 * @param {Object} editor - The BlockNote editor instance
 * @param {boolean} isReady - Whether editor is ready
 * @param {Object} toolbarPopupCallbacksRef - Ref to store popup callbacks
 */
export function useToolbarPopup(editor, isReady, toolbarPopupCallbacksRef) {
  useEffect(() => {
    if (!editor || !isReady) return;

    // Function to detect and intercept toolbar popup clicks
    const setupToolbarPopupObserver = () => {
      // Wait for toolbar to be rendered
      const toolbar = document.querySelector('.bn-toolbar');
      if (!toolbar) {
        setTimeout(setupToolbarPopupObserver, 100);
        return;
      }

      // Observer to detect when popups are created from toolbar
      const popupObserver = new MutationObserver((mutations) => {
        mutations.forEach((mutation) => {
          mutation.addedNodes.forEach((node) => {
            if (node.nodeType !== 1) return;

            const popup = node;
            // Check if this is a Mantine popup (Menu or Popover)
            const isMantinePopup =
              popup.classList?.contains('mantine-Menu-dropdown') ||
              popup.classList?.contains('mantine-Popover-dropdown');

            if (isMantinePopup) {
              const popupClasses = Array.from(popup.classList || []);
              const { type: popupType } = identifyPopupType(popupClasses);

              if (!popupType) return;

              // Get options for the popup type
              const options =
                popupType === 'blockTypeSelect'
                  ? TOOLBAR_POPUP_OPTIONS.blockTypeSelect
                  : TOOLBAR_POPUP_OPTIONS.colorStyle;

              // Only intercept toolbar popups (not side menu or other popups)
              if (
                popupType === 'blockTypeSelect' &&
                !isPopupNearToolbar(toolbar, popup)
              ) {
                return;
              }

              if (options.length > 0) {
                // Hide the default popup
                hidePopupElement(popup);

                // Close any other popups
                const existingPopups = document.querySelectorAll(
                  '.mantine-Menu-dropdown, .mantine-Popover-dropdown',
                );
                existingPopups.forEach((p) => {
                  if (p !== popup) {
                    hidePopupElement(p);
                  }
                });

                // Send request to Flutter
                const requestId = `popup_${Date.now()}_${Math.random()}`;
                const messagePayload = {
                  type: 'toolbar_popup_request',
                  requestId: requestId,
                  popupType: popupType,
                  options: options,
                };

                if (options.length > 0 && !options[0].id) {
                  console.warn(
                    '[BlockNote] Warning: Options missing IDs:',
                    options,
                  );
                }

                try {
                  window.BlockNoteChannel.postMessage(
                    JSON.stringify(messagePayload),
                  );
                } catch (err) {
                  console.error(
                    '[BlockNote] Error sending toolbar popup request:',
                    err,
                  );
                }

                // Set up callback to handle response
                toolbarPopupCallbacksRef.current.set(
                  requestId,
                  (selectedValue) => {
                    if (selectedValue !== null && selectedValue !== undefined) {
                      applyPopupSelection(editor, popupType, selectedValue);
                    }
                    removeHiddenPopups();
                  },
                );
              }
            }
          });
        });
      });

      // Observe document body for new popups
      popupObserver.observe(document.body, { childList: true, subtree: true });

      return () => {
        popupObserver.disconnect();
      };
    };

    const cleanup = setupToolbarPopupObserver();
    return cleanup;
  }, [editor, isReady, toolbarPopupCallbacksRef]);
}
