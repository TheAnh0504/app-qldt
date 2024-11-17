import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:app_qldt/core/extension/extension.dart';
import 'package:app_qldt/model/entities/post_model.dart';
import 'package:app_qldt/model/repositories/post_repository.dart';

final commentProvider = FutureProvider.autoDispose.family<
    List<(InfoCommentModel, String? avatar, String displayName)>,
    (String, int)>((ref, params) {
  return ref
      .watch(postRepositoryProvider)
      .api
      .getPostById(params.$1, offset: params.$2)
      .then((post) => post.infoComment
          .mapIndexed((i, e) => (
                e,
                post.countComments[i + 1]["avatar"] as String?,
                post.countComments[i + 1]["displayName"].toString()
              ))
          .toList());
});
