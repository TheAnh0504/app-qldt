// ignore_for_file: constant_identifier_names

import "dart:async";

import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:app_qldt/core/error/error.dart";
import "package:app_qldt/core/common/types.dart";
import "package:app_qldt/model/repositories/auth_repository.dart";
import "package:app_qldt/controller/security_provider.dart";

import "../model/entities/account_model.dart";
import "account_provider.dart";

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
      var authRepository = (await ref.read(authRepositoryProvider.future));
      await repo.api.getVerifyCode(ref.watch(accountProvider).value!.email, ref.watch(accountProvider).value!.password).then((value) {
        print("code: $value");
        var account = authRepository.local.readCurrentAccount()?.copyWith(verifyCode: value["verify_code"]);
        authRepository.local.updateCurrentAccount(account!);
        authRepository.local.updateCheckTokenExpired(true);
        ref.read(checkExpiredToken.notifier).forward(const AsyncData(true));
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
          .checkVerifyCode(verifyCode, repo.local.readCurrentAccount()!.email)
          .then((value) => state = const AsyncData(VerifyCodeState.success));
    } on Map<String, dynamic> catch (map) {
      state = AsyncError(
          errorMap[map["code"]] ?? "Lỗi không xác định.", StackTrace.current);
    }
    link.close();
  }
}
