// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'blocknote_block.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_BlockNoteInlineContent _$BlockNoteInlineContentFromJson(Map json) =>
    _BlockNoteInlineContent(
      type: $enumDecode(_$BlockNoteInlineContentTypeEnumMap, json['type']),
      text: json['text'] as String,
      styles: (json['styles'] as Map?)?.map((k, e) => MapEntry(k as String, e)),
      href: json['href'] as String?,
      mentionId: json['mentionId'] as String?,
    );

Map<String, dynamic> _$BlockNoteInlineContentToJson(
  _BlockNoteInlineContent instance,
) => <String, dynamic>{
  'type': _$BlockNoteInlineContentTypeEnumMap[instance.type]!,
  'text': instance.text,
  'styles': ?instance.styles,
  'href': ?instance.href,
  'mentionId': ?instance.mentionId,
};

const _$BlockNoteInlineContentTypeEnumMap = {
  BlockNoteInlineContentType.text: 'text',
  BlockNoteInlineContentType.link: 'link',
  BlockNoteInlineContentType.mention: 'mention',
};

_BlockNoteBlock _$BlockNoteBlockFromJson(Map json) => _BlockNoteBlock(
  id: json['id'] as String,
  type: $enumDecode(_$BlockNoteBlockTypeEnumMap, json['type']),
  content: (json['content'] as List<dynamic>?)
      ?.map(
        (e) => BlockNoteInlineContent.fromJson(
          Map<String, dynamic>.from(e as Map),
        ),
      )
      .toList(),
  props: (json['props'] as Map?)?.map((k, e) => MapEntry(k as String, e)),
  children: (json['children'] as List<dynamic>?)
      ?.map((e) => BlockNoteBlock.fromJson(Map<String, dynamic>.from(e as Map)))
      .toList(),
);

Map<String, dynamic> _$BlockNoteBlockToJson(_BlockNoteBlock instance) =>
    <String, dynamic>{
      'id': instance.id,
      'type': _$BlockNoteBlockTypeEnumMap[instance.type]!,
      'content': ?instance.content?.map((e) => e.toJson()).toList(),
      'props': ?instance.props,
      'children': ?instance.children?.map((e) => e.toJson()).toList(),
    };

const _$BlockNoteBlockTypeEnumMap = {
  BlockNoteBlockType.paragraph: 'paragraph',
  BlockNoteBlockType.heading: 'heading',
  BlockNoteBlockType.bulletListItem: 'bulletListItem',
  BlockNoteBlockType.numberedListItem: 'numberedListItem',
  BlockNoteBlockType.codeBlock: 'codeBlock',
  BlockNoteBlockType.image: 'image',
  BlockNoteBlockType.video: 'video',
  BlockNoteBlockType.file: 'file',
  BlockNoteBlockType.table: 'table',
  BlockNoteBlockType.custom: 'custom',
};
