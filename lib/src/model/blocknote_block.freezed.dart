// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'blocknote_block.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

BlockNoteInlineContent _$BlockNoteInlineContentFromJson(
  Map<String, dynamic> json,
) {
  return _BlockNoteInlineContent.fromJson(json);
}

/// @nodoc
mixin _$BlockNoteInlineContent {
  /// The type of inline content.
  BlockNoteInlineContentType get type => throw _privateConstructorUsedError;

  /// The text content.
  String get text => throw _privateConstructorUsedError;

  /// Optional text styles (bold, italic, underline, textColor, backgroundColor, etc.).
  /// Can contain boolean values (bold, italic, underline, strike) and string values (textColor, backgroundColor).
  Map<String, dynamic>? get styles => throw _privateConstructorUsedError;

  /// Optional href for link content.
  String? get href => throw _privateConstructorUsedError;

  /// Optional mention ID for mention content.
  String? get mentionId => throw _privateConstructorUsedError;

  /// Serializes this BlockNoteInlineContent to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of BlockNoteInlineContent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $BlockNoteInlineContentCopyWith<BlockNoteInlineContent> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BlockNoteInlineContentCopyWith<$Res> {
  factory $BlockNoteInlineContentCopyWith(
    BlockNoteInlineContent value,
    $Res Function(BlockNoteInlineContent) then,
  ) = _$BlockNoteInlineContentCopyWithImpl<$Res, BlockNoteInlineContent>;
  @useResult
  $Res call({
    BlockNoteInlineContentType type,
    String text,
    Map<String, dynamic>? styles,
    String? href,
    String? mentionId,
  });
}

/// @nodoc
class _$BlockNoteInlineContentCopyWithImpl<
  $Res,
  $Val extends BlockNoteInlineContent
>
    implements $BlockNoteInlineContentCopyWith<$Res> {
  _$BlockNoteInlineContentCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of BlockNoteInlineContent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? type = null,
    Object? text = null,
    Object? styles = freezed,
    Object? href = freezed,
    Object? mentionId = freezed,
  }) {
    return _then(
      _value.copyWith(
            type: null == type
                ? _value.type
                : type // ignore: cast_nullable_to_non_nullable
                      as BlockNoteInlineContentType,
            text: null == text
                ? _value.text
                : text // ignore: cast_nullable_to_non_nullable
                      as String,
            styles: freezed == styles
                ? _value.styles
                : styles // ignore: cast_nullable_to_non_nullable
                      as Map<String, dynamic>?,
            href: freezed == href
                ? _value.href
                : href // ignore: cast_nullable_to_non_nullable
                      as String?,
            mentionId: freezed == mentionId
                ? _value.mentionId
                : mentionId // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$BlockNoteInlineContentImplCopyWith<$Res>
    implements $BlockNoteInlineContentCopyWith<$Res> {
  factory _$$BlockNoteInlineContentImplCopyWith(
    _$BlockNoteInlineContentImpl value,
    $Res Function(_$BlockNoteInlineContentImpl) then,
  ) = __$$BlockNoteInlineContentImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    BlockNoteInlineContentType type,
    String text,
    Map<String, dynamic>? styles,
    String? href,
    String? mentionId,
  });
}

/// @nodoc
class __$$BlockNoteInlineContentImplCopyWithImpl<$Res>
    extends
        _$BlockNoteInlineContentCopyWithImpl<$Res, _$BlockNoteInlineContentImpl>
    implements _$$BlockNoteInlineContentImplCopyWith<$Res> {
  __$$BlockNoteInlineContentImplCopyWithImpl(
    _$BlockNoteInlineContentImpl _value,
    $Res Function(_$BlockNoteInlineContentImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of BlockNoteInlineContent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? type = null,
    Object? text = null,
    Object? styles = freezed,
    Object? href = freezed,
    Object? mentionId = freezed,
  }) {
    return _then(
      _$BlockNoteInlineContentImpl(
        type: null == type
            ? _value.type
            : type // ignore: cast_nullable_to_non_nullable
                  as BlockNoteInlineContentType,
        text: null == text
            ? _value.text
            : text // ignore: cast_nullable_to_non_nullable
                  as String,
        styles: freezed == styles
            ? _value._styles
            : styles // ignore: cast_nullable_to_non_nullable
                  as Map<String, dynamic>?,
        href: freezed == href
            ? _value.href
            : href // ignore: cast_nullable_to_non_nullable
                  as String?,
        mentionId: freezed == mentionId
            ? _value.mentionId
            : mentionId // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$BlockNoteInlineContentImpl implements _BlockNoteInlineContent {
  const _$BlockNoteInlineContentImpl({
    required this.type,
    required this.text,
    final Map<String, dynamic>? styles,
    this.href,
    this.mentionId,
  }) : _styles = styles;

  factory _$BlockNoteInlineContentImpl.fromJson(Map<String, dynamic> json) =>
      _$$BlockNoteInlineContentImplFromJson(json);

  /// The type of inline content.
  @override
  final BlockNoteInlineContentType type;

  /// The text content.
  @override
  final String text;

  /// Optional text styles (bold, italic, underline, textColor, backgroundColor, etc.).
  /// Can contain boolean values (bold, italic, underline, strike) and string values (textColor, backgroundColor).
  final Map<String, dynamic>? _styles;

  /// Optional text styles (bold, italic, underline, textColor, backgroundColor, etc.).
  /// Can contain boolean values (bold, italic, underline, strike) and string values (textColor, backgroundColor).
  @override
  Map<String, dynamic>? get styles {
    final value = _styles;
    if (value == null) return null;
    if (_styles is EqualUnmodifiableMapView) return _styles;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  /// Optional href for link content.
  @override
  final String? href;

  /// Optional mention ID for mention content.
  @override
  final String? mentionId;

  @override
  String toString() {
    return 'BlockNoteInlineContent(type: $type, text: $text, styles: $styles, href: $href, mentionId: $mentionId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BlockNoteInlineContentImpl &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.text, text) || other.text == text) &&
            const DeepCollectionEquality().equals(other._styles, _styles) &&
            (identical(other.href, href) || other.href == href) &&
            (identical(other.mentionId, mentionId) ||
                other.mentionId == mentionId));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    type,
    text,
    const DeepCollectionEquality().hash(_styles),
    href,
    mentionId,
  );

  /// Create a copy of BlockNoteInlineContent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$BlockNoteInlineContentImplCopyWith<_$BlockNoteInlineContentImpl>
  get copyWith =>
      __$$BlockNoteInlineContentImplCopyWithImpl<_$BlockNoteInlineContentImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$BlockNoteInlineContentImplToJson(this);
  }
}

abstract class _BlockNoteInlineContent implements BlockNoteInlineContent {
  const factory _BlockNoteInlineContent({
    required final BlockNoteInlineContentType type,
    required final String text,
    final Map<String, dynamic>? styles,
    final String? href,
    final String? mentionId,
  }) = _$BlockNoteInlineContentImpl;

  factory _BlockNoteInlineContent.fromJson(Map<String, dynamic> json) =
      _$BlockNoteInlineContentImpl.fromJson;

  /// The type of inline content.
  @override
  BlockNoteInlineContentType get type;

  /// The text content.
  @override
  String get text;

  /// Optional text styles (bold, italic, underline, textColor, backgroundColor, etc.).
  /// Can contain boolean values (bold, italic, underline, strike) and string values (textColor, backgroundColor).
  @override
  Map<String, dynamic>? get styles;

  /// Optional href for link content.
  @override
  String? get href;

  /// Optional mention ID for mention content.
  @override
  String? get mentionId;

  /// Create a copy of BlockNoteInlineContent
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$BlockNoteInlineContentImplCopyWith<_$BlockNoteInlineContentImpl>
  get copyWith => throw _privateConstructorUsedError;
}

BlockNoteBlock _$BlockNoteBlockFromJson(Map<String, dynamic> json) {
  return _BlockNoteBlock.fromJson(json);
}

/// @nodoc
mixin _$BlockNoteBlock {
  /// Unique identifier for this block.
  String get id => throw _privateConstructorUsedError;

  /// The type of this block.
  BlockNoteBlockType get type => throw _privateConstructorUsedError;

  /// Inline content of this block (for text-based blocks).
  List<BlockNoteInlineContent>? get content =>
      throw _privateConstructorUsedError;

  /// Block-specific properties (e.g., heading level, list item type).
  Map<String, dynamic>? get props => throw _privateConstructorUsedError;

  /// Child blocks (for nested structures like lists).
  List<BlockNoteBlock>? get children => throw _privateConstructorUsedError;

  /// Serializes this BlockNoteBlock to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of BlockNoteBlock
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $BlockNoteBlockCopyWith<BlockNoteBlock> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BlockNoteBlockCopyWith<$Res> {
  factory $BlockNoteBlockCopyWith(
    BlockNoteBlock value,
    $Res Function(BlockNoteBlock) then,
  ) = _$BlockNoteBlockCopyWithImpl<$Res, BlockNoteBlock>;
  @useResult
  $Res call({
    String id,
    BlockNoteBlockType type,
    List<BlockNoteInlineContent>? content,
    Map<String, dynamic>? props,
    List<BlockNoteBlock>? children,
  });
}

/// @nodoc
class _$BlockNoteBlockCopyWithImpl<$Res, $Val extends BlockNoteBlock>
    implements $BlockNoteBlockCopyWith<$Res> {
  _$BlockNoteBlockCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of BlockNoteBlock
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? type = null,
    Object? content = freezed,
    Object? props = freezed,
    Object? children = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            type: null == type
                ? _value.type
                : type // ignore: cast_nullable_to_non_nullable
                      as BlockNoteBlockType,
            content: freezed == content
                ? _value.content
                : content // ignore: cast_nullable_to_non_nullable
                      as List<BlockNoteInlineContent>?,
            props: freezed == props
                ? _value.props
                : props // ignore: cast_nullable_to_non_nullable
                      as Map<String, dynamic>?,
            children: freezed == children
                ? _value.children
                : children // ignore: cast_nullable_to_non_nullable
                      as List<BlockNoteBlock>?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$BlockNoteBlockImplCopyWith<$Res>
    implements $BlockNoteBlockCopyWith<$Res> {
  factory _$$BlockNoteBlockImplCopyWith(
    _$BlockNoteBlockImpl value,
    $Res Function(_$BlockNoteBlockImpl) then,
  ) = __$$BlockNoteBlockImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    BlockNoteBlockType type,
    List<BlockNoteInlineContent>? content,
    Map<String, dynamic>? props,
    List<BlockNoteBlock>? children,
  });
}

/// @nodoc
class __$$BlockNoteBlockImplCopyWithImpl<$Res>
    extends _$BlockNoteBlockCopyWithImpl<$Res, _$BlockNoteBlockImpl>
    implements _$$BlockNoteBlockImplCopyWith<$Res> {
  __$$BlockNoteBlockImplCopyWithImpl(
    _$BlockNoteBlockImpl _value,
    $Res Function(_$BlockNoteBlockImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of BlockNoteBlock
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? type = null,
    Object? content = freezed,
    Object? props = freezed,
    Object? children = freezed,
  }) {
    return _then(
      _$BlockNoteBlockImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        type: null == type
            ? _value.type
            : type // ignore: cast_nullable_to_non_nullable
                  as BlockNoteBlockType,
        content: freezed == content
            ? _value._content
            : content // ignore: cast_nullable_to_non_nullable
                  as List<BlockNoteInlineContent>?,
        props: freezed == props
            ? _value._props
            : props // ignore: cast_nullable_to_non_nullable
                  as Map<String, dynamic>?,
        children: freezed == children
            ? _value._children
            : children // ignore: cast_nullable_to_non_nullable
                  as List<BlockNoteBlock>?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$BlockNoteBlockImpl implements _BlockNoteBlock {
  const _$BlockNoteBlockImpl({
    required this.id,
    required this.type,
    final List<BlockNoteInlineContent>? content,
    final Map<String, dynamic>? props,
    final List<BlockNoteBlock>? children,
  }) : _content = content,
       _props = props,
       _children = children;

  factory _$BlockNoteBlockImpl.fromJson(Map<String, dynamic> json) =>
      _$$BlockNoteBlockImplFromJson(json);

  /// Unique identifier for this block.
  @override
  final String id;

  /// The type of this block.
  @override
  final BlockNoteBlockType type;

  /// Inline content of this block (for text-based blocks).
  final List<BlockNoteInlineContent>? _content;

  /// Inline content of this block (for text-based blocks).
  @override
  List<BlockNoteInlineContent>? get content {
    final value = _content;
    if (value == null) return null;
    if (_content is EqualUnmodifiableListView) return _content;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  /// Block-specific properties (e.g., heading level, list item type).
  final Map<String, dynamic>? _props;

  /// Block-specific properties (e.g., heading level, list item type).
  @override
  Map<String, dynamic>? get props {
    final value = _props;
    if (value == null) return null;
    if (_props is EqualUnmodifiableMapView) return _props;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  /// Child blocks (for nested structures like lists).
  final List<BlockNoteBlock>? _children;

  /// Child blocks (for nested structures like lists).
  @override
  List<BlockNoteBlock>? get children {
    final value = _children;
    if (value == null) return null;
    if (_children is EqualUnmodifiableListView) return _children;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  String toString() {
    return 'BlockNoteBlock(id: $id, type: $type, content: $content, props: $props, children: $children)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BlockNoteBlockImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.type, type) || other.type == type) &&
            const DeepCollectionEquality().equals(other._content, _content) &&
            const DeepCollectionEquality().equals(other._props, _props) &&
            const DeepCollectionEquality().equals(other._children, _children));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    type,
    const DeepCollectionEquality().hash(_content),
    const DeepCollectionEquality().hash(_props),
    const DeepCollectionEquality().hash(_children),
  );

  /// Create a copy of BlockNoteBlock
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$BlockNoteBlockImplCopyWith<_$BlockNoteBlockImpl> get copyWith =>
      __$$BlockNoteBlockImplCopyWithImpl<_$BlockNoteBlockImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$BlockNoteBlockImplToJson(this);
  }
}

abstract class _BlockNoteBlock implements BlockNoteBlock {
  const factory _BlockNoteBlock({
    required final String id,
    required final BlockNoteBlockType type,
    final List<BlockNoteInlineContent>? content,
    final Map<String, dynamic>? props,
    final List<BlockNoteBlock>? children,
  }) = _$BlockNoteBlockImpl;

  factory _BlockNoteBlock.fromJson(Map<String, dynamic> json) =
      _$BlockNoteBlockImpl.fromJson;

  /// Unique identifier for this block.
  @override
  String get id;

  /// The type of this block.
  @override
  BlockNoteBlockType get type;

  /// Inline content of this block (for text-based blocks).
  @override
  List<BlockNoteInlineContent>? get content;

  /// Block-specific properties (e.g., heading level, list item type).
  @override
  Map<String, dynamic>? get props;

  /// Child blocks (for nested structures like lists).
  @override
  List<BlockNoteBlock>? get children;

  /// Create a copy of BlockNoteBlock
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$BlockNoteBlockImplCopyWith<_$BlockNoteBlockImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
