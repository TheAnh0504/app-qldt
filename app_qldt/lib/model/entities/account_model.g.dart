// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'account_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AccountModelImpl _$$AccountModelImplFromJson(Map<String, dynamic> json) =>
    _$AccountModelImpl(
      username: json['username'] as String,
      accessToken: json['accessToken'] as String,
      refreshToken: json['refreshToken'] as String,
      statusAccount: json['statusAccount'] == null
          ? AccountStatus.NO
          : const _AccountStatusConverter()
              .fromJson(json['statusAccount'] as String),
      avatar: json['avatar'] as String?,
      saved: json['saved'] as bool? ?? false,
    );

Map<String, dynamic> _$$AccountModelImplToJson(_$AccountModelImpl instance) =>
    <String, dynamic>{
      'username': instance.username,
      'accessToken': instance.accessToken,
      'refreshToken': instance.refreshToken,
      'statusAccount':
          const _AccountStatusConverter().toJson(instance.statusAccount),
      'avatar': instance.avatar,
      'saved': instance.saved,
    };
