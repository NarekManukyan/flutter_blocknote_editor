// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'blocknote_slash_command.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$BlockNoteSlashCommandItem {

/// Title of the command item.
 String get title;/// JavaScript function code to execute when the item is clicked.
///
/// This should be a string containing JavaScript code that will be
/// evaluated. The code has access to the `editor` variable.
///
/// Example: "editor.insertBlocks([{type: 'paragraph', content: 'Hello'}], editor.getTextCursorPosition().block, 'after');"
 String get onItemClick;/// Subtitle text (optional).
 String? get subtext;/// Badge text (optional, typically shows keyboard shortcut).
 String? get badge;/// Aliases for filtering (optional).
 List<String>? get aliases;/// Group name (optional).
 String? get group;/// Icon identifier (optional).
 String? get icon;
/// Create a copy of BlockNoteSlashCommandItem
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BlockNoteSlashCommandItemCopyWith<BlockNoteSlashCommandItem> get copyWith => _$BlockNoteSlashCommandItemCopyWithImpl<BlockNoteSlashCommandItem>(this as BlockNoteSlashCommandItem, _$identity);

  /// Serializes this BlockNoteSlashCommandItem to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BlockNoteSlashCommandItem&&(identical(other.title, title) || other.title == title)&&(identical(other.onItemClick, onItemClick) || other.onItemClick == onItemClick)&&(identical(other.subtext, subtext) || other.subtext == subtext)&&(identical(other.badge, badge) || other.badge == badge)&&const DeepCollectionEquality().equals(other.aliases, aliases)&&(identical(other.group, group) || other.group == group)&&(identical(other.icon, icon) || other.icon == icon));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,title,onItemClick,subtext,badge,const DeepCollectionEquality().hash(aliases),group,icon);

@override
String toString() {
  return 'BlockNoteSlashCommandItem(title: $title, onItemClick: $onItemClick, subtext: $subtext, badge: $badge, aliases: $aliases, group: $group, icon: $icon)';
}


}

/// @nodoc
abstract mixin class $BlockNoteSlashCommandItemCopyWith<$Res>  {
  factory $BlockNoteSlashCommandItemCopyWith(BlockNoteSlashCommandItem value, $Res Function(BlockNoteSlashCommandItem) _then) = _$BlockNoteSlashCommandItemCopyWithImpl;
@useResult
$Res call({
 String title, String onItemClick, String? subtext, String? badge, List<String>? aliases, String? group, String? icon
});




}
/// @nodoc
class _$BlockNoteSlashCommandItemCopyWithImpl<$Res>
    implements $BlockNoteSlashCommandItemCopyWith<$Res> {
  _$BlockNoteSlashCommandItemCopyWithImpl(this._self, this._then);

  final BlockNoteSlashCommandItem _self;
  final $Res Function(BlockNoteSlashCommandItem) _then;

/// Create a copy of BlockNoteSlashCommandItem
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? title = null,Object? onItemClick = null,Object? subtext = freezed,Object? badge = freezed,Object? aliases = freezed,Object? group = freezed,Object? icon = freezed,}) {
  return _then(_self.copyWith(
title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,onItemClick: null == onItemClick ? _self.onItemClick : onItemClick // ignore: cast_nullable_to_non_nullable
as String,subtext: freezed == subtext ? _self.subtext : subtext // ignore: cast_nullable_to_non_nullable
as String?,badge: freezed == badge ? _self.badge : badge // ignore: cast_nullable_to_non_nullable
as String?,aliases: freezed == aliases ? _self.aliases : aliases // ignore: cast_nullable_to_non_nullable
as List<String>?,group: freezed == group ? _self.group : group // ignore: cast_nullable_to_non_nullable
as String?,icon: freezed == icon ? _self.icon : icon // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}



/// @nodoc
@JsonSerializable()

class _BlockNoteSlashCommandItem implements BlockNoteSlashCommandItem {
  const _BlockNoteSlashCommandItem({required this.title, required this.onItemClick, this.subtext, this.badge, final  List<String>? aliases, this.group, this.icon}): _aliases = aliases;
  factory _BlockNoteSlashCommandItem.fromJson(Map<String, dynamic> json) => _$BlockNoteSlashCommandItemFromJson(json);

/// Title of the command item.
@override final  String title;
/// JavaScript function code to execute when the item is clicked.
///
/// This should be a string containing JavaScript code that will be
/// evaluated. The code has access to the `editor` variable.
///
/// Example: "editor.insertBlocks([{type: 'paragraph', content: 'Hello'}], editor.getTextCursorPosition().block, 'after');"
@override final  String onItemClick;
/// Subtitle text (optional).
@override final  String? subtext;
/// Badge text (optional, typically shows keyboard shortcut).
@override final  String? badge;
/// Aliases for filtering (optional).
 final  List<String>? _aliases;
/// Aliases for filtering (optional).
@override List<String>? get aliases {
  final value = _aliases;
  if (value == null) return null;
  if (_aliases is EqualUnmodifiableListView) return _aliases;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

/// Group name (optional).
@override final  String? group;
/// Icon identifier (optional).
@override final  String? icon;

/// Create a copy of BlockNoteSlashCommandItem
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BlockNoteSlashCommandItemCopyWith<_BlockNoteSlashCommandItem> get copyWith => __$BlockNoteSlashCommandItemCopyWithImpl<_BlockNoteSlashCommandItem>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$BlockNoteSlashCommandItemToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _BlockNoteSlashCommandItem&&(identical(other.title, title) || other.title == title)&&(identical(other.onItemClick, onItemClick) || other.onItemClick == onItemClick)&&(identical(other.subtext, subtext) || other.subtext == subtext)&&(identical(other.badge, badge) || other.badge == badge)&&const DeepCollectionEquality().equals(other._aliases, _aliases)&&(identical(other.group, group) || other.group == group)&&(identical(other.icon, icon) || other.icon == icon));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,title,onItemClick,subtext,badge,const DeepCollectionEquality().hash(_aliases),group,icon);

@override
String toString() {
  return 'BlockNoteSlashCommandItem(title: $title, onItemClick: $onItemClick, subtext: $subtext, badge: $badge, aliases: $aliases, group: $group, icon: $icon)';
}


}

/// @nodoc
abstract mixin class _$BlockNoteSlashCommandItemCopyWith<$Res> implements $BlockNoteSlashCommandItemCopyWith<$Res> {
  factory _$BlockNoteSlashCommandItemCopyWith(_BlockNoteSlashCommandItem value, $Res Function(_BlockNoteSlashCommandItem) _then) = __$BlockNoteSlashCommandItemCopyWithImpl;
@override @useResult
$Res call({
 String title, String onItemClick, String? subtext, String? badge, List<String>? aliases, String? group, String? icon
});




}
/// @nodoc
class __$BlockNoteSlashCommandItemCopyWithImpl<$Res>
    implements _$BlockNoteSlashCommandItemCopyWith<$Res> {
  __$BlockNoteSlashCommandItemCopyWithImpl(this._self, this._then);

  final _BlockNoteSlashCommandItem _self;
  final $Res Function(_BlockNoteSlashCommandItem) _then;

/// Create a copy of BlockNoteSlashCommandItem
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? title = null,Object? onItemClick = null,Object? subtext = freezed,Object? badge = freezed,Object? aliases = freezed,Object? group = freezed,Object? icon = freezed,}) {
  return _then(_BlockNoteSlashCommandItem(
title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,onItemClick: null == onItemClick ? _self.onItemClick : onItemClick // ignore: cast_nullable_to_non_nullable
as String,subtext: freezed == subtext ? _self.subtext : subtext // ignore: cast_nullable_to_non_nullable
as String?,badge: freezed == badge ? _self.badge : badge // ignore: cast_nullable_to_non_nullable
as String?,aliases: freezed == aliases ? _self._aliases : aliases // ignore: cast_nullable_to_non_nullable
as List<String>?,group: freezed == group ? _self.group : group // ignore: cast_nullable_to_non_nullable
as String?,icon: freezed == icon ? _self.icon : icon // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$BlockNoteSlashCommandConfig {

/// Custom slash command items (extends default if provided).
 List<BlockNoteSlashCommandItem>? get items;/// Whether the slash menu is enabled (default: true).
 bool get enabled;/// Trigger character (default: '/').
 String get triggerCharacter;
/// Create a copy of BlockNoteSlashCommandConfig
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BlockNoteSlashCommandConfigCopyWith<BlockNoteSlashCommandConfig> get copyWith => _$BlockNoteSlashCommandConfigCopyWithImpl<BlockNoteSlashCommandConfig>(this as BlockNoteSlashCommandConfig, _$identity);

  /// Serializes this BlockNoteSlashCommandConfig to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BlockNoteSlashCommandConfig&&const DeepCollectionEquality().equals(other.items, items)&&(identical(other.enabled, enabled) || other.enabled == enabled)&&(identical(other.triggerCharacter, triggerCharacter) || other.triggerCharacter == triggerCharacter));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(items),enabled,triggerCharacter);

@override
String toString() {
  return 'BlockNoteSlashCommandConfig(items: $items, enabled: $enabled, triggerCharacter: $triggerCharacter)';
}


}

/// @nodoc
abstract mixin class $BlockNoteSlashCommandConfigCopyWith<$Res>  {
  factory $BlockNoteSlashCommandConfigCopyWith(BlockNoteSlashCommandConfig value, $Res Function(BlockNoteSlashCommandConfig) _then) = _$BlockNoteSlashCommandConfigCopyWithImpl;
@useResult
$Res call({
 List<BlockNoteSlashCommandItem>? items, bool enabled, String triggerCharacter
});




}
/// @nodoc
class _$BlockNoteSlashCommandConfigCopyWithImpl<$Res>
    implements $BlockNoteSlashCommandConfigCopyWith<$Res> {
  _$BlockNoteSlashCommandConfigCopyWithImpl(this._self, this._then);

  final BlockNoteSlashCommandConfig _self;
  final $Res Function(BlockNoteSlashCommandConfig) _then;

/// Create a copy of BlockNoteSlashCommandConfig
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? items = freezed,Object? enabled = null,Object? triggerCharacter = null,}) {
  return _then(_self.copyWith(
items: freezed == items ? _self.items : items // ignore: cast_nullable_to_non_nullable
as List<BlockNoteSlashCommandItem>?,enabled: null == enabled ? _self.enabled : enabled // ignore: cast_nullable_to_non_nullable
as bool,triggerCharacter: null == triggerCharacter ? _self.triggerCharacter : triggerCharacter // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}



/// @nodoc
@JsonSerializable()

class _BlockNoteSlashCommandConfig implements BlockNoteSlashCommandConfig {
  const _BlockNoteSlashCommandConfig({final  List<BlockNoteSlashCommandItem>? items, this.enabled = true, this.triggerCharacter = '/'}): _items = items;
  factory _BlockNoteSlashCommandConfig.fromJson(Map<String, dynamic> json) => _$BlockNoteSlashCommandConfigFromJson(json);

/// Custom slash command items (extends default if provided).
 final  List<BlockNoteSlashCommandItem>? _items;
/// Custom slash command items (extends default if provided).
@override List<BlockNoteSlashCommandItem>? get items {
  final value = _items;
  if (value == null) return null;
  if (_items is EqualUnmodifiableListView) return _items;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

/// Whether the slash menu is enabled (default: true).
@override@JsonKey() final  bool enabled;
/// Trigger character (default: '/').
@override@JsonKey() final  String triggerCharacter;

/// Create a copy of BlockNoteSlashCommandConfig
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BlockNoteSlashCommandConfigCopyWith<_BlockNoteSlashCommandConfig> get copyWith => __$BlockNoteSlashCommandConfigCopyWithImpl<_BlockNoteSlashCommandConfig>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$BlockNoteSlashCommandConfigToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _BlockNoteSlashCommandConfig&&const DeepCollectionEquality().equals(other._items, _items)&&(identical(other.enabled, enabled) || other.enabled == enabled)&&(identical(other.triggerCharacter, triggerCharacter) || other.triggerCharacter == triggerCharacter));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_items),enabled,triggerCharacter);

@override
String toString() {
  return 'BlockNoteSlashCommandConfig(items: $items, enabled: $enabled, triggerCharacter: $triggerCharacter)';
}


}

/// @nodoc
abstract mixin class _$BlockNoteSlashCommandConfigCopyWith<$Res> implements $BlockNoteSlashCommandConfigCopyWith<$Res> {
  factory _$BlockNoteSlashCommandConfigCopyWith(_BlockNoteSlashCommandConfig value, $Res Function(_BlockNoteSlashCommandConfig) _then) = __$BlockNoteSlashCommandConfigCopyWithImpl;
@override @useResult
$Res call({
 List<BlockNoteSlashCommandItem>? items, bool enabled, String triggerCharacter
});




}
/// @nodoc
class __$BlockNoteSlashCommandConfigCopyWithImpl<$Res>
    implements _$BlockNoteSlashCommandConfigCopyWith<$Res> {
  __$BlockNoteSlashCommandConfigCopyWithImpl(this._self, this._then);

  final _BlockNoteSlashCommandConfig _self;
  final $Res Function(_BlockNoteSlashCommandConfig) _then;

/// Create a copy of BlockNoteSlashCommandConfig
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? items = freezed,Object? enabled = null,Object? triggerCharacter = null,}) {
  return _then(_BlockNoteSlashCommandConfig(
items: freezed == items ? _self._items : items // ignore: cast_nullable_to_non_nullable
as List<BlockNoteSlashCommandItem>?,enabled: null == enabled ? _self.enabled : enabled // ignore: cast_nullable_to_non_nullable
as bool,triggerCharacter: null == triggerCharacter ? _self.triggerCharacter : triggerCharacter // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
