// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'security_notification_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$SecurityNotiImpl _$$SecurityNotiImplFromJson(Map<String, dynamic> json) =>
    _$SecurityNotiImpl(
      confirmWhat: json['confirmWhat'] as String,
      requestSending: json['requestSending'] as String,
      device: DeviceModel.fromJson(json['device'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$SecurityNotiImplToJson(_$SecurityNotiImpl instance) =>
    <String, dynamic>{
      'confirmWhat': instance.confirmWhat,
      'requestSending': instance.requestSending,
      'device': instance.device,
    };
