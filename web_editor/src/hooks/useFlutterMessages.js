/**
 * Custom hook for handling Flutter messages.
 */

import { useCallback, useEffect } from 'react';
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
 * Listen for Flutter-originated messages and delegate them to handlers.
 *
 * @param {Object} editor - The BlockNote editor instance.
 * @param {Object} setters - State setter functions { setIsReadonly, setTheme, setToolbarConfig, setSlashCommandConfig }
 * @param {Object} schemaControl - Schema dispatch { dispatchSchema, SCHEMA_ACTIONS }
 * @param {Object} refs - Shared mutable refs object with documentVersion, hasLoadedDocument, toolbarPopupCallbacks, pendingDocument, schemaChangePending
 */
export function useFlutterMessages(editor, setters, schemaControl, refs) {
  const { setIsReadonly, setTheme, setToolbarConfig, setSlashCommandConfig } =
    setters;
  const { dispatchSchema, SCHEMA_ACTIONS } = schemaControl;

  const handleFlutterMessage = useCallback(
    (message) => {
      switch (message.type) {
        case 'load_document':
          handleLoadDocument(editor, message.data, refs);
          break;
        case 'set_readonly':
          setIsReadonly(message.value);
          break;
        case 'set_schema_config':
          handleSetSchemaConfig(editor, message, dispatchSchema, SCHEMA_ACTIONS, refs);
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
          updateWebViewHeight(message.extraBottomPadding, editor);
          break;
        case 'inject_custom_css':
          injectCustomCss(message.css);
          break;
        case 'toolbar_popup_response':
          handleToolbarPopupResponse(message, refs.toolbarPopupCallbacks);
          break;
        case 'set_debounce_duration':
          handleSetDebounceDuration(message);
          break;
        case 'get_document':
          handleGetDocument(editor, message);
          break;
        default:
          if (window.BlockNoteDebugLogging) {
            console.warn('[BlockNote] Unknown message type:', message.type);
          }
      }
    },
    [
      editor,
      setIsReadonly,
      setTheme,
      setToolbarConfig,
      setSlashCommandConfig,
      dispatchSchema,
      SCHEMA_ACTIONS,
      refs,
    ],
  );

  useEffect(() => {
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
  }, [handleFlutterMessage]);
}
