// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'blocknote_transaction.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BlockNoteTransactionOp _$BlockNoteTransactionOpFromJson(
  Map<String, dynamic> json,
) => BlockNoteTransactionOp(
  operation: _operationFromJson(json['operation'] as String),
  blockId: json['blockId'] as String,
  block: json['block'] == null
      ? null
      : BlockNoteBlock.fromJson(json['block'] as Map<String, dynamic>),
  index: (json['index'] as num?)?.toInt(),
  parentId: json['parentId'] as String?,
);

Map<String, dynamic> _$BlockNoteTransactionOpToJson(
  BlockNoteTransactionOp instance,
) => <String, dynamic>{
  'operation': _operationToJson(instance.operation),
  'blockId': instance.blockId,
  'block': instance.block,
  'index': instance.index,
  'parentId': instance.parentId,
};

BlockNoteTransaction _$BlockNoteTransactionFromJson(
  Map<String, dynamic> json,
) => BlockNoteTransaction(
  baseVersion: (json['baseVersion'] as num).toInt(),
  operations: (json['operations'] as List<dynamic>)
      .map((e) => BlockNoteTransactionOp.fromJson(e as Map<String, dynamic>))
      .toList(),
  timestamp: (json['timestamp'] as num?)?.toInt(),
);

Map<String, dynamic> _$BlockNoteTransactionToJson(
  BlockNoteTransaction instance,
) => <String, dynamic>{
  'baseVersion': instance.baseVersion,
  'operations': instance.operations,
  'timestamp': instance.timestamp,
};
