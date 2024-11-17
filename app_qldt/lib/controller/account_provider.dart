import "dart:async";
// provider sử dụng Riverpod - gói quản lý trạng thái trong Flutter
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:app_qldt/controller/user_provider.dart";
import "package:app_qldt/core/error/error.dart";
import "package:app_qldt/core/common/types.dart";
import "package:app_qldt/model/entities/account_model.dart";
import "package:app_qldt/model/repositories/auth_repository.dart";
import "package:app_qldt/controller/verify_code_provider.dart";
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

  Future<void> login(String username, String password) async {
    // đặt trạng thái provider sang loading, biểu thị ứng dụng đang xử lý đăng nhập
    state = const AsyncValue.loading();
    try {
      // Lấy authRepositoryProvider không đồng bộ, trả về authRepository,
      // chứa các phương thức API và dữ liệu cục bộ.
      var authRepository = (await ref.read(authRepositoryProvider.future));
      state = await authRepository.api
          .login(username, password)
          .then<AsyncValue<AccountModel?>>((value) async {
            final account = AccountModel(
                username: username,
                accessToken: value["data"]["accessToken"],
                refreshToken: value["data"]["refreshToken"],
                statusAccount: AccountStatus.values.firstWhere((e) => e.name == value["data"]["statusAccount"])
            );
            authRepository.local.updateAccount(account);
            authRepository.local.updateCurrentAccount(account);
            authRepository.local.updateToken(value["data"]["accessToken"], value["data"]["refreshToken"]);
            // 1 data success from async
            return AsyncData(account);
          });
    // bắt lỗi Map<String, dynamic> map
    } on Map<String, dynamic> catch (map) {
      if (map["code"] == 1000 && map["type"] == "firstLogin") {
        var authRepository = (await ref.read(authRepositoryProvider.future));
        authRepository.local.updateToken(map["data"]["accessToken"], map["data"]["refreshToken"]);
        // tạo ra 1 micro-task để thực thi 1 đoạn mã ko đồng bộ, sau đó mới call return
        Future.microtask(() async {
          await ref.read(verifyCodeProvider(VerifyCodeType.first_login).notifier).getVerifyCode();
          // 1 error from async
          state = AsyncError("Đã yêu cầu đăng nhập lần đầu thành công. Hãy đợi phê duyệt.",StackTrace.current);
        });
        return;
      }
      if (map["code"] == 1000 && map["type"] == "unlockAccount") {
        var authRepository = (await ref.read(authRepositoryProvider.future));
        authRepository.local.updateToken(map["data"]["accessToken"], map["data"]["refreshToken"]);
        Future.microtask(() async {
          await ref.read(verifyCodeProvider(VerifyCodeType.unlock_acc).notifier).getVerifyCode();
          state = AsyncError("Đã yêu cầu mở khóa tài khoản thành công.", StackTrace.current);
        });
        return;
      }
      state = AsyncError(errorMap[map["code"]].toString(), StackTrace.current);
    }
  }

  // update state với AccountModel mới
  void forward(AsyncValue<AccountModel?> value) => state = value;

  Future<void> fastLogin(AccountModel account) async {
    var repo = (await ref.read(authRepositoryProvider.future));
    await repo.local.updateCurrentAccount(account.copyWith(statusAccount: AccountStatus.ACTIVE));
    await repo.local.updateAccount(account);
    await repo.local.updateToken(account.accessToken, account.refreshToken);
    state = AsyncValue.data(repo.local.readCurrentAccount());
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
        ref.invalidate(userProvider);
        ref.invalidateSelf();
      });
    }
  }

  Future<void> deleteCurrentInfo() async {
    var repo = (await ref.read(authRepositoryProvider.future));
    repo..local.deleteCurrentAccount()..local.deleteToken();
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
