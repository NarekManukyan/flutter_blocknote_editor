/**
 * Custom hook for handling toolbar popup interception.
 */

import { useEffect } from 'react';
import { TOOLBAR_POPUP_OPTIONS } from '../constants/toolbarOptions';
import { sendToFlutter } from '../utils/flutterBridge';
import {
  hidePopupElement,
  removeHiddenPopups,
  identifyPopupType,
  isPopupNearToolbar,
  applyPopupSelection,
} from '../utils/popupHelpers';

/**
 * Intercepts editor toolbar popups and forwards them to Flutter.
 * @param {Object} editor - BlockNote editor instance.
 * @param {boolean} isReady - Whether the editor is ready.
 * @param {Map} toolbarPopupCallbacks - Map storing response callbacks by requestId.
 */
export function useToolbarPopup(editor, isReady, toolbarPopupCallbacks) {
  useEffect(() => {
    if (!editor || !isReady) return;

    const setupToolbarPopupObserver = () => {
      const toolbar = document.querySelector('.bn-toolbar');
      if (!toolbar) {
        setTimeout(setupToolbarPopupObserver, 100);
        return;
      }

      const popupObserver = new MutationObserver((mutations) => {
        for (const mutation of mutations) {
          for (const node of mutation.addedNodes) {
            if (node.nodeType !== 1) continue;

            const isMantinePopup =
              node.classList?.contains('mantine-Menu-dropdown') ||
              node.classList?.contains('mantine-Popover-dropdown');

            if (!isMantinePopup) continue;

            const { type: popupType } = identifyPopupType(
              Array.from(node.classList || []),
            );
            if (!popupType) continue;

            const options =
              popupType === 'blockTypeSelect'
                ? TOOLBAR_POPUP_OPTIONS.blockTypeSelect
                : TOOLBAR_POPUP_OPTIONS.colorStyle;

            // Only intercept toolbar popups (not side menu)
            if (
              popupType === 'blockTypeSelect' &&
              !isPopupNearToolbar(toolbar, node)
            ) {
              continue;
            }

            if (options.length === 0) continue;

            // Hide default popup and close siblings
            hidePopupElement(node);
            document
              .querySelectorAll(
                '.mantine-Menu-dropdown, .mantine-Popover-dropdown',
              )
              .forEach((p) => {
                if (p !== node) hidePopupElement(p);
              });

            // Send request to Flutter
            const requestId = `popup_${Date.now()}_${Math.random()}`;
            sendToFlutter('toolbar_popup_request', {
              requestId,
              popupType,
              options,
            });

            // Store callback for response
            toolbarPopupCallbacks.set(requestId, (selectedValue) => {
              if (selectedValue != null) {
                applyPopupSelection(editor, popupType, selectedValue);
              }
              removeHiddenPopups();
            });
          }
        }
      });

      popupObserver.observe(document.body, { childList: true, subtree: true });
      return () => popupObserver.disconnect();
    };

    const cleanup = setupToolbarPopupObserver();
    return cleanup;
  }, [editor, isReady, toolbarPopupCallbacks]);
}
