// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'security_notification_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-model');

SecurityNotificationModel _$SecurityNotificationModelFromJson(
    Map<String, dynamic> json) {
  return _SecurityNoti.fromJson(json);
}

/// @nodoc
mixin _$SecurityNotificationModel {
  String get confirmWhat => throw _privateConstructorUsedError;
  String get requestSending => throw _privateConstructorUsedError;
  DeviceModel get device => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $SecurityNotificationModelCopyWith<SecurityNotificationModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SecurityNotificationModelCopyWith<$Res> {
  factory $SecurityNotificationModelCopyWith(SecurityNotificationModel value,
          $Res Function(SecurityNotificationModel) then) =
      _$SecurityNotificationModelCopyWithImpl<$Res, SecurityNotificationModel>;
  @useResult
  $Res call({String confirmWhat, String requestSending, DeviceModel device});

  $DeviceModelCopyWith<$Res> get device;
}

/// @nodoc
class _$SecurityNotificationModelCopyWithImpl<$Res,
        $Val extends SecurityNotificationModel>
    implements $SecurityNotificationModelCopyWith<$Res> {
  _$SecurityNotificationModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? confirmWhat = null,
    Object? requestSending = null,
    Object? device = null,
  }) {
    return _then(_value.copyWith(
      confirmWhat: null == confirmWhat
          ? _value.confirmWhat
          : confirmWhat // ignore: cast_nullable_to_non_nullable
              as String,
      requestSending: null == requestSending
          ? _value.requestSending
          : requestSending // ignore: cast_nullable_to_non_nullable
              as String,
      device: null == device
          ? _value.device
          : device // ignore: cast_nullable_to_non_nullable
              as DeviceModel,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $DeviceModelCopyWith<$Res> get device {
    return $DeviceModelCopyWith<$Res>(_value.device, (value) {
      return _then(_value.copyWith(device: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$SecurityNotiImplCopyWith<$Res>
    implements $SecurityNotificationModelCopyWith<$Res> {
  factory _$$SecurityNotiImplCopyWith(
          _$SecurityNotiImpl value, $Res Function(_$SecurityNotiImpl) then) =
      __$$SecurityNotiImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String confirmWhat, String requestSending, DeviceModel device});

  @override
  $DeviceModelCopyWith<$Res> get device;
}

/// @nodoc
class __$$SecurityNotiImplCopyWithImpl<$Res>
    extends _$SecurityNotificationModelCopyWithImpl<$Res, _$SecurityNotiImpl>
    implements _$$SecurityNotiImplCopyWith<$Res> {
  __$$SecurityNotiImplCopyWithImpl(
      _$SecurityNotiImpl _value, $Res Function(_$SecurityNotiImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? confirmWhat = null,
    Object? requestSending = null,
    Object? device = null,
  }) {
    return _then(_$SecurityNotiImpl(
      confirmWhat: null == confirmWhat
          ? _value.confirmWhat
          : confirmWhat // ignore: cast_nullable_to_non_nullable
              as String,
      requestSending: null == requestSending
          ? _value.requestSending
          : requestSending // ignore: cast_nullable_to_non_nullable
              as String,
      device: null == device
          ? _value.device
          : device // ignore: cast_nullable_to_non_nullable
              as DeviceModel,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$SecurityNotiImpl implements _SecurityNoti {
  const _$SecurityNotiImpl(
      {required this.confirmWhat,
      required this.requestSending,
      required this.device});

  factory _$SecurityNotiImpl.fromJson(Map<String, dynamic> json) =>
      _$$SecurityNotiImplFromJson(json);

  @override
  final String confirmWhat;
  @override
  final String requestSending;
  @override
  final DeviceModel device;

  @override
  String toString() {
    return 'SecurityNotificationModel(confirmWhat: $confirmWhat, requestSending: $requestSending, device: $device)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SecurityNotiImpl &&
            (identical(other.confirmWhat, confirmWhat) ||
                other.confirmWhat == confirmWhat) &&
            (identical(other.requestSending, requestSending) ||
                other.requestSending == requestSending) &&
            (identical(other.device, device) || other.device == device));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode =>
      Object.hash(runtimeType, confirmWhat, requestSending, device);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$SecurityNotiImplCopyWith<_$SecurityNotiImpl> get copyWith =>
      __$$SecurityNotiImplCopyWithImpl<_$SecurityNotiImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SecurityNotiImplToJson(
      this,
    );
  }
}

abstract class _SecurityNoti implements SecurityNotificationModel {
  const factory _SecurityNoti(
      {required final String confirmWhat,
      required final String requestSending,
      required final DeviceModel device}) = _$SecurityNotiImpl;

  factory _SecurityNoti.fromJson(Map<String, dynamic> json) =
      _$SecurityNotiImpl.fromJson;

  @override
  String get confirmWhat;
  @override
  String get requestSending;
  @override
  DeviceModel get device;
  @override
  @JsonKey(ignore: true)
  _$$SecurityNotiImplCopyWith<_$SecurityNotiImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
