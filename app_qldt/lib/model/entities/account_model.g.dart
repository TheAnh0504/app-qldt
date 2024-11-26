// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'account_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AccountModelImpl _$$AccountModelImplFromJson(Map<String, dynamic> json) =>
    _$AccountModelImpl(
      idAccount: json['idAccount'] as String? ?? "",
      ho: json['ho'] as String? ?? "",
      ten: json['ten'] as String? ?? "",
      name: json['name'] as String? ?? "",
      email: json['email'] as String? ?? "",
      password: json['password'] as String? ?? "",
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
      'idAccount': instance.idAccount,
      'ho': instance.ho,
      'ten': instance.ten,
      'name': instance.name,
      'email': instance.email,
      'password': instance.password,
      'accessToken': instance.accessToken,
      'role': instance.role,
      'status': instance.status,
      'avatar': instance.avatar,
      'verifyCode': instance.verifyCode,
      'classList': instance.classList,
      'saved': instance.saved,
    };
