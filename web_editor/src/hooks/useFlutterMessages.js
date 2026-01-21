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
 * @param {Function} setSchemaConfig - Function to set schema config
 * @param {Function} setSchemaConfigReady - Function to set schema config ready
 * @param {Function} setSchemaConfigRequired - Function to set schema required
 * @param {Object} documentVersionRef - Ref to track document version
 * @param {Object} hasLoadedDocumentRef - Ref to track if document was loaded
 * @param {Object} toolbarPopupCallbacksRef - Ref to store popup callbacks
 * @param {Object} pendingDocumentRef - Ref to store pending documents
 * @param {Object} schemaChangePendingRef - Ref to track schema updates
 */
export function useFlutterMessages(
  editor,
  setIsReadonly,
  setTheme,
  setToolbarConfig,
  setSlashCommandConfig,
  setSchemaConfig,
  setSchemaConfigReady,
  setSchemaConfigRequired,
  documentVersionRef,
  hasLoadedDocumentRef,
  toolbarPopupCallbacksRef,
  pendingDocumentRef,
  schemaChangePendingRef,
) {
  useEffect(() => {
    const handleFlutterMessage = (message) => {
      switch (message.type) {
        case 'load_document':
          if (!editor || schemaChangePendingRef.current) {
            pendingDocumentRef.current = message.data;
            break;
          }
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
        case 'set_schema_config':
          setSchemaConfigRequired(
            message.required !== undefined
              ? Boolean(message.required)
              : Boolean(message.data),
          );
          schemaChangePendingRef.current = true;
          setSchemaConfig(message.data ?? null);
          setSchemaConfigReady(true);
          schemaChangePendingRef.current = false;
          if (editor && pendingDocumentRef.current) {
            loadDocument(
              editor,
              pendingDocumentRef.current,
              documentVersionRef,
              hasLoadedDocumentRef,
            );
            pendingDocumentRef.current = null;
          }
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

    const handleFlutterEvent = (event) => {
      handleFlutterMessage(event.detail);
    };

    window.addEventListener('flutterMessage', handleFlutterEvent);

    if (window.__blockNotePendingSchemaConfig) {
      handleFlutterMessage(window.__blockNotePendingSchemaConfig);
      delete window.__blockNotePendingSchemaConfig;
    }
    return () => {
      window.removeEventListener('flutterMessage', handleFlutterEvent);
    };
  }, [
    editor,
    setIsReadonly,
    setTheme,
    setToolbarConfig,
    setSlashCommandConfig,
    setSchemaConfig,
    setSchemaConfigReady,
    setSchemaConfigRequired,
    documentVersionRef,
    hasLoadedDocumentRef,
    toolbarPopupCallbacksRef,
    pendingDocumentRef,
    schemaChangePendingRef,
  ]);
}
