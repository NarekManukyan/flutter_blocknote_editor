// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'blocknote_toolbar_config.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$BlockNoteToolbarButton {

/// Unique key for the button (used by React for list reconciliation).
///
/// If not provided, will be auto-generated based on type and properties.
 String? get key;/// Button type.
 BlockNoteToolbarButtonType get type;/// Basic text style (for BasicTextStyleButton).
 BlockNoteBasicTextStyle? get basicTextStyle;/// Text alignment (for TextAlignButton).
///
/// Only left, center, and right are supported by BlockNote.
// ignore: invalid_annotation_target
@JsonKey(fromJson: _textAlignFromBlockNoteNullable, toJson: _textAlignToBlockNoteNullable) TextAlign? get textAlignment;
/// Create a copy of BlockNoteToolbarButton
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BlockNoteToolbarButtonCopyWith<BlockNoteToolbarButton> get copyWith => _$BlockNoteToolbarButtonCopyWithImpl<BlockNoteToolbarButton>(this as BlockNoteToolbarButton, _$identity);

  /// Serializes this BlockNoteToolbarButton to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BlockNoteToolbarButton&&(identical(other.key, key) || other.key == key)&&(identical(other.type, type) || other.type == type)&&(identical(other.basicTextStyle, basicTextStyle) || other.basicTextStyle == basicTextStyle)&&(identical(other.textAlignment, textAlignment) || other.textAlignment == textAlignment));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,key,type,basicTextStyle,textAlignment);

@override
String toString() {
  return 'BlockNoteToolbarButton(key: $key, type: $type, basicTextStyle: $basicTextStyle, textAlignment: $textAlignment)';
}


}

/// @nodoc
abstract mixin class $BlockNoteToolbarButtonCopyWith<$Res>  {
  factory $BlockNoteToolbarButtonCopyWith(BlockNoteToolbarButton value, $Res Function(BlockNoteToolbarButton) _then) = _$BlockNoteToolbarButtonCopyWithImpl;
@useResult
$Res call({
 String? key, BlockNoteToolbarButtonType type, BlockNoteBasicTextStyle? basicTextStyle,@JsonKey(fromJson: _textAlignFromBlockNoteNullable, toJson: _textAlignToBlockNoteNullable) TextAlign? textAlignment
});




}
/// @nodoc
class _$BlockNoteToolbarButtonCopyWithImpl<$Res>
    implements $BlockNoteToolbarButtonCopyWith<$Res> {
  _$BlockNoteToolbarButtonCopyWithImpl(this._self, this._then);

  final BlockNoteToolbarButton _self;
  final $Res Function(BlockNoteToolbarButton) _then;

/// Create a copy of BlockNoteToolbarButton
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? key = freezed,Object? type = null,Object? basicTextStyle = freezed,Object? textAlignment = freezed,}) {
  return _then(_self.copyWith(
key: freezed == key ? _self.key : key // ignore: cast_nullable_to_non_nullable
as String?,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as BlockNoteToolbarButtonType,basicTextStyle: freezed == basicTextStyle ? _self.basicTextStyle : basicTextStyle // ignore: cast_nullable_to_non_nullable
as BlockNoteBasicTextStyle?,textAlignment: freezed == textAlignment ? _self.textAlignment : textAlignment // ignore: cast_nullable_to_non_nullable
as TextAlign?,
  ));
}

}



/// @nodoc
@JsonSerializable()

class _BlockNoteToolbarButton implements BlockNoteToolbarButton {
  const _BlockNoteToolbarButton({this.key, required this.type, this.basicTextStyle, @JsonKey(fromJson: _textAlignFromBlockNoteNullable, toJson: _textAlignToBlockNoteNullable) this.textAlignment});
  factory _BlockNoteToolbarButton.fromJson(Map<String, dynamic> json) => _$BlockNoteToolbarButtonFromJson(json);

/// Unique key for the button (used by React for list reconciliation).
///
/// If not provided, will be auto-generated based on type and properties.
@override final  String? key;
/// Button type.
@override final  BlockNoteToolbarButtonType type;
/// Basic text style (for BasicTextStyleButton).
@override final  BlockNoteBasicTextStyle? basicTextStyle;
/// Text alignment (for TextAlignButton).
///
/// Only left, center, and right are supported by BlockNote.
// ignore: invalid_annotation_target
@override@JsonKey(fromJson: _textAlignFromBlockNoteNullable, toJson: _textAlignToBlockNoteNullable) final  TextAlign? textAlignment;

/// Create a copy of BlockNoteToolbarButton
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BlockNoteToolbarButtonCopyWith<_BlockNoteToolbarButton> get copyWith => __$BlockNoteToolbarButtonCopyWithImpl<_BlockNoteToolbarButton>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$BlockNoteToolbarButtonToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _BlockNoteToolbarButton&&(identical(other.key, key) || other.key == key)&&(identical(other.type, type) || other.type == type)&&(identical(other.basicTextStyle, basicTextStyle) || other.basicTextStyle == basicTextStyle)&&(identical(other.textAlignment, textAlignment) || other.textAlignment == textAlignment));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,key,type,basicTextStyle,textAlignment);

@override
String toString() {
  return 'BlockNoteToolbarButton(key: $key, type: $type, basicTextStyle: $basicTextStyle, textAlignment: $textAlignment)';
}


}

/// @nodoc
abstract mixin class _$BlockNoteToolbarButtonCopyWith<$Res> implements $BlockNoteToolbarButtonCopyWith<$Res> {
  factory _$BlockNoteToolbarButtonCopyWith(_BlockNoteToolbarButton value, $Res Function(_BlockNoteToolbarButton) _then) = __$BlockNoteToolbarButtonCopyWithImpl;
@override @useResult
$Res call({
 String? key, BlockNoteToolbarButtonType type, BlockNoteBasicTextStyle? basicTextStyle,@JsonKey(fromJson: _textAlignFromBlockNoteNullable, toJson: _textAlignToBlockNoteNullable) TextAlign? textAlignment
});




}
/// @nodoc
class __$BlockNoteToolbarButtonCopyWithImpl<$Res>
    implements _$BlockNoteToolbarButtonCopyWith<$Res> {
  __$BlockNoteToolbarButtonCopyWithImpl(this._self, this._then);

  final _BlockNoteToolbarButton _self;
  final $Res Function(_BlockNoteToolbarButton) _then;

/// Create a copy of BlockNoteToolbarButton
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? key = freezed,Object? type = null,Object? basicTextStyle = freezed,Object? textAlignment = freezed,}) {
  return _then(_BlockNoteToolbarButton(
key: freezed == key ? _self.key : key // ignore: cast_nullable_to_non_nullable
as String?,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as BlockNoteToolbarButtonType,basicTextStyle: freezed == basicTextStyle ? _self.basicTextStyle : basicTextStyle // ignore: cast_nullable_to_non_nullable
as BlockNoteBasicTextStyle?,textAlignment: freezed == textAlignment ? _self.textAlignment : textAlignment // ignore: cast_nullable_to_non_nullable
as TextAlign?,
  ));
}


}


/// @nodoc
mixin _$BlockNoteBlockTypeItem {

/// Block type.
 BlockNoteBlockType get type;/// Display title.
 String get title;/// Icon name or identifier (optional).
 String? get icon;/// Group name (optional).
 String? get group;
/// Create a copy of BlockNoteBlockTypeItem
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BlockNoteBlockTypeItemCopyWith<BlockNoteBlockTypeItem> get copyWith => _$BlockNoteBlockTypeItemCopyWithImpl<BlockNoteBlockTypeItem>(this as BlockNoteBlockTypeItem, _$identity);

  /// Serializes this BlockNoteBlockTypeItem to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BlockNoteBlockTypeItem&&(identical(other.type, type) || other.type == type)&&(identical(other.title, title) || other.title == title)&&(identical(other.icon, icon) || other.icon == icon)&&(identical(other.group, group) || other.group == group));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,type,title,icon,group);

@override
String toString() {
  return 'BlockNoteBlockTypeItem(type: $type, title: $title, icon: $icon, group: $group)';
}


}

/// @nodoc
abstract mixin class $BlockNoteBlockTypeItemCopyWith<$Res>  {
  factory $BlockNoteBlockTypeItemCopyWith(BlockNoteBlockTypeItem value, $Res Function(BlockNoteBlockTypeItem) _then) = _$BlockNoteBlockTypeItemCopyWithImpl;
@useResult
$Res call({
 BlockNoteBlockType type, String title, String? icon, String? group
});




}
/// @nodoc
class _$BlockNoteBlockTypeItemCopyWithImpl<$Res>
    implements $BlockNoteBlockTypeItemCopyWith<$Res> {
  _$BlockNoteBlockTypeItemCopyWithImpl(this._self, this._then);

  final BlockNoteBlockTypeItem _self;
  final $Res Function(BlockNoteBlockTypeItem) _then;

/// Create a copy of BlockNoteBlockTypeItem
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? type = null,Object? title = null,Object? icon = freezed,Object? group = freezed,}) {
  return _then(_self.copyWith(
type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as BlockNoteBlockType,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,icon: freezed == icon ? _self.icon : icon // ignore: cast_nullable_to_non_nullable
as String?,group: freezed == group ? _self.group : group // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}



/// @nodoc
@JsonSerializable()

class _BlockNoteBlockTypeItem implements BlockNoteBlockTypeItem {
  const _BlockNoteBlockTypeItem({required this.type, required this.title, this.icon, this.group});
  factory _BlockNoteBlockTypeItem.fromJson(Map<String, dynamic> json) => _$BlockNoteBlockTypeItemFromJson(json);

/// Block type.
@override final  BlockNoteBlockType type;
/// Display title.
@override final  String title;
/// Icon name or identifier (optional).
@override final  String? icon;
/// Group name (optional).
@override final  String? group;

/// Create a copy of BlockNoteBlockTypeItem
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BlockNoteBlockTypeItemCopyWith<_BlockNoteBlockTypeItem> get copyWith => __$BlockNoteBlockTypeItemCopyWithImpl<_BlockNoteBlockTypeItem>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$BlockNoteBlockTypeItemToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _BlockNoteBlockTypeItem&&(identical(other.type, type) || other.type == type)&&(identical(other.title, title) || other.title == title)&&(identical(other.icon, icon) || other.icon == icon)&&(identical(other.group, group) || other.group == group));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,type,title,icon,group);

@override
String toString() {
  return 'BlockNoteBlockTypeItem(type: $type, title: $title, icon: $icon, group: $group)';
}


}

/// @nodoc
abstract mixin class _$BlockNoteBlockTypeItemCopyWith<$Res> implements $BlockNoteBlockTypeItemCopyWith<$Res> {
  factory _$BlockNoteBlockTypeItemCopyWith(_BlockNoteBlockTypeItem value, $Res Function(_BlockNoteBlockTypeItem) _then) = __$BlockNoteBlockTypeItemCopyWithImpl;
@override @useResult
$Res call({
 BlockNoteBlockType type, String title, String? icon, String? group
});




}
/// @nodoc
class __$BlockNoteBlockTypeItemCopyWithImpl<$Res>
    implements _$BlockNoteBlockTypeItemCopyWith<$Res> {
  __$BlockNoteBlockTypeItemCopyWithImpl(this._self, this._then);

  final _BlockNoteBlockTypeItem _self;
  final $Res Function(_BlockNoteBlockTypeItem) _then;

/// Create a copy of BlockNoteBlockTypeItem
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? type = null,Object? title = null,Object? icon = freezed,Object? group = freezed,}) {
  return _then(_BlockNoteBlockTypeItem(
type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as BlockNoteBlockType,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,icon: freezed == icon ? _self.icon : icon // ignore: cast_nullable_to_non_nullable
as String?,group: freezed == group ? _self.group : group // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$BlockNoteToolbarConfig {

/// Custom toolbar buttons (replaces default if provided).
// ignore: invalid_annotation_target
@JsonKey(toJson: _buttonsToJson) List<BlockNoteToolbarButton>? get buttons;/// Custom block type select items (extends default if provided).
 List<BlockNoteBlockTypeItem>? get blockTypeSelectItems;/// Whether the toolbar is enabled (default: true).
 bool get enabled;
/// Create a copy of BlockNoteToolbarConfig
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BlockNoteToolbarConfigCopyWith<BlockNoteToolbarConfig> get copyWith => _$BlockNoteToolbarConfigCopyWithImpl<BlockNoteToolbarConfig>(this as BlockNoteToolbarConfig, _$identity);

  /// Serializes this BlockNoteToolbarConfig to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BlockNoteToolbarConfig&&const DeepCollectionEquality().equals(other.buttons, buttons)&&const DeepCollectionEquality().equals(other.blockTypeSelectItems, blockTypeSelectItems)&&(identical(other.enabled, enabled) || other.enabled == enabled));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(buttons),const DeepCollectionEquality().hash(blockTypeSelectItems),enabled);

@override
String toString() {
  return 'BlockNoteToolbarConfig(buttons: $buttons, blockTypeSelectItems: $blockTypeSelectItems, enabled: $enabled)';
}


}

/// @nodoc
abstract mixin class $BlockNoteToolbarConfigCopyWith<$Res>  {
  factory $BlockNoteToolbarConfigCopyWith(BlockNoteToolbarConfig value, $Res Function(BlockNoteToolbarConfig) _then) = _$BlockNoteToolbarConfigCopyWithImpl;
@useResult
$Res call({
@JsonKey(toJson: _buttonsToJson) List<BlockNoteToolbarButton>? buttons, List<BlockNoteBlockTypeItem>? blockTypeSelectItems, bool enabled
});




}
/// @nodoc
class _$BlockNoteToolbarConfigCopyWithImpl<$Res>
    implements $BlockNoteToolbarConfigCopyWith<$Res> {
  _$BlockNoteToolbarConfigCopyWithImpl(this._self, this._then);

  final BlockNoteToolbarConfig _self;
  final $Res Function(BlockNoteToolbarConfig) _then;

/// Create a copy of BlockNoteToolbarConfig
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? buttons = freezed,Object? blockTypeSelectItems = freezed,Object? enabled = null,}) {
  return _then(_self.copyWith(
buttons: freezed == buttons ? _self.buttons : buttons // ignore: cast_nullable_to_non_nullable
as List<BlockNoteToolbarButton>?,blockTypeSelectItems: freezed == blockTypeSelectItems ? _self.blockTypeSelectItems : blockTypeSelectItems // ignore: cast_nullable_to_non_nullable
as List<BlockNoteBlockTypeItem>?,enabled: null == enabled ? _self.enabled : enabled // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}



/// @nodoc
@JsonSerializable()

class _BlockNoteToolbarConfig implements BlockNoteToolbarConfig {
  const _BlockNoteToolbarConfig({@JsonKey(toJson: _buttonsToJson) final  List<BlockNoteToolbarButton>? buttons, final  List<BlockNoteBlockTypeItem>? blockTypeSelectItems, this.enabled = true}): _buttons = buttons,_blockTypeSelectItems = blockTypeSelectItems;
  factory _BlockNoteToolbarConfig.fromJson(Map<String, dynamic> json) => _$BlockNoteToolbarConfigFromJson(json);

/// Custom toolbar buttons (replaces default if provided).
// ignore: invalid_annotation_target
 final  List<BlockNoteToolbarButton>? _buttons;
/// Custom toolbar buttons (replaces default if provided).
// ignore: invalid_annotation_target
@override@JsonKey(toJson: _buttonsToJson) List<BlockNoteToolbarButton>? get buttons {
  final value = _buttons;
  if (value == null) return null;
  if (_buttons is EqualUnmodifiableListView) return _buttons;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

/// Custom block type select items (extends default if provided).
 final  List<BlockNoteBlockTypeItem>? _blockTypeSelectItems;
/// Custom block type select items (extends default if provided).
@override List<BlockNoteBlockTypeItem>? get blockTypeSelectItems {
  final value = _blockTypeSelectItems;
  if (value == null) return null;
  if (_blockTypeSelectItems is EqualUnmodifiableListView) return _blockTypeSelectItems;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

/// Whether the toolbar is enabled (default: true).
@override@JsonKey() final  bool enabled;

/// Create a copy of BlockNoteToolbarConfig
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BlockNoteToolbarConfigCopyWith<_BlockNoteToolbarConfig> get copyWith => __$BlockNoteToolbarConfigCopyWithImpl<_BlockNoteToolbarConfig>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$BlockNoteToolbarConfigToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _BlockNoteToolbarConfig&&const DeepCollectionEquality().equals(other._buttons, _buttons)&&const DeepCollectionEquality().equals(other._blockTypeSelectItems, _blockTypeSelectItems)&&(identical(other.enabled, enabled) || other.enabled == enabled));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_buttons),const DeepCollectionEquality().hash(_blockTypeSelectItems),enabled);

@override
String toString() {
  return 'BlockNoteToolbarConfig(buttons: $buttons, blockTypeSelectItems: $blockTypeSelectItems, enabled: $enabled)';
}


}

/// @nodoc
abstract mixin class _$BlockNoteToolbarConfigCopyWith<$Res> implements $BlockNoteToolbarConfigCopyWith<$Res> {
  factory _$BlockNoteToolbarConfigCopyWith(_BlockNoteToolbarConfig value, $Res Function(_BlockNoteToolbarConfig) _then) = __$BlockNoteToolbarConfigCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(toJson: _buttonsToJson) List<BlockNoteToolbarButton>? buttons, List<BlockNoteBlockTypeItem>? blockTypeSelectItems, bool enabled
});




}
/// @nodoc
class __$BlockNoteToolbarConfigCopyWithImpl<$Res>
    implements _$BlockNoteToolbarConfigCopyWith<$Res> {
  __$BlockNoteToolbarConfigCopyWithImpl(this._self, this._then);

  final _BlockNoteToolbarConfig _self;
  final $Res Function(_BlockNoteToolbarConfig) _then;

/// Create a copy of BlockNoteToolbarConfig
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? buttons = freezed,Object? blockTypeSelectItems = freezed,Object? enabled = null,}) {
  return _then(_BlockNoteToolbarConfig(
buttons: freezed == buttons ? _self._buttons : buttons // ignore: cast_nullable_to_non_nullable
as List<BlockNoteToolbarButton>?,blockTypeSelectItems: freezed == blockTypeSelectItems ? _self._blockTypeSelectItems : blockTypeSelectItems // ignore: cast_nullable_to_non_nullable
as List<BlockNoteBlockTypeItem>?,enabled: null == enabled ? _self.enabled : enabled // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
