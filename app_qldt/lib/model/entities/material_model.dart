import 'package:freezed_annotation/freezed_annotation.dart';

part "material_model.freezed.dart";
part "material_model.g.dart";
@freezed
class MaterialModel with _$MaterialModel {
  @JsonSerializable(explicitToJson: true)
  const factory MaterialModel(
      {required String id,
        required String class_id,
        required String material_name,
        required String description,
        required String material_type,
        String? material_link,
      }) = _MaterialModel;

  factory MaterialModel.fromJson(Map<String, dynamic> json) =>
      _$MaterialModelFromJson(json);
}