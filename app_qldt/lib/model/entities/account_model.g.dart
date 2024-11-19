// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'account_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AccountModelImpl _$$AccountModelImplFromJson(Map<String, dynamic> json) =>
    _$AccountModelImpl(
      id: (json['id'] as num?)?.toInt() ?? 0,
      ho: json['ho'] ?? "",
      ten: json['ten'] as String? ?? "",
      name: json['name'] as String? ?? "",
      email: json['email'] as String? ?? "",
      accessToken: json['accessToken'] as String? ?? "",
      role: json['role'] as String? ?? "",
      status: json['status'] as String? ?? "",
      avatar: json['avatar'] as String? ?? "",
      verifyCode: json['verifyCode'] as String? ?? "",
      classList: json['classList'] as List<dynamic>? ?? const [],
      saved: json['saved'] as bool? ?? false,
    );

Map<String, dynamic> _$$AccountModelImplToJson(_$AccountModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'ho': instance.ho,
      'ten': instance.ten,
      'name': instance.name,
      'email': instance.email,
      'accessToken': instance.accessToken,
      'role': instance.role,
      'status': instance.status,
      'avatar': instance.avatar,
      'verifyCode': instance.verifyCode,
      'classList': instance.classList,
      'saved': instance.saved,
    };
