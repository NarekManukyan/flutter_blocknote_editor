/**
 * Custom hook for handling Flutter messages.
 */

import { useEffect } from 'react';
import { loadDocument } from '../utils/documentLoader';
import { updateWebViewHeight } from '../utils/webViewHeightManager';
import { injectCustomCss } from '../utils/cssInjector';
import { handleToolbarPopupResponse } from '../utils/toolbarPopupHandler';

/**
 * Wire incoming Flutter messages to the editor and UI state handlers.
 *
 * Registers a window 'flutterMessage' listener and dispatches message payloads
 * to editor-related handlers. Supports document loading (with optional
 * deferral while a schema update is pending), applying schema configuration
 * and readiness flags, forcing transaction flushes, theme/config updates,
 * webview height updates, injecting CSS, and routing toolbar popup responses.
 *
 * @param {Object} editor - The BlockNote editor instance.
 * @param {Function} setIsReadonly - Setter for read-only state.
 * @param {Function} setTheme - Setter for theme.
 * @param {Function} setToolbarConfig - Setter for toolbar configuration.
 * @param {Function} setSlashCommandConfig - Setter for slash command configuration.
 * @param {Function} setSchemaConfig - Setter for schema configuration (may receive null).
 * @param {Function} setSchemaConfigReady - Setter to mark schema config as ready.
 * @param {Function} setSchemaConfigRequired - Setter to mark whether schema config is required.
 * @param {Object} documentVersionRef - Ref used to track the current document version.
 * @param {Object} hasLoadedDocumentRef - Ref indicating whether a document has been loaded.
 * @param {Object} toolbarPopupCallbacksRef - Ref storing callbacks for toolbar popup responses.
 * @param {Object} pendingDocumentRef - Ref used to hold a document payload when loading is deferred.
 * @param {Object} schemaChangePendingRef - Ref indicating whether a schema update is in progress.
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