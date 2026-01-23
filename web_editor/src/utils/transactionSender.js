/**
 * Transaction sending utilities.
 * Extracted from useEditorReady to reduce complexity.
 */

/**
 * Creates initial operations for first-time document send.
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
 * Sends transactions to Flutter.
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
