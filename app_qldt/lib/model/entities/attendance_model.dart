import 'package:freezed_annotation/freezed_annotation.dart';

part "attendance_model.freezed.dart";
part "attendance_model.g.dart";
@freezed
class AttendanceModel with _$AttendanceModel {
  @JsonSerializable(explicitToJson: true)
  const factory AttendanceModel(
      {required String attendance_id,
        required String student_id,
        required String status,
        String? class_id,
      }) = _AttendanceModel;

  factory AttendanceModel.fromJson(Map<String, dynamic> json) =>
      _$AttendanceModelFromJson(json);
}