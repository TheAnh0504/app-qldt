import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:app_qldt/core/extension/extension.dart';
import 'package:app_qldt/model/entities/post_model.dart';
import 'package:app_qldt/model/repositories/media_repository.dart';
import 'package:app_qldt/model/repositories/post_repository.dart';
import 'package:app_qldt/controller/user_provider.dart';

final postProvider =
    AsyncNotifierProvider.autoDispose<PostNotifier, List<PostModel>>(
        PostNotifier.new);

class PostNotifier extends AutoDisposeAsyncNotifier<List<PostModel>> {
  int offset = 0;

  @override
  Future<List<PostModel>> build() async {
    return [];
  }

  Future<List<PostModel>> morePost(int offset) async {
    final posts =
        await ref.watch(postRepositoryProvider).api.getPostByRandom(offset);
    offset = offset + posts.length;
    state = AsyncValue.data([...?state.value, ...posts]);
    return posts;
  }

  Future<String> addPost(
      {required String description,
      required List<File> media,
      required List<String> tag}) async {
    List<String> mediaUpload = [];
    for (var m in media) {
      mediaUpload.add(await ref.read(mediaRepositoryProvider).api.addImage(m));
    }

    return ref
        .read(postRepositoryProvider)
        .api
        .addPost(description: description, media: mediaUpload, tag: tag);
  }

  Future<void> comment({
    required String description,
    required String postId,
    String? commentId,
  }) async {
    return ref
        .read(postRepositoryProvider)
        .api
        .comment(description: description, postId: postId, commentId: commentId)
        .then((value) async {
      final index =
          (state.value ?? []).indexWhere((e) => e.infoPost.postId == postId);
      if (index != -1) {
        state = AsyncData(
            await Future.wait((state.value ?? []).mapIndexed((i, e) async {
          if (i == index) {
            return await ref
                .read(postRepositoryProvider)
                .api
                .getPostById(postId);
          }
          return e;
        }).toList()));
      }
    });
  }

  Future<void> like(
      {required String postId, String? commentId, required bool like}) async {
    return ref
        .read(postRepositoryProvider)
        .api
        .like(postId: postId, commentId: commentId, like: like)
        .then((value) {
      final index =
          (state.value ?? []).indexWhere((e) => e.infoPost.postId == postId);
      final currentUser = ref.read(userProvider).value!;

      if (index != -1) {
        state = AsyncData((state.value ?? []).mapIndexed((i, e) {
          if (i == index) {
            final List<String> likes =
                e.infoPost.like == null ? <String>[] : e.infoPost.like!;
            return e.copyWith.infoPost.call(
                like: like
                    ? [...likes, currentUser.userId]
                    : likes.where((ele) => ele != currentUser.userId).toList());
          }
          return e;
        }).toList());
      }
    });
  }
}
