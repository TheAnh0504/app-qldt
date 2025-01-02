import 'package:freezed_annotation/freezed_annotation.dart';

part "absence_request_model.freezed.dart";
part "absence_request_model.g.dart";
@freezed
class AbsenceRequestModel with _$AbsenceRequestModel {
  @JsonSerializable(explicitToJson: true)
  const factory AbsenceRequestModel(
      {
        List<Map<String, dynamic>>? page_content
      }) = _AbsenceRequestModel;

  factory AbsenceRequestModel.fromJson(Map<String, dynamic> json) =>
      _$AbsenceRequestModelFromJson(json);
}