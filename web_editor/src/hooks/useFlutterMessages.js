/**
 * Custom hook for handling Flutter messages.
 */

import { useEffect } from 'react';
import { loadDocument } from '../utils/documentLoader';
import { updateWebViewHeight } from '../utils/webViewHeightManager';
import { injectCustomCss } from '../utils/cssInjector';
import { handleToolbarPopupResponse } from '../utils/toolbarPopupHandler';

/**
 * Custom hook to handle messages from Flutter.
 * @param {Object} editor - The BlockNote editor instance
 * @param {Function} setIsReadonly - Function to set read-only state
 * @param {Function} setTheme - Function to set theme
 * @param {Function} setToolbarConfig - Function to set toolbar config
 * @param {Function} setSlashCommandConfig - Function to set slash command config
 * @param {Object} documentVersionRef - Ref to track document version
 * @param {Object} hasLoadedDocumentRef - Ref to track if document was loaded
 * @param {Object} toolbarPopupCallbacksRef - Ref to store popup callbacks
 */
export function useFlutterMessages(
  editor,
  setIsReadonly,
  setTheme,
  setToolbarConfig,
  setSlashCommandConfig,
  documentVersionRef,
  hasLoadedDocumentRef,
  toolbarPopupCallbacksRef,
) {
  useEffect(() => {
    const handleFlutterMessage = (event) => {
      const message = event.detail;

      switch (message.type) {
        case 'load_document':
          loadDocument(
            editor,
            message.data,
            documentVersionRef,
            hasLoadedDocumentRef,
          );
          break;
        case 'set_readonly':
          setIsReadonly(message.value);
          break;
        case 'flush':
          // Force immediate transaction emission (bypass debounce)
          if (
            window.sendPendingTransaction &&
            typeof window.sendPendingTransaction === 'function'
          ) {
            window.sendPendingTransaction();
          } else if (editor && editor.onChange) {
            // Fallback: trigger onChange if sendPendingTransaction not available
            editor.onChange();
          }
          break;
        case 'set_theme':
          try {
            console.log('[BlockNote] Setting theme:', message.data);
            setTheme(message.data);
          } catch (error) {
            console.error('[BlockNote] Error setting theme:', error);
          }
          break;
        case 'set_toolbar_config':
          setToolbarConfig(message.data);
          break;
        case 'set_slash_command_config':
          setSlashCommandConfig(message.data);
          break;
        case 'update_webview_height':
          updateWebViewHeight(message.height, message.keyboardHeight, editor);
          break;
        case 'inject_custom_css':
          injectCustomCss(message.css);
          break;
        case 'toolbar_popup_response':
          handleToolbarPopupResponse(message, toolbarPopupCallbacksRef);
          break;
        default:
          console.warn('[BlockNote] Unknown message type:', message.type);
      }
    };

    window.addEventListener('flutterMessage', handleFlutterMessage);
    return () => {
      window.removeEventListener('flutterMessage', handleFlutterMessage);
    };
  }, [
    editor,
    setIsReadonly,
    setTheme,
    setToolbarConfig,
    setSlashCommandConfig,
    documentVersionRef,
    hasLoadedDocumentRef,
    toolbarPopupCallbacksRef,
  ]);
}
