// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'blocknote_transaction.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_BlockNoteTransactionOp _$BlockNoteTransactionOpFromJson(Map json) =>
    _BlockNoteTransactionOp(
      operation: $enumDecode(
        _$BlockNoteTransactionOperationEnumMap,
        json['operation'],
      ),
      blockId: json['blockId'] as String,
      block: json['block'] == null
          ? null
          : BlockNoteBlock.fromJson(
              Map<String, dynamic>.from(json['block'] as Map),
            ),
      index: (json['index'] as num?)?.toInt(),
      parentId: json['parentId'] as String?,
    );

Map<String, dynamic> _$BlockNoteTransactionOpToJson(
  _BlockNoteTransactionOp instance,
) => <String, dynamic>{
  'operation': _$BlockNoteTransactionOperationEnumMap[instance.operation]!,
  'blockId': instance.blockId,
  'block': ?instance.block?.toJson(),
  'index': ?instance.index,
  'parentId': ?instance.parentId,
};

const _$BlockNoteTransactionOperationEnumMap = {
  BlockNoteTransactionOperation.insert: 'insert',
  BlockNoteTransactionOperation.update: 'update',
  BlockNoteTransactionOperation.delete: 'delete',
  BlockNoteTransactionOperation.move: 'move',
};

_BlockNoteTransaction _$BlockNoteTransactionFromJson(Map json) =>
    _BlockNoteTransaction(
      baseVersion: (json['baseVersion'] as num).toInt(),
      operations: (json['operations'] as List<dynamic>)
          .map(
            (e) => BlockNoteTransactionOp.fromJson(
              Map<String, dynamic>.from(e as Map),
            ),
          )
          .toList(),
      timestamp: (json['timestamp'] as num?)?.toInt(),
    );

Map<String, dynamic> _$BlockNoteTransactionToJson(
  _BlockNoteTransaction instance,
) => <String, dynamic>{
  'baseVersion': instance.baseVersion,
  'operations': instance.operations.map((e) => e.toJson()).toList(),
  'timestamp': ?instance.timestamp,
};
