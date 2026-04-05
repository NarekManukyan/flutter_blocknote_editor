/**
 * Transaction sending utilities.
 */

import { generateBlockId } from './idGenerator.js';
import { sendToFlutter } from './flutterBridge';

/**
 * Build initial update operations representing the current document state.
 * @param {Object} editor - The BlockNote editor instance.
 * @param {Array<Object>|null} serializedCurrentBlocks - Serialized blocks or null.
 * @returns {Array<Object>} Array of update operations.
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
      blockId,
      block,
      parentId: parentBlock?.id ?? null,
      beforeChildId: prevBlock?.id ?? null,
      afterChildId: nextBlock?.id ?? null,
    };
  });
}

/**
 * Remove redundant insert+delete pairs for the same blockId.
 * @param {Array<Object>} operations
 * @returns {Array<Object>} Filtered operations.
 */
export function filterRedundantOperations(operations) {
  const insertIds = new Set(
    operations.filter((op) => op.operation === 'insert').map((op) => op.blockId),
  );
  const deleteIds = new Set(
    operations.filter((op) => op.operation === 'delete').map((op) => op.blockId),
  );
  const redundantIds = new Set([...insertIds].filter((id) => deleteIds.has(id)));

  if (redundantIds.size === 0) return operations;

  return operations.filter((op) => {
    if (op.operation === 'insert' || op.operation === 'delete') {
      return !redundantIds.has(op.blockId);
    }
    return true;
  });
}

/**
 * Send a transaction payload to Flutter.
 * @param {Array<Object>} operations - Operations for the transaction.
 * @param {Object} refs - Shared mutable refs with documentVersion property.
 */
export function sendTransactionsToFlutter(operations, refs) {
  const filtered = filterRedundantOperations(operations);
  if (filtered.length === 0) return;

  const operationsWithIndex = filtered.map((op, i) => ({ ...op, index: i }));

  const transactions = [
    {
      baseVersion: refs.documentVersion,
      operations: operationsWithIndex,
    },
  ];

  refs.documentVersion++;

  sendToFlutter('transactions', {
    data: transactions,
    timestamp: Date.now(),
  });
}
