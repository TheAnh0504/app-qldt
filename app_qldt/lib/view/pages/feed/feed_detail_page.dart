import 'dart:convert';

import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:app_qldt/core/common/formatter.dart';
import 'package:app_qldt/core/common/types.dart';
import 'package:app_qldt/core/router/url.dart';
import 'package:app_qldt/core/theme/palette.dart';
import 'package:app_qldt/core/theme/typestyle.dart';
import 'package:app_qldt/model/entities/post_model.dart';
import 'package:app_qldt/view/pages/feed/feed_comment_page.dart';
import 'package:app_qldt/view/pages/feed/feed_post.dart';
import 'package:app_qldt/view/pages/profile/profile_other_page.dart';
import 'package:app_qldt/view/widgets/sw_markdown.dart';
import 'package:app_qldt/controller/comment_provider.dart';
import 'package:app_qldt/controller/post_provider.dart';
import 'package:app_qldt/controller/user_provider.dart';

class FeedDetailPage extends ConsumerStatefulWidget {
  final String postId;

  const FeedDetailPage({super.key, required this.postId});

  @override
  ConsumerState<FeedDetailPage> createState() => _FeedDetailPageState();
}

class _FeedDetailPageState extends ConsumerState<FeedDetailPage> {
  late final PagingController<int, (InfoCommentModel, String?, String)>
      commentPagingController;

  @override
  void initState() {
    super.initState();
    commentPagingController =
        PagingController<int, (InfoCommentModel, String?, String)>(
            firstPageKey: 0);
    commentPagingController.addPageRequestListener((offset) async {
      final comments =
          await ref.read(commentProvider((widget.postId, offset)).future);
      if (comments.length < 10) {
        commentPagingController.appendLastPage(comments);
      } else {
        commentPagingController.appendPage(comments, offset + comments.length);
      }
    });
  }

  void goToProfile(BuildContext context, WidgetRef ref, PostModel post) {
    if (post.infoAuthor.first.userId == ref.read(userProvider).value?.userId) {
      context.go(profileRoute);
    } else {
      Navigator.of(context, rootNavigator: true).push(MaterialPageRoute(
          builder: (context) =>
              ProfileOtherPage(userId: post.infoAuthor.first.userId)));
    }
  }

  @override
  Widget build(BuildContext context) {
    final asyncValue = ref.watch(postProvider);

    return switch (asyncValue) {
      AsyncError(error: final _, stackTrace: final _) => Scaffold(
          appBar: AppBar(
              leading: IconButton(
                  onPressed: context.pop,
                  icon: const FaIcon(FaIcons.arrowLeft))),
          body: const Padding(
            padding: EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(child: FaIcon(FaIcons.ban, size: 48)),
                Center(child: Text("Đã có lỗi xảy ra, hãy thử lại sau.")),
              ],
            ),
          )),
      AsyncLoading() => Scaffold(
          appBar: AppBar(
              leading: IconButton(
                  onPressed: context.pop,
                  icon: const FaIcon(FaIcons.arrowLeft))),
          body: const Padding(
            padding: EdgeInsets.all(8),
            child: Center(child: CircularProgressIndicator()),
          )),
      AsyncData(:final value) => Builder(builder: (context) {
          final post =
              value.firstWhere((e) => e.infoPost.postId == widget.postId);
          final likes = post.infoPost.like == null
              ? <String>[]
              : post.infoPost.like ?? [];
          final medias = (post.infoPost.media == null
              ? <String>[]
              : (jsonDecode(post.infoPost.media!) as Map<String, dynamic>)
                  .values
                  .cast<String>());
          final hasLike = likes.contains(ref.watch(userProvider).value?.userId);
          var description = post.infoPost.description;
          for (var ti in post.tagInfo) {
            description = description.replaceAll(
                "@[${ti.userId}]", "[${ti.displayName}](@${ti.userId})");
          }

          return Scaffold(
              appBar: AppBar(
                leading: IconButton(
                    onPressed: context.pop,
                    icon: const FaIcon(FaIcons.arrowLeft)),
                actions: [
                  IconButton(
                      onPressed: () {
                        ref
                            .read(postProvider.notifier)
                            .like(postId: post.infoPost.postId, like: !hasLike);
                      },
                      icon: FaIcon(
                        hasLike ? FaIcons.solidThumbsUp : FaIcons.thumbsUp,
                        color: hasLike
                            ? Theme.of(context).colorScheme.primary
                            : null,
                      )),
                  IconButton(
                      onPressed: () {
                        Navigator.of(context, rootNavigator: true)
                            .push(MaterialPageRoute(
                                builder: (context) => FeedCommentPage(
                                    postId: post.infoPost.postId)))
                            .then((_) {
                          commentPagingController.refresh();
                        });
                      },
                      icon: const FaIcon(FaIcons.comment)),
                  IconButton(
                      onPressed: () {},
                      icon: const FaIcon(FaIcons.ellipsisVertical)),
                ],
              ),
              body: Padding(
                padding: const EdgeInsets.all(8),
                child: CustomScrollView(
                  slivers: [
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Row(
                          children: [
                            GestureDetector(
                              onTap: () => goToProfile(context, ref, post),
                              child: CircleAvatar(
                                  radius: 20,
                                  backgroundImage: ExtendedNetworkImageProvider(
                                      ref.read(userProvider).value?.avatar ??
                                          "https://picsum.photos/1024")),
                            ),
                            const SizedBox(width: 14),
                            GestureDetector(
                              onTap: () => goToProfile(context, ref, post),
                              child: Text(
                                  ref.watch(userProvider).value?.displayName ??
                                      "",
                                  style: TypeStyle.title3),
                            ),
                            const Spacer(),
                            Text(
                                formatMessageDate(
                                    DateTime.parse(post.infoPost.createdAt)),
                                style: TypeStyle.body5)
                          ],
                        ),
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SWMarkdown(data: description, style: "",),
                      ),
                    ),
                    if (medias.isNotEmpty)
                      SliverToBoxAdapter(
                          child: FeedMediaGrid(medias: medias.toList())),
                    PagedSliverList<int, (InfoCommentModel, String?, String)>(
                        pagingController: commentPagingController,
                        builderDelegate: PagedChildBuilderDelegate(
                            noItemsFoundIndicatorBuilder: (context) =>
                                const Center(
                                    child: Text(
                                        "Bài viết hiện tại chưa có bình luận.")),
                            noMoreItemsIndicatorBuilder: (context) => const Center(
                                child: Text(
                                    "Bài viết hiện tại đã tải hết bình luận.")),
                            itemBuilder: (context, e, index) => Card(
                                elevation: 0,
                                color: Palette.grey40,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    children: [
                                      GestureDetector(
                                        onTap: () =>
                                            goToProfile(context, ref, post),
                                        child: CircleAvatar(
                                            radius: 20,
                                            backgroundImage:
                                                ExtendedNetworkImageProvider(e
                                                        .$2 ??
                                                    "https://picsum.photos/1024")),
                                      ),
                                      const SizedBox(width: 16),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(e.$3,
                                              style: TypeStyle.title4
                                                  .copyWith(fontSize: 14)),
                                          Text(e.$1.description.trim(),
                                              style: TypeStyle.body4),
                                          Text(
                                              formatMessageDate(DateTime.parse(
                                                  e.$1.createdAt)),
                                              style: TypeStyle.body5)
                                        ],
                                      )
                                    ],
                                  ),
                                )))),
                  ],
                ),
              ));
        }),
      _ => Container()
    };
  }
}
