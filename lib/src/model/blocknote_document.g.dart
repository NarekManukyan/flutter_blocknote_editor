// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'blocknote_document.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BlockNoteDocumentVersion _$BlockNoteDocumentVersionFromJson(
  Map<String, dynamic> json,
) => BlockNoteDocumentVersion(
  major: (json['major'] as num?)?.toInt() ?? 1,
  minor: (json['minor'] as num?)?.toInt() ?? 0,
  patch: (json['patch'] as num?)?.toInt() ?? 0,
);

Map<String, dynamic> _$BlockNoteDocumentVersionToJson(
  BlockNoteDocumentVersion instance,
) => <String, dynamic>{
  'major': instance.major,
  'minor': instance.minor,
  'patch': instance.patch,
};

BlockNoteDocument _$BlockNoteDocumentFromJson(Map<String, dynamic> json) =>
    BlockNoteDocument(
      blocks: (json['blocks'] as List<dynamic>)
          .map((e) => BlockNoteBlock.fromJson(e as Map<String, dynamic>))
          .toList(),
      version: json['version'] == null
          ? null
          : BlockNoteDocumentVersion.fromJson(
              json['version'] as Map<String, dynamic>,
            ),
    );

Map<String, dynamic> _$BlockNoteDocumentToJson(BlockNoteDocument instance) =>
    <String, dynamic>{'blocks': instance.blocks, 'version': instance.version};
