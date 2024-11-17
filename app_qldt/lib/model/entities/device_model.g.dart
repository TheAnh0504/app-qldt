// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'device_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$DeviceImpl _$$DeviceImplFromJson(Map<String, dynamic> json) => _$DeviceImpl(
      deviceId: json['deviceId'] as String? ?? "",
      uuid: json['uuid'] as String? ?? "",
      type: json['type'] as String,
      model: json['model'] as String?,
      version: json['version'] as String,
      OS: json['OS'] as String,
      serial: json['serial'] as String? ?? "",
      deviceName: json['deviceName'] as String,
    );

Map<String, dynamic> _$$DeviceImplToJson(_$DeviceImpl instance) =>
    <String, dynamic>{
      'deviceId': instance.deviceId,
      'uuid': instance.uuid,
      'type': instance.type,
      'model': instance.model,
      'version': instance.version,
      'OS': instance.OS,
      'serial': instance.serial,
      'deviceName': instance.deviceName,
    };
