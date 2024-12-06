import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:app_qldt/model/datastores/swapi.dart';
import 'package:app_qldt/model/entities/group_chat_model.dart';
import 'package:app_qldt/model/entities/message_model.dart';

final messagingRepositoryProvider = Provider((ref) =>
    MessagingRepository(MessagingApiRepository(ref.watch(swapiProvider))));

class MessagingRepository {
  final MessagingApiRepository api;

  MessagingRepository(this.api);
}

class MessagingApiRepository {
  final SWApi swapi;

  MessagingApiRepository(this.swapi);

  Future<List<GroupChatModel>> getListGroup(int count) {
    return swapi.getListGroup(count).then((value) {
      if (value["meta"]["code"] == "1000") {
        var listGroupChat = <GroupChatModel>[];
        for (int i = 0; i < (value["data"]["conversations"] as List<dynamic>).length; i++) {
          listGroupChat.add(GroupChatModel(
              infoGroup: GroupChatInfoModel.fromJson(
                  (value["data"]["conversations"] as List<dynamic>)[i]),
              infoMessageNotRead: GroupChatInfoMessageNotRead.fromJson(
                  (value["data"]["conversations"] as List<dynamic>)[i]),
              numNewMessage: int.parse(value["data"]["num_new_message"])
          ));
        }
        return listGroupChat;
      }
      return [];
    });
  }

  Future<List<MessageModel>> getMessage(int groupId, int count, String read) {
    return swapi.getMessage(groupId, count, read).then((value) {
      if (value["meta"]["code"] == "1000") {
        var listMessage = <MessageModel>[];
        for (int i = 0; i < (value["data"]["conversation"] as List<dynamic>).length; i++) {
          var user = MessageUserModel(
            id: value["data"]["conversation"][i]["sender"]["id"],
            name: value["data"]["conversation"][i]["sender"]["name"],
            avatar: value["data"]["conversation"][i]["sender"]["avatar"],
          );
          listMessage.add(MessageModel(
              messageId: value["data"]["conversation"][i]["message_id"],
              user: user,
              message: value["data"]["conversation"][i]["message"],
              createdAt: value["data"]["conversation"][i]["created_at"],
              unread: value["data"]["conversation"][i]["unread"]));
        }
        return listMessage;
      }
      return [];
    });
  }

  Future<Map<String, dynamic>> addMessage(String groupId,
      {String? message, String? media}) {
    return swapi
        .addMessage(groupId, message: message, media: media)
        .then((value) {
      if (value["code"] == 1000) return value;
      throw value;
    });
  }

  Future<List<Map<String, dynamic>>> addGroupChat(String? search) {
    return swapi
        .addNewGroupChat(search)
        .then((value) {
      if (value["meta"]["code"] == "1000") return List<Map<String, dynamic>>.from(value["data"]["page_content"]);
      throw value;
    });
  }

  Future<Map<String, dynamic>> getUserInfo(String userId) {
    return swapi.getUserInfo(userId).then((value) async {
      if (value["code"] == "1000") return value["data"];
      throw value;
    });
  }

  Future<bool> deleteMessage(dynamic messageId, dynamic conversationId) {
    return swapi.deleteMessage(messageId, conversationId).then((value) async {
      if (value["meta"]["code"] == "1000") return true;
      throw value;
    });
  }
}
