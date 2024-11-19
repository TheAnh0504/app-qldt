// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'group_chat_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$GroupChatModelImpl _$$GroupChatModelImplFromJson(Map<String, dynamic> json) =>
    _$GroupChatModelImpl(
      infoGroup: GroupChatInfoModel.fromJson(
          json['infoGroup'] as Map<String, dynamic>),
      infoMessageNotRead: GroupChatInfoMessageNotRead.fromJson(
          json['infoMessageNotRead'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$GroupChatModelImplToJson(
        _$GroupChatModelImpl instance) =>
    <String, dynamic>{
      'infoGroup': instance.infoGroup.toJson(),
      'infoMessageNotRead': instance.infoMessageNotRead.toJson(),
    };

_$GroupChatInfoModelImpl _$$GroupChatInfoModelImplFromJson(
        Map<String, dynamic> json) =>
    _$GroupChatInfoModelImpl(
      groupId: json['groupId'] as String,
      groupName: json['groupName'] as Object,
      listUserId: (json['listUserId'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      listAdmin: (json['listAdmin'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      image: json['image'] as String?,
      type: json['type'] as String,
      createdAt: json['createdAt'] as String,
      updatedAt: json['updatedAt'] as String,
    );

Map<String, dynamic> _$$GroupChatInfoModelImplToJson(
        _$GroupChatInfoModelImpl instance) =>
    <String, dynamic>{
      'groupId': instance.groupId,
      'groupName': instance.groupName,
      'listUserId': instance.listUserId,
      'listAdmin': instance.listAdmin,
      'image': instance.image,
      'type': instance.type,
      'createdAt': instance.createdAt,
      'updatedAt': instance.updatedAt,
    };

_$GroupChatInfoMessageNotReadImpl _$$GroupChatInfoMessageNotReadImplFromJson(
        Map<String, dynamic> json) =>
    _$GroupChatInfoMessageNotReadImpl(
      countMessageNotRead: (json['countMessageNotRead'] as num).toInt(),
      groupId: json['groupId'] as String,
      avatar: json['avatar'] as String?,
    );

Map<String, dynamic> _$$GroupChatInfoMessageNotReadImplToJson(
        _$GroupChatInfoMessageNotReadImpl instance) =>
    <String, dynamic>{
      'countMessageNotRead': instance.countMessageNotRead,
      'groupId': instance.groupId,
      'avatar': instance.avatar,
    };
