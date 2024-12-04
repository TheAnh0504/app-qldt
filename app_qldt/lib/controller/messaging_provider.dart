import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:app_qldt/model/entities/group_chat_model.dart';
import 'package:app_qldt/model/entities/message_model.dart';
import 'package:app_qldt/model/repositories/messaging_repository.dart';

import '../core/error/error.dart';
import '../model/repositories/auth_repository.dart';
import 'account_provider.dart';

final groupChatProvider =
    FutureProvider.family<List<GroupChatModel>, int>((ref, count) {
  return ref.watch(messagingRepositoryProvider).api.getListGroup(count);
});

final messagesProvider =
    FutureProvider.family<List<MessageModel>, (int, int, String)>((ref, params) {
        return ref.read(messagingRepositoryProvider).api.getMessage(params.$1, params.$2, params.$3);
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

final searchGroupChatProvider = AsyncNotifierProvider.autoDispose
    .family<AddGroupChatProvider, List<Map<String, dynamic>>,
    (String?,)>(AddGroupChatProvider.new);
class AddGroupChatProvider extends AutoDisposeFamilyAsyncNotifier<List<Map<String, dynamic>>, (String?,)> {
  @override
  Future<List<Map<String, dynamic>>> build((String?,) arg) async {
    try {
      // Gọi API và lấy dữ liệu
      List<Map<String, dynamic>> res = await ref.read(messagingRepositoryProvider).api.addGroupChat(arg.$1);

      // Cập nhật state với AsyncData khi có dữ liệu
      state = AsyncData(res);

      // Trả về dữ liệu
      return res;
    } catch (e) {
      rethrow;
    }
  }
}

final listAccountProvider =
AsyncNotifierProvider<AsyncAccountsNotifier, List<Map<String, dynamic>>>(
    AsyncAccountsNotifier.new);
class AsyncAccountsNotifier extends AsyncNotifier<List<Map<String, dynamic>>> {
  // hàm khởi tạo cho AsyncNotifier, đc gọi khi provider được khởi tạo
  @override
  Future<List<Map<String, dynamic>>> build() async {
    // khởi tạo null cho AccountModel khi ứng dụng run
    return [];
  }

  Future<List<Map<String, dynamic>>> getListAccount(String text) async {
    // đặt trạng thái provider sang loading, biểu thị ứng dụng đang xử lý đăng nhập
    state = const AsyncValue.loading();
    try {
      List<Map<String, dynamic>> res = await ref
          .read(messagingRepositoryProvider)
          .api
          .addGroupChat(text);
      state = AsyncData(res);
      // 1 data success from async
      return res;
      // bắt lỗi Map<String, dynamic> map
    } on Map<String, dynamic> catch (map) {
      state = AsyncError(errorMap[map["code"]].toString(), StackTrace.current);
      return [];
    }
  }
}

final getUserInfoProvider = FutureProvider.family<Map<String, dynamic>, String>(
      (ref, userId) async {
    return ref.read(messagingRepositoryProvider).api.getUserInfo(userId);
  },
);

final deleteMessageProvider = FutureProvider.family<bool, Map<String, dynamic>>(
      (ref, data) async {
    return ref.read(messagingRepositoryProvider).api.deleteMessage(data['message_id'], data['conversation_id']);
  },
);
