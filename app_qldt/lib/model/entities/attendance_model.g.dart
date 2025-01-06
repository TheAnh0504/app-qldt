// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'attendance_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AttendanceModelImpl _$$AttendanceModelImplFromJson(
        Map<String, dynamic> json) =>
    _$AttendanceModelImpl(
      attendance_id: json['attendance_id'] as String,
      student_id: json['student_id'] as String,
      status: json['status'] as String,
      class_id: json['class_id'] as String?,
    );

Map<String, dynamic> _$$AttendanceModelImplToJson(
        _$AttendanceModelImpl instance) =>
    <String, dynamic>{
      'attendance_id': instance.attendance_id,
      'student_id': instance.student_id,
      'status': instance.status,
      'class_id': instance.class_id,
    };
