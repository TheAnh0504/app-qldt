import 'package:freezed_annotation/freezed_annotation.dart';

part "group_chat_model.freezed.dart";
part "group_chat_model.g.dart";

@freezed
class GroupChatModel with _$GroupChatModel {
  @JsonSerializable(explicitToJson: true)
  const factory GroupChatModel(
          {required GroupChatInfoModel infoGroup,
          required GroupChatInfoMessageNotRead infoMessageNotRead}) =
      _GroupChatModel;

  factory GroupChatModel.fromJson(Map<String, dynamic> json) =>
      _$GroupChatModelFromJson(json);
}

@freezed
class GroupChatInfoModel with _$GroupChatInfoModel {
  const factory GroupChatInfoModel(
      {required String groupId,
      required Object groupName,
      required List<String> listUserId,
      @Default([]) List<String> listAdmin,
      String? image,
      required String type,
      required String createdAt,
      required String updatedAt}) = _GroupChatInfoModel;

  factory GroupChatInfoModel.fromJson(Map<String, dynamic> json) =>
      _$GroupChatInfoModelFromJson(json);
}

@freezed
class GroupChatInfoMessageNotRead with _$GroupChatInfoMessageNotRead {
  const factory GroupChatInfoMessageNotRead(
      {required int countMessageNotRead,
      required String groupId,
      String? avatar}) = _GroupChatInfoMessageNotRead;

  factory GroupChatInfoMessageNotRead.fromJson(Map<String, dynamic> json) =>
      _$GroupChatInfoMessageNotReadFromJson(json);
}
