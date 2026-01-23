/**
 * Transaction sending utilities.
 * Extracted from useEditorReady to reduce complexity.
 */

/**
 * Build the initial list of update operations representing the current document state.
 *
 * When no blocks are provided, returns a single operation that updates the root with a null block.
 * When blocks are provided, returns one 'update' operation per block with surrounding child links.
 *
 * @param {Array<Object>|null|undefined} serializedCurrentBlocks - Array of block objects in document order, or falsy if no blocks exist.
 * @returns {Array<Object>} An array of operation objects. Each operation has the form:
 *   {
 *     operation: 'update',
 *     blockId: string,        // block.id if present, otherwise a generated id like "block_<index>"
 *     block: Object|null,     // the block object (null for the root update when no blocks)
 *     beforeChildId: string|null, // id of the previous block or null
 *     afterChildId: string|null   // id of the next block or null
 *   }
 */
export function createInitialOperations(serializedCurrentBlocks) {
  if (!serializedCurrentBlocks) {
    return [
      {
        operation: 'update',
        blockId: 'root',
        block: null,
        beforeChildId: null,
        afterChildId: null,
      },
    ];
  }

  return serializedCurrentBlocks.map((block, index) => {
    const isLastBlock = index === serializedCurrentBlocks.length - 1;
    const beforeIndex = index - 1;
    const afterIndex = index + 1;
    const beforeChildId =
      beforeIndex >= 0 && serializedCurrentBlocks[beforeIndex]?.id
        ? serializedCurrentBlocks[beforeIndex].id
        : null;
    const afterChildId = isLastBlock
      ? null
      : afterIndex < serializedCurrentBlocks.length &&
          serializedCurrentBlocks[afterIndex]?.id
        ? serializedCurrentBlocks[afterIndex].id
        : null;

    return {
      operation: 'update',
      blockId: block.id || `block_${index}`,
      block: block,
      beforeChildId: beforeChildId,
      afterChildId: afterChildId,
    };
  });
}

/**
 * Send a transaction payload containing the provided operations to the Flutter channel.
 *
 * Constructs a single transaction object using documentVersionRef.current as the baseVersion,
 * increments documentVersionRef.current, and posts the transaction array to window.BlockNoteChannel.
 *
 * @param {Array<Object>} operations - Array of operation objects to include in the transaction. Each operation typically contains:
 *   - `operation` (string): the action type (e.g., 'update'),
 *   - `blockId` (string): identifier for the block,
 *   - `block` (Object|null): the block payload or null,
 *   - `beforeChildId` (string|null): preceding sibling block id or null,
 *   - `afterChildId` (string|null): following sibling block id or null.
 * @param {{ current: number }} documentVersionRef - Mutable ref object whose `current` value is used as the transaction's baseVersion and then incremented.
 */
export function sendTransactionsToFlutter(operations, documentVersionRef) {
  if (operations.length === 0) return;

  const transactions = [
    {
      baseVersion: documentVersionRef.current,
      operations: operations,
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