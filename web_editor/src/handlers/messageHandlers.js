/**
 * Message handlers for Flutter messages.
 * Extracted from useFlutterMessages to reduce complexity.
 */

import { loadDocument } from '../utils/documentLoader';

/**
 * Load a document into the editor or defer it when the editor is unavailable or a schema change is pending.
 *
 * If the editor is not present or `schemaChangePendingRef.current` is true, stores `messageData` on
 * `pendingDocumentRef.current` for later processing. Otherwise invokes the document loader to apply
 * `messageData` and update `documentVersionRef` / `hasLoadedDocumentRef`.
 *
 * @param {object|null} editor - The editor instance to load the document into, or null if not initialized.
 * @param {object} messageData - Document payload received from the message channel.
 * @param {object} documentVersionRef - Mutable ref object used to track the current document version.
 * @param {object} hasLoadedDocumentRef - Mutable ref object indicating whether a document has been loaded.
 * @param {object} pendingDocumentRef - Mutable ref object where a deferred `messageData` is stored.
 * @param {object} schemaChangePendingRef - Mutable ref object whose `current` flag indicates a pending schema change.
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
 * Apply a new schema configuration and, if necessary, reload a previously deferred document.
 *
 * Sets whether the schema config is required (preferring message.required over message.data),
 * marks a schema change as pending while updating the config and readiness state, and clears the
 * pending flag afterward. If an editor exists and a pending document is present, loads that
 * document and clears the pendingDocumentRef.
 *
 * @param {*} editor - Editor instance used to reload a pending document (may be null/undefined).
 * @param {{data: any, required?: boolean}} message - Incoming message containing `data` (new schema config) and optional `required` flag.
 * @param {function(any): void} setSchemaConfig - Setter to apply the new schema configuration (accepts config or null).
 * @param {function(boolean): void} setSchemaConfigReady - Setter to mark schema config readiness.
 * @param {function(boolean): void} setSchemaConfigRequired - Setter to mark whether a schema config is required.
 * @param {{current: any}} documentVersionRef - Ref holding the current document version (passed to loadDocument).
 * @param {{current: boolean}} hasLoadedDocumentRef - Ref indicating whether a document has been loaded.
 * @param {{current: any}} pendingDocumentRef - Ref holding a pending document to be loaded when schema updates complete.
 * @param {{current: boolean}} schemaChangePendingRef - Ref used to mark that a schema change is in progress.
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
 * Apply the theme payload from an incoming message to the editor.
 * @param {Object} message - Incoming message containing the theme payload in `message.data`.
 * @param {Function} setTheme - Function that applies the theme; called with the value of `message.data`.
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
 * Update the global debounce duration using the incoming message.
 *
 * If `message.durationMs` is a number greater than or equal to zero, sets
 * `window.__blockNoteDebounceDuration` and, if available, calls
 * `window.updateDebounceDuration` with the new value.
 *
 * @param {Object} message - Message object containing the new debounce duration.
 * @param {number} message.durationMs - Debounce duration in milliseconds (must be >= 0).
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
 * Create a fallback block serializer.
 *
 * The returned function serializes a block node into a plain object containing `id`, `type`,
 * and optional `content`, `props`, and recursively serialized `children`.
 * `content` is included when it is an array or an object with `type === 'tableContent'`.
 *
 * @returns {(node: Object|null) => Object|null} A serializer that returns the serialized block object, or `null` for a falsy input.
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
 * Fetches and serializes the editor's top-level blocks and sends them back via BlockNoteChannel.
 *
 * If no editor is available, posts an error message. Uses `window.serializeBlock` when present,
 * otherwise falls back to an internal serializer. On success posts a message with type `"document"`
 * that includes the original `requestId` and a `document.blocks` array; on failure logs the error
 * and posts an error message describing the failure.
 *
 * @param {object|null} editor - The editor instance whose `topLevelBlocks` will be serialized.
 * @param {object} message - Incoming message; expected to include `requestId` to correlate the response.
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