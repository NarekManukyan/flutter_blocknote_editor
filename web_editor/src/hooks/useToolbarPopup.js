/**
 * Custom hook for handling toolbar popup interception.
 */

import { useEffect, useRef } from 'react';
import { TOOLBAR_POPUP_OPTIONS } from '../constants/toolbarOptions';
import { sendToFlutter } from '../utils/flutterBridge';
import {
  hidePopupElement,
  removeHiddenPopups,
  identifyPopupType,
  isPopupNearToolbar,
  applyPopupSelection,
} from '../utils/popupHelpers';

const CALLBACK_TTL_MS = 30_000;
const MAX_POLL_ATTEMPTS = 50;

/**
 * Intercepts editor toolbar popups and forwards them to Flutter.
 * @param {Object} editor - BlockNote editor instance.
 * @param {boolean} isReady - Whether the editor is ready.
 * @param {Map} toolbarPopupCallbacks - Map storing response callbacks by requestId.
 */
export function useToolbarPopup(editor, isReady, toolbarPopupCallbacks) {
  const pollTimeoutRef = useRef(null);

  useEffect(() => {
    if (!editor || !isReady) return;

    let popupObserver = null;
    let pollAttempts = 0;

    const setupToolbarPopupObserver = () => {
      const toolbar = document.querySelector('.bn-toolbar');
      if (!toolbar) {
        if (pollAttempts >= MAX_POLL_ATTEMPTS) {
          // Give up — toolbar never appeared
          return;
        }
        pollAttempts++;
        pollTimeoutRef.current = setTimeout(setupToolbarPopupObserver, 100);
        return;
      }

      const handlePopupNode = (node) => {
        if (!node || node.nodeType !== 1) return;

        const isMantinePopup =
          node.classList?.contains('mantine-Menu-dropdown') ||
          node.classList?.contains('mantine-Popover-dropdown');

        if (!isMantinePopup) return;

        // Skip nodes we've already processed (subtree walk + direct add can collide)
        if (node.getAttribute('data-bn-flutter-handled') === 'true') return;

        const { type: popupType } = identifyPopupType(
          Array.from(node.classList || []),
        );
        if (!popupType) return;

        const options =
          popupType === 'blockTypeSelect'
            ? TOOLBAR_POPUP_OPTIONS.blockTypeSelect
            : TOOLBAR_POPUP_OPTIONS.colorStyle;

        // Only intercept toolbar popups (not side menu)
        if (
          popupType === 'blockTypeSelect' &&
          !isPopupNearToolbar(toolbar, node)
        ) {
          return;
        }

        if (options.length === 0) return;

        node.setAttribute('data-bn-flutter-handled', 'true');

        // Hide default popup and close siblings. Exclude link/form popovers
        // (bn-form-popover) and any other BlockNote-native popups we don't
        // intercept — those must keep working natively.
        hidePopupElement(node);
        document
          .querySelectorAll(
            '.mantine-Menu-dropdown:not(.bn-form-popover), ' +
              '.mantine-Popover-dropdown:not(.bn-form-popover)',
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

        // Schedule TTL cleanup for this callback
        const ttlTimeout = setTimeout(() => {
          toolbarPopupCallbacks.delete(requestId);
        }, CALLBACK_TTL_MS);

        // Store callback for response; clear TTL timer when invoked normally
        toolbarPopupCallbacks.set(requestId, (selectedValue) => {
          clearTimeout(ttlTimeout);
          toolbarPopupCallbacks.delete(requestId);
          if (selectedValue != null) {
            applyPopupSelection(editor, popupType, selectedValue);
          }
          removeHiddenPopups();
        });
      };

      popupObserver = new MutationObserver((mutations) => {
        for (const mutation of mutations) {
          if (mutation.type === 'childList') {
            for (const node of mutation.addedNodes) {
              if (node.nodeType !== 1) continue;
              // Check the node itself
              handlePopupNode(node);
              // Also walk descendants — MutationObserver does NOT emit separate
              // records for descendants of a subtree added in one shot, so a
              // popup mounted inside a wrapper would otherwise be missed.
              if (node.querySelectorAll) {
                node
                  .querySelectorAll(
                    '.mantine-Menu-dropdown, .mantine-Popover-dropdown',
                  )
                  .forEach(handlePopupNode);
              }
            }
          } else if (mutation.type === 'attributes') {
            // Mantine often reuses the same dropdown DOM node and toggles its
            // visibility via style/data attributes instead of unmount/remount.
            // childList won't fire on re-show, so we re-check the existing
            // node whenever its visibility-related attributes change.
            handlePopupNode(mutation.target);
          }
        }
      });

      popupObserver.observe(document.body, {
        childList: true,
        subtree: true,
        attributes: true,
        attributeFilter: ['style', 'data-expanded', 'aria-expanded', 'hidden'],
      });
    };

    setupToolbarPopupObserver();

    return () => {
      // Cancel any in-flight polling timeout
      if (pollTimeoutRef.current !== null) {
        clearTimeout(pollTimeoutRef.current);
        pollTimeoutRef.current = null;
      }
      // Disconnect observer if it was created
      if (popupObserver) {
        popupObserver.disconnect();
        popupObserver = null;
      }
    };
  }, [editor, isReady, toolbarPopupCallbacks]);
}
