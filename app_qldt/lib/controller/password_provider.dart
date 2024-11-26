import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:app_qldt/core/error/error.dart';
import 'package:app_qldt/core/common/types.dart';
import 'package:app_qldt/model/entities/account_model.dart';
import 'package:app_qldt/model/repositories/auth_repository.dart';
import 'package:app_qldt/controller/account_provider.dart';
import 'package:app_qldt/controller/verify_code_provider.dart';

final changePasswordProvider =
    AsyncNotifierProvider.autoDispose<AsyncChangePasswordNotifier, void>(
        AsyncChangePasswordNotifier.new);

class AsyncChangePasswordNotifier extends AutoDisposeAsyncNotifier<void> {
  @override
  FutureOr<void> build() {}

  Future<void> changePassword(String oldPassword, String newPassword) async {
    state = const AsyncValue.loading();
    try {
      var repo = (await ref.read(authRepositoryProvider.future));
      await repo.api
          .changePassword(oldPassword, newPassword)
          .then((value) async {
        final account = ref.read(accountProvider).requireValue!.copyWith(password: newPassword);
        repo.local.updateAccount(account);
        Future.microtask(() {
          ref.read(accountProvider.notifier).forward(AsyncData(account));
          state = AsyncData(() {}());
        });
      });
    } on Map<String, dynamic> catch (map) {
      state = AsyncError(errorMap[map["code"]].toString(), StackTrace.current);
    }
  }
}

final forgetPasswordProvider =
    AsyncNotifierProvider.autoDispose<AsyncResetPasswordNotifier, void>(
        AsyncResetPasswordNotifier.new);

class AsyncResetPasswordNotifier extends AutoDisposeAsyncNotifier<void> {
  @override
  FutureOr<void> build() {}

  Future<void> forgetPassword(String email) async {
    state = const AsyncValue.loading();
    try {
      var repo = (await ref.read(authRepositoryProvider.future));
      await repo.api.forgetPassword(email).then((value) async {
        final account = AccountModel(
            email: email,
            accessToken: value["data"]["token"]);
        await repo.local.updateCurrentAccount(account);
        ref.read(accountProvider.notifier).forward(AsyncData(account));
        await repo.local.updateToken(value["data"]["token"]);

        await ref
            .read(verifyCodeProvider(VerifyCodeType.forget_pas).notifier)
            .getVerifyCode();
        state = ref.read(verifyCodeProvider(VerifyCodeType.forget_pas)).hasError
            ? AsyncError("Gửi mã xác nhận thất bại.", StackTrace.current)
            : AsyncData(() {}());
      });
    } on Map<String, dynamic> catch (map) {
      state = AsyncError(errorMap[map["code"]].toString(), StackTrace.current);
    }
  }
}
