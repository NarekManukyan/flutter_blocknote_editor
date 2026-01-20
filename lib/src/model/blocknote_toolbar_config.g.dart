// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'blocknote_toolbar_config.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_BlockNoteToolbarButton _$BlockNoteToolbarButtonFromJson(Map json) =>
    _BlockNoteToolbarButton(
      key: json['key'] as String?,
      type: $enumDecode(_$BlockNoteToolbarButtonTypeEnumMap, json['type']),
      basicTextStyle: $enumDecodeNullable(
        _$BlockNoteBasicTextStyleEnumMap,
        json['basicTextStyle'],
      ),
      textAlignment: _textAlignFromBlockNoteNullable(
        json['textAlignment'] as String?,
      ),
    );

Map<String, dynamic> _$BlockNoteToolbarButtonToJson(
  _BlockNoteToolbarButton instance,
) => <String, dynamic>{
  'key': ?instance.key,
  'type': _$BlockNoteToolbarButtonTypeEnumMap[instance.type]!,
  'basicTextStyle': ?_$BlockNoteBasicTextStyleEnumMap[instance.basicTextStyle],
  'textAlignment': ?_textAlignToBlockNoteNullable(instance.textAlignment),
};

const _$BlockNoteToolbarButtonTypeEnumMap = {
  BlockNoteToolbarButtonType.blockTypeSelect: 'blockTypeSelect',
  BlockNoteToolbarButtonType.fileCaptionButton: 'fileCaptionButton',
  BlockNoteToolbarButtonType.fileReplaceButton: 'fileReplaceButton',
  BlockNoteToolbarButtonType.basicTextStyleButton: 'basicTextStyleButton',
  BlockNoteToolbarButtonType.textAlignButton: 'textAlignButton',
  BlockNoteToolbarButtonType.colorStyleButton: 'colorStyleButton',
  BlockNoteToolbarButtonType.nestBlockButton: 'nestBlockButton',
  BlockNoteToolbarButtonType.unnestBlockButton: 'unnestBlockButton',
  BlockNoteToolbarButtonType.createLinkButton: 'createLinkButton',
};

const _$BlockNoteBasicTextStyleEnumMap = {
  BlockNoteBasicTextStyle.bold: 'bold',
  BlockNoteBasicTextStyle.italic: 'italic',
  BlockNoteBasicTextStyle.underline: 'underline',
  BlockNoteBasicTextStyle.strike: 'strike',
  BlockNoteBasicTextStyle.code: 'code',
};

_BlockNoteBlockTypeItem _$BlockNoteBlockTypeItemFromJson(Map json) =>
    _BlockNoteBlockTypeItem(
      type: $enumDecode(_$BlockNoteBlockTypeEnumMap, json['type']),
      title: json['title'] as String,
      icon: json['icon'] as String?,
      group: json['group'] as String?,
    );

Map<String, dynamic> _$BlockNoteBlockTypeItemToJson(
  _BlockNoteBlockTypeItem instance,
) => <String, dynamic>{
  'type': _$BlockNoteBlockTypeEnumMap[instance.type]!,
  'title': instance.title,
  'icon': ?instance.icon,
  'group': ?instance.group,
};

const _$BlockNoteBlockTypeEnumMap = {
  BlockNoteBlockType.paragraph: 'paragraph',
  BlockNoteBlockType.heading: 'heading',
  BlockNoteBlockType.quote: 'quote',
  BlockNoteBlockType.bulletListItem: 'bulletListItem',
  BlockNoteBlockType.numberedListItem: 'numberedListItem',
  BlockNoteBlockType.checkListItem: 'checkListItem',
  BlockNoteBlockType.toggleListItem: 'toggleListItem',
  BlockNoteBlockType.codeBlock: 'codeBlock',
  BlockNoteBlockType.audio: 'audio',
  BlockNoteBlockType.image: 'image',
  BlockNoteBlockType.video: 'video',
  BlockNoteBlockType.file: 'file',
  BlockNoteBlockType.table: 'table',
  BlockNoteBlockType.custom: 'custom',
};

_BlockNoteToolbarConfig _$BlockNoteToolbarConfigFromJson(Map json) =>
    _BlockNoteToolbarConfig(
      buttons: (json['buttons'] as List<dynamic>?)
          ?.map(
            (e) => BlockNoteToolbarButton.fromJson(
              Map<String, dynamic>.from(e as Map),
            ),
          )
          .toList(),
      blockTypeSelectItems: (json['blockTypeSelectItems'] as List<dynamic>?)
          ?.map(
            (e) => BlockNoteBlockTypeItem.fromJson(
              Map<String, dynamic>.from(e as Map),
            ),
          )
          .toList(),
      enabled: json['enabled'] as bool? ?? true,
    );

Map<String, dynamic> _$BlockNoteToolbarConfigToJson(
  _BlockNoteToolbarConfig instance,
) => <String, dynamic>{
  'buttons': ?_buttonsToJson(instance.buttons),
  'blockTypeSelectItems': ?instance.blockTypeSelectItems
      ?.map((e) => e.toJson())
      .toList(),
  'enabled': instance.enabled,
};
