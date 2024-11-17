// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'push_notification_settings_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PushNotiSettingsImpl _$$PushNotiSettingsImplFromJson(
        Map<String, dynamic> json) =>
    _$PushNotiSettingsImpl(
      vibrantOn: json['vibrantOn'] as bool? ?? true,
      notificationOn: json['notificationOn'] as bool? ?? true,
      soundOn: json['soundOn'] as bool? ?? true,
      ledOn: json['ledOn'] as bool? ?? true,
    );

Map<String, dynamic> _$$PushNotiSettingsImplToJson(
        _$PushNotiSettingsImpl instance) =>
    <String, dynamic>{
      'vibrantOn': instance.vibrantOn,
      'notificationOn': instance.notificationOn,
      'soundOn': instance.soundOn,
      'ledOn': instance.ledOn,
    };
