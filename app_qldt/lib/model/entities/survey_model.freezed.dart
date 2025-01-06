// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'survey_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

SurveyModel _$SurveyModelFromJson(Map<String, dynamic> json) {
  return _SurveyModel.fromJson(json);
}

/// @nodoc
mixin _$SurveyModel {
  int get id => throw _privateConstructorUsedError;
  String? get title => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  int get lecturer_id => throw _privateConstructorUsedError;
  String? get deadline => throw _privateConstructorUsedError;
  String? get file_url => throw _privateConstructorUsedError;
  String? get class_id => throw _privateConstructorUsedError;

  /// Serializes this SurveyModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of SurveyModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SurveyModelCopyWith<SurveyModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SurveyModelCopyWith<$Res> {
  factory $SurveyModelCopyWith(
          SurveyModel value, $Res Function(SurveyModel) then) =
      _$SurveyModelCopyWithImpl<$Res, SurveyModel>;
  @useResult
  $Res call(
      {int id,
      String? title,
      String? description,
      int lecturer_id,
      String? deadline,
      String? file_url,
      String? class_id});
}

/// @nodoc
class _$SurveyModelCopyWithImpl<$Res, $Val extends SurveyModel>
    implements $SurveyModelCopyWith<$Res> {
  _$SurveyModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SurveyModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = freezed,
    Object? description = freezed,
    Object? lecturer_id = null,
    Object? deadline = freezed,
    Object? file_url = freezed,
    Object? class_id = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      title: freezed == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String?,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      lecturer_id: null == lecturer_id
          ? _value.lecturer_id
          : lecturer_id // ignore: cast_nullable_to_non_nullable
              as int,
      deadline: freezed == deadline
          ? _value.deadline
          : deadline // ignore: cast_nullable_to_non_nullable
              as String?,
      file_url: freezed == file_url
          ? _value.file_url
          : file_url // ignore: cast_nullable_to_non_nullable
              as String?,
      class_id: freezed == class_id
          ? _value.class_id
          : class_id // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$SurveyModelImplCopyWith<$Res>
    implements $SurveyModelCopyWith<$Res> {
  factory _$$SurveyModelImplCopyWith(
          _$SurveyModelImpl value, $Res Function(_$SurveyModelImpl) then) =
      __$$SurveyModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int id,
      String? title,
      String? description,
      int lecturer_id,
      String? deadline,
      String? file_url,
      String? class_id});
}

/// @nodoc
class __$$SurveyModelImplCopyWithImpl<$Res>
    extends _$SurveyModelCopyWithImpl<$Res, _$SurveyModelImpl>
    implements _$$SurveyModelImplCopyWith<$Res> {
  __$$SurveyModelImplCopyWithImpl(
      _$SurveyModelImpl _value, $Res Function(_$SurveyModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of SurveyModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = freezed,
    Object? description = freezed,
    Object? lecturer_id = null,
    Object? deadline = freezed,
    Object? file_url = freezed,
    Object? class_id = freezed,
  }) {
    return _then(_$SurveyModelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      title: freezed == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String?,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      lecturer_id: null == lecturer_id
          ? _value.lecturer_id
          : lecturer_id // ignore: cast_nullable_to_non_nullable
              as int,
      deadline: freezed == deadline
          ? _value.deadline
          : deadline // ignore: cast_nullable_to_non_nullable
              as String?,
      file_url: freezed == file_url
          ? _value.file_url
          : file_url // ignore: cast_nullable_to_non_nullable
              as String?,
      class_id: freezed == class_id
          ? _value.class_id
          : class_id // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _$SurveyModelImpl implements _SurveyModel {
  const _$SurveyModelImpl(
      {required this.id,
      this.title,
      this.description,
      required this.lecturer_id,
      this.deadline,
      this.file_url,
      this.class_id});

  factory _$SurveyModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$SurveyModelImplFromJson(json);

  @override
  final int id;
  @override
  final String? title;
  @override
  final String? description;
  @override
  final int lecturer_id;
  @override
  final String? deadline;
  @override
  final String? file_url;
  @override
  final String? class_id;

  @override
  String toString() {
    return 'SurveyModel(id: $id, title: $title, description: $description, lecturer_id: $lecturer_id, deadline: $deadline, file_url: $file_url, class_id: $class_id)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SurveyModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.lecturer_id, lecturer_id) ||
                other.lecturer_id == lecturer_id) &&
            (identical(other.deadline, deadline) ||
                other.deadline == deadline) &&
            (identical(other.file_url, file_url) ||
                other.file_url == file_url) &&
            (identical(other.class_id, class_id) ||
                other.class_id == class_id));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, title, description,
      lecturer_id, deadline, file_url, class_id);

  /// Create a copy of SurveyModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SurveyModelImplCopyWith<_$SurveyModelImpl> get copyWith =>
      __$$SurveyModelImplCopyWithImpl<_$SurveyModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SurveyModelImplToJson(
      this,
    );
  }
}

abstract class _SurveyModel implements SurveyModel {
  const factory _SurveyModel(
      {required final int id,
      final String? title,
      final String? description,
      required final int lecturer_id,
      final String? deadline,
      final String? file_url,
      final String? class_id}) = _$SurveyModelImpl;

  factory _SurveyModel.fromJson(Map<String, dynamic> json) =
      _$SurveyModelImpl.fromJson;

  @override
  int get id;
  @override
  String? get title;
  @override
  String? get description;
  @override
  int get lecturer_id;
  @override
  String? get deadline;
  @override
  String? get file_url;
  @override
  String? get class_id;

  /// Create a copy of SurveyModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SurveyModelImplCopyWith<_$SurveyModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
