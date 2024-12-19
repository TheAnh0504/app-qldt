import 'package:freezed_annotation/freezed_annotation.dart';

part "class_info_model.freezed.dart";
part "class_info_model.g.dart";
@freezed
class ClassInfoModel with _$ClassInfoModel {
  @JsonSerializable(explicitToJson: true)
  const factory ClassInfoModel(
      {required String class_id,
        required String class_name,
        String? attached_code,
        required String class_type,
        required String lecturer_name,
        required String lecturer_account_id,
        required String student_count,
        required String start_date,
        required String end_date,
        required String status,
        String? status_register
      }) = _ClassInfoModel;

  factory ClassInfoModel.fromJson(Map<String, dynamic> json) =>
      _$ClassInfoModelFromJson(json);
}