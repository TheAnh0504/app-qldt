// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'survey_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$SurveyModelImpl _$$SurveyModelImplFromJson(Map<String, dynamic> json) =>
    _$SurveyModelImpl(
      id: (json['id'] as num).toInt(),
      title: json['title'] as String?,
      description: json['description'] as String?,
      lecturer_id: (json['lecturer_id'] as num).toInt(),
      deadline: json['deadline'] as String?,
      file_url: json['file_url'] as String?,
      class_id: json['class_id'] as String?,
    );

Map<String, dynamic> _$$SurveyModelImplToJson(_$SurveyModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'description': instance.description,
      'lecturer_id': instance.lecturer_id,
      'deadline': instance.deadline,
      'file_url': instance.file_url,
      'class_id': instance.class_id,
    };
