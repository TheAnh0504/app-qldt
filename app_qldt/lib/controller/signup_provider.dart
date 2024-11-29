import "dart:io";

import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:app_qldt/core/error/error.dart";
import "package:app_qldt/core/common/types.dart";
import "package:app_qldt/model/entities/account_model.dart";
import "package:app_qldt/model/repositories/auth_repository.dart";
import "package:app_qldt/model/repositories/media_repository.dart";
import "package:app_qldt/controller/account_provider.dart";
import "package:app_qldt/controller/verify_code_provider.dart";

final signupProvider =
    AsyncNotifierProvider.autoDispose<AsyncSignupNotifier, void>(
        AsyncSignupNotifier.new);

class AsyncSignupNotifier extends AutoDisposeAsyncNotifier<void> {
  @override
  void build() {}

  Future<void> signup(String ho, String ten, String email, String password, String role) async {
    state = const AsyncValue.loading();
    try {
      ref.read(accountProvider.notifier).forward(const AsyncValue.loading());
      var repo = (await ref.read(authRepositoryProvider.future));
      await repo.api.signup(ho, ten, email, password, role).then((value) async {
        final account = AccountModel(
            email: email,
            password: password,
            ho: ho,
            ten: ten,
            accessToken: "signup",
            role: role,
            verifyCode: value["verify_code"]
        );
        await repo.local.updateCurrentAccount(account);
        Future(() {
          // ref
          //     .read(verifyCodeProvider(VerifyCodeType.add_user).notifier)
          //     .getVerifyCode();
          ref.read(accountProvider.notifier).forward(AsyncData(account));
        });
      });
    } on Map<String, dynamic> catch (map) {
      ref.read(accountProvider.notifier).forward(
          AsyncError(errorMap[map["code"]].toString(), StackTrace.current));
    }
  }
}

final changeInfoAfterSignupProvider =
    AsyncNotifierProvider.autoDispose<AsyncChangeInfoAfterSignupNotifier, void>(
        AsyncChangeInfoAfterSignupNotifier.new);

class AsyncChangeInfoAfterSignupNotifier
    extends AutoDisposeAsyncNotifier<void> {
  @override
  void build() {}

  Future<void> changeInfoAfterSignup(
      {
      File? avatar}) async {
    state = const AsyncValue.loading();
    try {
      var repo = (await ref.read(authRepositoryProvider.future));
      if (avatar == null) {
        final account = repo.local.readCurrentAccount()?.copyWith(avatar: "");
        repo.local.updateCurrentAccount(account!);
        repo.local.updateAccount(account);
        ref.read(accountProvider.notifier).forward(AsyncData(account));
      } else {
        var avatarUpload =  await ref.read(mediaRepositoryProvider).api.addImage(avatar);
        final account = repo.local.readCurrentAccount()?.copyWith(avatar: avatarUpload);
        repo.local.updateCurrentAccount(account!);
        repo.local.updateAccount(account);
        ref.read(accountProvider.notifier).forward(AsyncData(account));
      }
    } on Map<String, dynamic> catch (map) {
      ref.read(accountProvider.notifier).forward(
          AsyncError(errorMap[map["code"]].toString(), StackTrace.current));
    }
  }
}
