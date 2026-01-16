// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'blocknote_document.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_BlockNoteDocumentVersion _$BlockNoteDocumentVersionFromJson(Map json) =>
    _BlockNoteDocumentVersion(
      major: (json['major'] as num?)?.toInt() ?? 1,
      minor: (json['minor'] as num?)?.toInt() ?? 0,
      patch: (json['patch'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$BlockNoteDocumentVersionToJson(
  _BlockNoteDocumentVersion instance,
) => <String, dynamic>{
  'major': instance.major,
  'minor': instance.minor,
  'patch': instance.patch,
};

_BlockNoteDocument _$BlockNoteDocumentFromJson(Map json) => _BlockNoteDocument(
  blocks: (json['blocks'] as List<dynamic>)
      .map((e) => BlockNoteBlock.fromJson(Map<String, dynamic>.from(e as Map)))
      .toList(),
  version: json['version'] == null
      ? null
      : BlockNoteDocumentVersion.fromJson(
          Map<String, dynamic>.from(json['version'] as Map),
        ),
);

Map<String, dynamic> _$BlockNoteDocumentToJson(_BlockNoteDocument instance) =>
    <String, dynamic>{
      'blocks': instance.blocks.map((e) => e.toJson()).toList(),
      'version': ?instance.version?.toJson(),
    };
