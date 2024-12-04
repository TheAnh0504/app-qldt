import 'dart:async';
import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:app_qldt/core/extension/extension.dart';
import 'package:app_qldt/core/common/types.dart';
import 'package:app_qldt/model/entities/post_model.dart';
import 'package:app_qldt/model/entities/user_model.dart';
import 'package:app_qldt/model/repositories/media_repository.dart';
import 'package:app_qldt/model/repositories/user_repository.dart';

final userProvider =
    AsyncNotifierProvider.autoDispose<AsyncUserProvider, UserModel>(
        AsyncUserProvider.new);

class AsyncUserProvider extends AutoDisposeAsyncNotifier<UserModel> {
  @override
  FutureOr<UserModel> build() async {
    ref.cacheFor(const Duration(seconds: 30));
    return ref.watch(userRepositoryProvider).api.getUserInfo("1");
  }

  Future<Map<String, dynamic>> setUserInfo(
      {required String firstName,
      required String lastName,
      required String phoneNumber,
      required String address,
      required DateTime dateOfBirth,
      required String gender,
      required List<String> school,
      File? avatar,
      String? email}) async {
    state = const AsyncLoading();
    var avatarUpload = avatar == null
        ? null
        : await ref.read(mediaRepositoryProvider).api.addImage(avatar);

    return ref
        .watch(userRepositoryProvider)
        .api
        .setUserInfo(
            school: school,
            firstName: firstName,
            lastName: lastName,
            phoneNumber: phoneNumber,
            address: address,
            dateOfBirth: dateOfBirth,
            gender: gender,
            avatar: avatarUpload,
            email: email)
        .then((value) {
      if (value["code"] == 1000) {
        state = AsyncData(UserModel(
            userId: state.value!.userId,
            firstName: firstName,
            lastName: lastName,
            subject: state.value!.subject,
            school: school,
            displayName: "$lastName $firstName",
            phoneNumber: phoneNumber,
            address: address,
            dateOfBirth: dateOfBirth.toString(),
            gender: Gender.values[int.parse(gender) - 1],
            avatar: avatarUpload,
            email: email));
        return value;
      }
      throw value;
    });
  }
}

final userFollowerProvider =
    FutureProvider.autoDispose<List<InfoAuthorModel>>((ref) {
  return ref.watch(userRepositoryProvider).api.getListFollower();
});

final userFollowingProvider =
    FutureProvider.autoDispose<List<InfoAuthorModel>>((ref) {
  return ref.watch(userRepositoryProvider).api.getListFollowing();
});

final otherUserProvider = AsyncNotifierProvider.autoDispose
    .family<AsyncOtherUserProvider, (bool, UserModel), String>(
        AsyncOtherUserProvider.new);

class AsyncOtherUserProvider
    extends AutoDisposeFamilyAsyncNotifier<(bool, UserModel), String> {
  @override
  FutureOr<(bool, UserModel)> build(String arg) async {
    ref.cacheFor(const Duration(seconds: 30));
    var result =
        await ref.watch(userRepositoryProvider).api.getOtherUserInfo(arg);
    return (result.$1.contains("following"), result.$2);
  }

  Future<void> following() async {
    await ref.watch(userRepositoryProvider).api.following(arg);
    ref.invalidate(userFollowingProvider);
    ref.invalidateSelf();
  }

  Future<void> unFollowing() async {
    await ref.watch(userRepositoryProvider).api.unFollowing(arg);
    ref.invalidate(userFollowingProvider);
    ref.invalidateSelf();
  }
}
