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
      numNewMessage: (json['numNewMessage'] as num).toInt(),
    );

Map<String, dynamic> _$$GroupChatModelImplToJson(
        _$GroupChatModelImpl instance) =>
    <String, dynamic>{
      'infoGroup': instance.infoGroup.toJson(),
      'infoMessageNotRead': instance.infoMessageNotRead.toJson(),
      'numNewMessage': instance.numNewMessage,
    };

_$GroupChatInfoModelImpl _$$GroupChatInfoModelImplFromJson(
        Map<String, dynamic> json) =>
    _$GroupChatInfoModelImpl(
          groupId: (json['id'] as num).toInt(),
          partnerId: (json['partner']['id'] as num).toInt(),
          partnerName: json['partner']['name'] as String,
          partnerAvatar: json['partner']['avatar'] as String?,
          lastMessageSenderId: (json['last_message']['sender']['id'] as num).toInt(),
          lastMessageSenderName: json['last_message']['sender']['name'] as String,
          lastMessageSenderAvatar: json['last_message']['sender']['avatar'] as String?,
          lastMessageMessage: json['last_message']['message'] as String?,
          lastMessageCreatedAt: json['last_message']['created_at'] as String,
          lastMessageUnRead: (json['last_message']['unread'] as num).toInt(),
          createdAt: json['created_at'] as String,
          updatedAt: json['updated_at'] as String,
    );

Map<String, dynamic> _$$GroupChatInfoModelImplToJson(
        _$GroupChatInfoModelImpl instance) =>
    <String, dynamic>{
      'groupId': instance.groupId,
      'partnerId': instance.partnerId,
      'partnerName': instance.partnerName,
      'partnerAvatar': instance.partnerAvatar,
      'lastMessageSenderId': instance.lastMessageSenderId,
      'lastMessageSenderName': instance.lastMessageSenderName,
      'lastMessageSenderAvatar': instance.lastMessageSenderAvatar,
      'lastMessageMessage': instance.lastMessageMessage,
      'lastMessageCreatedAt': instance.lastMessageCreatedAt,
      'lastMessageUnRead': instance.lastMessageUnRead,
      'createdAt': instance.createdAt,
      'updatedAt': instance.updatedAt,
    };

_$GroupChatInfoMessageNotReadImpl _$$GroupChatInfoMessageNotReadImplFromJson(
        Map<String, dynamic> json) =>
    _$GroupChatInfoMessageNotReadImpl(
          groupId: (json['id'] as num).toInt(),
          partnerId: (json['partner']['id'] as num).toInt(),
          partnerName: json['partner']['name'] as String,
          partnerAvatar: json['partner']['avatar'] as String?,
          lastMessageSenderId: (json['last_message']['sender']['id'] as num).toInt(),
          lastMessageSenderName: json['last_message']['sender']['name'] as String,
          lastMessageSenderAvatar: json['last_message']['sender']['avatar'] as String?,
          lastMessageMessage: json['last_message']['message'] as String?,
          lastMessageCreatedAt: json['last_message']['created_at'] as String,
          lastMessageUnRead: (json['last_message']['unread'] as num).toInt(),
          createdAt: json['created_at'] as String,
          updatedAt: json['updated_at'] as String,
    );

Map<String, dynamic> _$$GroupChatInfoMessageNotReadImplToJson(
        _$GroupChatInfoMessageNotReadImpl instance) =>
    <String, dynamic>{
      'groupId': instance.groupId,
      'partnerId': instance.partnerId,
      'partnerName': instance.partnerName,
      'partnerAvatar': instance.partnerAvatar,
      'lastMessageSenderId': instance.lastMessageSenderId,
      'lastMessageSenderName': instance.lastMessageSenderName,
      'lastMessageSenderAvatar': instance.lastMessageSenderAvatar,
      'lastMessageMessage': instance.lastMessageMessage,
      'lastMessageCreatedAt': instance.lastMessageCreatedAt,
      'lastMessageUnRead': instance.lastMessageUnRead,
      'createdAt': instance.createdAt,
      'updatedAt': instance.updatedAt,
    };
