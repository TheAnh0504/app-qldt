// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'class_info_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ClassInfoModelImpl _$$ClassInfoModelImplFromJson(Map<String, dynamic> json) =>
    _$ClassInfoModelImpl(
      class_id: json['class_id'] as String,
      class_name: json['class_name'] as String,
      attached_code: json['attached_code'] as String?,
      class_type: json['class_type'] as String,
      lecturer_name: json['lecturer_name'] as String,
      lecturer_account_id: json['lecturer_account_id'] as String,
      student_count: json['student_count'] as String,
      start_date: json['start_date'] as String,
      end_date: json['end_date'] as String,
      status: json['status'] as String,
      status_register: json['status_register'] as String?,
      student_accounts: (json['student_accounts'] as List<dynamic>?)
          ?.map((e) => e as Map<String, dynamic>)
          .toList(),
    );

Map<String, dynamic> _$$ClassInfoModelImplToJson(
        _$ClassInfoModelImpl instance) =>
    <String, dynamic>{
      'class_id': instance.class_id,
      'class_name': instance.class_name,
      'attached_code': instance.attached_code,
      'class_type': instance.class_type,
      'lecturer_name': instance.lecturer_name,
      'lecturer_account_id': instance.lecturer_account_id,
      'student_count': instance.student_count,
      'start_date': instance.start_date,
      'end_date': instance.end_date,
      'status': instance.status,
      'status_register': instance.status_register,
      'student_accounts': instance.student_accounts,
    };
