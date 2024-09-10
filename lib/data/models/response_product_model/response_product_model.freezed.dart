// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'response_product_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

ResponseProductModel _$ResponseProductModelFromJson(Map<String, dynamic> json) {
  return _ResponseProductModel.fromJson(json);
}

/// @nodoc
mixin _$ResponseProductModel {
  Map<String, dynamic> get product => throw _privateConstructorUsedError;

  /// Serializes this ResponseProductModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ResponseProductModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ResponseProductModelCopyWith<ResponseProductModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ResponseProductModelCopyWith<$Res> {
  factory $ResponseProductModelCopyWith(ResponseProductModel value,
          $Res Function(ResponseProductModel) then) =
      _$ResponseProductModelCopyWithImpl<$Res, ResponseProductModel>;
  @useResult
  $Res call({Map<String, dynamic> product});
}

/// @nodoc
class _$ResponseProductModelCopyWithImpl<$Res,
        $Val extends ResponseProductModel>
    implements $ResponseProductModelCopyWith<$Res> {
  _$ResponseProductModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ResponseProductModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? product = null,
  }) {
    return _then(_value.copyWith(
      product: null == product
          ? _value.product
          : product // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ResponseProductModelImplCopyWith<$Res>
    implements $ResponseProductModelCopyWith<$Res> {
  factory _$$ResponseProductModelImplCopyWith(_$ResponseProductModelImpl value,
          $Res Function(_$ResponseProductModelImpl) then) =
      __$$ResponseProductModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({Map<String, dynamic> product});
}

/// @nodoc
class __$$ResponseProductModelImplCopyWithImpl<$Res>
    extends _$ResponseProductModelCopyWithImpl<$Res, _$ResponseProductModelImpl>
    implements _$$ResponseProductModelImplCopyWith<$Res> {
  __$$ResponseProductModelImplCopyWithImpl(_$ResponseProductModelImpl _value,
      $Res Function(_$ResponseProductModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of ResponseProductModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? product = null,
  }) {
    return _then(_$ResponseProductModelImpl(
      product: null == product
          ? _value._product
          : product // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ResponseProductModelImpl extends _ResponseProductModel {
  const _$ResponseProductModelImpl(
      {required final Map<String, dynamic> product})
      : _product = product,
        super._();

  factory _$ResponseProductModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$ResponseProductModelImplFromJson(json);

  final Map<String, dynamic> _product;
  @override
  Map<String, dynamic> get product {
    if (_product is EqualUnmodifiableMapView) return _product;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_product);
  }

  @override
  String toString() {
    return 'ResponseProductModel(product: $product)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ResponseProductModelImpl &&
            const DeepCollectionEquality().equals(other._product, _product));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(_product));

  /// Create a copy of ResponseProductModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ResponseProductModelImplCopyWith<_$ResponseProductModelImpl>
      get copyWith =>
          __$$ResponseProductModelImplCopyWithImpl<_$ResponseProductModelImpl>(
              this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ResponseProductModelImplToJson(
      this,
    );
  }
}

abstract class _ResponseProductModel extends ResponseProductModel {
  const factory _ResponseProductModel(
          {required final Map<String, dynamic> product}) =
      _$ResponseProductModelImpl;
  const _ResponseProductModel._() : super._();

  factory _ResponseProductModel.fromJson(Map<String, dynamic> json) =
      _$ResponseProductModelImpl.fromJson;

  @override
  Map<String, dynamic> get product;

  /// Create a copy of ResponseProductModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ResponseProductModelImplCopyWith<_$ResponseProductModelImpl>
      get copyWith => throw _privateConstructorUsedError;
}
