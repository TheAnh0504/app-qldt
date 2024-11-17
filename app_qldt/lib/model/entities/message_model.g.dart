// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'message_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$MessageModelImpl _$$MessageModelImplFromJson(Map<String, dynamic> json) =>
    _$MessageModelImpl(
      id: json['id'] as String,
      user: MessageUserModel.fromJson(json['user'] as Map<String, dynamic>),
      message: json['message'] as String?,
      media: json['media'] as String?,
      isRead: json['isRead'] as List<dynamic>?,
      createdAt: json['createdAt'] as String,
      updatedAt: json['updatedAt'] as String,
    );

Map<String, dynamic> _$$MessageModelImplToJson(_$MessageModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'user': instance.user.toJson(),
      'message': instance.message,
      'media': instance.media,
      'isRead': instance.isRead,
      'createdAt': instance.createdAt,
      'updatedAt': instance.updatedAt,
    };

_$MessageUserModelImpl _$$MessageUserModelImplFromJson(
        Map<String, dynamic> json) =>
    _$MessageUserModelImpl(
      userId: json['userId'] as String,
      displayName: json['displayName'] as String,
      avatar: json['avatar'] as String?,
    );

Map<String, dynamic> _$$MessageUserModelImplToJson(
        _$MessageUserModelImpl instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'displayName': instance.displayName,
      'avatar': instance.avatar,
    };
