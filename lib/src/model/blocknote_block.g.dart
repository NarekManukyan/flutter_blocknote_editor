// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'blocknote_block.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$BlockNoteInlineContentImpl _$$BlockNoteInlineContentImplFromJson(Map json) =>
    _$BlockNoteInlineContentImpl(
      type: $enumDecode(_$BlockNoteInlineContentTypeEnumMap, json['type']),
      text: json['text'] as String,
      styles: (json['styles'] as Map?)?.map((k, e) => MapEntry(k as String, e)),
      href: json['href'] as String?,
      mentionId: json['mentionId'] as String?,
    );

Map<String, dynamic> _$$BlockNoteInlineContentImplToJson(
  _$BlockNoteInlineContentImpl instance,
) => <String, dynamic>{
  'type': _$BlockNoteInlineContentTypeEnumMap[instance.type]!,
  'text': instance.text,
  if (instance.styles case final value?) 'styles': value,
  if (instance.href case final value?) 'href': value,
  if (instance.mentionId case final value?) 'mentionId': value,
};

const _$BlockNoteInlineContentTypeEnumMap = {
  BlockNoteInlineContentType.text: 'text',
  BlockNoteInlineContentType.link: 'link',
  BlockNoteInlineContentType.mention: 'mention',
};

_$BlockNoteBlockImpl _$$BlockNoteBlockImplFromJson(Map json) =>
    _$BlockNoteBlockImpl(
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
          ?.map(
            (e) => BlockNoteBlock.fromJson(Map<String, dynamic>.from(e as Map)),
          )
          .toList(),
    );

Map<String, dynamic> _$$BlockNoteBlockImplToJson(
  _$BlockNoteBlockImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'type': _$BlockNoteBlockTypeEnumMap[instance.type]!,
  if (instance.content?.map((e) => e.toJson()).toList() case final value?)
    'content': value,
  if (instance.props case final value?) 'props': value,
  if (instance.children?.map((e) => e.toJson()).toList() case final value?)
    'children': value,
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
