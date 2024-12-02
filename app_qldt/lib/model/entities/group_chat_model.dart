import 'package:freezed_annotation/freezed_annotation.dart';

part "group_chat_model.freezed.dart";
part "group_chat_model.g.dart";

@freezed
class GroupChatModel with _$GroupChatModel {
  @JsonSerializable(explicitToJson: true)
  const factory GroupChatModel(
          {required GroupChatInfoModel infoGroup,
          required GroupChatInfoMessageNotRead infoMessageNotRead,
            required int numNewMessage}) =
      _GroupChatModel;

  factory GroupChatModel.fromJson(Map<String, dynamic> json) =>
      _$GroupChatModelFromJson(json);
}

@freezed
class GroupChatInfoModel with _$GroupChatInfoModel {
  const factory GroupChatInfoModel(
      {required int groupId, // id of chat
      required int partnerId, // info of người chat vs mình: id, name, avatar
        required String partnerName,
        String? partnerAvatar,
      required int lastMessageSenderId, // last message: sender(id, name, avatar), message, created_at, unread
        required String lastMessageSenderName,
        String? lastMessageSenderAvatar,
        String? lastMessageMessage,
        required String lastMessageCreatedAt,
        required int lastMessageUnRead,
      required String createdAt,
      required String updatedAt}) = _GroupChatInfoModel;

  factory GroupChatInfoModel.fromJson(Map<String, dynamic> json) =>
      _$GroupChatInfoModelFromJson(json);
}

@freezed
class GroupChatInfoMessageNotRead with _$GroupChatInfoMessageNotRead {
  const factory GroupChatInfoMessageNotRead(
      {required int groupId, // id of chat
  required int partnerId, // info of người chat vs mình: id, name, avatar
  required String partnerName,
  String? partnerAvatar,
  required int lastMessageSenderId, // last message: sender(id, name, avatar), message, created_at, unread
  required String lastMessageSenderName,
  String? lastMessageSenderAvatar,
  String? lastMessageMessage,
  required String lastMessageCreatedAt,
  required int lastMessageUnRead,
  required String createdAt,
  required String updatedAt}) = _GroupChatInfoMessageNotRead;

  factory GroupChatInfoMessageNotRead.fromJson(Map<String, dynamic> json) =>
      _$GroupChatInfoMessageNotReadFromJson(json);
}
