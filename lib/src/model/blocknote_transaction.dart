/// BlockNote transaction patches for incremental updates.
///
/// This file defines transaction models that represent incremental changes
/// to a document. Transactions are emitted from the JavaScript editor and
/// batched before being sent to Flutter to prevent excessive rebuilds.
library;

import 'package:freezed_annotation/freezed_annotation.dart';
import 'blocknote_block.dart';

part 'blocknote_transaction.freezed.dart';
part 'blocknote_transaction.g.dart';

/// Transaction operation types.
enum BlockNoteTransactionOperation {
  /// Insert a new block.
  insert,

  /// Update an existing block.
  update,

  /// Delete a block.
  delete,

  /// Move a block (reorder).
  move,
}

/// A single transaction operation.
///
/// Represents one operation in a transaction (insert, update, delete, move).
@freezed
sealed class BlockNoteTransactionOp with _$BlockNoteTransactionOp {
  /// Creates a new transaction operation.
  const factory BlockNoteTransactionOp({
    /// The type of operation.
    required BlockNoteTransactionOperation operation,

    /// The ID of the block being operated on.
    required String blockId,

    /// The block data (for insert/update operations).
    BlockNoteBlock? block,

    /// The index position (for insert/move operations).
    int? index,

    /// The parent block ID (for nested structures).
    String? parentId,
  }) = _BlockNoteTransactionOp;

  /// Creates a BlockNoteTransactionOp from a JSON map.
  factory BlockNoteTransactionOp.fromJson(Map<String, dynamic> json) =>
      _$BlockNoteTransactionOpFromJson(json);
}

/// A BlockNote transaction containing one or more operations.
///
/// Transactions represent incremental changes to a document. They are
/// emitted from the JavaScript editor and batched before being sent to
/// Flutter. Each transaction includes a base version number for conflict
/// resolution.
@freezed
sealed class BlockNoteTransaction with _$BlockNoteTransaction {
  /// Creates a new transaction instance.
  const factory BlockNoteTransaction({
    /// The base document version this transaction is based on.
    required int baseVersion,

    /// The operations in this transaction.
    required List<BlockNoteTransactionOp> operations,

    /// Optional timestamp when this transaction was created.
    int? timestamp,
  }) = _BlockNoteTransaction;

  /// Creates a BlockNoteTransaction from a JSON map.
  factory BlockNoteTransaction.fromJson(Map<String, dynamic> json) =>
      _$BlockNoteTransactionFromJson(json);
}
