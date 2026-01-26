/**
 * Block difference computation utilities.
 * Extracted from useEditorReady to reduce complexity.
 */

/**
 * Determine whether two block objects are deeply structurally equal.
 *
 * Compares `id`, `type`, `content` (treating absent content as `null`), `props` (defaulting to `{}`),
 * and recursively compares `children` arrays for equality.
 *
 * @param {Object|null|undefined} block1 - The first block to compare; may be `null` or `undefined`.
 * @param {Object|null|undefined} block2 - The second block to compare; may be `null` or `undefined`.
 * @returns {boolean} `true` if the blocks are equal in `id`, `type`, `content`, `props`, and `children`; `false` otherwise.
 */
export function blocksEqual(block1, block2) {
  const blocksEqualInner = (left, right) => {
    if (!left && !right) return true;
    if (!left || !right) return false;
    if (left.id !== right.id) return false;
    if (left.type !== right.type) return false;

    const content1 = JSON.stringify(left.content ?? null);
    const content2 = JSON.stringify(right.content ?? null);
    if (content1 !== content2) return false;

    const props1 = JSON.stringify(left.props || {});
    const props2 = JSON.stringify(right.props || {});
    if (props1 !== props2) return false;

    const children1 = left.children || [];
    const children2 = right.children || [];
    if (children1.length !== children2.length) return false;

    for (let i = 0; i < children1.length; i++) {
      if (!blocksEqualInner(children1[i], children2[i])) return false;
    }

    return true;
  };

  return blocksEqualInner(block1, block2);
}

/**
 * Determine the IDs of the blocks immediately before and after a given index in an ordered block list.
 * @param {Array<Object>} currentBlocks - Ordered array of block objects; blocks may omit an `id` property.
 * @param {number} index - Zero-based index to inspect.
 * @returns {{beforeChildId: string|null, afterChildId: string|null}} `beforeChildId` is the id of the block at index - 1 or `null` if out of range or missing; `afterChildId` is the id of the block at index + 1 or `null` if out of range, missing, or if `index` is the last position.
 */
function getAdjacentBlockIds(currentBlocks, index) {
  if (!currentBlocks || currentBlocks.length === 0) {
    return { beforeChildId: null, afterChildId: null };
  }

  if (index < 0 || index >= currentBlocks.length) {
    return { beforeChildId: null, afterChildId: null };
  }

  const isLastBlock = index === currentBlocks.length - 1;
  const beforeIndex = index - 1;
  const afterIndex = index + 1;

  const beforeChildId =
    beforeIndex >= 0 && currentBlocks[beforeIndex]?.id
      ? currentBlocks[beforeIndex].id
      : null;

  const afterChildId = isLastBlock
    ? null
    : afterIndex < currentBlocks.length && currentBlocks[afterIndex]?.id
      ? currentBlocks[afterIndex].id
      : null;

  return { beforeChildId, afterChildId };
}

/**
 * Produce a list of operations that transform a sequence of previous blocks into the given current blocks.
 *
 * @param {Array<Object>} previousBlocks - The prior sequence of block objects (each may include `id`, `type`, `content`, `props`, and `children`).
 * @param {Array<Object>} currentBlocks - The new sequence of block objects to compare against `previousBlocks`.
 * @param {(a: Object, b: Object) => boolean} blocksEqualFn - Function that returns `true` if two block objects are considered equal, `false` otherwise.
 * @returns {Array<Object>} An array of operation objects describing changes. Each operation has an `operation` field with one of:
 *  - `insert`: { operation: 'insert', blockId, block, index, beforeChildId, afterChildId }
 *  - `delete`: { operation: 'delete', blockId, beforeChildId, afterChildId }
 *  - `update`: { operation: 'update', blockId, block, beforeChildId, afterChildId }
 *  - `move`:   { operation: 'move', blockId, index, beforeChildId, afterChildId }
 *  The `beforeChildId` and `afterChildId` fields indicate adjacent sibling IDs for positional context and may be `null`.
 */
export function computeBlockDifferences(
  previousBlocks,
  currentBlocks,
  blocksEqualFn,
) {
  const operations = [];

  const previousMap = new Map();
  const currentMap = new Map();

  if (previousBlocks) {
    previousBlocks.forEach((block, index) => {
      if (block && block.id) {
        previousMap.set(block.id, { block, index });
      }
    });
  }

  if (currentBlocks) {
    currentBlocks.forEach((block, index) => {
      if (block && block.id) {
        currentMap.set(block.id, { block, index });
      }
    });
  }

  // Find deleted blocks
  for (const blockId of previousMap.keys()) {
    if (!currentMap.has(blockId)) {
      const prevEntry = previousMap.get(blockId);
      const prevIndex = prevEntry ? prevEntry.index : -1;
      const { beforeChildId, afterChildId } = getAdjacentBlockIds(
        currentBlocks,
        prevIndex,
      );

      operations.push({
        operation: 'delete',
        blockId: blockId,
        beforeChildId: beforeChildId,
        afterChildId: afterChildId,
      });
    }
  }

  // Find inserted and updated blocks
  if (currentBlocks) {
    currentBlocks.forEach((currBlock, currIndex) => {
      if (!currBlock || !currBlock.id) return;

      const blockId = currBlock.id;
      const prevEntry = previousMap.get(blockId);
      const { beforeChildId, afterChildId } = getAdjacentBlockIds(
        currentBlocks,
        currIndex,
      );

      if (!prevEntry) {
        // New block - insert
        operations.push({
          operation: 'insert',
          blockId: blockId,
          block: currBlock,
          index: currIndex,
          beforeChildId: beforeChildId,
          afterChildId: afterChildId,
        });
      } else {
        // Existing block - check if it changed
        const prevBlock = prevEntry.block;
        const prevIndex = prevEntry.index;

        if (!blocksEqualFn(prevBlock, currBlock)) {
          operations.push({
            operation: 'update',
            blockId: blockId,
            block: currBlock,
            beforeChildId: beforeChildId,
            afterChildId: afterChildId,
          });
        }

        if (prevIndex !== currIndex) {
          operations.push({
            operation: 'move',
            blockId: blockId,
            index: currIndex,
            beforeChildId: beforeChildId,
            afterChildId: afterChildId,
          });
        }
      }
    });
  }

  return operations;
}
