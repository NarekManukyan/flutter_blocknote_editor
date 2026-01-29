/**
 * Tests for blockDiff utilities: getBlockContextFromEditor, getAdjacentBlockIdsFromTopLevel, computeBlockDifferences.
 */

import { describe, it, expect, vi } from 'vitest';
import {
  getBlockContextFromEditor,
  getAdjacentBlockIdsFromTopLevel,
  computeBlockDifferences,
} from './blockDiff.js';

describe('getBlockContextFromEditor', () => {
  it('should return beforeChildId as previous sibling id and afterChildId as next sibling id', () => {
    const editor = {
      getPrevBlock: vi.fn((id) => (id === 'ID_2' ? { id: 'ID_1' } : undefined)),
      getNextBlock: vi.fn((id) => (id === 'ID_1' ? { id: 'ID_2' } : undefined)),
      getParentBlock: vi.fn(() => null),
    };
    const result = getBlockContextFromEditor(editor, 'ID_1');
    expect(result.beforeChildId).toBe(null);
    expect(result.afterChildId).toBe('ID_2');
    expect(result.parentId).toBe(null);
  });

  it('should return null context for first block (no previous)', () => {
    const editor = {
      getPrevBlock: vi.fn(() => undefined),
      getNextBlock: vi.fn(() => ({ id: 'ID_2' })),
      getParentBlock: vi.fn(() => null),
    };
    const result = getBlockContextFromEditor(editor, 'ID_1');
    expect(result.beforeChildId).toBe(null);
    expect(result.afterChildId).toBe('ID_2');
  });

  it('should return null context for last block (no next)', () => {
    const editor = {
      getPrevBlock: vi.fn(() => ({ id: 'ID_2' })),
      getNextBlock: vi.fn(() => undefined),
      getParentBlock: vi.fn(() => null),
    };
    const result = getBlockContextFromEditor(editor, 'ID_3');
    expect(result.beforeChildId).toBe('ID_2');
    expect(result.afterChildId).toBe(null);
  });

  it('should return middle block context (both siblings)', () => {
    const editor = {
      getPrevBlock: vi.fn(() => ({ id: 'ID_1' })),
      getNextBlock: vi.fn(() => ({ id: 'ID_3' })),
      getParentBlock: vi.fn(() => null),
    };
    const result = getBlockContextFromEditor(editor, 'ID_2');
    expect(result.beforeChildId).toBe('ID_1');
    expect(result.afterChildId).toBe('ID_3');
  });

  it('should return nulls for only block (no siblings)', () => {
    const editor = {
      getPrevBlock: vi.fn(() => undefined),
      getNextBlock: vi.fn(() => undefined),
      getParentBlock: vi.fn(() => null),
    };
    const result = getBlockContextFromEditor(editor, 'ID_1');
    expect(result.beforeChildId).toBe(null);
    expect(result.afterChildId).toBe(null);
  });

  it('should return parentId when block has parent', () => {
    const editor = {
      getPrevBlock: vi.fn(() => ({ id: 'ID_1_1' })),
      getNextBlock: vi.fn(() => undefined),
      getParentBlock: vi.fn(() => ({ id: 'ID_1' })),
    };
    const result = getBlockContextFromEditor(editor, 'ID_1_2');
    expect(result.parentId).toBe('ID_1');
    expect(result.beforeChildId).toBe('ID_1_1');
    expect(result.afterChildId).toBe(null);
  });

  it('should return nulls when editor or blockId is missing', () => {
    expect(getBlockContextFromEditor(null, 'ID_1')).toEqual({
      beforeChildId: null,
      afterChildId: null,
      parentId: null,
    });
    expect(getBlockContextFromEditor({}, '')).toEqual({
      beforeChildId: null,
      afterChildId: null,
      parentId: null,
    });
  });
});

describe('getAdjacentBlockIdsFromTopLevel', () => {
  const topLevel = [{ id: 'ID_1' }, { id: 'ID_2' }, { id: 'ID_3' }];

  it('should return before null and after next id for first block', () => {
    const result = getAdjacentBlockIdsFromTopLevel(topLevel, 'ID_1');
    expect(result.beforeChildId).toBe(null);
    expect(result.afterChildId).toBe('ID_2');
  });

  it('should return after null and before prev id for last block', () => {
    const result = getAdjacentBlockIdsFromTopLevel(topLevel, 'ID_3');
    expect(result.beforeChildId).toBe('ID_2');
    expect(result.afterChildId).toBe(null);
  });

  it('should return both siblings for middle block', () => {
    const result = getAdjacentBlockIdsFromTopLevel(topLevel, 'ID_2');
    expect(result.beforeChildId).toBe('ID_1');
    expect(result.afterChildId).toBe('ID_3');
  });

  it('should return both null for missing block', () => {
    const result = getAdjacentBlockIdsFromTopLevel(topLevel, 'MISSING');
    expect(result.beforeChildId).toBe(null);
    expect(result.afterChildId).toBe(null);
  });

  it('should return both null for empty or falsy blocks', () => {
    expect(getAdjacentBlockIdsFromTopLevel([], 'ID_1')).toEqual({
      beforeChildId: null,
      afterChildId: null,
    });
    expect(getAdjacentBlockIdsFromTopLevel(null, 'ID_1')).toEqual({
      beforeChildId: null,
      afterChildId: null,
    });
    expect(getAdjacentBlockIdsFromTopLevel(topLevel, '')).toEqual({
      beforeChildId: null,
      afterChildId: null,
    });
  });

  it('should handle single block (both null)', () => {
    const result = getAdjacentBlockIdsFromTopLevel([{ id: 'ID_1' }], 'ID_1');
    expect(result.beforeChildId).toBe(null);
    expect(result.afterChildId).toBe(null);
  });
});

describe('computeBlockDifferences', () => {
  it('should emit insert with correct beforeChildId/afterChildId/parentId from editor', () => {
    const editor = {
      getPrevBlock: vi.fn(() => null),
      getNextBlock: vi.fn(() => null),
      getParentBlock: vi.fn(() => null),
    };
    const previousBlocks = [];
    const currentBlocks = [{ id: 'new-id', type: 'paragraph' }];
    const ops = computeBlockDifferences(editor, previousBlocks, currentBlocks);
    expect(ops).toHaveLength(1);
    expect(ops[0].operation).toBe('insert');
    expect(ops[0].blockId).toBe('new-id');
    expect(ops[0].parentId).toBe(null);
    expect(ops[0].beforeChildId).toBe(null);
    expect(ops[0].afterChildId).toBe(null);
  });

  it('should emit update with context from editor when block content changes', () => {
    const editor = {
      getPrevBlock: vi.fn(() => ({ id: 'ID_1' })),
      getNextBlock: vi.fn(() => ({ id: 'ID_3' })),
      getParentBlock: vi.fn(() => null),
    };
    const previousBlocks = [
      {
        id: 'ID_2',
        type: 'paragraph',
        content: [{ type: 'text', text: 'old' }],
      },
    ];
    const currentBlocks = [
      {
        id: 'ID_2',
        type: 'paragraph',
        content: [{ type: 'text', text: 'new' }],
      },
    ];
    const ops = computeBlockDifferences(editor, previousBlocks, currentBlocks);
    expect(ops).toHaveLength(1);
    expect(ops[0].operation).toBe('update');
    expect(ops[0].beforeChildId).toBe('ID_1');
    expect(ops[0].afterChildId).toBe('ID_3');
  });

  it('should emit delete with beforeChildId/afterChildId from previous top-level array', () => {
    const editor = {};
    const previousBlocks = [{ id: 'ID_1' }, { id: 'ID_2' }, { id: 'ID_3' }];
    const currentBlocks = [{ id: 'ID_1' }, { id: 'ID_3' }];
    const ops = computeBlockDifferences(editor, previousBlocks, currentBlocks);
    expect(ops).toHaveLength(1);
    expect(ops[0].operation).toBe('delete');
    expect(ops[0].blockId).toBe('ID_2');
    expect(ops[0].beforeChildId).toBe('ID_1');
    expect(ops[0].afterChildId).toBe('ID_3');
  });

  it('should emit reorder with correct parentId and orderedChildIds when order changes', () => {
    const editor = {
      getPrevBlock: vi.fn((id) => {
        if (id === 'ID_1') return { id: 'ID_3' };
        if (id === 'ID_3') return null;
        return { id: 'ID_1' };
      }),
      getNextBlock: vi.fn((id) => {
        if (id === 'ID_1') return null;
        if (id === 'ID_3') return { id: 'ID_2' };
        return { id: 'ID_3' };
      }),
      getParentBlock: vi.fn(() => null),
    };
    const previousBlocks = [{ id: 'ID_1' }, { id: 'ID_2' }, { id: 'ID_3' }];
    const currentBlocks = [{ id: 'ID_3' }, { id: 'ID_2' }, { id: 'ID_1' }];
    const ops = computeBlockDifferences(editor, previousBlocks, currentBlocks);
    const reorderOp = ops.find((o) => o.operation === 'reorder');
    expect(reorderOp).toBeDefined();
    expect(reorderOp.parentId).toBe(null);
    // orderedChildIds contains only blocks that changed index (ID_3 and ID_1); ID_2 stayed at index 1
    expect(reorderOp.orderedChildIds).toEqual(['ID_3', 'ID_1']);
  });

  it('should emit only one update for the edited child block, not for the parent (shallow-children comparison)', () => {
    const parentId = 'toggle-root';
    const childAId = 'child-a';
    const childBId = 'child-b';
    const editor = {
      getPrevBlock: vi.fn((blockId) => {
        if (blockId === parentId) return null;
        if (blockId === childAId) return null;
        if (blockId === childBId) return { id: childAId };
        return null;
      }),
      getNextBlock: vi.fn((blockId) => {
        if (blockId === parentId) return null;
        if (blockId === childAId) return { id: childBId };
        if (blockId === childBId) return null;
        return null;
      }),
      getParentBlock: vi.fn((blockId) => {
        if (blockId === childAId || blockId === childBId)
          return { id: parentId };
        return null;
      }),
    };
    const previousBlocks = [
      {
        id: parentId,
        type: 'toggle',
        children: [
          {
            id: childAId,
            type: 'paragraph',
            content: [{ type: 'text', text: 'Item A' }],
          },
          {
            id: childBId,
            type: 'paragraph',
            content: [{ type: 'text', text: 'Item B' }],
          },
        ],
      },
    ];
    const currentBlocks = [
      {
        id: parentId,
        type: 'toggle',
        children: [
          {
            id: childAId,
            type: 'paragraph',
            content: [{ type: 'text', text: 'Item A' }],
          },
          {
            id: childBId,
            type: 'paragraph',
            content: [{ type: 'text', text: 'Item B edited' }],
          },
        ],
      },
    ];
    const ops = computeBlockDifferences(editor, previousBlocks, currentBlocks);
    const updates = ops.filter((o) => o.operation === 'update');
    expect(updates).toHaveLength(1);
    expect(updates[0].blockId).toBe(childBId);
    expect(updates[0].parentId).toBe(parentId);
    expect(updates[0].beforeChildId).toBe(childAId);
    expect(updates[0].afterChildId).toBe(null);
    expect(updates[0].block.content).toEqual([
      { type: 'text', text: 'Item B edited' },
    ]);
  });
});
