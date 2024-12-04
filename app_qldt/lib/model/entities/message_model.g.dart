// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'message_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$MessageModelImpl _$$MessageModelImplFromJson(Map<String, dynamic> json) =>
    _$MessageModelImpl(
      messageId: json['message_id'] as String,
      user: MessageUserModel.fromJson(json['user'] as Map<String, dynamic>),
      message: json['message'] as String?,
      createdAt: json['created_at'] as String,
      unread: (json['unread'] as num).toInt(),
    );

Map<String, dynamic> _$$MessageModelImplToJson(_$MessageModelImpl instance) =>
    <String, dynamic>{
      'messageId': instance.messageId,
      'user': instance.user.toJson(),
      'message': instance.message,
      'createdAt': instance.createdAt,
      'unread': instance.unread,
    };

_$MessageUserModelImpl _$$MessageUserModelImplFromJson(
        Map<String, dynamic> json) =>
    _$MessageUserModelImpl(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      avatar: json['avatar'] as String?,
      firstName: json['firstName'] as String?,
      lastName: json['lastName'] as String?,
      email: json['email'] as String?,
    );

Map<String, dynamic> _$$MessageUserModelImplToJson(
        _$MessageUserModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'avatar': instance.avatar,
      'firstName': instance.firstName,
      'lastName': instance.lastName,
      'email': instance.email,
    };
