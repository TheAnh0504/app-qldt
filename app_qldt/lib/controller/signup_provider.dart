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
            ho: ho,
            ten: ten,
            accessToken: "signup",
            role: role,
            verifyCode: value["verify_code"]
        );
        await repo.local.updateAccount(account);
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
      {required String firstName,
      required String lastName,
      required String phoneNumber,
      required String address,
      required DateTime dateOfBirth,
      required String gender,
      File? avatar,
      String? email}) async {
    state = const AsyncValue.loading();
    try {
      var repo = (await ref.read(authRepositoryProvider.future));
      var avatarUpload = avatar == null
          ? null
          : await ref.read(mediaRepositoryProvider).api.addImage(avatar);

      await repo.api
          .changeInfoAfterSignup(
              firstName: firstName,
              lastName: lastName,
              phoneNumber: phoneNumber,
              address: address,
              dateOfBirth: dateOfBirth,
              gender: gender,
              avatar: avatarUpload,
              email: email)
          .then((value) {
        // final account = ref.read(accountProvider).value!.copyWith(statusAccount: AccountStatus.ACTIVE);
        final account = ref.read(accountProvider).value!;
        repo.local.updateCurrentAccount(account);
        ref.read(accountProvider.notifier).forward(AsyncData(account));
      });
    } on Map<String, dynamic> catch (map) {
      ref.read(accountProvider.notifier).forward(
          AsyncError(errorMap[map["code"]].toString(), StackTrace.current));
    }
  }
}
