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
    // Fast path: identical reference means all fields are equal.
    if (left === right) return true;
    if (left.id !== right.id) return false;
    if (left.type !== right.type) return false;

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
 * Compare two blocks for "did this block itself change" — same as blocksEqual except children
 * are compared only by id list (same length, same ids in order). Used so we do not emit an
 * update for a parent when the only change is in a descendant (we emit only for the edited block).
 *
 * @param {Object|null|undefined} block1 - First block.
 * @param {Object|null|undefined} block2 - Second block.
 * @returns {boolean} True if id, type, content, props match and children have same ids in order.
 */
function blocksEqualShallowChildren(block1, block2) {
  if (!block1 && !block2) return true;
  if (!block1 || !block2) return false;
  if (block1.id !== block2.id) return false;
  if (block1.type !== block2.type) return false;
  if (block1 === block2) return true;
  const c1 = block1.content ?? null;
  const c2 = block2.content ?? null;
  if (JSON.stringify(c1) !== JSON.stringify(c2)) return false;
  const p1 = block1.props || {};
  const p2 = block2.props || {};
  if (JSON.stringify(p1) !== JSON.stringify(p2)) return false;
  const ch1 = block1.children || [];
  const ch2 = block2.children || [];
  if (ch1.length !== ch2.length) return false;
  for (let i = 0; i < ch1.length; i++) {
    if (ch1[i]?.id !== ch2[i]?.id) return false;
  }
  return true;
}

/**
 * Get adjacent sibling block IDs and parent for a block anywhere in a block tree.
 * Used for delete operations when the block is no longer in the editor (searches previous tree).
 *
 * @param {Array<Object>} blocks - Block tree (top-level array; each block may have `children`).
 * @param {string} blockId - The block id to find.
 * @returns {{beforeChildId: string|null, afterChildId: string|null, parentId: string|null}} Sibling and parent ids; all `null` if not found.
 */
function getBlockContextFromTree(blocks, blockId) {
  if (!blocks?.length || !blockId) {
    return { beforeChildId: null, afterChildId: null, parentId: null };
  }
  function search(list, parent) {
    for (let i = 0; i < list.length; i++) {
      const node = list[i];
      if (node?.id === blockId) {
        const beforeChildId = i > 0 && list[i - 1]?.id ? list[i - 1].id : null;
        const afterChildId =
          i < list.length - 1 && list[i + 1]?.id ? list[i + 1].id : null;
        const parentId = parent?.id ?? null;
        return { beforeChildId, afterChildId, parentId };
      }
      if (node?.children?.length) {
        const found = search(node.children, node);
        if (found) return found;
      }
    }
    return null;
  }
  return (
    search(blocks, null) ?? {
      beforeChildId: null,
      afterChildId: null,
      parentId: null,
    }
  );
}

/**
 * Collect all blocks from a block tree in depth-first order (for diffing at all levels).
 *
 * @param {Array<Object>} blocks - Block tree (top-level array; each block may have `children`).
 * @returns {Array<Object>} Flat array of block objects in depth-first order.
 */
function collectBlocksDepthFirst(blocks) {
  const result = [];
  function walk(list) {
    for (const b of list || []) {
      if (b?.id) {
        result.push(b);
        if (b.children?.length) walk(b.children);
      }
    }
  }
  walk(blocks);
  return result;
}

/**
 * Get the IDs of the previous and next sibling blocks for a block in a top-level block array.
 * Used only when the block is no longer in the editor (e.g. delete operations). Does not search
 * nested children—only the top-level array. Prefer getBlockContextFromTree for nested blocks.
 *
 * @param {Array<Object>} blocks - Top-level ordered array of block objects (not a flattened tree).
 * @param {string} blockId - The block id to find.
 * @returns {{beforeChildId: string|null, afterChildId: string|null}} `beforeChildId` is the previous sibling's id; `afterChildId` is the next sibling's id; both `null` if not found or no sibling.
 */
export function getAdjacentBlockIdsFromTopLevel(blocks, blockId) {
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
 * Semantics: beforeChildId = previous sibling, afterChildId = next sibling (matches BlockNote and Dart model).
 *
 * @param {Object} editor - The BlockNote editor instance.
 * @param {string} blockId - The block id to look up.
 * @returns {{beforeChildId: string|null, afterChildId: string|null, parentId: string|null}}
 */
export function getBlockContextFromEditor(editor, blockId) {
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
 * @returns {Array<Object>} An array of operation objects describing changes. Each operation has an `operation` field with one of:
 *  - `insert`: { operation: 'insert', blockId, block, parentId, beforeChildId, afterChildId }
 *  - `delete`: { operation: 'delete', blockId, beforeChildId, afterChildId }
 *  - `update`: { operation: 'update', blockId, block, parentId, beforeChildId, afterChildId }
 *  - `reorder`: { operation: 'reorder', parentId, afterChildId, beforeChildId, orderedChildIds } — single op when the same set of blocks was reordered (no insert/delete). One transaction for the whole reorder.
 *  The `parentId` is the block's parent (null for top-level). `beforeChildId` and `afterChildId` are previous/next sibling IDs.
 */
export function computeBlockDifferences(editor, previousBlocks, currentBlocks) {
  const operations = [];

  const previousListFull = collectBlocksDepthFirst(previousBlocks || []);
  const currentListFull = collectBlocksDepthFirst(currentBlocks || []);
  const previousMapFull = new Map();
  const currentMapFull = new Map();
  previousListFull.forEach((b) => previousMapFull.set(b.id, b));
  currentListFull.forEach((b) => currentMapFull.set(b.id, b));

  const previousMapTop = new Map();
  const currentMapTop = new Map();
  if (previousBlocks) {
    previousBlocks.forEach((block, index) => {
      if (block?.id) previousMapTop.set(block.id, { block, index });
    });
  }
  if (currentBlocks) {
    currentBlocks.forEach((block, index) => {
      if (block?.id) currentMapTop.set(block.id, { block, index });
    });
  }

  const hasInsertOrDelete =
    previousMapTop.size !== currentMapTop.size ||
    [...previousMapTop.keys()].some((id) => !currentMapTop.has(id));

  // Find deleted blocks (any level); use previous tree for sibling/parent context
  for (const blockId of previousMapFull.keys()) {
    if (!currentMapFull.has(blockId)) {
      const { beforeChildId, afterChildId, parentId } = getBlockContextFromTree(
        previousBlocks,
        blockId,
      );
      operations.push({
        operation: 'delete',
        blockId: blockId,
        beforeChildId: beforeChildId,
        afterChildId: afterChildId,
        parentId: parentId,
      });
    }
  }

  // Collect moved block ids when it's a pure reorder at top level (same set of top-level blocks, no insert/delete)
  const movedBlockIds =
    !hasInsertOrDelete && currentBlocks
      ? currentBlocks
          .filter((currBlock, currIndex) => {
            if (!currBlock?.id || !previousMapTop.has(currBlock.id))
              return false;
            const prevIndex = previousMapTop.get(currBlock.id).index;
            return prevIndex !== currIndex;
          })
          .map((b) => b.id)
      : [];

  // Find inserted, updated blocks at all levels (use editor getPrevBlock/getNextBlock/getParentBlock for context)
  for (const currBlock of currentListFull) {
    if (!currBlock?.id) continue;
    const blockId = currBlock.id;
    const { beforeChildId, afterChildId, parentId } = getBlockContextFromEditor(
      editor,
      blockId,
    );

    if (!previousMapFull.has(blockId)) {
      operations.push({
        operation: 'insert',
        blockId: blockId,
        block: currBlock,
        parentId: parentId,
        beforeChildId: beforeChildId,
        afterChildId: afterChildId,
      });
    } else {
      const prevBlock = previousMapFull.get(blockId);
      if (!blocksEqualShallowChildren(prevBlock, currBlock)) {
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
