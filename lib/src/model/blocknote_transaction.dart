/// BlockNote transaction patches for incremental updates.
///
/// This file defines transaction models that represent incremental changes
/// to a document. Transactions are emitted from the JavaScript editor and
/// batched before being sent to Flutter to prevent excessive rebuilds.
library;

import 'blocknote_block.dart';

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
class BlockNoteTransactionOp {
  /// Creates a new transaction operation.
  const BlockNoteTransactionOp({
    required this.operation,
    required this.blockId,
    this.block,
    this.index,
    this.parentId,
    this.afterChildId,
    this.beforeChildId,
  });

  /// The type of operation.
  final BlockNoteTransactionOperation operation;

  /// The ID of the block being operated on.
  final String blockId;

  /// The block data (for insert/update operations).
  final BlockNoteBlock? block;

  /// The index position (for insert/move operations).
  final int? index;

  /// The parent block ID (for nested structures).
  final String? parentId;

  /// The ID of the block that comes after this block (next sibling).
  ///
  /// This represents the block that appears immediately after the current block
  /// in the document order. Used to maintain correct block ordering when applying
  /// transactions. Will be `null` if this block is the last block in its parent.
  final String? afterChildId;

  /// The ID of the block that comes before this block (previous sibling).
  ///
  /// This represents the block that appears immediately before the current block
  /// in the document order. Used to maintain correct block ordering when applying
  /// transactions. Will be `null` if this block is the first block in its parent.
  final String? beforeChildId;

  /// Creates a BlockNoteTransactionOp from a JSON map.
  factory BlockNoteTransactionOp.fromJson(Map<String, dynamic> json) {
    return BlockNoteTransactionOp(
      operation: BlockNoteTransactionOperation.values.byName(
        json['operation'] as String,
      ),
      blockId: json['blockId'] as String? ?? '',
      block: json['block'] == null
          ? null
          : BlockNoteBlock.fromJson(
              Map<String, dynamic>.from(json['block'] as Map),
            ),
      index: json['index'] as int?,
      parentId: json['parentId'] as String?,
      afterChildId: json['afterChildId'] as String?,
      beforeChildId: json['beforeChildId'] as String?,
    );
  }

  /// Converts this transaction op to JSON.
  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{
      'operation': operation.name,
      'blockId': blockId,
      if (block != null) 'block': block!.toJson(),
      if (index != null) 'index': index,
      if (parentId != null) 'parentId': parentId,
      if (afterChildId != null) 'afterChildId': afterChildId,
      if (beforeChildId != null) 'beforeChildId': beforeChildId,
    };
    return json;
  }

  BlockNoteTransactionOp copyWith({
    BlockNoteTransactionOperation? operation,
    String? blockId,
    Object? block = _unset,
    Object? index = _unset,
    Object? parentId = _unset,
    Object? afterChildId = _unset,
    Object? beforeChildId = _unset,
  }) {
    return BlockNoteTransactionOp(
      operation: operation ?? this.operation,
      blockId: blockId ?? this.blockId,
      block: identical(block, _unset) ? this.block : block as BlockNoteBlock?,
      index: identical(index, _unset) ? this.index : index as int?,
      parentId: identical(parentId, _unset)
          ? this.parentId
          : parentId as String?,
      afterChildId: identical(afterChildId, _unset)
          ? this.afterChildId
          : afterChildId as String?,
      beforeChildId: identical(beforeChildId, _unset)
          ? this.beforeChildId
          : beforeChildId as String?,
    );
  }

  @override
  String toString() {
    return 'BlockNoteTransactionOp(operation: $operation, blockId: $blockId, block: $block, index: $index, parentId: $parentId, afterChildId: $afterChildId, beforeChildId: $beforeChildId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is BlockNoteTransactionOp &&
            other.operation == operation &&
            other.blockId == blockId &&
            other.block == block &&
            other.index == index &&
            other.parentId == parentId &&
            other.afterChildId == afterChildId &&
            other.beforeChildId == beforeChildId;
  }

  @override
  int get hashCode => Object.hash(
    operation,
    blockId,
    block,
    index,
    parentId,
    afterChildId,
    beforeChildId,
  );
}

/// A BlockNote transaction containing one or more operations.
///
/// Transactions represent incremental changes to a document. They are
/// emitted from the JavaScript editor and batched before being sent to
/// Flutter. Each transaction includes a base version number for conflict
/// resolution.
class BlockNoteTransaction {
  /// Creates a new transaction instance.
  const BlockNoteTransaction({
    required this.baseVersion,
    required this.operations,
    this.timestamp,
  });

  /// The base document version this transaction is based on.
  final int baseVersion;

  /// The operations in this transaction.
  final List<BlockNoteTransactionOp> operations;

  /// Optional timestamp when this transaction was created.
  final int? timestamp;

  /// Creates a BlockNoteTransaction from a JSON map.
  factory BlockNoteTransaction.fromJson(Map<String, dynamic> json) {
    return BlockNoteTransaction(
      baseVersion: json['baseVersion'] as int? ?? 0,
      operations: (json['operations'] as List<dynamic>? ?? [])
          .whereType<Map>()
          .map(
            (op) =>
                BlockNoteTransactionOp.fromJson(Map<String, dynamic>.from(op)),
          )
          .toList(),
      timestamp: json['timestamp'] as int?,
    );
  }

  /// Converts this transaction to JSON.
  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{
      'baseVersion': baseVersion,
      'operations': operations.map((op) => op.toJson()).toList(),
    };
    if (timestamp != null) {
      json['timestamp'] = timestamp;
    }
    return json;
  }

  BlockNoteTransaction copyWith({
    int? baseVersion,
    List<BlockNoteTransactionOp>? operations,
    Object? timestamp = _unset,
  }) {
    return BlockNoteTransaction(
      baseVersion: baseVersion ?? this.baseVersion,
      operations: operations ?? this.operations,
      timestamp: identical(timestamp, _unset)
          ? this.timestamp
          : timestamp as int?,
    );
  }

  @override
  String toString() {
    return 'BlockNoteTransaction(baseVersion: $baseVersion, operations: $operations, timestamp: $timestamp)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is BlockNoteTransaction &&
            other.baseVersion == baseVersion &&
            _listEquals(other.operations, operations) &&
            other.timestamp == timestamp;
  }

  @override
  int get hashCode =>
      Object.hash(baseVersion, _listHash(operations), timestamp);
}

const Object _unset = Object();

bool _listEquals<T>(List<T>? a, List<T>? b) {
  if (identical(a, b)) return true;
  if (a == null || b == null || a.length != b.length) return false;
  for (var i = 0; i < a.length; i++) {
    if (a[i] != b[i]) return false;
  }
  return true;
}

int _listHash<T>(List<T>? list) {
  if (list == null) return 0;
  return Object.hashAll(list);
}
