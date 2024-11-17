import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:app_qldt/model/entities/group_chat_model.dart';
import 'package:app_qldt/model/entities/message_model.dart';
import 'package:app_qldt/model/repositories/messaging_repository.dart';

final groupChatProvider =
    FutureProvider.family<List<GroupChatModel>, int>((ref, offset) {
  return ref.read(messagingRepositoryProvider).api.getListGroup(offset);
});

final messagesProvider =
    FutureProvider.family<List<MessageModel>, (String, int)>((ref, params) {
  return ref
      .read(messagingRepositoryProvider)
      .api
      .getMessage(params.$1, params.$2);
});

final addMessageProvider = AsyncNotifierProvider.autoDispose
    .family<AddMessageProvider, void, (String, String?, String?)>(
        AddMessageProvider.new);

class AddMessageProvider
    extends AutoDisposeFamilyAsyncNotifier<void, (String, String?, String?)> {
  @override
  FutureOr<void> build((String, String?, String?) arg) async {
    await ref
        .read(messagingRepositoryProvider)
        .api
        .addMessage(arg.$1, message: arg.$2, media: arg.$3);
  }
}

final addGroupChatProvider = AsyncNotifierProvider.autoDispose.family<
    AddGroupChatProvider,
    void,
    (String?, List<String>, List<String>?, String)>(AddGroupChatProvider.new);

class AddGroupChatProvider extends AutoDisposeFamilyAsyncNotifier<void,
    (String?, List<String>, List<String>?, String)> {
  @override
  FutureOr<void> build(
      (String?, List<String>, List<String>?, String) arg) async {
    await ref.read(messagingRepositoryProvider).api.addGroupChat(
        groupName: arg.$1,
        listUserId: arg.$2,
        listAdmin: arg.$3 ?? [],
        type: arg.$4);
  }
}
