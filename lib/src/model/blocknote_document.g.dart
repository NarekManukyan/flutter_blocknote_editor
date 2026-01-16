// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'blocknote_document.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$BlockNoteDocumentVersionImpl _$$BlockNoteDocumentVersionImplFromJson(
  Map json,
) => _$BlockNoteDocumentVersionImpl(
  major: (json['major'] as num?)?.toInt() ?? 1,
  minor: (json['minor'] as num?)?.toInt() ?? 0,
  patch: (json['patch'] as num?)?.toInt() ?? 0,
);

Map<String, dynamic> _$$BlockNoteDocumentVersionImplToJson(
  _$BlockNoteDocumentVersionImpl instance,
) => <String, dynamic>{
  'major': instance.major,
  'minor': instance.minor,
  'patch': instance.patch,
};

_$BlockNoteDocumentImpl _$$BlockNoteDocumentImplFromJson(Map json) =>
    _$BlockNoteDocumentImpl(
      blocks: (json['blocks'] as List<dynamic>)
          .map(
            (e) => BlockNoteBlock.fromJson(Map<String, dynamic>.from(e as Map)),
          )
          .toList(),
      version: json['version'] == null
          ? null
          : BlockNoteDocumentVersion.fromJson(
              Map<String, dynamic>.from(json['version'] as Map),
            ),
    );

Map<String, dynamic> _$$BlockNoteDocumentImplToJson(
  _$BlockNoteDocumentImpl instance,
) => <String, dynamic>{
  'blocks': instance.blocks.map((e) => e.toJson()).toList(),
  if (instance.version?.toJson() case final value?) 'version': value,
};
