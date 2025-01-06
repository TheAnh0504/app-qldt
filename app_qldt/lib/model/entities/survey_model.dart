import 'package:freezed_annotation/freezed_annotation.dart';

part "survey_model.freezed.dart";
part "survey_model.g.dart";
@freezed
class SurveyModel with _$SurveyModel {
  @JsonSerializable(explicitToJson: true)
  const factory SurveyModel(
      {required int id,
         String? title,
         String? description,
        required int lecturer_id,
         String? deadline,
        String? file_url,
        String? class_id,
      }) = _SurveyModel;

  factory SurveyModel.fromJson(Map<String, dynamic> json) =>
      _$SurveyModelFromJson(json);
}