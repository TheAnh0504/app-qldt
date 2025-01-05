// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'material_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

MaterialModel _$MaterialModelFromJson(Map<String, dynamic> json) {
  return _MaterialModel.fromJson(json);
}

/// @nodoc
mixin _$MaterialModel {
  String get id => throw _privateConstructorUsedError;
  String get class_id => throw _privateConstructorUsedError;
  String get material_name => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;
  String get material_type => throw _privateConstructorUsedError;
  String? get material_link => throw _privateConstructorUsedError;

  /// Serializes this MaterialModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of MaterialModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $MaterialModelCopyWith<MaterialModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MaterialModelCopyWith<$Res> {
  factory $MaterialModelCopyWith(
          MaterialModel value, $Res Function(MaterialModel) then) =
      _$MaterialModelCopyWithImpl<$Res, MaterialModel>;
  @useResult
  $Res call(
      {String id,
      String class_id,
      String material_name,
      String description,
      String material_type,
      String? material_link});
}

/// @nodoc
class _$MaterialModelCopyWithImpl<$Res, $Val extends MaterialModel>
    implements $MaterialModelCopyWith<$Res> {
  _$MaterialModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of MaterialModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? class_id = null,
    Object? material_name = null,
    Object? description = null,
    Object? material_type = null,
    Object? material_link = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      class_id: null == class_id
          ? _value.class_id
          : class_id // ignore: cast_nullable_to_non_nullable
              as String,
      material_name: null == material_name
          ? _value.material_name
          : material_name // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      material_type: null == material_type
          ? _value.material_type
          : material_type // ignore: cast_nullable_to_non_nullable
              as String,
      material_link: freezed == material_link
          ? _value.material_link
          : material_link // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$MaterialModelImplCopyWith<$Res>
    implements $MaterialModelCopyWith<$Res> {
  factory _$$MaterialModelImplCopyWith(
          _$MaterialModelImpl value, $Res Function(_$MaterialModelImpl) then) =
      __$$MaterialModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String class_id,
      String material_name,
      String description,
      String material_type,
      String? material_link});
}

/// @nodoc
class __$$MaterialModelImplCopyWithImpl<$Res>
    extends _$MaterialModelCopyWithImpl<$Res, _$MaterialModelImpl>
    implements _$$MaterialModelImplCopyWith<$Res> {
  __$$MaterialModelImplCopyWithImpl(
      _$MaterialModelImpl _value, $Res Function(_$MaterialModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of MaterialModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? class_id = null,
    Object? material_name = null,
    Object? description = null,
    Object? material_type = null,
    Object? material_link = freezed,
  }) {
    return _then(_$MaterialModelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      class_id: null == class_id
          ? _value.class_id
          : class_id // ignore: cast_nullable_to_non_nullable
              as String,
      material_name: null == material_name
          ? _value.material_name
          : material_name // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      material_type: null == material_type
          ? _value.material_type
          : material_type // ignore: cast_nullable_to_non_nullable
              as String,
      material_link: freezed == material_link
          ? _value.material_link
          : material_link // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _$MaterialModelImpl implements _MaterialModel {
  const _$MaterialModelImpl(
      {required this.id,
      required this.class_id,
      required this.material_name,
      required this.description,
      required this.material_type,
      this.material_link});

  factory _$MaterialModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$MaterialModelImplFromJson(json);

  @override
  final String id;
  @override
  final String class_id;
  @override
  final String material_name;
  @override
  final String description;
  @override
  final String material_type;
  @override
  final String? material_link;

  @override
  String toString() {
    return 'MaterialModel(id: $id, class_id: $class_id, material_name: $material_name, description: $description, material_type: $material_type, material_link: $material_link)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MaterialModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.class_id, class_id) ||
                other.class_id == class_id) &&
            (identical(other.material_name, material_name) ||
                other.material_name == material_name) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.material_type, material_type) ||
                other.material_type == material_type) &&
            (identical(other.material_link, material_link) ||
                other.material_link == material_link));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, class_id, material_name,
      description, material_type, material_link);

  /// Create a copy of MaterialModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$MaterialModelImplCopyWith<_$MaterialModelImpl> get copyWith =>
      __$$MaterialModelImplCopyWithImpl<_$MaterialModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$MaterialModelImplToJson(
      this,
    );
  }
}

abstract class _MaterialModel implements MaterialModel {
  const factory _MaterialModel(
      {required final String id,
      required final String class_id,
      required final String material_name,
      required final String description,
      required final String material_type,
      final String? material_link}) = _$MaterialModelImpl;

  factory _MaterialModel.fromJson(Map<String, dynamic> json) =
      _$MaterialModelImpl.fromJson;

  @override
  String get id;
  @override
  String get class_id;
  @override
  String get material_name;
  @override
  String get description;
  @override
  String get material_type;
  @override
  String? get material_link;

  /// Create a copy of MaterialModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MaterialModelImplCopyWith<_$MaterialModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
