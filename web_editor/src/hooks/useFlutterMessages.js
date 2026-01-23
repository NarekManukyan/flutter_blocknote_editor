/**
 * Custom hook for handling Flutter messages.
 */

import { useEffect } from 'react';
import { updateWebViewHeight } from '../utils/webViewHeightManager';
import { injectCustomCss } from '../utils/cssInjector';
import { handleToolbarPopupResponse } from '../utils/toolbarPopupHandler';
import {
  handleLoadDocument,
  handleSetSchemaConfig,
  handleFlush,
  handleSetTheme,
  handleSetDebounceDuration,
  handleGetDocument,
} from '../handlers/messageHandlers';

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
          handleLoadDocument(
            editor,
            message.data,
            documentVersionRef,
            hasLoadedDocumentRef,
            pendingDocumentRef,
            schemaChangePendingRef,
          );
          break;
        case 'set_readonly':
          setIsReadonly(message.value);
          break;
        case 'set_schema_config':
          handleSetSchemaConfig(
            editor,
            message,
            setSchemaConfig,
            setSchemaConfigReady,
            setSchemaConfigRequired,
            documentVersionRef,
            hasLoadedDocumentRef,
            pendingDocumentRef,
            schemaChangePendingRef,
          );
          break;
        case 'flush':
          handleFlush(editor);
          break;
        case 'set_theme':
          handleSetTheme(message, setTheme);
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
        case 'set_debounce_duration':
          handleSetDebounceDuration(message);
          break;
        case 'get_document':
          handleGetDocument(editor, message);
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
