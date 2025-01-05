// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'material_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$MaterialModelImpl _$$MaterialModelImplFromJson(Map<String, dynamic> json) =>
    _$MaterialModelImpl(
      id: json['id'] as String,
      class_id: json['class_id'] as String,
      material_name: json['material_name'] as String,
      description: json['description'] as String,
      material_type: json['material_type'] as String,
      material_link: json['material_link'] as String?,
    );

Map<String, dynamic> _$$MaterialModelImplToJson(_$MaterialModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'class_id': instance.class_id,
      'material_name': instance.material_name,
      'description': instance.description,
      'material_type': instance.material_type,
      'material_link': instance.material_link,
    };
