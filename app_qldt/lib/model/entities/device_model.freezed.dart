// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'device_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-model');

DeviceModel _$DeviceModelFromJson(Map<String, dynamic> json) {
  return _Device.fromJson(json);
}

/// @nodoc
mixin _$DeviceModel {
  String get deviceId => throw _privateConstructorUsedError;
  String get uuid => throw _privateConstructorUsedError;
  String get type => throw _privateConstructorUsedError;
  String? get model => throw _privateConstructorUsedError;
  String get version =>
      throw _privateConstructorUsedError; // ignore: non_constant_identifier_names
  String get OS => throw _privateConstructorUsedError;
  String get serial => throw _privateConstructorUsedError;
  String get deviceName => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $DeviceModelCopyWith<DeviceModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DeviceModelCopyWith<$Res> {
  factory $DeviceModelCopyWith(
          DeviceModel value, $Res Function(DeviceModel) then) =
      _$DeviceModelCopyWithImpl<$Res, DeviceModel>;
  @useResult
  $Res call(
      {String deviceId,
      String uuid,
      String type,
      String? model,
      String version,
      String OS,
      String serial,
      String deviceName});
}

/// @nodoc
class _$DeviceModelCopyWithImpl<$Res, $Val extends DeviceModel>
    implements $DeviceModelCopyWith<$Res> {
  _$DeviceModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? deviceId = null,
    Object? uuid = null,
    Object? type = null,
    Object? model = freezed,
    Object? version = null,
    Object? OS = null,
    Object? serial = null,
    Object? deviceName = null,
  }) {
    return _then(_value.copyWith(
      deviceId: null == deviceId
          ? _value.deviceId
          : deviceId // ignore: cast_nullable_to_non_nullable
              as String,
      uuid: null == uuid
          ? _value.uuid
          : uuid // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
      model: freezed == model
          ? _value.model
          : model // ignore: cast_nullable_to_non_nullable
              as String?,
      version: null == version
          ? _value.version
          : version // ignore: cast_nullable_to_non_nullable
              as String,
      OS: null == OS
          ? _value.OS
          : OS // ignore: cast_nullable_to_non_nullable
              as String,
      serial: null == serial
          ? _value.serial
          : serial // ignore: cast_nullable_to_non_nullable
              as String,
      deviceName: null == deviceName
          ? _value.deviceName
          : deviceName // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$DeviceImplCopyWith<$Res>
    implements $DeviceModelCopyWith<$Res> {
  factory _$$DeviceImplCopyWith(
          _$DeviceImpl value, $Res Function(_$DeviceImpl) then) =
      __$$DeviceImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String deviceId,
      String uuid,
      String type,
      String? model,
      String version,
      String OS,
      String serial,
      String deviceName});
}

/// @nodoc
class __$$DeviceImplCopyWithImpl<$Res>
    extends _$DeviceModelCopyWithImpl<$Res, _$DeviceImpl>
    implements _$$DeviceImplCopyWith<$Res> {
  __$$DeviceImplCopyWithImpl(
      _$DeviceImpl _value, $Res Function(_$DeviceImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? deviceId = null,
    Object? uuid = null,
    Object? type = null,
    Object? model = freezed,
    Object? version = null,
    Object? OS = null,
    Object? serial = null,
    Object? deviceName = null,
  }) {
    return _then(_$DeviceImpl(
      deviceId: null == deviceId
          ? _value.deviceId
          : deviceId // ignore: cast_nullable_to_non_nullable
              as String,
      uuid: null == uuid
          ? _value.uuid
          : uuid // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
      model: freezed == model
          ? _value.model
          : model // ignore: cast_nullable_to_non_nullable
              as String?,
      version: null == version
          ? _value.version
          : version // ignore: cast_nullable_to_non_nullable
              as String,
      OS: null == OS
          ? _value.OS
          : OS // ignore: cast_nullable_to_non_nullable
              as String,
      serial: null == serial
          ? _value.serial
          : serial // ignore: cast_nullable_to_non_nullable
              as String,
      deviceName: null == deviceName
          ? _value.deviceName
          : deviceName // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _$DeviceImpl implements _Device {
  const _$DeviceImpl(
      {this.deviceId = "",
      this.uuid = "",
      required this.type,
      this.model,
      required this.version,
      required this.OS,
      this.serial = "",
      required this.deviceName});

  factory _$DeviceImpl.fromJson(Map<String, dynamic> json) =>
      _$$DeviceImplFromJson(json);

  @override
  @JsonKey()
  final String deviceId;
  @override
  @JsonKey()
  final String uuid;
  @override
  final String type;
  @override
  final String? model;
  @override
  final String version;
// ignore: non_constant_identifier_names
  @override
  final String OS;
  @override
  @JsonKey()
  final String serial;
  @override
  final String deviceName;

  @override
  String toString() {
    return 'DeviceModel(deviceId: $deviceId, uuid: $uuid, type: $type, model: $model, version: $version, OS: $OS, serial: $serial, deviceName: $deviceName)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DeviceImpl &&
            (identical(other.deviceId, deviceId) ||
                other.deviceId == deviceId) &&
            (identical(other.uuid, uuid) || other.uuid == uuid) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.model, model) || other.model == model) &&
            (identical(other.version, version) || other.version == version) &&
            (identical(other.OS, OS) || other.OS == OS) &&
            (identical(other.serial, serial) || other.serial == serial) &&
            (identical(other.deviceName, deviceName) ||
                other.deviceName == deviceName));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, deviceId, uuid, type, model,
      version, OS, serial, deviceName);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$DeviceImplCopyWith<_$DeviceImpl> get copyWith =>
      __$$DeviceImplCopyWithImpl<_$DeviceImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$DeviceImplToJson(
      this,
    );
  }
}

abstract class _Device implements DeviceModel {
  const factory _Device(
      {final String deviceId,
      final String uuid,
      required final String type,
      final String? model,
      required final String version,
      required final String OS,
      final String serial,
      required final String deviceName}) = _$DeviceImpl;

  factory _Device.fromJson(Map<String, dynamic> json) = _$DeviceImpl.fromJson;

  @override
  String get deviceId;
  @override
  String get uuid;
  @override
  String get type;
  @override
  String? get model;
  @override
  String get version;
  @override // ignore: non_constant_identifier_names
  String get OS;
  @override
  String get serial;
  @override
  String get deviceName;
  @override
  @JsonKey(ignore: true)
  _$$DeviceImplCopyWith<_$DeviceImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
