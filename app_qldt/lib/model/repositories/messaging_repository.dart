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

  Future<List<GroupChatModel>> getListGroup(int offset) {
    return swapi.getListGroup(offset: offset).then((value) {
      if (value["code"] == 1000) {
        var listGroupChat = <GroupChatModel>[];
        for (int i = 0;
            i < (value["data"]["infoGroup"] as List<dynamic>).length;
            i++) {
          listGroupChat.add(GroupChatModel(
              infoGroup: GroupChatInfoModel.fromJson(
                  (value["data"]["infoGroup"] as List<dynamic>)[i]),
              infoMessageNotRead: GroupChatInfoMessageNotRead.fromJson(
                  (value["data"]["infoMessageNotRead"] as List<dynamic>)[i])));
        }
        return listGroupChat;
      }
      throw value;
    });
  }

  Future<List<MessageModel>> getMessage(String groupId, int offset) {
    return swapi.getMessage(groupId: groupId, offset: offset).then((value) {
      if (value["code"] == 1000) {
        var listMessage = <MessageModel>[];
        var listUsers = <MessageUserModel>[];
        for (int i = 0;
            i < (value["data"]["infoUsers"] as List<dynamic>).length;
            i++) {
          listUsers
              .add(MessageUserModel.fromJson(value["data"]["infoUsers"][i]));
        }
        for (int i = 0;
            i < (value["data"]["infoMessages"] as List<dynamic>).length;
            i++) {
          listMessage.add(MessageModel(
              id: value["data"]["infoMessages"][i]["id"],
              user: listUsers.firstWhere((e) =>
                  e.userId == value["data"]["infoMessages"][i]["userId"]),
              message: value["data"]["infoMessages"][i]["message"],
              media: value["data"]["infoMessages"][i]["media"],
              isRead: value["data"]["infoMessages"][i]["isRead"],
              createdAt: value["data"]["infoMessages"][i]["createdAt"],
              updatedAt: value["data"]["infoMessages"][i]["updatedAt"]));
        }
        return listMessage;
      }
      throw value;
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

  Future<Map<String, dynamic>> addGroupChat(
      {String? groupName,
      required List<String> listUserId,
      List<String> listAdmin = const [],
      required String type}) {
    return swapi
        .addNewGroupChat(
            groupName: groupName,
            listUserId: listUserId,
            listAdmin: listAdmin,
            type: type)
        .then((value) {
      if (value["code"] == 1000) return value;
      throw value;
    });
  }
}
