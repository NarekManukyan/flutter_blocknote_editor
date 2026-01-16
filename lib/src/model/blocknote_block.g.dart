// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'blocknote_block.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BlockNoteInlineContent _$BlockNoteInlineContentFromJson(
  Map<String, dynamic> json,
) => BlockNoteInlineContent(
  type: _inlineContentTypeFromJson(json['type'] as String),
  text: json['text'] as String,
  styles: (json['styles'] as Map<String, dynamic>?)?.map(
    (k, e) => MapEntry(k, e as bool),
  ),
  href: json['href'] as String?,
  mentionId: json['mentionId'] as String?,
);

Map<String, dynamic> _$BlockNoteInlineContentToJson(
  BlockNoteInlineContent instance,
) => <String, dynamic>{
  'type': _inlineContentTypeToJson(instance.type),
  'text': instance.text,
  'styles': instance.styles,
  'href': instance.href,
  'mentionId': instance.mentionId,
};

BlockNoteBlock _$BlockNoteBlockFromJson(Map<String, dynamic> json) =>
    BlockNoteBlock(
      id: json['id'] as String,
      type: _blockTypeFromJson(json['type'] as String),
      content: (json['content'] as List<dynamic>?)
          ?.map(
            (e) => BlockNoteInlineContent.fromJson(e as Map<String, dynamic>),
          )
          .toList(),
      props: json['props'] as Map<String, dynamic>?,
      children: (json['children'] as List<dynamic>?)
          ?.map((e) => BlockNoteBlock.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$BlockNoteBlockToJson(BlockNoteBlock instance) =>
    <String, dynamic>{
      'id': instance.id,
      'type': _blockTypeToJson(instance.type),
      'content': instance.content,
      'props': instance.props,
      'children': instance.children,
    };
