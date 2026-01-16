/**
 * Custom hook for handling toolbar popup interception.
 */

import { useEffect, useRef } from 'react';
import { TOOLBAR_POPUP_OPTIONS } from '../constants/toolbarOptions';

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
            const isMantinePopup = popup.classList?.contains('mantine-Menu-dropdown') ||
                                  popup.classList?.contains('mantine-Popover-dropdown');
            
            if (isMantinePopup) {
              // Identify popup type directly from popup classes
              const popupClasses = Array.from(popup.classList || []);
              let popupType = null;
              let options = [];
              
              // Check for block type select popup
              if (popupClasses.includes('bn-select')) {
                popupType = 'blockTypeSelect';
                options = TOOLBAR_POPUP_OPTIONS.blockTypeSelect;
              }
              // Check for color picker popup
              else if (popupClasses.includes('bn-color-picker-dropdown')) {
                popupType = 'colorStyle';
                options = TOOLBAR_POPUP_OPTIONS.colorStyle;
              }
              
              // Only intercept toolbar popups (not side menu or other popups)
              if (popupType === 'blockTypeSelect') {
                const toolbarRect = toolbar.getBoundingClientRect();
                const popupRect = popup.getBoundingClientRect();
                const isNearToolbar = Math.abs(popupRect.top - toolbarRect.bottom) < 100 ||
                                     Math.abs(popupRect.bottom - toolbarRect.top) < 100;
                
                if (!isNearToolbar) {
                  popupType = null; // Don't intercept if not near toolbar
                }
              }
              
              if (popupType && options.length > 0) {
                // Hide the default popup
                popup.style.display = 'none';
                
                // Close any other popups
                const existingPopups = document.querySelectorAll('.mantine-Menu-dropdown, .mantine-Popover-dropdown');
                existingPopups.forEach((p) => {
                  if (p !== popup) {
                    p.style.display = 'none';
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
                
                // Debug: verify options have IDs
                if (options.length > 0 && !options[0].id) {
                  console.warn('[BlockNote] Warning: Options missing IDs:', options);
                }
                
                try {
                  window.BlockNoteChannel.postMessage(JSON.stringify(messagePayload));
                } catch (err) {
                  console.error('[BlockNote] Error sending toolbar popup request:', err);
                }

                // Set up callback to handle response
                toolbarPopupCallbacksRef.current.set(requestId, (selectedValue) => {
                  if (selectedValue !== null && selectedValue !== undefined) {
                    // Apply the selected value
                    if (popupType === 'colorStyle' && editor) {
                      // Apply color style
                      try {
                        editor.toggleStyles({ textColor: selectedValue });
                      } catch (err) {
                        console.error('[BlockNote] Error applying color style:', err);
                      }
                    } else if (popupType === 'blockTypeSelect' && editor) {
                      // Change block type
                      try {
                        const currentBlock = editor.getTextCursorPosition().block;
                        if (currentBlock) {
                          // Parse value if it's a JSON string (for heading levels, checklist, etc.)
                          let blockUpdate = {};
                          if (typeof selectedValue === 'string' && selectedValue.startsWith('{')) {
                            try {
                              const parsed = JSON.parse(selectedValue);
                              blockUpdate = parsed;
                            } catch (e) {
                              // Not JSON, treat as simple type
                              blockUpdate = { type: selectedValue };
                            }
                          } else if (typeof selectedValue === 'object' && selectedValue !== null) {
                            // Already an object, use directly
                            blockUpdate = selectedValue;
                          } else {
                            blockUpdate = { type: selectedValue };
                          }
                          
                          editor.updateBlock(currentBlock, blockUpdate);
                        }
                      } catch (err) {
                        console.error('[BlockNote] Error changing block type:', err);
                      }
                    }
                  }
                });
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
