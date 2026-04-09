library;

import 'package:fake_async/fake_async.dart';
import 'package:flutter_blocknote_editor/src/batching/transaction_batcher.dart';
import 'package:flutter_blocknote_editor/src/model/blocknote_transaction.dart';
import 'package:flutter_test/flutter_test.dart';

BlockNoteTransaction _tx(int version) => BlockNoteTransaction(
      baseVersion: version,
      operations: [],
      timestamp: 0,
    );

void main() {
  group('TransactionBatcher', () {
    test('addTransaction debounces and emits batch after window', () {
      fakeAsync((async) {
        final batches = <List<BlockNoteTransaction>>[];
        final batcher = TransactionBatcher(
          onBatch: batches.add,
          batchWindow: const Duration(milliseconds: 400),
        );

        batcher.addTransaction(_tx(1));

        // Nothing yet — still inside the window.
        async.elapse(const Duration(milliseconds: 300));
        expect(batches, isEmpty);

        // Window expires.
        async.elapse(const Duration(milliseconds: 200));
        expect(batches.length, 1);
        expect(batches.first.length, 1);
        expect(batches.first.first.baseVersion, 1);

        batcher.dispose();
      });
    });

    test('multiple addTransaction calls within window are coalesced', () {
      fakeAsync((async) {
        final batches = <List<BlockNoteTransaction>>[];
        final batcher = TransactionBatcher(
          onBatch: batches.add,
          batchWindow: const Duration(milliseconds: 400),
        );

        batcher.addTransaction(_tx(1));
        batcher.addTransaction(_tx(2));
        batcher.addTransaction(_tx(3));

        async.elapse(const Duration(milliseconds: 500));

        // All three should arrive in a single batch.
        expect(batches.length, 1);
        expect(batches.first.length, 3);
        expect(batches.first.map((t) => t.baseVersion).toList(), [1, 2, 3]);

        batcher.dispose();
      });
    });

    test('flush() emits immediately without waiting for window', () {
      fakeAsync((async) {
        final batches = <List<BlockNoteTransaction>>[];
        final batcher = TransactionBatcher(
          onBatch: batches.add,
          batchWindow: const Duration(milliseconds: 400),
        );

        batcher.addTransaction(_tx(1));
        expect(batches, isEmpty);

        batcher.flush();
        expect(batches.length, 1);
        expect(batches.first.first.baseVersion, 1);

        // Timer should be cancelled — no second emission after window.
        async.elapse(const Duration(milliseconds: 500));
        expect(batches.length, 1);

        batcher.dispose();
      });
    });

    test('dispose() flushes pending transactions', () {
      fakeAsync((async) {
        final batches = <List<BlockNoteTransaction>>[];
        final batcher = TransactionBatcher(
          onBatch: batches.add,
          batchWindow: const Duration(milliseconds: 400),
        );

        batcher.addTransaction(_tx(7));
        expect(batches, isEmpty);

        batcher.dispose();
        expect(batches.length, 1);
        expect(batches.first.first.baseVersion, 7);
      });
    });

    test('flushImmediately:true bypasses the debounce window', () {
      fakeAsync((async) {
        final batches = <List<BlockNoteTransaction>>[];
        final batcher = TransactionBatcher(
          onBatch: batches.add,
          batchWindow: const Duration(milliseconds: 400),
        );

        batcher.addTransaction(_tx(5), flushImmediately: true);

        // Batch should be emitted synchronously, before any time passes.
        expect(batches.length, 1);
        expect(batches.first.first.baseVersion, 5);

        // No further emissions after the window.
        async.elapse(const Duration(milliseconds: 500));
        expect(batches.length, 1);

        batcher.dispose();
      });
    });

    test('flush() on empty pending list emits nothing', () {
      fakeAsync((async) {
        final batches = <List<BlockNoteTransaction>>[];
        final batcher = TransactionBatcher(onBatch: batches.add);

        batcher.flush();
        expect(batches, isEmpty);

        batcher.dispose();
      });
    });

    test('baseVersion reflects the most recently added transaction', () {
      fakeAsync((async) {
        final batcher = TransactionBatcher(onBatch: (_) {});

        expect(batcher.baseVersion, 0);

        batcher.addTransaction(_tx(3));
        expect(batcher.baseVersion, 3);

        batcher.addTransaction(_tx(9));
        expect(batcher.baseVersion, 9);

        batcher.dispose();
      });
    });
  });
}
