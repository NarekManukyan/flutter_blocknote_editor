// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'blocknote_transaction.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$BlockNoteTransactionOp {

/// The type of operation.
 BlockNoteTransactionOperation get operation;/// The ID of the block being operated on.
 String get blockId;/// The block data (for insert/update operations).
 BlockNoteBlock? get block;/// The index position (for insert/move operations).
 int? get index;/// The parent block ID (for nested structures).
 String? get parentId;
/// Create a copy of BlockNoteTransactionOp
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BlockNoteTransactionOpCopyWith<BlockNoteTransactionOp> get copyWith => _$BlockNoteTransactionOpCopyWithImpl<BlockNoteTransactionOp>(this as BlockNoteTransactionOp, _$identity);

  /// Serializes this BlockNoteTransactionOp to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BlockNoteTransactionOp&&(identical(other.operation, operation) || other.operation == operation)&&(identical(other.blockId, blockId) || other.blockId == blockId)&&(identical(other.block, block) || other.block == block)&&(identical(other.index, index) || other.index == index)&&(identical(other.parentId, parentId) || other.parentId == parentId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,operation,blockId,block,index,parentId);

@override
String toString() {
  return 'BlockNoteTransactionOp(operation: $operation, blockId: $blockId, block: $block, index: $index, parentId: $parentId)';
}


}

/// @nodoc
abstract mixin class $BlockNoteTransactionOpCopyWith<$Res>  {
  factory $BlockNoteTransactionOpCopyWith(BlockNoteTransactionOp value, $Res Function(BlockNoteTransactionOp) _then) = _$BlockNoteTransactionOpCopyWithImpl;
@useResult
$Res call({
 BlockNoteTransactionOperation operation, String blockId, BlockNoteBlock? block, int? index, String? parentId
});


$BlockNoteBlockCopyWith<$Res>? get block;

}
/// @nodoc
class _$BlockNoteTransactionOpCopyWithImpl<$Res>
    implements $BlockNoteTransactionOpCopyWith<$Res> {
  _$BlockNoteTransactionOpCopyWithImpl(this._self, this._then);

  final BlockNoteTransactionOp _self;
  final $Res Function(BlockNoteTransactionOp) _then;

/// Create a copy of BlockNoteTransactionOp
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? operation = null,Object? blockId = null,Object? block = freezed,Object? index = freezed,Object? parentId = freezed,}) {
  return _then(_self.copyWith(
operation: null == operation ? _self.operation : operation // ignore: cast_nullable_to_non_nullable
as BlockNoteTransactionOperation,blockId: null == blockId ? _self.blockId : blockId // ignore: cast_nullable_to_non_nullable
as String,block: freezed == block ? _self.block : block // ignore: cast_nullable_to_non_nullable
as BlockNoteBlock?,index: freezed == index ? _self.index : index // ignore: cast_nullable_to_non_nullable
as int?,parentId: freezed == parentId ? _self.parentId : parentId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}
/// Create a copy of BlockNoteTransactionOp
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$BlockNoteBlockCopyWith<$Res>? get block {
    if (_self.block == null) {
    return null;
  }

  return $BlockNoteBlockCopyWith<$Res>(_self.block!, (value) {
    return _then(_self.copyWith(block: value));
  });
}
}



/// @nodoc
@JsonSerializable()

class _BlockNoteTransactionOp implements BlockNoteTransactionOp {
  const _BlockNoteTransactionOp({required this.operation, required this.blockId, this.block, this.index, this.parentId});
  factory _BlockNoteTransactionOp.fromJson(Map<String, dynamic> json) => _$BlockNoteTransactionOpFromJson(json);

/// The type of operation.
@override final  BlockNoteTransactionOperation operation;
/// The ID of the block being operated on.
@override final  String blockId;
/// The block data (for insert/update operations).
@override final  BlockNoteBlock? block;
/// The index position (for insert/move operations).
@override final  int? index;
/// The parent block ID (for nested structures).
@override final  String? parentId;

/// Create a copy of BlockNoteTransactionOp
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BlockNoteTransactionOpCopyWith<_BlockNoteTransactionOp> get copyWith => __$BlockNoteTransactionOpCopyWithImpl<_BlockNoteTransactionOp>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$BlockNoteTransactionOpToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _BlockNoteTransactionOp&&(identical(other.operation, operation) || other.operation == operation)&&(identical(other.blockId, blockId) || other.blockId == blockId)&&(identical(other.block, block) || other.block == block)&&(identical(other.index, index) || other.index == index)&&(identical(other.parentId, parentId) || other.parentId == parentId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,operation,blockId,block,index,parentId);

@override
String toString() {
  return 'BlockNoteTransactionOp(operation: $operation, blockId: $blockId, block: $block, index: $index, parentId: $parentId)';
}


}

/// @nodoc
abstract mixin class _$BlockNoteTransactionOpCopyWith<$Res> implements $BlockNoteTransactionOpCopyWith<$Res> {
  factory _$BlockNoteTransactionOpCopyWith(_BlockNoteTransactionOp value, $Res Function(_BlockNoteTransactionOp) _then) = __$BlockNoteTransactionOpCopyWithImpl;
@override @useResult
$Res call({
 BlockNoteTransactionOperation operation, String blockId, BlockNoteBlock? block, int? index, String? parentId
});


@override $BlockNoteBlockCopyWith<$Res>? get block;

}
/// @nodoc
class __$BlockNoteTransactionOpCopyWithImpl<$Res>
    implements _$BlockNoteTransactionOpCopyWith<$Res> {
  __$BlockNoteTransactionOpCopyWithImpl(this._self, this._then);

  final _BlockNoteTransactionOp _self;
  final $Res Function(_BlockNoteTransactionOp) _then;

/// Create a copy of BlockNoteTransactionOp
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? operation = null,Object? blockId = null,Object? block = freezed,Object? index = freezed,Object? parentId = freezed,}) {
  return _then(_BlockNoteTransactionOp(
operation: null == operation ? _self.operation : operation // ignore: cast_nullable_to_non_nullable
as BlockNoteTransactionOperation,blockId: null == blockId ? _self.blockId : blockId // ignore: cast_nullable_to_non_nullable
as String,block: freezed == block ? _self.block : block // ignore: cast_nullable_to_non_nullable
as BlockNoteBlock?,index: freezed == index ? _self.index : index // ignore: cast_nullable_to_non_nullable
as int?,parentId: freezed == parentId ? _self.parentId : parentId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

/// Create a copy of BlockNoteTransactionOp
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$BlockNoteBlockCopyWith<$Res>? get block {
    if (_self.block == null) {
    return null;
  }

  return $BlockNoteBlockCopyWith<$Res>(_self.block!, (value) {
    return _then(_self.copyWith(block: value));
  });
}
}


/// @nodoc
mixin _$BlockNoteTransaction {

/// The base document version this transaction is based on.
 int get baseVersion;/// The operations in this transaction.
 List<BlockNoteTransactionOp> get operations;/// Optional timestamp when this transaction was created.
 int? get timestamp;
/// Create a copy of BlockNoteTransaction
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BlockNoteTransactionCopyWith<BlockNoteTransaction> get copyWith => _$BlockNoteTransactionCopyWithImpl<BlockNoteTransaction>(this as BlockNoteTransaction, _$identity);

  /// Serializes this BlockNoteTransaction to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BlockNoteTransaction&&(identical(other.baseVersion, baseVersion) || other.baseVersion == baseVersion)&&const DeepCollectionEquality().equals(other.operations, operations)&&(identical(other.timestamp, timestamp) || other.timestamp == timestamp));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,baseVersion,const DeepCollectionEquality().hash(operations),timestamp);

@override
String toString() {
  return 'BlockNoteTransaction(baseVersion: $baseVersion, operations: $operations, timestamp: $timestamp)';
}


}

/// @nodoc
abstract mixin class $BlockNoteTransactionCopyWith<$Res>  {
  factory $BlockNoteTransactionCopyWith(BlockNoteTransaction value, $Res Function(BlockNoteTransaction) _then) = _$BlockNoteTransactionCopyWithImpl;
@useResult
$Res call({
 int baseVersion, List<BlockNoteTransactionOp> operations, int? timestamp
});




}
/// @nodoc
class _$BlockNoteTransactionCopyWithImpl<$Res>
    implements $BlockNoteTransactionCopyWith<$Res> {
  _$BlockNoteTransactionCopyWithImpl(this._self, this._then);

  final BlockNoteTransaction _self;
  final $Res Function(BlockNoteTransaction) _then;

/// Create a copy of BlockNoteTransaction
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? baseVersion = null,Object? operations = null,Object? timestamp = freezed,}) {
  return _then(_self.copyWith(
baseVersion: null == baseVersion ? _self.baseVersion : baseVersion // ignore: cast_nullable_to_non_nullable
as int,operations: null == operations ? _self.operations : operations // ignore: cast_nullable_to_non_nullable
as List<BlockNoteTransactionOp>,timestamp: freezed == timestamp ? _self.timestamp : timestamp // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

}



/// @nodoc
@JsonSerializable()

class _BlockNoteTransaction implements BlockNoteTransaction {
  const _BlockNoteTransaction({required this.baseVersion, required final  List<BlockNoteTransactionOp> operations, this.timestamp}): _operations = operations;
  factory _BlockNoteTransaction.fromJson(Map<String, dynamic> json) => _$BlockNoteTransactionFromJson(json);

/// The base document version this transaction is based on.
@override final  int baseVersion;
/// The operations in this transaction.
 final  List<BlockNoteTransactionOp> _operations;
/// The operations in this transaction.
@override List<BlockNoteTransactionOp> get operations {
  if (_operations is EqualUnmodifiableListView) return _operations;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_operations);
}

/// Optional timestamp when this transaction was created.
@override final  int? timestamp;

/// Create a copy of BlockNoteTransaction
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BlockNoteTransactionCopyWith<_BlockNoteTransaction> get copyWith => __$BlockNoteTransactionCopyWithImpl<_BlockNoteTransaction>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$BlockNoteTransactionToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _BlockNoteTransaction&&(identical(other.baseVersion, baseVersion) || other.baseVersion == baseVersion)&&const DeepCollectionEquality().equals(other._operations, _operations)&&(identical(other.timestamp, timestamp) || other.timestamp == timestamp));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,baseVersion,const DeepCollectionEquality().hash(_operations),timestamp);

@override
String toString() {
  return 'BlockNoteTransaction(baseVersion: $baseVersion, operations: $operations, timestamp: $timestamp)';
}


}

/// @nodoc
abstract mixin class _$BlockNoteTransactionCopyWith<$Res> implements $BlockNoteTransactionCopyWith<$Res> {
  factory _$BlockNoteTransactionCopyWith(_BlockNoteTransaction value, $Res Function(_BlockNoteTransaction) _then) = __$BlockNoteTransactionCopyWithImpl;
@override @useResult
$Res call({
 int baseVersion, List<BlockNoteTransactionOp> operations, int? timestamp
});




}
/// @nodoc
class __$BlockNoteTransactionCopyWithImpl<$Res>
    implements _$BlockNoteTransactionCopyWith<$Res> {
  __$BlockNoteTransactionCopyWithImpl(this._self, this._then);

  final _BlockNoteTransaction _self;
  final $Res Function(_BlockNoteTransaction) _then;

/// Create a copy of BlockNoteTransaction
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? baseVersion = null,Object? operations = null,Object? timestamp = freezed,}) {
  return _then(_BlockNoteTransaction(
baseVersion: null == baseVersion ? _self.baseVersion : baseVersion // ignore: cast_nullable_to_non_nullable
as int,operations: null == operations ? _self._operations : operations // ignore: cast_nullable_to_non_nullable
as List<BlockNoteTransactionOp>,timestamp: freezed == timestamp ? _self.timestamp : timestamp // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}

// dart format on
