/**
 * Tests for transactionSender: createInitialOperations, filterRedundantOperations, operation index, and ID_1/ID_2/ID_3 structure.
 */

import { describe, it, expect, vi } from 'vitest';
import { getBlockContextFromEditor } from './blockDiff.js';
import {
  createInitialOperations,
  filterRedundantOperations,
  sendTransactionsToFlutter,
} from './transactionSender.js';

describe('createInitialOperations', () => {
  it('should use getPrevBlock/getNextBlock/getParentBlock only and set correct sibling links for ID_1, ID_2, ID_3', () => {
    const serializedBlocks = [
      { id: 'ID_1', type: 'paragraph' },
      { id: 'ID_2', type: 'paragraph' },
      { id: 'ID_3', type: 'paragraph' },
    ];
    const editor = {
      getPrevBlock: vi.fn((blockId) => {
        if (blockId === 'ID_1') return undefined;
        if (blockId === 'ID_2') return { id: 'ID_1' };
        if (blockId === 'ID_3') return { id: 'ID_2' };
        return undefined;
      }),
      getNextBlock: vi.fn((blockId) => {
        if (blockId === 'ID_1') return { id: 'ID_2' };
        if (blockId === 'ID_2') return { id: 'ID_3' };
        if (blockId === 'ID_3') return undefined;
        return undefined;
      }),
      getParentBlock: vi.fn(() => null),
    };
    const ops = createInitialOperations(editor, serializedBlocks);
    expect(ops).toHaveLength(3);

    expect(ops[0].blockId).toBe('ID_1');
    expect(ops[0].beforeChildId).toBe(null);
    expect(ops[0].afterChildId).toBe('ID_2');
    expect(ops[0].parentId).toBe(null);

    expect(ops[1].blockId).toBe('ID_2');
    expect(ops[1].beforeChildId).toBe('ID_1');
    expect(ops[1].afterChildId).toBe('ID_3');
    expect(ops[1].parentId).toBe(null);

    expect(ops[2].blockId).toBe('ID_3');
    expect(ops[2].beforeChildId).toBe('ID_2');
    expect(ops[2].afterChildId).toBe(null);
    expect(ops[2].parentId).toBe(null);
  });

  it('should return single root update when no blocks', () => {
    const editor = {};
    const ops = createInitialOperations(editor, null);
    expect(ops).toHaveLength(1);
    expect(ops[0].operation).toBe('update');
    expect(ops[0].block).toBe(null);
    expect(ops[0].beforeChildId).toBe(null);
    expect(ops[0].afterChildId).toBe(null);
  });
});

describe('filterRedundantOperations', () => {
  it('should remove insert and delete for same blockId', () => {
    const operations = [
      { operation: 'insert', blockId: 'x' },
      { operation: 'delete', blockId: 'x' },
      { operation: 'update', blockId: 'y' },
    ];
    const filtered = filterRedundantOperations(operations);
    expect(filtered).toHaveLength(1);
    expect(filtered[0].operation).toBe('update');
    expect(filtered[0].blockId).toBe('y');
  });

  it('should leave operations unchanged when no redundant pair', () => {
    const operations = [
      { operation: 'insert', blockId: 'a' },
      { operation: 'delete', blockId: 'b' },
    ];
    const filtered = filterRedundantOperations(operations);
    expect(filtered).toHaveLength(2);
  });
});

describe('transaction payload with index', () => {
  it('should include index 0, 1, 2 on each operation when sending', () => {
    if (typeof globalThis.window === 'undefined') {
      globalThis.window = {};
    }
    const operations = [
      {
        operation: 'update',
        blockId: 'ID_1',
        beforeChildId: null,
        afterChildId: 'ID_2',
      },
      {
        operation: 'update',
        blockId: 'ID_2',
        beforeChildId: 'ID_1',
        afterChildId: 'ID_3',
      },
      {
        operation: 'update',
        blockId: 'ID_3',
        beforeChildId: 'ID_2',
        afterChildId: null,
      },
    ];
    const documentVersionRef = { current: 0 };
    const posted = [];
    window.BlockNoteChannel = {
      postMessage: (msg) => {
        posted.push(JSON.parse(msg));
      },
    };
    sendTransactionsToFlutter(operations, documentVersionRef);
    expect(posted).toHaveLength(1);
    const data = posted[0];
    expect(data.type).toBe('transactions');
    expect(data.data).toHaveLength(1);
    const transaction = data.data[0];
    expect(transaction.operations).toHaveLength(3);
    transaction.operations.forEach((op, i) => {
      expect(op.index).toBe(i);
    });
    expect(transaction.operations[0].beforeChildId).toBe(null);
    expect(transaction.operations[0].afterChildId).toBe('ID_2');
    expect(transaction.operations[1].beforeChildId).toBe('ID_1');
    expect(transaction.operations[1].afterChildId).toBe('ID_3');
    expect(transaction.operations[2].beforeChildId).toBe('ID_2');
    expect(transaction.operations[2].afterChildId).toBe(null);
    if (globalThis.window) delete globalThis.window.BlockNoteChannel;
  });
});

describe('structure test: ID_1, ID_1_1, ID_1_2, ID_1_2_1, ID_1_2_2, ID_2, ID_2_1, ID_2_2, ID_3, ID_3_1, ID_3_2', () => {
  /**
   * Spec (user naming: after_child_id = previous sibling, before_child_id = next sibling):
   *   ID_1 (after_child_id null, before_child_id ID_2)
   *     ID_1_1
   *     ID_1_2 (after_child_id ID_1_1, before_child_id null)
   *       ID_1_2_1
   *       ID_1_2_2
   *   ID_2 (after_child_id ID_1, before_child_id ID_3)
   *     ID_2_1, ID_2_2
   *   ID_3 (after_child_id ID_2, before_child_id null)
   *     ID_3_1, ID_3_2
   * Our API: beforeChildId = previous sibling, afterChildId = next sibling.
   */
  it('should produce correct beforeChildId/afterChildId/parentId for top-level blocks', () => {
    const serializedBlocks = [
      {
        id: 'ID_1',
        type: 'paragraph',
        children: [
          { id: 'ID_1_1', type: 'paragraph' },
          {
            id: 'ID_1_2',
            type: 'paragraph',
            children: [
              { id: 'ID_1_2_1', type: 'paragraph' },
              { id: 'ID_1_2_2', type: 'paragraph' },
            ],
          },
        ],
      },
      {
        id: 'ID_2',
        type: 'paragraph',
        children: [
          { id: 'ID_2_1', type: 'paragraph' },
          { id: 'ID_2_2', type: 'paragraph' },
        ],
      },
      {
        id: 'ID_3',
        type: 'paragraph',
        children: [
          { id: 'ID_3_1', type: 'paragraph' },
          { id: 'ID_3_2', type: 'paragraph' },
        ],
      },
    ];
    const editor = {
      getPrevBlock: vi.fn((blockId) => {
        if (blockId === 'ID_1') return undefined;
        if (blockId === 'ID_2') return { id: 'ID_1' };
        if (blockId === 'ID_3') return { id: 'ID_2' };
        return undefined;
      }),
      getNextBlock: vi.fn((blockId) => {
        if (blockId === 'ID_1') return { id: 'ID_2' };
        if (blockId === 'ID_2') return { id: 'ID_3' };
        if (blockId === 'ID_3') return undefined;
        return undefined;
      }),
      getParentBlock: vi.fn(() => null),
    };
    const ops = createInitialOperations(editor, serializedBlocks);
    expect(ops).toHaveLength(3);

    expect(ops[0].blockId).toBe('ID_1');
    expect(ops[0].beforeChildId).toBe(null);
    expect(ops[0].afterChildId).toBe('ID_2');
    expect(ops[0].parentId).toBe(null);

    expect(ops[1].blockId).toBe('ID_2');
    expect(ops[1].beforeChildId).toBe('ID_1');
    expect(ops[1].afterChildId).toBe('ID_3');
    expect(ops[1].parentId).toBe(null);

    expect(ops[2].blockId).toBe('ID_3');
    expect(ops[2].beforeChildId).toBe('ID_2');
    expect(ops[2].afterChildId).toBe(null);
    expect(ops[2].parentId).toBe(null);
  });

  it('should produce correct sibling context for nested ID_1_2 (getBlockContextFromEditor)', () => {
    const editor = {
      getPrevBlock: vi.fn((blockId) => {
        if (blockId === 'ID_1_2') return { id: 'ID_1_1' };
        return undefined;
      }),
      getNextBlock: vi.fn((blockId) => {
        if (blockId === 'ID_1_2') return undefined;
        return undefined;
      }),
      getParentBlock: vi.fn((blockId) => {
        if (blockId === 'ID_1_2') return { id: 'ID_1' };
        return undefined;
      }),
    };
    const ctx = getBlockContextFromEditor(editor, 'ID_1_2');
    // ID_1_2: after_child_id is ID_1_1 (previous), before_child_id is null (next)
    expect(ctx.beforeChildId).toBe('ID_1_1');
    expect(ctx.afterChildId).toBe(null);
    expect(ctx.parentId).toBe('ID_1');
  });
});
