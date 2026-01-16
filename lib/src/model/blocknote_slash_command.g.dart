// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'blocknote_slash_command.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_BlockNoteSlashCommandItem _$BlockNoteSlashCommandItemFromJson(Map json) =>
    _BlockNoteSlashCommandItem(
      title: json['title'] as String,
      onItemClick: json['onItemClick'] as String,
      subtext: json['subtext'] as String?,
      badge: json['badge'] as String?,
      aliases: (json['aliases'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      group: json['group'] as String?,
      icon: json['icon'] as String?,
    );

Map<String, dynamic> _$BlockNoteSlashCommandItemToJson(
  _BlockNoteSlashCommandItem instance,
) => <String, dynamic>{
  'title': instance.title,
  'onItemClick': instance.onItemClick,
  'subtext': ?instance.subtext,
  'badge': ?instance.badge,
  'aliases': ?instance.aliases,
  'group': ?instance.group,
  'icon': ?instance.icon,
};

_BlockNoteSlashCommandConfig _$BlockNoteSlashCommandConfigFromJson(Map json) =>
    _BlockNoteSlashCommandConfig(
      items: (json['items'] as List<dynamic>?)
          ?.map(
            (e) => BlockNoteSlashCommandItem.fromJson(
              Map<String, dynamic>.from(e as Map),
            ),
          )
          .toList(),
      enabled: json['enabled'] as bool? ?? true,
      triggerCharacter: json['triggerCharacter'] as String? ?? '/',
    );

Map<String, dynamic> _$BlockNoteSlashCommandConfigToJson(
  _BlockNoteSlashCommandConfig instance,
) => <String, dynamic>{
  'items': ?instance.items?.map((e) => e.toJson()).toList(),
  'enabled': instance.enabled,
  'triggerCharacter': instance.triggerCharacter,
};
