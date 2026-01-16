// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'blocknote_document.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

BlockNoteDocumentVersion _$BlockNoteDocumentVersionFromJson(
  Map<String, dynamic> json,
) {
  return _BlockNoteDocumentVersion.fromJson(json);
}

/// @nodoc
mixin _$BlockNoteDocumentVersion {
  int get major => throw _privateConstructorUsedError;
  int get minor => throw _privateConstructorUsedError;
  int get patch => throw _privateConstructorUsedError;

  /// Serializes this BlockNoteDocumentVersion to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of BlockNoteDocumentVersion
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $BlockNoteDocumentVersionCopyWith<BlockNoteDocumentVersion> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BlockNoteDocumentVersionCopyWith<$Res> {
  factory $BlockNoteDocumentVersionCopyWith(
    BlockNoteDocumentVersion value,
    $Res Function(BlockNoteDocumentVersion) then,
  ) = _$BlockNoteDocumentVersionCopyWithImpl<$Res, BlockNoteDocumentVersion>;
  @useResult
  $Res call({int major, int minor, int patch});
}

/// @nodoc
class _$BlockNoteDocumentVersionCopyWithImpl<
  $Res,
  $Val extends BlockNoteDocumentVersion
>
    implements $BlockNoteDocumentVersionCopyWith<$Res> {
  _$BlockNoteDocumentVersionCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of BlockNoteDocumentVersion
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? major = null,
    Object? minor = null,
    Object? patch = null,
  }) {
    return _then(
      _value.copyWith(
            major: null == major
                ? _value.major
                : major // ignore: cast_nullable_to_non_nullable
                      as int,
            minor: null == minor
                ? _value.minor
                : minor // ignore: cast_nullable_to_non_nullable
                      as int,
            patch: null == patch
                ? _value.patch
                : patch // ignore: cast_nullable_to_non_nullable
                      as int,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$BlockNoteDocumentVersionImplCopyWith<$Res>
    implements $BlockNoteDocumentVersionCopyWith<$Res> {
  factory _$$BlockNoteDocumentVersionImplCopyWith(
    _$BlockNoteDocumentVersionImpl value,
    $Res Function(_$BlockNoteDocumentVersionImpl) then,
  ) = __$$BlockNoteDocumentVersionImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int major, int minor, int patch});
}

/// @nodoc
class __$$BlockNoteDocumentVersionImplCopyWithImpl<$Res>
    extends
        _$BlockNoteDocumentVersionCopyWithImpl<
          $Res,
          _$BlockNoteDocumentVersionImpl
        >
    implements _$$BlockNoteDocumentVersionImplCopyWith<$Res> {
  __$$BlockNoteDocumentVersionImplCopyWithImpl(
    _$BlockNoteDocumentVersionImpl _value,
    $Res Function(_$BlockNoteDocumentVersionImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of BlockNoteDocumentVersion
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? major = null,
    Object? minor = null,
    Object? patch = null,
  }) {
    return _then(
      _$BlockNoteDocumentVersionImpl(
        major: null == major
            ? _value.major
            : major // ignore: cast_nullable_to_non_nullable
                  as int,
        minor: null == minor
            ? _value.minor
            : minor // ignore: cast_nullable_to_non_nullable
                  as int,
        patch: null == patch
            ? _value.patch
            : patch // ignore: cast_nullable_to_non_nullable
                  as int,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$BlockNoteDocumentVersionImpl implements _BlockNoteDocumentVersion {
  const _$BlockNoteDocumentVersionImpl({
    this.major = 1,
    this.minor = 0,
    this.patch = 0,
  });

  factory _$BlockNoteDocumentVersionImpl.fromJson(Map<String, dynamic> json) =>
      _$$BlockNoteDocumentVersionImplFromJson(json);

  @override
  @JsonKey()
  final int major;
  @override
  @JsonKey()
  final int minor;
  @override
  @JsonKey()
  final int patch;

  @override
  String toString() {
    return 'BlockNoteDocumentVersion(major: $major, minor: $minor, patch: $patch)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BlockNoteDocumentVersionImpl &&
            (identical(other.major, major) || other.major == major) &&
            (identical(other.minor, minor) || other.minor == minor) &&
            (identical(other.patch, patch) || other.patch == patch));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, major, minor, patch);

  /// Create a copy of BlockNoteDocumentVersion
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$BlockNoteDocumentVersionImplCopyWith<_$BlockNoteDocumentVersionImpl>
  get copyWith =>
      __$$BlockNoteDocumentVersionImplCopyWithImpl<
        _$BlockNoteDocumentVersionImpl
      >(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$BlockNoteDocumentVersionImplToJson(this);
  }
}

abstract class _BlockNoteDocumentVersion implements BlockNoteDocumentVersion {
  const factory _BlockNoteDocumentVersion({
    final int major,
    final int minor,
    final int patch,
  }) = _$BlockNoteDocumentVersionImpl;

  factory _BlockNoteDocumentVersion.fromJson(Map<String, dynamic> json) =
      _$BlockNoteDocumentVersionImpl.fromJson;

  @override
  int get major;
  @override
  int get minor;
  @override
  int get patch;

  /// Create a copy of BlockNoteDocumentVersion
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$BlockNoteDocumentVersionImplCopyWith<_$BlockNoteDocumentVersionImpl>
  get copyWith => throw _privateConstructorUsedError;
}

BlockNoteDocument _$BlockNoteDocumentFromJson(Map<String, dynamic> json) {
  return _BlockNoteDocument.fromJson(json);
}

/// @nodoc
mixin _$BlockNoteDocument {
  /// The blocks that make up this document.
  List<BlockNoteBlock> get blocks => throw _privateConstructorUsedError;

  /// Optional schema version for future compatibility.
  BlockNoteDocumentVersion? get version => throw _privateConstructorUsedError;

  /// Serializes this BlockNoteDocument to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of BlockNoteDocument
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $BlockNoteDocumentCopyWith<BlockNoteDocument> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BlockNoteDocumentCopyWith<$Res> {
  factory $BlockNoteDocumentCopyWith(
    BlockNoteDocument value,
    $Res Function(BlockNoteDocument) then,
  ) = _$BlockNoteDocumentCopyWithImpl<$Res, BlockNoteDocument>;
  @useResult
  $Res call({List<BlockNoteBlock> blocks, BlockNoteDocumentVersion? version});

  $BlockNoteDocumentVersionCopyWith<$Res>? get version;
}

/// @nodoc
class _$BlockNoteDocumentCopyWithImpl<$Res, $Val extends BlockNoteDocument>
    implements $BlockNoteDocumentCopyWith<$Res> {
  _$BlockNoteDocumentCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of BlockNoteDocument
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? blocks = null, Object? version = freezed}) {
    return _then(
      _value.copyWith(
            blocks: null == blocks
                ? _value.blocks
                : blocks // ignore: cast_nullable_to_non_nullable
                      as List<BlockNoteBlock>,
            version: freezed == version
                ? _value.version
                : version // ignore: cast_nullable_to_non_nullable
                      as BlockNoteDocumentVersion?,
          )
          as $Val,
    );
  }

  /// Create a copy of BlockNoteDocument
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $BlockNoteDocumentVersionCopyWith<$Res>? get version {
    if (_value.version == null) {
      return null;
    }

    return $BlockNoteDocumentVersionCopyWith<$Res>(_value.version!, (value) {
      return _then(_value.copyWith(version: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$BlockNoteDocumentImplCopyWith<$Res>
    implements $BlockNoteDocumentCopyWith<$Res> {
  factory _$$BlockNoteDocumentImplCopyWith(
    _$BlockNoteDocumentImpl value,
    $Res Function(_$BlockNoteDocumentImpl) then,
  ) = __$$BlockNoteDocumentImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({List<BlockNoteBlock> blocks, BlockNoteDocumentVersion? version});

  @override
  $BlockNoteDocumentVersionCopyWith<$Res>? get version;
}

/// @nodoc
class __$$BlockNoteDocumentImplCopyWithImpl<$Res>
    extends _$BlockNoteDocumentCopyWithImpl<$Res, _$BlockNoteDocumentImpl>
    implements _$$BlockNoteDocumentImplCopyWith<$Res> {
  __$$BlockNoteDocumentImplCopyWithImpl(
    _$BlockNoteDocumentImpl _value,
    $Res Function(_$BlockNoteDocumentImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of BlockNoteDocument
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? blocks = null, Object? version = freezed}) {
    return _then(
      _$BlockNoteDocumentImpl(
        blocks: null == blocks
            ? _value._blocks
            : blocks // ignore: cast_nullable_to_non_nullable
                  as List<BlockNoteBlock>,
        version: freezed == version
            ? _value.version
            : version // ignore: cast_nullable_to_non_nullable
                  as BlockNoteDocumentVersion?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$BlockNoteDocumentImpl implements _BlockNoteDocument {
  const _$BlockNoteDocumentImpl({
    required final List<BlockNoteBlock> blocks,
    this.version,
  }) : _blocks = blocks;

  factory _$BlockNoteDocumentImpl.fromJson(Map<String, dynamic> json) =>
      _$$BlockNoteDocumentImplFromJson(json);

  /// The blocks that make up this document.
  final List<BlockNoteBlock> _blocks;

  /// The blocks that make up this document.
  @override
  List<BlockNoteBlock> get blocks {
    if (_blocks is EqualUnmodifiableListView) return _blocks;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_blocks);
  }

  /// Optional schema version for future compatibility.
  @override
  final BlockNoteDocumentVersion? version;

  @override
  String toString() {
    return 'BlockNoteDocument(blocks: $blocks, version: $version)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BlockNoteDocumentImpl &&
            const DeepCollectionEquality().equals(other._blocks, _blocks) &&
            (identical(other.version, version) || other.version == version));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    const DeepCollectionEquality().hash(_blocks),
    version,
  );

  /// Create a copy of BlockNoteDocument
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$BlockNoteDocumentImplCopyWith<_$BlockNoteDocumentImpl> get copyWith =>
      __$$BlockNoteDocumentImplCopyWithImpl<_$BlockNoteDocumentImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$BlockNoteDocumentImplToJson(this);
  }
}

abstract class _BlockNoteDocument implements BlockNoteDocument {
  const factory _BlockNoteDocument({
    required final List<BlockNoteBlock> blocks,
    final BlockNoteDocumentVersion? version,
  }) = _$BlockNoteDocumentImpl;

  factory _BlockNoteDocument.fromJson(Map<String, dynamic> json) =
      _$BlockNoteDocumentImpl.fromJson;

  /// The blocks that make up this document.
  @override
  List<BlockNoteBlock> get blocks;

  /// Optional schema version for future compatibility.
  @override
  BlockNoteDocumentVersion? get version;

  /// Create a copy of BlockNoteDocument
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$BlockNoteDocumentImplCopyWith<_$BlockNoteDocumentImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
