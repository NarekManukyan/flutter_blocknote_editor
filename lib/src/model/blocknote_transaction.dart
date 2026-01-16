/// BlockNote transaction patches for incremental updates.
///
/// This file defines transaction models that represent incremental changes
/// to a document. Transactions are emitted from the JavaScript editor and
/// batched before being sent to Flutter to prevent excessive rebuilds.
library;

import 'package:json_annotation/json_annotation.dart';
import 'blocknote_block.dart';

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
@JsonSerializable()
class BlockNoteTransactionOp {
  /// Creates a new transaction operation.
  const BlockNoteTransactionOp({
    required this.operation,
    required this.blockId,
    this.block,
    this.index,
    this.parentId,
  });

  /// The type of operation.
  @JsonKey(name: 'operation', fromJson: _operationFromJson, toJson: _operationToJson)
  final BlockNoteTransactionOperation operation;

  /// The ID of the block being operated on.
  @JsonKey(name: 'blockId')
  final String blockId;

  /// The block data (for insert/update operations).
  final BlockNoteBlock? block;

  /// The index position (for insert/move operations).
  final int? index;

  /// The parent block ID (for nested structures).
  @JsonKey(name: 'parentId')
  final String? parentId;

  /// Creates a BlockNoteTransactionOp from a JSON map.
  factory BlockNoteTransactionOp.fromJson(Map<String, dynamic> json) =>
      _$BlockNoteTransactionOpFromJson(json);

  /// Converts this instance to a JSON map.
  Map<String, dynamic> toJson() => _$BlockNoteTransactionOpToJson(this);
}

/// A BlockNote transaction containing one or more operations.
///
/// Transactions represent incremental changes to a document. They are
/// emitted from the JavaScript editor and batched before being sent to
/// Flutter. Each transaction includes a base version number for conflict
/// resolution.
@JsonSerializable()
class BlockNoteTransaction {
  /// Creates a new transaction instance.
  const BlockNoteTransaction({
    required this.baseVersion,
    required this.operations,
    this.timestamp,
  });

  /// The base document version this transaction is based on.
  @JsonKey(name: 'baseVersion')
  final int baseVersion;

  /// The operations in this transaction.
  final List<BlockNoteTransactionOp> operations;

  /// Optional timestamp when this transaction was created.
  final int? timestamp;

  /// Creates a BlockNoteTransaction from a JSON map.
  factory BlockNoteTransaction.fromJson(Map<String, dynamic> json) =>
      _$BlockNoteTransactionFromJson(json);

  /// Converts this instance to a JSON map.
  Map<String, dynamic> toJson() => _$BlockNoteTransactionToJson(this);
}

/// Helper function to deserialize BlockNoteTransactionOperation from JSON.
BlockNoteTransactionOperation _operationFromJson(String value) {
  return BlockNoteTransactionOperation.values.firstWhere(
    (e) => e.name == value,
    orElse: () => BlockNoteTransactionOperation.update,
  );
}

/// Helper function to serialize BlockNoteTransactionOperation to JSON.
String _operationToJson(BlockNoteTransactionOperation value) => value.name;
