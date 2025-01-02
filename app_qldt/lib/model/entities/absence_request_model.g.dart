// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'absence_request_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AbsenceRequestModelImpl _$$AbsenceRequestModelImplFromJson(
        Map<String, dynamic> json) =>
    _$AbsenceRequestModelImpl(
      id: json['id'] as String,
      absence_date: json['absence_date'] as String,
      title: json['title'] as String,
      reason: json['reason'] as String,
      status: json['status'] as String,
      class_id: json['class_id'] as String?,
      file_url: json['file_url'] as String?,
      student_account: json['student_account'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$$AbsenceRequestModelImplToJson(
        _$AbsenceRequestModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'absence_date': instance.absence_date,
      'title': instance.title,
      'reason': instance.reason,
      'status': instance.status,
      'class_id': instance.class_id,
      'file_url': instance.file_url,
      'student_account': instance.student_account,
    };
