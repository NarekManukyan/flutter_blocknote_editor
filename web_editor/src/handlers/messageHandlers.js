/**
 * Message handlers for Flutter messages.
 */

import { loadDocument } from '../utils/documentLoader';
import { sendErrorToFlutter, debugLog } from '../utils/flutterBridge';
import { sendToFlutter } from '../utils/flutterBridge';

/**
 * Load a document into the editor or defer it when unavailable.
 * @param {object|null} editor
 * @param {object} messageData
 * @param {object} refs - Shared mutable refs (documentVersion, hasLoadedDocument, pendingDocument)
 */
export function handleLoadDocument(editor, messageData, refs) {
  if (!editor) {
    refs.pendingDocument = messageData;
    return;
  }
  loadDocument(editor, messageData, refs, refs.resetPreviousBlocks);
}

/**
 * Apply a new schema configuration. Deferral of pendingDocument is handled by
 * the App.jsx effect that watches editor + refs.pendingDocument.
 * @param {*} editor
 * @param {Object} message
 * @param {Function} dispatchSchema - Schema state dispatcher
 * @param {Object} SCHEMA_ACTIONS - Action type constants
 * @param {Object} refs - Shared mutable refs
 */
export function handleSetSchemaConfig(
  editor,
  message,
  dispatchSchema,
  SCHEMA_ACTIONS,
  refs,
) {
  const isRequired =
    message.required !== undefined
      ? Boolean(message.required)
      : Boolean(message.data);

  dispatchSchema({ type: SCHEMA_ACTIONS.SET_REQUIRED, payload: isRequired });
  dispatchSchema({ type: SCHEMA_ACTIONS.SET_CONFIG, payload: message.data ?? null });
  dispatchSchema({ type: SCHEMA_ACTIONS.SET_READY, payload: true });
  // Note: pendingDocument loading after schema change is handled by the App.jsx
  // effect (watches editor + refs.pendingDocument). Do not duplicate it here.
}

/**
 * Force-flush any pending transactions.
 */
export function handleFlush(editor) {
  if (typeof window.sendPendingTransaction === 'function') {
    window.sendPendingTransaction();
  } else if (editor?.onChange) {
    editor.onChange();
  }
}

/**
 * Apply theme from message.
 * @param {Object} message
 * @param {Function} setTheme
 */
export function handleSetTheme(message, setTheme) {
  try {
    debugLog('Setting theme:', message.data);
    setTheme(message.data);
  } catch (error) {
    console.error('[BlockNote] Error setting theme:', error);
  }
}

/**
 * Update the global debounce duration.
 * @param {Object} message - Contains durationMs field
 */
export function handleSetDebounceDuration(message) {
  if (typeof message.durationMs === 'number' && message.durationMs >= 0) {
    window.__blockNoteDebounceDuration = message.durationMs;
    if (typeof window.updateDebounceDuration === 'function') {
      window.updateDebounceDuration(message.durationMs);
    }
  }
}

/**
 * Create a fallback block serializer for when window.serializeBlock is unavailable.
 */
function createFallbackSerializeBlock() {
  const serialize = (node) => {
    if (!node) return null;

    const result = { id: node.id, type: node.type };

    if (Array.isArray(node.content)) {
      result.content = node.content;
    } else if (node.content?.type === 'tableContent') {
      result.content = node.content;
    }

    if (node.props && typeof node.props === 'object') {
      result.props = node.props;
    }

    if (node.children?.length > 0) {
      result.children = node.children.map(serialize).filter(Boolean);
    }

    return result;
  };

  return serialize;
}

/**
 * Serialize and return the current document to Flutter.
 * @param {object|null} editor
 * @param {object} message - Contains requestId
 */
export function handleGetDocument(editor, message) {
  if (!editor) {
    sendErrorToFlutter('Editor not initialized');
    return;
  }

  try {
    const currentBlocks = editor.topLevelBlocks || [];
    const serializeBlock =
      window.serializeBlock || createFallbackSerializeBlock();

    const serializedBlocks =
      currentBlocks.length > 0
        ? currentBlocks.map((block) => serializeBlock(block))
        : [];

    sendToFlutter('document', {
      requestId: message.requestId,
      document: { blocks: serializedBlocks },
    });
  } catch (error) {
    console.error('[BlockNote] Error getting document:', error);
    sendErrorToFlutter('Failed to get document: ' + error.message);
  }
}
