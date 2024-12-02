import 'package:freezed_annotation/freezed_annotation.dart';

part "message_model.freezed.dart";
part "message_model.g.dart";

@freezed
class MessageModel with _$MessageModel {
  @JsonSerializable(explicitToJson: true)
  const factory MessageModel(
      {required String messageId,
      required MessageUserModel user,
      String? message,
      required String createdAt,
      required int unread}) = _MessageModel;
}

@freezed
class MessageUserModel with _$MessageUserModel {
  @JsonSerializable(explicitToJson: true)
  const factory MessageUserModel(
      {required int id,
      required String name,
      String? avatar}) = _MessageUserModel;

  factory MessageUserModel.fromJson(Map<String, dynamic> json) =>
      _$MessageUserModelFromJson(json);
}
