/// Transaction batching system for efficient Flutter updates.
///
/// This file implements a batching system that collects transactions from
/// the JavaScript editor and batches them before sending to Flutter. This
/// prevents excessive Flutter rebuilds on every keystroke.
library;

import 'dart:async';
import 'package:flutter/foundation.dart';
import '../model/blocknote_transaction.dart';

/// Transaction batcher for collecting and batching editor transactions.
///
/// Batches transactions over a configurable time window (default 300-500ms)
/// and flushes immediately on certain events (paste, delete block, etc.).
/// This prevents Flutter rebuilds on every keystroke while maintaining
/// responsiveness for important operations.
class TransactionBatcher {
  /// Creates a new transaction batcher.
  TransactionBatcher({
    required this.onBatch,
    this.batchWindow = const Duration(milliseconds: 400),
    this.debugLogging = false,
  });

  /// Callback invoked when a batch is ready.
  final ValueChanged<List<BlockNoteTransaction>> onBatch;

  /// The time window for batching transactions.
  final Duration batchWindow;

  /// Whether to enable debug logging.
  final bool debugLogging;

  /// Pending transactions waiting to be batched.
  final List<BlockNoteTransaction> _pendingTransactions = [];

  /// Timer for the current batch window.
  Timer? _batchTimer;

  /// The current base version for transactions.
  int _baseVersion = 0;

  /// Adds a transaction to the batch.
  ///
  /// Transactions are collected and sent as a batch after the batch window
  /// expires, or immediately if [flushImmediately] is true.
  void addTransaction(
    BlockNoteTransaction transaction, {
    bool flushImmediately = false,
  }) {
    _pendingTransactions.add(transaction);
    _baseVersion = transaction.baseVersion;

    if (flushImmediately) {
      _flush();
    } else {
      _scheduleFlush();
    }
  }

  /// Schedules a flush after the batch window expires.
  void _scheduleFlush() {
    _batchTimer?.cancel();
    _batchTimer = Timer(batchWindow, _flush);
  }

  /// Flushes all pending transactions immediately.
  ///
  /// This is called:
  /// - After the batch window expires
  /// - On paste operations
  /// - On delete block operations
  /// - When the app goes to background
  /// - When the widget is disposed
  void _flush() {
    _batchTimer?.cancel();
    _batchTimer = null;

    if (_pendingTransactions.isEmpty) {
      return;
    }

    final batch = List<BlockNoteTransaction>.from(_pendingTransactions);
    _pendingTransactions.clear();

    if (debugLogging) {
      debugPrint('[TransactionBatcher] Flushing ${batch.length} transactions');
    }

    onBatch(batch);
  }

  /// Forces an immediate flush of all pending transactions.
  ///
  /// Used for critical operations that require immediate updates.
  void flush() {
    _flush();
  }

  /// Disposes the batcher and flushes any pending transactions.
  void dispose() {
    _batchTimer?.cancel();
    _flush();
  }

  /// Gets the current base version.
  int get baseVersion => _baseVersion;
}
