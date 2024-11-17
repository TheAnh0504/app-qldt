import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:app_qldt/core/common/types.dart';

part 'user_model.freezed.dart';
part 'user_model.g.dart';

@freezed
class UserModel with _$UserModel {
  @JsonSerializable(explicitToJson: true)
  const factory UserModel(
      {required String userId,
      required String firstName,
      required String lastName,
      required String displayName,
      String? email,
      required String phoneNumber,
      required String address,
      required String dateOfBirth,
      @GenderConverter() required Gender gender,
      required String subject,
      String? avatar,
      dynamic school}) = _UserModel;

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);
}
