/**
 * Message handlers for Flutter messages.
 * Extracted from useFlutterMessages to reduce complexity.
 */

import { loadDocument } from '../utils/documentLoader';

/**
 * Handles load_document message.
 */
export function handleLoadDocument(
  editor,
  messageData,
  documentVersionRef,
  hasLoadedDocumentRef,
  pendingDocumentRef,
  schemaChangePendingRef,
) {
  if (!editor || schemaChangePendingRef.current) {
    pendingDocumentRef.current = messageData;
    return;
  }
  loadDocument(editor, messageData, documentVersionRef, hasLoadedDocumentRef);
}

/**
 * Handles set_schema_config message.
 */
export function handleSetSchemaConfig(
  editor,
  message,
  setSchemaConfig,
  setSchemaConfigReady,
  setSchemaConfigRequired,
  documentVersionRef,
  hasLoadedDocumentRef,
  pendingDocumentRef,
  schemaChangePendingRef,
) {
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
}

/**
 * Handles flush message.
 */
export function handleFlush(editor) {
  if (
    window.sendPendingTransaction &&
    typeof window.sendPendingTransaction === 'function'
  ) {
    window.sendPendingTransaction();
  } else if (editor && editor.onChange) {
    editor.onChange();
  }
}

/**
 * Handles set_theme message.
 */
export function handleSetTheme(message, setTheme) {
  try {
    console.log('[BlockNote] Setting theme:', message.data);
    setTheme(message.data);
  } catch (error) {
    console.error('[BlockNote] Error setting theme:', error);
  }
}

/**
 * Handles set_debounce_duration message.
 */
export function handleSetDebounceDuration(message) {
  if (typeof message.durationMs === 'number' && message.durationMs >= 0) {
    window.__blockNoteDebounceDuration = message.durationMs;
    if (
      window.updateDebounceDuration &&
      typeof window.updateDebounceDuration === 'function'
    ) {
      window.updateDebounceDuration(message.durationMs);
    }
  }
}

/**
 * Fallback serialization function for blocks.
 */
function createFallbackSerializeBlock() {
  const serializeBlockInner = (node) => {
    if (!node) return null;

    const serialized = {
      id: node.id,
      type: node.type,
    };

    if (node.content && Array.isArray(node.content)) {
      serialized.content = node.content;
    } else if (
      node.content &&
      typeof node.content === 'object' &&
      node.content.type === 'tableContent'
    ) {
      serialized.content = node.content;
    }

    if (node.props && typeof node.props === 'object') {
      serialized.props = node.props;
    }

    if (
      node.children &&
      Array.isArray(node.children) &&
      node.children.length > 0
    ) {
      serialized.children = node.children
        .map((child) => serializeBlockInner(child))
        .filter(Boolean);
    }

    return serialized;
  };

  return serializeBlockInner;
}

/**
 * Handles get_document message.
 */
export function handleGetDocument(editor, message) {
  if (!editor) {
    window.BlockNoteChannel.postMessage(
      JSON.stringify({
        type: 'error',
        data: {
          message: 'Editor not initialized',
        },
      }),
    );
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

    window.BlockNoteChannel.postMessage(
      JSON.stringify({
        type: 'document',
        requestId: message.requestId,
        document: {
          blocks: serializedBlocks,
        },
      }),
    );
  } catch (error) {
    console.error('[BlockNote] Error getting document:', error);
    window.BlockNoteChannel.postMessage(
      JSON.stringify({
        type: 'error',
        data: {
          message: 'Failed to get document: ' + error.message,
        },
      }),
    );
  }
}
