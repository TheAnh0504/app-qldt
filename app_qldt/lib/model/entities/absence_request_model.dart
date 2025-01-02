import 'package:freezed_annotation/freezed_annotation.dart';

part "absence_request_model.freezed.dart";
part "absence_request_model.g.dart";
@freezed
class AbsenceRequestModel with _$AbsenceRequestModel {
  @JsonSerializable(explicitToJson: true)
  const factory AbsenceRequestModel(
      {required String id,
        required String absence_date,
        required String title,
        required String reason,
        required String status,
        String? class_id,
        String? file_url,
        Map<String, dynamic>? student_account
      }) = _AbsenceRequestModel;

  factory AbsenceRequestModel.fromJson(Map<String, dynamic> json) =>
      _$AbsenceRequestModelFromJson(json);
}