import "dart:async";
// provider sử dụng Riverpod - gói quản lý trạng thái trong Flutter
import "package:app_qldt/controller/messaging_provider.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:app_qldt/controller/user_provider.dart";
import "package:app_qldt/core/error/error.dart";
import "package:app_qldt/core/common/types.dart";
import "package:app_qldt/model/entities/account_model.dart";
import "package:app_qldt/model/repositories/auth_repository.dart";
import "package:app_qldt/controller/verify_code_provider.dart";

import "../model/repositories/messaging_repository.dart";
import "../view/pages/home_skeleton.dart";
import "list_class_provider.dart";

final checkExpiredToken =
AsyncNotifierProvider<CheckExpiredTokenNotifier, bool?>(
    CheckExpiredTokenNotifier.new);
// chơi ko đồng bộ: call api, get data from database
class CheckExpiredTokenNotifier extends AsyncNotifier<bool?> {
  // hàm khởi tạo cho AsyncNotifier, đc gọi khi provider được khởi tạo
  @override
  Future<bool?> build() async {
    // khởi tạo null cho AccountModel khi ứng dụng run
    return null;
  }
  // update state với AccountModel mới
  void forward(AsyncValue<bool?> value) => state = value;
}

// là 1 provider ko đồng bộ (asynchronous provider) cung cấp trạng thái của 1 AccountModel và update khi cần
// accountProvider lắng nghe sự thay đổi của AccountModel, từ đó cập nhật UI hoặc làm cái khác
final accountProvider =
    AsyncNotifierProvider<AsyncAccountNotifier, AccountModel?>(
        AsyncAccountNotifier.new);
// chơi ko đồng bộ: call api, get data from database
class AsyncAccountNotifier extends AsyncNotifier<AccountModel?> {
  // hàm khởi tạo cho AsyncNotifier, đc gọi khi provider được khởi tạo
  @override
  Future<AccountModel?> build() async {
    // khởi tạo null cho AccountModel khi ứng dụng run
    return null;
  }

  Future<void> login(String email, String password) async {
    // đặt trạng thái provider sang loading, biểu thị ứng dụng đang xử lý đăng nhập
    state = const AsyncValue.loading();
    try {
      // Lấy authRepositoryProvider không đồng bộ, trả về authRepository,
      // chứa các phương thức API và dữ liệu cục bộ.
      var authRepository = (await ref.read(authRepositoryProvider.future));
      state = await authRepository.api
          .login(email, password)
          .then<AsyncValue<AccountModel?>>((value) async {
            final account = AccountModel(
                email: value["data"]["email"],
                password: password,
                idAccount: value["data"]["id"],
                ho: value["data"]["ho"],
                ten: value["data"]["ten"],
                name: value["data"]["name"],
                accessToken: value["data"]["token"],
                role: value["data"]["role"],
                status: value["data"]["status"],
                avatar: value["data"]["avatar"] ?? "",
                classList: value["data"]["class_list"]
            );
            authRepository.local.updateAccount(account);
            authRepository.local.updateCurrentAccount(account);
            authRepository.local.updateCheckTokenExpired(true);
            authRepository.local.updateToken(value["data"]["token"]);
            ref.read(checkExpiredToken.notifier).forward(const AsyncData(true));
            // 1 data success from async
            return AsyncData(account);
          });
    // bắt lỗi Map<String, dynamic> map
    } on Map<String, dynamic> catch (map) {
      // if (map["code"] == 1000 && map["type"] == "firstLogin") {
      //   var authRepository = (await ref.read(authRepositoryProvider.future));
      //   authRepository.local.updateToken(map["data"]["token"]);
      //   // tạo ra 1 micro-task để thực thi 1 đoạn mã ko đồng bộ, sau đó mới call return
      //   Future.microtask(() async {
      //     await ref.read(verifyCodeProvider(VerifyCodeType.first_login).notifier).getVerifyCode();
      //     // 1 error from async
      //     state = AsyncError("Đã yêu cầu đăng nhập lần đầu thành công. Hãy đợi phê duyệt.",StackTrace.current);
      //   });
      //   return;
      // }
      // if (map["code"] == 1000 && map["type"] == "unlockAccount") {
      //   var authRepository = (await ref.read(authRepositoryProvider.future));
      //   authRepository.local.updateToken(map["data"]["token"]);
      //   Future.microtask(() async {
      //     await ref.read(verifyCodeProvider(VerifyCodeType.unlock_acc).notifier).getVerifyCode();
      //     state = AsyncError("Đã yêu cầu mở khóa tài khoản thành công.", StackTrace.current);
      //   });
      //   return;
      // }
      state = AsyncError(errorMap[map["code"]].toString(), StackTrace.current);
    }
  }

  Future<AccountModel?> getUserInfo(String id) async {
    try {
      var authRepository = (await ref.read(authRepositoryProvider.future));
      AccountModel response = const AccountModel();
      await authRepository.api.getUserInfo(id).then((value) {
        final account = AccountModel(
            email: value["data"]["email"],
            idAccount: value["data"]["id"],
            ho: value["data"]["ho"],
            ten: value["data"]["ten"],
            name: value["data"]["name"],
            role: value["data"]["role"],
            status: value["data"]["status"],
            avatar: value["data"]["avatar"] ?? "",
        );
        response = account;
      });
      return response;
      // bắt lỗi Map<String, dynamic> map
    } on Map<String, dynamic> catch (map) {
      return null;
    }
  }

  // update state với AccountModel mới
  void forward(AsyncValue<AccountModel?> value) => state = value;

  Future<void> fastLogin(AccountModel account1) async {
    var repo = (await ref.read(authRepositoryProvider.future));
      await repo.api
          .login(account1.email, account1.password)
          .then((value) async {
        final account = AccountModel(
            email: value["data"]["email"],
            password: account1.password,
            idAccount: value["data"]["id"],
            ho: value["data"]["ho"],
            ten: value["data"]["ten"],
            name: value["data"]["name"],
            accessToken: value["data"]["token"],
            role: value["data"]["role"],
            status: value["data"]["status"],
            avatar: value["data"]["avatar"] ?? "",
            classList: value["data"]["class_list"]
        );
        await repo.local.updateCurrentAccount(account);
        await repo.local.updateCheckTokenExpired(true);
        await repo.local.updateAccount(account);
        await repo.local.updateToken(value["data"]["token"]);
        ref.read(checkExpiredToken.notifier).forward(const AsyncData(true));
        state = AsyncValue.data(account);
      });
  }

  Future<void> logout({required bool isSaved}) async {
    var repo = (await ref.read(authRepositoryProvider.future));
    try {
      if (!isSaved) {
        await repo.api.logout();
      } else {
        repo.local.updateAccount(repo.local.readCurrentAccount()!.copyWith(saved: true));
      }
    } finally {
      deleteCurrentInfo();
      // Tạo một tác vụ không đồng bộ để làm mới thông tin người dùng và tự hủy (invalidate) provider hiện tại:
      Future(() {
        ref.invalidate(checkExpiredToken);
        ref.invalidate(userProvider);
        ref.invalidate(groupChatProvider);
        ref.invalidate(messagesProvider);
        ref.invalidate(countNotificationProvider);
        ref.invalidate(checkCountProvider);
        ref.invalidate(countProvider);
        ref.invalidate(searchGroupChatProvider);
        ref.invalidate(listAccountProvider);
        ref.invalidate(messagingRepositoryProvider);
        ref.invalidate(listClassRegisterNowProvider);
        ref.invalidate(listClassProvider);
        ref.invalidate(listClassAllProvider);
        ref.invalidate(infoClassDataProvider);
        ref.invalidateSelf();
      });
    }
  }

  Future<void> deleteCurrentInfo() async {
    var repo = (await ref.read(authRepositoryProvider.future));
    repo..local.deleteCurrentAccount()..local.deleteToken()..local.deleteCheckTokenExpired();
  }
}

// autoDispose: chế độ tự hủy - khi ko còn bất kỳ listener nào (ví dụ: không còn widget nào sử dụng provider này)
// trạng thái của provider sẽ bị hủy và tài nguyên sẽ được giải phóng.
final lockAccountProvider =
    AsyncNotifierProvider.autoDispose<AsyncLockAccountNotifier, void>(
        AsyncLockAccountNotifier.new);
// Class này kế thừa từ AutoDisposeAsyncNotifier<void>, nghĩa là nó sẽ quản lý
// trạng thái bất đồng bộ và tự động giải phóng tài nguyên khi không còn cần thiết.
class AsyncLockAccountNotifier extends AutoDisposeAsyncNotifier<void> {
  @override
  FutureOr<void> build() {
    return null;
  }

  // khóa tài khoản
  Future<void> lock() async {
    state = const AsyncValue.loading();
    try {
      var repo = (await ref.read(authRepositoryProvider.future));
      await repo.api.lockAccount().then((value) {
        state = AsyncData(() {}());
      });
      await ref.read(accountProvider.notifier).logout(isSaved: false);
    } on Map<String, dynamic> catch (map) {
      state = AsyncError(errorMap[map["code"]].toString(), StackTrace.current);
    }
  }
}
