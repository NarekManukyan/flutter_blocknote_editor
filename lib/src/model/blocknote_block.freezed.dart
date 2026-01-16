// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'blocknote_block.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$BlockNoteInlineContent {

/// The type of inline content.
 BlockNoteInlineContentType get type;/// The text content.
 String get text;/// Optional text styles (bold, italic, underline, textColor, backgroundColor, etc.).
/// Can contain boolean values (bold, italic, underline, strike) and string values (textColor, backgroundColor).
 Map<String, dynamic>? get styles;/// Optional href for link content.
 String? get href;/// Optional mention ID for mention content.
 String? get mentionId;
/// Create a copy of BlockNoteInlineContent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BlockNoteInlineContentCopyWith<BlockNoteInlineContent> get copyWith => _$BlockNoteInlineContentCopyWithImpl<BlockNoteInlineContent>(this as BlockNoteInlineContent, _$identity);

  /// Serializes this BlockNoteInlineContent to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BlockNoteInlineContent&&(identical(other.type, type) || other.type == type)&&(identical(other.text, text) || other.text == text)&&const DeepCollectionEquality().equals(other.styles, styles)&&(identical(other.href, href) || other.href == href)&&(identical(other.mentionId, mentionId) || other.mentionId == mentionId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,type,text,const DeepCollectionEquality().hash(styles),href,mentionId);

@override
String toString() {
  return 'BlockNoteInlineContent(type: $type, text: $text, styles: $styles, href: $href, mentionId: $mentionId)';
}


}

/// @nodoc
abstract mixin class $BlockNoteInlineContentCopyWith<$Res>  {
  factory $BlockNoteInlineContentCopyWith(BlockNoteInlineContent value, $Res Function(BlockNoteInlineContent) _then) = _$BlockNoteInlineContentCopyWithImpl;
@useResult
$Res call({
 BlockNoteInlineContentType type, String text, Map<String, dynamic>? styles, String? href, String? mentionId
});




}
/// @nodoc
class _$BlockNoteInlineContentCopyWithImpl<$Res>
    implements $BlockNoteInlineContentCopyWith<$Res> {
  _$BlockNoteInlineContentCopyWithImpl(this._self, this._then);

  final BlockNoteInlineContent _self;
  final $Res Function(BlockNoteInlineContent) _then;

/// Create a copy of BlockNoteInlineContent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? type = null,Object? text = null,Object? styles = freezed,Object? href = freezed,Object? mentionId = freezed,}) {
  return _then(_self.copyWith(
type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as BlockNoteInlineContentType,text: null == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String,styles: freezed == styles ? _self.styles : styles // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,href: freezed == href ? _self.href : href // ignore: cast_nullable_to_non_nullable
as String?,mentionId: freezed == mentionId ? _self.mentionId : mentionId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}



/// @nodoc
@JsonSerializable()

class _BlockNoteInlineContent implements BlockNoteInlineContent {
  const _BlockNoteInlineContent({required this.type, required this.text, final  Map<String, dynamic>? styles, this.href, this.mentionId}): _styles = styles;
  factory _BlockNoteInlineContent.fromJson(Map<String, dynamic> json) => _$BlockNoteInlineContentFromJson(json);

/// The type of inline content.
@override final  BlockNoteInlineContentType type;
/// The text content.
@override final  String text;
/// Optional text styles (bold, italic, underline, textColor, backgroundColor, etc.).
/// Can contain boolean values (bold, italic, underline, strike) and string values (textColor, backgroundColor).
 final  Map<String, dynamic>? _styles;
/// Optional text styles (bold, italic, underline, textColor, backgroundColor, etc.).
/// Can contain boolean values (bold, italic, underline, strike) and string values (textColor, backgroundColor).
@override Map<String, dynamic>? get styles {
  final value = _styles;
  if (value == null) return null;
  if (_styles is EqualUnmodifiableMapView) return _styles;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(value);
}

/// Optional href for link content.
@override final  String? href;
/// Optional mention ID for mention content.
@override final  String? mentionId;

/// Create a copy of BlockNoteInlineContent
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BlockNoteInlineContentCopyWith<_BlockNoteInlineContent> get copyWith => __$BlockNoteInlineContentCopyWithImpl<_BlockNoteInlineContent>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$BlockNoteInlineContentToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _BlockNoteInlineContent&&(identical(other.type, type) || other.type == type)&&(identical(other.text, text) || other.text == text)&&const DeepCollectionEquality().equals(other._styles, _styles)&&(identical(other.href, href) || other.href == href)&&(identical(other.mentionId, mentionId) || other.mentionId == mentionId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,type,text,const DeepCollectionEquality().hash(_styles),href,mentionId);

@override
String toString() {
  return 'BlockNoteInlineContent(type: $type, text: $text, styles: $styles, href: $href, mentionId: $mentionId)';
}


}

/// @nodoc
abstract mixin class _$BlockNoteInlineContentCopyWith<$Res> implements $BlockNoteInlineContentCopyWith<$Res> {
  factory _$BlockNoteInlineContentCopyWith(_BlockNoteInlineContent value, $Res Function(_BlockNoteInlineContent) _then) = __$BlockNoteInlineContentCopyWithImpl;
@override @useResult
$Res call({
 BlockNoteInlineContentType type, String text, Map<String, dynamic>? styles, String? href, String? mentionId
});




}
/// @nodoc
class __$BlockNoteInlineContentCopyWithImpl<$Res>
    implements _$BlockNoteInlineContentCopyWith<$Res> {
  __$BlockNoteInlineContentCopyWithImpl(this._self, this._then);

  final _BlockNoteInlineContent _self;
  final $Res Function(_BlockNoteInlineContent) _then;

/// Create a copy of BlockNoteInlineContent
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? type = null,Object? text = null,Object? styles = freezed,Object? href = freezed,Object? mentionId = freezed,}) {
  return _then(_BlockNoteInlineContent(
type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as BlockNoteInlineContentType,text: null == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String,styles: freezed == styles ? _self._styles : styles // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,href: freezed == href ? _self.href : href // ignore: cast_nullable_to_non_nullable
as String?,mentionId: freezed == mentionId ? _self.mentionId : mentionId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$BlockNoteBlock {

/// Unique identifier for this block.
 String get id;/// The type of this block.
 BlockNoteBlockType get type;/// Inline content of this block (for text-based blocks).
 List<BlockNoteInlineContent>? get content;/// Block-specific properties (e.g., heading level, list item type).
 Map<String, dynamic>? get props;/// Child blocks (for nested structures like lists).
 List<BlockNoteBlock>? get children;
/// Create a copy of BlockNoteBlock
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BlockNoteBlockCopyWith<BlockNoteBlock> get copyWith => _$BlockNoteBlockCopyWithImpl<BlockNoteBlock>(this as BlockNoteBlock, _$identity);

  /// Serializes this BlockNoteBlock to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BlockNoteBlock&&(identical(other.id, id) || other.id == id)&&(identical(other.type, type) || other.type == type)&&const DeepCollectionEquality().equals(other.content, content)&&const DeepCollectionEquality().equals(other.props, props)&&const DeepCollectionEquality().equals(other.children, children));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,type,const DeepCollectionEquality().hash(content),const DeepCollectionEquality().hash(props),const DeepCollectionEquality().hash(children));

@override
String toString() {
  return 'BlockNoteBlock(id: $id, type: $type, content: $content, props: $props, children: $children)';
}


}

/// @nodoc
abstract mixin class $BlockNoteBlockCopyWith<$Res>  {
  factory $BlockNoteBlockCopyWith(BlockNoteBlock value, $Res Function(BlockNoteBlock) _then) = _$BlockNoteBlockCopyWithImpl;
@useResult
$Res call({
 String id, BlockNoteBlockType type, List<BlockNoteInlineContent>? content, Map<String, dynamic>? props, List<BlockNoteBlock>? children
});




}
/// @nodoc
class _$BlockNoteBlockCopyWithImpl<$Res>
    implements $BlockNoteBlockCopyWith<$Res> {
  _$BlockNoteBlockCopyWithImpl(this._self, this._then);

  final BlockNoteBlock _self;
  final $Res Function(BlockNoteBlock) _then;

/// Create a copy of BlockNoteBlock
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? type = null,Object? content = freezed,Object? props = freezed,Object? children = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as BlockNoteBlockType,content: freezed == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as List<BlockNoteInlineContent>?,props: freezed == props ? _self.props : props // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,children: freezed == children ? _self.children : children // ignore: cast_nullable_to_non_nullable
as List<BlockNoteBlock>?,
  ));
}

}



/// @nodoc
@JsonSerializable()

class _BlockNoteBlock implements BlockNoteBlock {
  const _BlockNoteBlock({required this.id, required this.type, final  List<BlockNoteInlineContent>? content, final  Map<String, dynamic>? props, final  List<BlockNoteBlock>? children}): _content = content,_props = props,_children = children;
  factory _BlockNoteBlock.fromJson(Map<String, dynamic> json) => _$BlockNoteBlockFromJson(json);

/// Unique identifier for this block.
@override final  String id;
/// The type of this block.
@override final  BlockNoteBlockType type;
/// Inline content of this block (for text-based blocks).
 final  List<BlockNoteInlineContent>? _content;
/// Inline content of this block (for text-based blocks).
@override List<BlockNoteInlineContent>? get content {
  final value = _content;
  if (value == null) return null;
  if (_content is EqualUnmodifiableListView) return _content;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

/// Block-specific properties (e.g., heading level, list item type).
 final  Map<String, dynamic>? _props;
/// Block-specific properties (e.g., heading level, list item type).
@override Map<String, dynamic>? get props {
  final value = _props;
  if (value == null) return null;
  if (_props is EqualUnmodifiableMapView) return _props;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(value);
}

/// Child blocks (for nested structures like lists).
 final  List<BlockNoteBlock>? _children;
/// Child blocks (for nested structures like lists).
@override List<BlockNoteBlock>? get children {
  final value = _children;
  if (value == null) return null;
  if (_children is EqualUnmodifiableListView) return _children;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}


/// Create a copy of BlockNoteBlock
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BlockNoteBlockCopyWith<_BlockNoteBlock> get copyWith => __$BlockNoteBlockCopyWithImpl<_BlockNoteBlock>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$BlockNoteBlockToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _BlockNoteBlock&&(identical(other.id, id) || other.id == id)&&(identical(other.type, type) || other.type == type)&&const DeepCollectionEquality().equals(other._content, _content)&&const DeepCollectionEquality().equals(other._props, _props)&&const DeepCollectionEquality().equals(other._children, _children));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,type,const DeepCollectionEquality().hash(_content),const DeepCollectionEquality().hash(_props),const DeepCollectionEquality().hash(_children));

@override
String toString() {
  return 'BlockNoteBlock(id: $id, type: $type, content: $content, props: $props, children: $children)';
}


}

/// @nodoc
abstract mixin class _$BlockNoteBlockCopyWith<$Res> implements $BlockNoteBlockCopyWith<$Res> {
  factory _$BlockNoteBlockCopyWith(_BlockNoteBlock value, $Res Function(_BlockNoteBlock) _then) = __$BlockNoteBlockCopyWithImpl;
@override @useResult
$Res call({
 String id, BlockNoteBlockType type, List<BlockNoteInlineContent>? content, Map<String, dynamic>? props, List<BlockNoteBlock>? children
});




}
/// @nodoc
class __$BlockNoteBlockCopyWithImpl<$Res>
    implements _$BlockNoteBlockCopyWith<$Res> {
  __$BlockNoteBlockCopyWithImpl(this._self, this._then);

  final _BlockNoteBlock _self;
  final $Res Function(_BlockNoteBlock) _then;

/// Create a copy of BlockNoteBlock
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? type = null,Object? content = freezed,Object? props = freezed,Object? children = freezed,}) {
  return _then(_BlockNoteBlock(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as BlockNoteBlockType,content: freezed == content ? _self._content : content // ignore: cast_nullable_to_non_nullable
as List<BlockNoteInlineContent>?,props: freezed == props ? _self._props : props // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,children: freezed == children ? _self._children : children // ignore: cast_nullable_to_non_nullable
as List<BlockNoteBlock>?,
  ));
}


}

// dart format on
