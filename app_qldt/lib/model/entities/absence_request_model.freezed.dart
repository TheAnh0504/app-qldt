// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'absence_request_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

AbsenceRequestModel _$AbsenceRequestModelFromJson(Map<String, dynamic> json) {
  return _AbsenceRequestModel.fromJson(json);
}

/// @nodoc
mixin _$AbsenceRequestModel {
  String get id => throw _privateConstructorUsedError;
  String get absence_date => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String get reason => throw _privateConstructorUsedError;
  String get status => throw _privateConstructorUsedError;
  String? get class_id => throw _privateConstructorUsedError;
  String? get file_url => throw _privateConstructorUsedError;
  Map<String, dynamic>? get student_account =>
      throw _privateConstructorUsedError;

  /// Serializes this AbsenceRequestModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of AbsenceRequestModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AbsenceRequestModelCopyWith<AbsenceRequestModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AbsenceRequestModelCopyWith<$Res> {
  factory $AbsenceRequestModelCopyWith(
          AbsenceRequestModel value, $Res Function(AbsenceRequestModel) then) =
      _$AbsenceRequestModelCopyWithImpl<$Res, AbsenceRequestModel>;
  @useResult
  $Res call(
      {String id,
      String absence_date,
      String title,
      String reason,
      String status,
      String? class_id,
      String? file_url,
      Map<String, dynamic>? student_account});
}

/// @nodoc
class _$AbsenceRequestModelCopyWithImpl<$Res, $Val extends AbsenceRequestModel>
    implements $AbsenceRequestModelCopyWith<$Res> {
  _$AbsenceRequestModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AbsenceRequestModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? absence_date = null,
    Object? title = null,
    Object? reason = null,
    Object? status = null,
    Object? class_id = freezed,
    Object? file_url = freezed,
    Object? student_account = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      absence_date: null == absence_date
          ? _value.absence_date
          : absence_date // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      reason: null == reason
          ? _value.reason
          : reason // ignore: cast_nullable_to_non_nullable
              as String,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      class_id: freezed == class_id
          ? _value.class_id
          : class_id // ignore: cast_nullable_to_non_nullable
              as String?,
      file_url: freezed == file_url
          ? _value.file_url
          : file_url // ignore: cast_nullable_to_non_nullable
              as String?,
      student_account: freezed == student_account
          ? _value.student_account
          : student_account // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$AbsenceRequestModelImplCopyWith<$Res>
    implements $AbsenceRequestModelCopyWith<$Res> {
  factory _$$AbsenceRequestModelImplCopyWith(_$AbsenceRequestModelImpl value,
          $Res Function(_$AbsenceRequestModelImpl) then) =
      __$$AbsenceRequestModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String absence_date,
      String title,
      String reason,
      String status,
      String? class_id,
      String? file_url,
      Map<String, dynamic>? student_account});
}

/// @nodoc
class __$$AbsenceRequestModelImplCopyWithImpl<$Res>
    extends _$AbsenceRequestModelCopyWithImpl<$Res, _$AbsenceRequestModelImpl>
    implements _$$AbsenceRequestModelImplCopyWith<$Res> {
  __$$AbsenceRequestModelImplCopyWithImpl(_$AbsenceRequestModelImpl _value,
      $Res Function(_$AbsenceRequestModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of AbsenceRequestModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? absence_date = null,
    Object? title = null,
    Object? reason = null,
    Object? status = null,
    Object? class_id = freezed,
    Object? file_url = freezed,
    Object? student_account = freezed,
  }) {
    return _then(_$AbsenceRequestModelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      absence_date: null == absence_date
          ? _value.absence_date
          : absence_date // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      reason: null == reason
          ? _value.reason
          : reason // ignore: cast_nullable_to_non_nullable
              as String,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      class_id: freezed == class_id
          ? _value.class_id
          : class_id // ignore: cast_nullable_to_non_nullable
              as String?,
      file_url: freezed == file_url
          ? _value.file_url
          : file_url // ignore: cast_nullable_to_non_nullable
              as String?,
      student_account: freezed == student_account
          ? _value._student_account
          : student_account // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
    ));
  }
}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _$AbsenceRequestModelImpl implements _AbsenceRequestModel {
  const _$AbsenceRequestModelImpl(
      {required this.id,
      required this.absence_date,
      required this.title,
      required this.reason,
      required this.status,
      this.class_id,
      this.file_url,
      final Map<String, dynamic>? student_account})
      : _student_account = student_account;

  factory _$AbsenceRequestModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$AbsenceRequestModelImplFromJson(json);

  @override
  final String id;
  @override
  final String absence_date;
  @override
  final String title;
  @override
  final String reason;
  @override
  final String status;
  @override
  final String? class_id;
  @override
  final String? file_url;
  final Map<String, dynamic>? _student_account;
  @override
  Map<String, dynamic>? get student_account {
    final value = _student_account;
    if (value == null) return null;
    if (_student_account is EqualUnmodifiableMapView) return _student_account;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  String toString() {
    return 'AbsenceRequestModel(id: $id, absence_date: $absence_date, title: $title, reason: $reason, status: $status, class_id: $class_id, file_url: $file_url, student_account: $student_account)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AbsenceRequestModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.absence_date, absence_date) ||
                other.absence_date == absence_date) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.reason, reason) || other.reason == reason) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.class_id, class_id) ||
                other.class_id == class_id) &&
            (identical(other.file_url, file_url) ||
                other.file_url == file_url) &&
            const DeepCollectionEquality()
                .equals(other._student_account, _student_account));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      absence_date,
      title,
      reason,
      status,
      class_id,
      file_url,
      const DeepCollectionEquality().hash(_student_account));

  /// Create a copy of AbsenceRequestModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AbsenceRequestModelImplCopyWith<_$AbsenceRequestModelImpl> get copyWith =>
      __$$AbsenceRequestModelImplCopyWithImpl<_$AbsenceRequestModelImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AbsenceRequestModelImplToJson(
      this,
    );
  }
}

abstract class _AbsenceRequestModel implements AbsenceRequestModel {
  const factory _AbsenceRequestModel(
      {required final String id,
      required final String absence_date,
      required final String title,
      required final String reason,
      required final String status,
      final String? class_id,
      final String? file_url,
      final Map<String, dynamic>? student_account}) = _$AbsenceRequestModelImpl;

  factory _AbsenceRequestModel.fromJson(Map<String, dynamic> json) =
      _$AbsenceRequestModelImpl.fromJson;

  @override
  String get id;
  @override
  String get absence_date;
  @override
  String get title;
  @override
  String get reason;
  @override
  String get status;
  @override
  String? get class_id;
  @override
  String? get file_url;
  @override
  Map<String, dynamic>? get student_account;

  /// Create a copy of AbsenceRequestModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AbsenceRequestModelImplCopyWith<_$AbsenceRequestModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
