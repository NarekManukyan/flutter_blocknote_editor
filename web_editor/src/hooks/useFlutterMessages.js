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
 * Listen for Flutter-originated messages and delegate them to handlers that update the editor state and related UI/configuration.
 *
 * Attaches a window 'flutterMessage' listener that routes incoming message payloads to the appropriate handler (document loading, schema updates, theme, toolbar, etc.) and cleans up the listener on unmount. Also processes any pending schema config left on window.__blockNotePendingSchemaConfig.
 *
 * @param {Object} editor - The BlockNote editor instance.
 * @param {Function} setIsReadonly - Setter to update the editor read-only state.
 * @param {Function} setTheme - Setter to update the editor theme.
 * @param {Function} setToolbarConfig - Setter to update the toolbar configuration.
 * @param {Function} setSlashCommandConfig - Setter to update slash-command configuration.
 * @param {Function} setSchemaConfig - Setter to update the editor schema configuration.
 * @param {Function} setSchemaConfigReady - Setter to mark schema config as ready.
 * @param {Function} setSchemaConfigRequired - Setter to indicate that schema config is required.
 * @param {Object} documentVersionRef - Ref tracking the current document version.
 * @param {Object} hasLoadedDocumentRef - Ref indicating whether a document has been loaded.
 * @param {Object} toolbarPopupCallbacksRef - Ref storing callbacks for toolbar popup responses.
 * @param {Object} pendingDocumentRef - Ref storing a pending document awaiting processing.
 * @param {Object} schemaChangePendingRef - Ref indicating whether a schema change is pending.
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