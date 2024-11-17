import 'package:freezed_annotation/freezed_annotation.dart';

part "message_model.freezed.dart";
part "message_model.g.dart";

@freezed
class MessageModel with _$MessageModel {
  @JsonSerializable(explicitToJson: true)
  const factory MessageModel(
      {required String id,
      required MessageUserModel user,
      String? message,
      String? media,
      List<dynamic>? isRead,
      required String createdAt,
      required String updatedAt}) = _MessageModel;
}

@freezed
class MessageUserModel with _$MessageUserModel {
  @JsonSerializable(explicitToJson: true)
  const factory MessageUserModel(
      {required String userId,
      required String displayName,
      String? avatar}) = _MessageUserModel;

  factory MessageUserModel.fromJson(Map<String, dynamic> json) =>
      _$MessageUserModelFromJson(json);
}
