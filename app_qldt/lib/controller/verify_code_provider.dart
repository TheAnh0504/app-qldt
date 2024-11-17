// ignore_for_file: constant_identifier_names

import "dart:async";

import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:app_qldt/core/error/error.dart";
import "package:app_qldt/core/common/types.dart";
import "package:app_qldt/model/repositories/auth_repository.dart";
import "package:app_qldt/controller/security_provider.dart";

final verifyCodeProvider = AsyncNotifierProvider.autoDispose
    .family<AsyncVerifyCodeNotifier, VerifyCodeState, VerifyCodeType>(
        AsyncVerifyCodeNotifier.new);

class AsyncVerifyCodeNotifier
    extends AutoDisposeFamilyAsyncNotifier<VerifyCodeState, VerifyCodeType> {
  @override
  FutureOr<VerifyCodeState> build(VerifyCodeType arg) {
    return VerifyCodeState.init;
  }

  Future<void> getVerifyCode() async {
    final link = ref.keepAlive();
    try {
      state = const AsyncLoading();
      final repo = await ref.read(authRepositoryProvider.future);
      await repo.api.getVerifyCode(arg.name).then((value) {
        print("code: $value");
        state = const AsyncData(VerifyCodeState.sent);
      });
    } on Map<String, dynamic> catch (map) {
      state = AsyncError(map, StackTrace.current);
    }
    link.close();
  }

  Future<void> checkVerifyCode(String verifyCode) async {
    final link = ref.keepAlive();
    try {
      state = const AsyncLoading();
      final repo = (await ref.read(authRepositoryProvider.future));
      await repo.api
          .checkVerifyCode(verifyCode, arg.name)
          .then((value) => state = const AsyncData(VerifyCodeState.success));
      if (arg == VerifyCodeType.first_login) {
        ref.invalidate(securityNotificationProvider);
      }
    } on Map<String, dynamic> catch (map) {
      state = AsyncError(
          errorMap[map["code"]] ?? "Lỗi không xác định.", StackTrace.current);
    }
    link.close();
  }
}
