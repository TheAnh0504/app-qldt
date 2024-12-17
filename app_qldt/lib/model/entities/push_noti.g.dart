// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'push_noti.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PushNotiImpl _$$PushNotiImplFromJson(Map<String, dynamic> json) =>
    _$PushNotiImpl(
      id: (json['id'] as num).toInt(),
      message: json['message'] as String?,
      status: json['status'] as String?,
      fromUser: (json['from_user'] as num?)?.toInt(),
      toUser: (json['to_user'] as num?)?.toInt(),
      type: json['type'] as String?,
      imageUrl: json['image_url'] as String?,
      sentTime: json['sent_time'] as String,
      titlePushNotification: json['title_push_notification'] as String?,
      dataType: json['data']['type'] as String?,
      dataId: json['data']['id'] as String?,
    );

Map<String, dynamic> _$$PushNotiImplToJson(_$PushNotiImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'message': instance.message,
      'status': instance.status,
      'fromUser': instance.fromUser,
      'toUser': instance.toUser,
      'type': instance.type,
      'imageUrl': instance.imageUrl,
      'sentTime': instance.sentTime,
      'titlePushNotification': instance.titlePushNotification,
      'dataType': instance.dataType,
      'dataId': instance.dataId,
    };
