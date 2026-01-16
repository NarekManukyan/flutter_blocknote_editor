// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'blocknote_document.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$BlockNoteDocumentVersion {

 int get major; int get minor; int get patch;
/// Create a copy of BlockNoteDocumentVersion
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BlockNoteDocumentVersionCopyWith<BlockNoteDocumentVersion> get copyWith => _$BlockNoteDocumentVersionCopyWithImpl<BlockNoteDocumentVersion>(this as BlockNoteDocumentVersion, _$identity);

  /// Serializes this BlockNoteDocumentVersion to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BlockNoteDocumentVersion&&(identical(other.major, major) || other.major == major)&&(identical(other.minor, minor) || other.minor == minor)&&(identical(other.patch, patch) || other.patch == patch));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,major,minor,patch);

@override
String toString() {
  return 'BlockNoteDocumentVersion(major: $major, minor: $minor, patch: $patch)';
}


}

/// @nodoc
abstract mixin class $BlockNoteDocumentVersionCopyWith<$Res>  {
  factory $BlockNoteDocumentVersionCopyWith(BlockNoteDocumentVersion value, $Res Function(BlockNoteDocumentVersion) _then) = _$BlockNoteDocumentVersionCopyWithImpl;
@useResult
$Res call({
 int major, int minor, int patch
});




}
/// @nodoc
class _$BlockNoteDocumentVersionCopyWithImpl<$Res>
    implements $BlockNoteDocumentVersionCopyWith<$Res> {
  _$BlockNoteDocumentVersionCopyWithImpl(this._self, this._then);

  final BlockNoteDocumentVersion _self;
  final $Res Function(BlockNoteDocumentVersion) _then;

/// Create a copy of BlockNoteDocumentVersion
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? major = null,Object? minor = null,Object? patch = null,}) {
  return _then(_self.copyWith(
major: null == major ? _self.major : major // ignore: cast_nullable_to_non_nullable
as int,minor: null == minor ? _self.minor : minor // ignore: cast_nullable_to_non_nullable
as int,patch: null == patch ? _self.patch : patch // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}



/// @nodoc
@JsonSerializable()

class _BlockNoteDocumentVersion implements BlockNoteDocumentVersion {
  const _BlockNoteDocumentVersion({this.major = 1, this.minor = 0, this.patch = 0});
  factory _BlockNoteDocumentVersion.fromJson(Map<String, dynamic> json) => _$BlockNoteDocumentVersionFromJson(json);

@override@JsonKey() final  int major;
@override@JsonKey() final  int minor;
@override@JsonKey() final  int patch;

/// Create a copy of BlockNoteDocumentVersion
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BlockNoteDocumentVersionCopyWith<_BlockNoteDocumentVersion> get copyWith => __$BlockNoteDocumentVersionCopyWithImpl<_BlockNoteDocumentVersion>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$BlockNoteDocumentVersionToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _BlockNoteDocumentVersion&&(identical(other.major, major) || other.major == major)&&(identical(other.minor, minor) || other.minor == minor)&&(identical(other.patch, patch) || other.patch == patch));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,major,minor,patch);

@override
String toString() {
  return 'BlockNoteDocumentVersion(major: $major, minor: $minor, patch: $patch)';
}


}

/// @nodoc
abstract mixin class _$BlockNoteDocumentVersionCopyWith<$Res> implements $BlockNoteDocumentVersionCopyWith<$Res> {
  factory _$BlockNoteDocumentVersionCopyWith(_BlockNoteDocumentVersion value, $Res Function(_BlockNoteDocumentVersion) _then) = __$BlockNoteDocumentVersionCopyWithImpl;
@override @useResult
$Res call({
 int major, int minor, int patch
});




}
/// @nodoc
class __$BlockNoteDocumentVersionCopyWithImpl<$Res>
    implements _$BlockNoteDocumentVersionCopyWith<$Res> {
  __$BlockNoteDocumentVersionCopyWithImpl(this._self, this._then);

  final _BlockNoteDocumentVersion _self;
  final $Res Function(_BlockNoteDocumentVersion) _then;

/// Create a copy of BlockNoteDocumentVersion
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? major = null,Object? minor = null,Object? patch = null,}) {
  return _then(_BlockNoteDocumentVersion(
major: null == major ? _self.major : major // ignore: cast_nullable_to_non_nullable
as int,minor: null == minor ? _self.minor : minor // ignore: cast_nullable_to_non_nullable
as int,patch: null == patch ? _self.patch : patch // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$BlockNoteDocument {

/// The blocks that make up this document.
 List<BlockNoteBlock> get blocks;/// Optional schema version for future compatibility.
 BlockNoteDocumentVersion? get version;
/// Create a copy of BlockNoteDocument
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BlockNoteDocumentCopyWith<BlockNoteDocument> get copyWith => _$BlockNoteDocumentCopyWithImpl<BlockNoteDocument>(this as BlockNoteDocument, _$identity);

  /// Serializes this BlockNoteDocument to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BlockNoteDocument&&const DeepCollectionEquality().equals(other.blocks, blocks)&&(identical(other.version, version) || other.version == version));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(blocks),version);

@override
String toString() {
  return 'BlockNoteDocument(blocks: $blocks, version: $version)';
}


}

/// @nodoc
abstract mixin class $BlockNoteDocumentCopyWith<$Res>  {
  factory $BlockNoteDocumentCopyWith(BlockNoteDocument value, $Res Function(BlockNoteDocument) _then) = _$BlockNoteDocumentCopyWithImpl;
@useResult
$Res call({
 List<BlockNoteBlock> blocks, BlockNoteDocumentVersion? version
});


$BlockNoteDocumentVersionCopyWith<$Res>? get version;

}
/// @nodoc
class _$BlockNoteDocumentCopyWithImpl<$Res>
    implements $BlockNoteDocumentCopyWith<$Res> {
  _$BlockNoteDocumentCopyWithImpl(this._self, this._then);

  final BlockNoteDocument _self;
  final $Res Function(BlockNoteDocument) _then;

/// Create a copy of BlockNoteDocument
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? blocks = null,Object? version = freezed,}) {
  return _then(_self.copyWith(
blocks: null == blocks ? _self.blocks : blocks // ignore: cast_nullable_to_non_nullable
as List<BlockNoteBlock>,version: freezed == version ? _self.version : version // ignore: cast_nullable_to_non_nullable
as BlockNoteDocumentVersion?,
  ));
}
/// Create a copy of BlockNoteDocument
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$BlockNoteDocumentVersionCopyWith<$Res>? get version {
    if (_self.version == null) {
    return null;
  }

  return $BlockNoteDocumentVersionCopyWith<$Res>(_self.version!, (value) {
    return _then(_self.copyWith(version: value));
  });
}
}



/// @nodoc
@JsonSerializable()

class _BlockNoteDocument implements BlockNoteDocument {
  const _BlockNoteDocument({required final  List<BlockNoteBlock> blocks, this.version}): _blocks = blocks;
  factory _BlockNoteDocument.fromJson(Map<String, dynamic> json) => _$BlockNoteDocumentFromJson(json);

/// The blocks that make up this document.
 final  List<BlockNoteBlock> _blocks;
/// The blocks that make up this document.
@override List<BlockNoteBlock> get blocks {
  if (_blocks is EqualUnmodifiableListView) return _blocks;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_blocks);
}

/// Optional schema version for future compatibility.
@override final  BlockNoteDocumentVersion? version;

/// Create a copy of BlockNoteDocument
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BlockNoteDocumentCopyWith<_BlockNoteDocument> get copyWith => __$BlockNoteDocumentCopyWithImpl<_BlockNoteDocument>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$BlockNoteDocumentToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _BlockNoteDocument&&const DeepCollectionEquality().equals(other._blocks, _blocks)&&(identical(other.version, version) || other.version == version));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_blocks),version);

@override
String toString() {
  return 'BlockNoteDocument(blocks: $blocks, version: $version)';
}


}

/// @nodoc
abstract mixin class _$BlockNoteDocumentCopyWith<$Res> implements $BlockNoteDocumentCopyWith<$Res> {
  factory _$BlockNoteDocumentCopyWith(_BlockNoteDocument value, $Res Function(_BlockNoteDocument) _then) = __$BlockNoteDocumentCopyWithImpl;
@override @useResult
$Res call({
 List<BlockNoteBlock> blocks, BlockNoteDocumentVersion? version
});


@override $BlockNoteDocumentVersionCopyWith<$Res>? get version;

}
/// @nodoc
class __$BlockNoteDocumentCopyWithImpl<$Res>
    implements _$BlockNoteDocumentCopyWith<$Res> {
  __$BlockNoteDocumentCopyWithImpl(this._self, this._then);

  final _BlockNoteDocument _self;
  final $Res Function(_BlockNoteDocument) _then;

/// Create a copy of BlockNoteDocument
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? blocks = null,Object? version = freezed,}) {
  return _then(_BlockNoteDocument(
blocks: null == blocks ? _self._blocks : blocks // ignore: cast_nullable_to_non_nullable
as List<BlockNoteBlock>,version: freezed == version ? _self.version : version // ignore: cast_nullable_to_non_nullable
as BlockNoteDocumentVersion?,
  ));
}

/// Create a copy of BlockNoteDocument
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$BlockNoteDocumentVersionCopyWith<$Res>? get version {
    if (_self.version == null) {
    return null;
  }

  return $BlockNoteDocumentVersionCopyWith<$Res>(_self.version!, (value) {
    return _then(_self.copyWith(version: value));
  });
}
}

// dart format on
