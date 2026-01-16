// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'blocknote_transaction.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$BlockNoteTransactionOpImpl _$$BlockNoteTransactionOpImplFromJson(Map json) =>
    _$BlockNoteTransactionOpImpl(
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

Map<String, dynamic> _$$BlockNoteTransactionOpImplToJson(
  _$BlockNoteTransactionOpImpl instance,
) => <String, dynamic>{
  'operation': _$BlockNoteTransactionOperationEnumMap[instance.operation]!,
  'blockId': instance.blockId,
  if (instance.block?.toJson() case final value?) 'block': value,
  if (instance.index case final value?) 'index': value,
  if (instance.parentId case final value?) 'parentId': value,
};

const _$BlockNoteTransactionOperationEnumMap = {
  BlockNoteTransactionOperation.insert: 'insert',
  BlockNoteTransactionOperation.update: 'update',
  BlockNoteTransactionOperation.delete: 'delete',
  BlockNoteTransactionOperation.move: 'move',
};

_$BlockNoteTransactionImpl _$$BlockNoteTransactionImplFromJson(Map json) =>
    _$BlockNoteTransactionImpl(
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

Map<String, dynamic> _$$BlockNoteTransactionImplToJson(
  _$BlockNoteTransactionImpl instance,
) => <String, dynamic>{
  'baseVersion': instance.baseVersion,
  'operations': instance.operations.map((e) => e.toJson()).toList(),
  if (instance.timestamp case final value?) 'timestamp': value,
};
