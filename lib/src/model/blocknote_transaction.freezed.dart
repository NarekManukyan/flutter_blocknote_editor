// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'blocknote_transaction.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

BlockNoteTransactionOp _$BlockNoteTransactionOpFromJson(
  Map<String, dynamic> json,
) {
  return _BlockNoteTransactionOp.fromJson(json);
}

/// @nodoc
mixin _$BlockNoteTransactionOp {
  /// The type of operation.
  BlockNoteTransactionOperation get operation =>
      throw _privateConstructorUsedError;

  /// The ID of the block being operated on.
  String get blockId => throw _privateConstructorUsedError;

  /// The block data (for insert/update operations).
  BlockNoteBlock? get block => throw _privateConstructorUsedError;

  /// The index position (for insert/move operations).
  int? get index => throw _privateConstructorUsedError;

  /// The parent block ID (for nested structures).
  String? get parentId => throw _privateConstructorUsedError;

  /// Serializes this BlockNoteTransactionOp to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of BlockNoteTransactionOp
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $BlockNoteTransactionOpCopyWith<BlockNoteTransactionOp> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BlockNoteTransactionOpCopyWith<$Res> {
  factory $BlockNoteTransactionOpCopyWith(
    BlockNoteTransactionOp value,
    $Res Function(BlockNoteTransactionOp) then,
  ) = _$BlockNoteTransactionOpCopyWithImpl<$Res, BlockNoteTransactionOp>;
  @useResult
  $Res call({
    BlockNoteTransactionOperation operation,
    String blockId,
    BlockNoteBlock? block,
    int? index,
    String? parentId,
  });

  $BlockNoteBlockCopyWith<$Res>? get block;
}

/// @nodoc
class _$BlockNoteTransactionOpCopyWithImpl<
  $Res,
  $Val extends BlockNoteTransactionOp
>
    implements $BlockNoteTransactionOpCopyWith<$Res> {
  _$BlockNoteTransactionOpCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of BlockNoteTransactionOp
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? operation = null,
    Object? blockId = null,
    Object? block = freezed,
    Object? index = freezed,
    Object? parentId = freezed,
  }) {
    return _then(
      _value.copyWith(
            operation: null == operation
                ? _value.operation
                : operation // ignore: cast_nullable_to_non_nullable
                      as BlockNoteTransactionOperation,
            blockId: null == blockId
                ? _value.blockId
                : blockId // ignore: cast_nullable_to_non_nullable
                      as String,
            block: freezed == block
                ? _value.block
                : block // ignore: cast_nullable_to_non_nullable
                      as BlockNoteBlock?,
            index: freezed == index
                ? _value.index
                : index // ignore: cast_nullable_to_non_nullable
                      as int?,
            parentId: freezed == parentId
                ? _value.parentId
                : parentId // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }

  /// Create a copy of BlockNoteTransactionOp
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $BlockNoteBlockCopyWith<$Res>? get block {
    if (_value.block == null) {
      return null;
    }

    return $BlockNoteBlockCopyWith<$Res>(_value.block!, (value) {
      return _then(_value.copyWith(block: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$BlockNoteTransactionOpImplCopyWith<$Res>
    implements $BlockNoteTransactionOpCopyWith<$Res> {
  factory _$$BlockNoteTransactionOpImplCopyWith(
    _$BlockNoteTransactionOpImpl value,
    $Res Function(_$BlockNoteTransactionOpImpl) then,
  ) = __$$BlockNoteTransactionOpImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    BlockNoteTransactionOperation operation,
    String blockId,
    BlockNoteBlock? block,
    int? index,
    String? parentId,
  });

  @override
  $BlockNoteBlockCopyWith<$Res>? get block;
}

/// @nodoc
class __$$BlockNoteTransactionOpImplCopyWithImpl<$Res>
    extends
        _$BlockNoteTransactionOpCopyWithImpl<$Res, _$BlockNoteTransactionOpImpl>
    implements _$$BlockNoteTransactionOpImplCopyWith<$Res> {
  __$$BlockNoteTransactionOpImplCopyWithImpl(
    _$BlockNoteTransactionOpImpl _value,
    $Res Function(_$BlockNoteTransactionOpImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of BlockNoteTransactionOp
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? operation = null,
    Object? blockId = null,
    Object? block = freezed,
    Object? index = freezed,
    Object? parentId = freezed,
  }) {
    return _then(
      _$BlockNoteTransactionOpImpl(
        operation: null == operation
            ? _value.operation
            : operation // ignore: cast_nullable_to_non_nullable
                  as BlockNoteTransactionOperation,
        blockId: null == blockId
            ? _value.blockId
            : blockId // ignore: cast_nullable_to_non_nullable
                  as String,
        block: freezed == block
            ? _value.block
            : block // ignore: cast_nullable_to_non_nullable
                  as BlockNoteBlock?,
        index: freezed == index
            ? _value.index
            : index // ignore: cast_nullable_to_non_nullable
                  as int?,
        parentId: freezed == parentId
            ? _value.parentId
            : parentId // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$BlockNoteTransactionOpImpl implements _BlockNoteTransactionOp {
  const _$BlockNoteTransactionOpImpl({
    required this.operation,
    required this.blockId,
    this.block,
    this.index,
    this.parentId,
  });

  factory _$BlockNoteTransactionOpImpl.fromJson(Map<String, dynamic> json) =>
      _$$BlockNoteTransactionOpImplFromJson(json);

  /// The type of operation.
  @override
  final BlockNoteTransactionOperation operation;

  /// The ID of the block being operated on.
  @override
  final String blockId;

  /// The block data (for insert/update operations).
  @override
  final BlockNoteBlock? block;

  /// The index position (for insert/move operations).
  @override
  final int? index;

  /// The parent block ID (for nested structures).
  @override
  final String? parentId;

  @override
  String toString() {
    return 'BlockNoteTransactionOp(operation: $operation, blockId: $blockId, block: $block, index: $index, parentId: $parentId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BlockNoteTransactionOpImpl &&
            (identical(other.operation, operation) ||
                other.operation == operation) &&
            (identical(other.blockId, blockId) || other.blockId == blockId) &&
            (identical(other.block, block) || other.block == block) &&
            (identical(other.index, index) || other.index == index) &&
            (identical(other.parentId, parentId) ||
                other.parentId == parentId));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, operation, blockId, block, index, parentId);

  /// Create a copy of BlockNoteTransactionOp
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$BlockNoteTransactionOpImplCopyWith<_$BlockNoteTransactionOpImpl>
  get copyWith =>
      __$$BlockNoteTransactionOpImplCopyWithImpl<_$BlockNoteTransactionOpImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$BlockNoteTransactionOpImplToJson(this);
  }
}

abstract class _BlockNoteTransactionOp implements BlockNoteTransactionOp {
  const factory _BlockNoteTransactionOp({
    required final BlockNoteTransactionOperation operation,
    required final String blockId,
    final BlockNoteBlock? block,
    final int? index,
    final String? parentId,
  }) = _$BlockNoteTransactionOpImpl;

  factory _BlockNoteTransactionOp.fromJson(Map<String, dynamic> json) =
      _$BlockNoteTransactionOpImpl.fromJson;

  /// The type of operation.
  @override
  BlockNoteTransactionOperation get operation;

  /// The ID of the block being operated on.
  @override
  String get blockId;

  /// The block data (for insert/update operations).
  @override
  BlockNoteBlock? get block;

  /// The index position (for insert/move operations).
  @override
  int? get index;

  /// The parent block ID (for nested structures).
  @override
  String? get parentId;

  /// Create a copy of BlockNoteTransactionOp
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$BlockNoteTransactionOpImplCopyWith<_$BlockNoteTransactionOpImpl>
  get copyWith => throw _privateConstructorUsedError;
}

BlockNoteTransaction _$BlockNoteTransactionFromJson(Map<String, dynamic> json) {
  return _BlockNoteTransaction.fromJson(json);
}

/// @nodoc
mixin _$BlockNoteTransaction {
  /// The base document version this transaction is based on.
  int get baseVersion => throw _privateConstructorUsedError;

  /// The operations in this transaction.
  List<BlockNoteTransactionOp> get operations =>
      throw _privateConstructorUsedError;

  /// Optional timestamp when this transaction was created.
  int? get timestamp => throw _privateConstructorUsedError;

  /// Serializes this BlockNoteTransaction to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of BlockNoteTransaction
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $BlockNoteTransactionCopyWith<BlockNoteTransaction> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BlockNoteTransactionCopyWith<$Res> {
  factory $BlockNoteTransactionCopyWith(
    BlockNoteTransaction value,
    $Res Function(BlockNoteTransaction) then,
  ) = _$BlockNoteTransactionCopyWithImpl<$Res, BlockNoteTransaction>;
  @useResult
  $Res call({
    int baseVersion,
    List<BlockNoteTransactionOp> operations,
    int? timestamp,
  });
}

/// @nodoc
class _$BlockNoteTransactionCopyWithImpl<
  $Res,
  $Val extends BlockNoteTransaction
>
    implements $BlockNoteTransactionCopyWith<$Res> {
  _$BlockNoteTransactionCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of BlockNoteTransaction
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? baseVersion = null,
    Object? operations = null,
    Object? timestamp = freezed,
  }) {
    return _then(
      _value.copyWith(
            baseVersion: null == baseVersion
                ? _value.baseVersion
                : baseVersion // ignore: cast_nullable_to_non_nullable
                      as int,
            operations: null == operations
                ? _value.operations
                : operations // ignore: cast_nullable_to_non_nullable
                      as List<BlockNoteTransactionOp>,
            timestamp: freezed == timestamp
                ? _value.timestamp
                : timestamp // ignore: cast_nullable_to_non_nullable
                      as int?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$BlockNoteTransactionImplCopyWith<$Res>
    implements $BlockNoteTransactionCopyWith<$Res> {
  factory _$$BlockNoteTransactionImplCopyWith(
    _$BlockNoteTransactionImpl value,
    $Res Function(_$BlockNoteTransactionImpl) then,
  ) = __$$BlockNoteTransactionImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    int baseVersion,
    List<BlockNoteTransactionOp> operations,
    int? timestamp,
  });
}

/// @nodoc
class __$$BlockNoteTransactionImplCopyWithImpl<$Res>
    extends _$BlockNoteTransactionCopyWithImpl<$Res, _$BlockNoteTransactionImpl>
    implements _$$BlockNoteTransactionImplCopyWith<$Res> {
  __$$BlockNoteTransactionImplCopyWithImpl(
    _$BlockNoteTransactionImpl _value,
    $Res Function(_$BlockNoteTransactionImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of BlockNoteTransaction
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? baseVersion = null,
    Object? operations = null,
    Object? timestamp = freezed,
  }) {
    return _then(
      _$BlockNoteTransactionImpl(
        baseVersion: null == baseVersion
            ? _value.baseVersion
            : baseVersion // ignore: cast_nullable_to_non_nullable
                  as int,
        operations: null == operations
            ? _value._operations
            : operations // ignore: cast_nullable_to_non_nullable
                  as List<BlockNoteTransactionOp>,
        timestamp: freezed == timestamp
            ? _value.timestamp
            : timestamp // ignore: cast_nullable_to_non_nullable
                  as int?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$BlockNoteTransactionImpl implements _BlockNoteTransaction {
  const _$BlockNoteTransactionImpl({
    required this.baseVersion,
    required final List<BlockNoteTransactionOp> operations,
    this.timestamp,
  }) : _operations = operations;

  factory _$BlockNoteTransactionImpl.fromJson(Map<String, dynamic> json) =>
      _$$BlockNoteTransactionImplFromJson(json);

  /// The base document version this transaction is based on.
  @override
  final int baseVersion;

  /// The operations in this transaction.
  final List<BlockNoteTransactionOp> _operations;

  /// The operations in this transaction.
  @override
  List<BlockNoteTransactionOp> get operations {
    if (_operations is EqualUnmodifiableListView) return _operations;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_operations);
  }

  /// Optional timestamp when this transaction was created.
  @override
  final int? timestamp;

  @override
  String toString() {
    return 'BlockNoteTransaction(baseVersion: $baseVersion, operations: $operations, timestamp: $timestamp)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BlockNoteTransactionImpl &&
            (identical(other.baseVersion, baseVersion) ||
                other.baseVersion == baseVersion) &&
            const DeepCollectionEquality().equals(
              other._operations,
              _operations,
            ) &&
            (identical(other.timestamp, timestamp) ||
                other.timestamp == timestamp));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    baseVersion,
    const DeepCollectionEquality().hash(_operations),
    timestamp,
  );

  /// Create a copy of BlockNoteTransaction
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$BlockNoteTransactionImplCopyWith<_$BlockNoteTransactionImpl>
  get copyWith =>
      __$$BlockNoteTransactionImplCopyWithImpl<_$BlockNoteTransactionImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$BlockNoteTransactionImplToJson(this);
  }
}

abstract class _BlockNoteTransaction implements BlockNoteTransaction {
  const factory _BlockNoteTransaction({
    required final int baseVersion,
    required final List<BlockNoteTransactionOp> operations,
    final int? timestamp,
  }) = _$BlockNoteTransactionImpl;

  factory _BlockNoteTransaction.fromJson(Map<String, dynamic> json) =
      _$BlockNoteTransactionImpl.fromJson;

  /// The base document version this transaction is based on.
  @override
  int get baseVersion;

  /// The operations in this transaction.
  @override
  List<BlockNoteTransactionOp> get operations;

  /// Optional timestamp when this transaction was created.
  @override
  int? get timestamp;

  /// Create a copy of BlockNoteTransaction
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$BlockNoteTransactionImplCopyWith<_$BlockNoteTransactionImpl>
  get copyWith => throw _privateConstructorUsedError;
}
