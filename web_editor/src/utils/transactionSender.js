/**
 * Transaction sending utilities.
 * Extracted from useEditorReady to reduce complexity.
 */

import { generateBlockId } from './idGenerator.js';

/**
 * Build the initial list of update operations representing the current document state.
 *
 * When no blocks are provided, returns a single operation that updates the root with a null block.
 * When blocks are provided, returns one 'update' operation per block with surrounding child links
 * derived from the BlockNote editor getPrevBlock/getNextBlock.
 *
 * @param {Object} editor - The BlockNote editor instance (used for getPrevBlock/getNextBlock).
 * @param {Array<Object>|null|undefined} serializedCurrentBlocks - Array of block objects in document order, or falsy if no blocks exist.
 * @returns {Array<Object>} An array of operation objects. Each operation has the form:
 *   {
 *     operation: 'update',
 *     blockId: string,        // block.id if present, otherwise a UUID v4
 *     block: Object|null,     // the block object (null for the root update when no blocks)
 *     beforeChildId: string|null, // id of the previous sibling block or null
 *     afterChildId: string|null   // id of the next sibling block or null
 *   }
 */
export function createInitialOperations(editor, serializedCurrentBlocks) {
  if (!serializedCurrentBlocks) {
    return [
      {
        operation: 'update',
        blockId: generateBlockId(),
        block: null,
        beforeChildId: null,
        afterChildId: null,
      },
    ];
  }

  return serializedCurrentBlocks.map((block) => {
    const blockId = block.id || generateBlockId();
    const prevBlock = editor?.getPrevBlock?.(blockId);
    const nextBlock = editor?.getNextBlock?.(blockId);
    const parentBlock = editor?.getParentBlock?.(blockId);

    return {
      operation: 'update',
      blockId: blockId,
      block: block,
      parentId: parentBlock?.id ?? null,
      beforeChildId: prevBlock?.id ?? null,
      afterChildId: nextBlock?.id ?? null,
    };
  });
}

/**
 * Remove redundant operations: when the same block has both insert and delete in the same batch, drop both
 * (e.g. block added then removed before send, or when merging multiple batches).
 *
 * @param {Array<Object>} operations - Raw operations from diff.
 * @returns {Array<Object>} Filtered operations.
 */
export function filterRedundantOperations(operations) {
  const insertIds = new Set(
    operations
      .filter((op) => op.operation === 'insert')
      .map((op) => op.blockId),
  );
  const deleteIds = new Set(
    operations
      .filter((op) => op.operation === 'delete')
      .map((op) => op.blockId),
  );
  const redundantIds = new Set(
    [...insertIds].filter((id) => deleteIds.has(id)),
  );
  if (redundantIds.size === 0) return operations;
  return operations.filter((op) => {
    if (op.operation === 'insert' || op.operation === 'delete') {
      return !redundantIds.has(op.blockId);
    }
    return true;
  });
}

/**
 * Send a transaction payload containing the provided operations to the Flutter channel.
 *
 * Constructs a single transaction object using documentVersionRef.current as the baseVersion,
 * increments documentVersionRef.current, and posts the transaction array to window.BlockNoteChannel.
 * Redundant insert+delete pairs for the same blockId are filtered out before sending.
 *
 * @param {Array<Object>} operations - Array of operation objects to include in the transaction. Each operation typically contains:
 *   - `operation` (string): the action type (e.g., 'update'),
 *   - `blockId` (string): identifier for the block,
 *   - `block` (Object|null): the block payload or null,
 *   - `parentId` (string|null): parent block id or null,
 *   - `beforeChildId` (string|null): preceding sibling block id or null,
 *   - `afterChildId` (string|null): following sibling block id or null.
 * @param {{ current: number }} documentVersionRef - Mutable ref object whose `current` value is used as the transaction's baseVersion and then incremented.
 */
export function sendTransactionsToFlutter(operations, documentVersionRef) {
  const filtered = filterRedundantOperations(operations);
  if (filtered.length === 0) return;

  const transactions = [
    {
      baseVersion: documentVersionRef.current,
      operations: filtered,
    },
  ];

  documentVersionRef.current++;

  window.BlockNoteChannel.postMessage(
    JSON.stringify({
      type: 'transactions',
      data: transactions,
      timestamp: Date.now(),
    }),
  );
}
