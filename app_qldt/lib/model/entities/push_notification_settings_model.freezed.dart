// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'push_notification_settings_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

PushNotificationSettingsModel _$PushNotificationSettingsModelFromJson(
    Map<String, dynamic> json) {
  return _PushNotiSettings.fromJson(json);
}

/// @nodoc
mixin _$PushNotificationSettingsModel {
  bool get vibrantOn => throw _privateConstructorUsedError;
  bool get notificationOn => throw _privateConstructorUsedError;
  bool get soundOn => throw _privateConstructorUsedError;
  bool get ledOn => throw _privateConstructorUsedError;

  /// Serializes this PushNotificationSettingsModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PushNotificationSettingsModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PushNotificationSettingsModelCopyWith<PushNotificationSettingsModel>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PushNotificationSettingsModelCopyWith<$Res> {
  factory $PushNotificationSettingsModelCopyWith(
          PushNotificationSettingsModel value,
          $Res Function(PushNotificationSettingsModel) then) =
      _$PushNotificationSettingsModelCopyWithImpl<$Res,
          PushNotificationSettingsModel>;
  @useResult
  $Res call({bool vibrantOn, bool notificationOn, bool soundOn, bool ledOn});
}

/// @nodoc
class _$PushNotificationSettingsModelCopyWithImpl<$Res,
        $Val extends PushNotificationSettingsModel>
    implements $PushNotificationSettingsModelCopyWith<$Res> {
  _$PushNotificationSettingsModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PushNotificationSettingsModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? vibrantOn = null,
    Object? notificationOn = null,
    Object? soundOn = null,
    Object? ledOn = null,
  }) {
    return _then(_value.copyWith(
      vibrantOn: null == vibrantOn
          ? _value.vibrantOn
          : vibrantOn // ignore: cast_nullable_to_non_nullable
              as bool,
      notificationOn: null == notificationOn
          ? _value.notificationOn
          : notificationOn // ignore: cast_nullable_to_non_nullable
              as bool,
      soundOn: null == soundOn
          ? _value.soundOn
          : soundOn // ignore: cast_nullable_to_non_nullable
              as bool,
      ledOn: null == ledOn
          ? _value.ledOn
          : ledOn // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$PushNotiSettingsImplCopyWith<$Res>
    implements $PushNotificationSettingsModelCopyWith<$Res> {
  factory _$$PushNotiSettingsImplCopyWith(_$PushNotiSettingsImpl value,
          $Res Function(_$PushNotiSettingsImpl) then) =
      __$$PushNotiSettingsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({bool vibrantOn, bool notificationOn, bool soundOn, bool ledOn});
}

/// @nodoc
class __$$PushNotiSettingsImplCopyWithImpl<$Res>
    extends _$PushNotificationSettingsModelCopyWithImpl<$Res,
        _$PushNotiSettingsImpl>
    implements _$$PushNotiSettingsImplCopyWith<$Res> {
  __$$PushNotiSettingsImplCopyWithImpl(_$PushNotiSettingsImpl _value,
      $Res Function(_$PushNotiSettingsImpl) _then)
      : super(_value, _then);

  /// Create a copy of PushNotificationSettingsModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? vibrantOn = null,
    Object? notificationOn = null,
    Object? soundOn = null,
    Object? ledOn = null,
  }) {
    return _then(_$PushNotiSettingsImpl(
      vibrantOn: null == vibrantOn
          ? _value.vibrantOn
          : vibrantOn // ignore: cast_nullable_to_non_nullable
              as bool,
      notificationOn: null == notificationOn
          ? _value.notificationOn
          : notificationOn // ignore: cast_nullable_to_non_nullable
              as bool,
      soundOn: null == soundOn
          ? _value.soundOn
          : soundOn // ignore: cast_nullable_to_non_nullable
              as bool,
      ledOn: null == ledOn
          ? _value.ledOn
          : ledOn // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _$PushNotiSettingsImpl implements _PushNotiSettings {
  const _$PushNotiSettingsImpl(
      {this.vibrantOn = true,
      this.notificationOn = true,
      this.soundOn = true,
      this.ledOn = true});

  factory _$PushNotiSettingsImpl.fromJson(Map<String, dynamic> json) =>
      _$$PushNotiSettingsImplFromJson(json);

  @override
  @JsonKey()
  final bool vibrantOn;
  @override
  @JsonKey()
  final bool notificationOn;
  @override
  @JsonKey()
  final bool soundOn;
  @override
  @JsonKey()
  final bool ledOn;

  @override
  String toString() {
    return 'PushNotificationSettingsModel(vibrantOn: $vibrantOn, notificationOn: $notificationOn, soundOn: $soundOn, ledOn: $ledOn)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PushNotiSettingsImpl &&
            (identical(other.vibrantOn, vibrantOn) ||
                other.vibrantOn == vibrantOn) &&
            (identical(other.notificationOn, notificationOn) ||
                other.notificationOn == notificationOn) &&
            (identical(other.soundOn, soundOn) || other.soundOn == soundOn) &&
            (identical(other.ledOn, ledOn) || other.ledOn == ledOn));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, vibrantOn, notificationOn, soundOn, ledOn);

  /// Create a copy of PushNotificationSettingsModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PushNotiSettingsImplCopyWith<_$PushNotiSettingsImpl> get copyWith =>
      __$$PushNotiSettingsImplCopyWithImpl<_$PushNotiSettingsImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PushNotiSettingsImplToJson(
      this,
    );
  }
}

abstract class _PushNotiSettings implements PushNotificationSettingsModel {
  const factory _PushNotiSettings(
      {final bool vibrantOn,
      final bool notificationOn,
      final bool soundOn,
      final bool ledOn}) = _$PushNotiSettingsImpl;

  factory _PushNotiSettings.fromJson(Map<String, dynamic> json) =
      _$PushNotiSettingsImpl.fromJson;

  @override
  bool get vibrantOn;
  @override
  bool get notificationOn;
  @override
  bool get soundOn;
  @override
  bool get ledOn;

  /// Create a copy of PushNotificationSettingsModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PushNotiSettingsImplCopyWith<_$PushNotiSettingsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
