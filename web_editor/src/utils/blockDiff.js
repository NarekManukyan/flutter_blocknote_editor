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
/**
 * Optimized block equality check that avoids JSON.stringify when possible.
 * Uses shallow comparison first, then deep comparison only when needed.
 */
export function blocksEqual(block1, block2) {
  const blocksEqualInner = (left, right) => {
    if (!left && !right) return true;
    if (!left || !right) return false;
    if (left.id !== right.id) return false;
    if (left.type !== right.type) return false;

    // Fast path: if references are the same, they're equal
    if (left === right) return true;

    // Shallow comparison for content (most common case)
    const leftContent = left.content ?? null;
    const rightContent = right.content ?? null;
    if (leftContent !== rightContent) {
      // Only use JSON.stringify if shallow comparison fails
      const content1 = JSON.stringify(leftContent);
      const content2 = JSON.stringify(rightContent);
      if (content1 !== content2) return false;
    }

    // Shallow comparison for props
    const leftProps = left.props || {};
    const rightProps = right.props || {};
    if (leftProps !== rightProps) {
      // Only use JSON.stringify if shallow comparison fails
      const props1 = JSON.stringify(leftProps);
      const props2 = JSON.stringify(rightProps);
      if (props1 !== props2) return false;
    }

    const children1 = left.children || [];
    const children2 = right.children || [];
    if (children1.length !== children2.length) return false;

    // Fast path: if children arrays are the same reference, they're equal
    if (children1 === children2) return true;

    for (let i = 0; i < children1.length; i++) {
      if (!blocksEqualInner(children1[i], children2[i])) return false;
    }

    return true;
  };

  return blocksEqualInner(block1, block2);
}

/**
 * Get the IDs of the previous and next sibling blocks for a block in a top-level block array.
 * Used when the block is no longer in the editor (e.g. delete operations).
 *
 * @param {Array<Object>} blocks - Top-level ordered array of block objects.
 * @param {string} blockId - The block id to find.
 * @returns {{beforeChildId: string|null, afterChildId: string|null}} `beforeChildId` is the previous sibling's id; `afterChildId` is the next sibling's id; both `null` if not found or no sibling.
 */
function getAdjacentBlockIdsFromTopLevel(blocks, blockId) {
  if (!blocks?.length || !blockId) {
    return { beforeChildId: null, afterChildId: null };
  }

  const index = blocks.findIndex((b) => b?.id === blockId);
  if (index < 0) {
    return { beforeChildId: null, afterChildId: null };
  }

  const beforeChildId =
    index > 0 && blocks[index - 1]?.id ? blocks[index - 1].id : null;
  const afterChildId =
    index < blocks.length - 1 && blocks[index + 1]?.id
      ? blocks[index + 1].id
      : null;

  return { beforeChildId, afterChildId };
}

/**
 * Get adjacent sibling block IDs and parent from the BlockNote editor (getPrevBlock/getNextBlock/getParentBlock).
 *
 * @param {Object} editor - The BlockNote editor instance.
 * @param {string} blockId - The block id to look up.
 * @returns {{beforeChildId: string|null, afterChildId: string|null, parentId: string|null}}
 */
function getBlockContextFromEditor(editor, blockId) {
  if (!editor || !blockId) {
    return { beforeChildId: null, afterChildId: null, parentId: null };
  }

  const prevBlock = editor.getPrevBlock?.(blockId);
  const nextBlock = editor.getNextBlock?.(blockId);
  const parentBlock = editor.getParentBlock?.(blockId);

  return {
    beforeChildId: prevBlock?.id ?? null,
    afterChildId: nextBlock?.id ?? null,
    parentId: parentBlock?.id ?? null,
  };
}

/**
 * Produce a list of operations that transform a sequence of previous blocks into the given current blocks.
 * Uses BlockNote editor getPrevBlock/getNextBlock for adjacent sibling IDs (insert/update/reorder).
 * For delete operations, adjacent IDs are derived from the previous block tree since the block is no longer in the editor.
 *
 * @param {Object} editor - The BlockNote editor instance (used for getPrevBlock/getNextBlock).
 * @param {Array<Object>} previousBlocks - The prior sequence of block objects (each may include `id`, `type`, `content`, `props`, and `children`).
 * @param {Array<Object>} currentBlocks - The new sequence of block objects to compare against `previousBlocks`.
 * @param {(a: Object, b: Object) => boolean} blocksEqualFn - Function that returns `true` if two block objects are considered equal, `false` otherwise.
 * @returns {Array<Object>} An array of operation objects describing changes. Each operation has an `operation` field with one of:
 *  - `insert`: { operation: 'insert', blockId, block, parentId, beforeChildId, afterChildId }
 *  - `delete`: { operation: 'delete', blockId, beforeChildId, afterChildId }
 *  - `update`: { operation: 'update', blockId, block, parentId, beforeChildId, afterChildId }
 *  - `reorder`: { operation: 'reorder', parentId, afterChildId, beforeChildId, orderedChildIds } — single op when the same set of blocks was reordered (no insert/delete). One transaction for the whole reorder.
 *  The `parentId` is the block's parent (null for top-level). `beforeChildId` and `afterChildId` are previous/next sibling IDs.
 */
export function computeBlockDifferences(
  editor,
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

  const hasInsertOrDelete =
    previousMap.size !== currentMap.size ||
    [...previousMap.keys()].some((id) => !currentMap.has(id));

  // Find deleted blocks (block no longer in editor; use previous block tree for adjacent IDs)
  for (const blockId of previousMap.keys()) {
    if (!currentMap.has(blockId)) {
      const { beforeChildId, afterChildId } = getAdjacentBlockIdsFromTopLevel(
        previousBlocks,
        blockId,
      );

      operations.push({
        operation: 'delete',
        blockId: blockId,
        beforeChildId: beforeChildId,
        afterChildId: afterChildId,
      });
    }
  }

  // Collect moved block ids when it's a pure reorder (same set of blocks, no insert/delete)
  const movedBlockIds =
    !hasInsertOrDelete && currentBlocks
      ? currentBlocks
          .filter((currBlock, currIndex) => {
            if (!currBlock?.id || !previousMap.has(currBlock.id)) return false;
            const prevIndex = previousMap.get(currBlock.id).index;
            return prevIndex !== currIndex;
          })
          .map((b) => b.id)
      : [];

  // Find inserted, updated blocks (use editor getPrevBlock/getNextBlock/getParentBlock for context)
  if (currentBlocks) {
    currentBlocks.forEach((currBlock) => {
      if (!currBlock || !currBlock.id) return;

      const blockId = currBlock.id;
      const { beforeChildId, afterChildId, parentId } =
        getBlockContextFromEditor(editor, blockId);

      if (!previousMap.has(blockId)) {
        // New block - insert
        operations.push({
          operation: 'insert',
          blockId: blockId,
          block: currBlock,
          parentId: parentId,
          beforeChildId: beforeChildId,
          afterChildId: afterChildId,
        });
      } else {
        const prevEntry = previousMap.get(blockId);
        const prevBlock = prevEntry.block;

        if (!blocksEqualFn(prevBlock, currBlock)) {
          operations.push({
            operation: 'update',
            blockId: blockId,
            block: currBlock,
            parentId: parentId,
            beforeChildId: beforeChildId,
            afterChildId: afterChildId,
          });
        }
      }
    });
  }

  // Emit a single reorder operation when blocks were reordered (top-level parent = null)
  if (movedBlockIds.length > 0) {
    const firstMovedId = movedBlockIds[0];
    const { beforeChildId, afterChildId, parentId } = getBlockContextFromEditor(
      editor,
      firstMovedId,
    );
    operations.push({
      operation: 'reorder',
      blockId: '',
      parentId: parentId,
      afterChildId: afterChildId,
      beforeChildId: beforeChildId,
      orderedChildIds: movedBlockIds,
    });
  }

  return operations;
}
