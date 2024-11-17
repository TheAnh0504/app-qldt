import 'dart:convert';

import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:app_qldt/core/common/formatter.dart';
import 'package:app_qldt/core/common/types.dart';
import 'package:app_qldt/core/extension/extension.dart';
import 'package:app_qldt/core/router/url.dart';
import 'package:app_qldt/core/theme/palette.dart';
import 'package:app_qldt/core/theme/typestyle.dart';
import 'package:app_qldt/model/entities/post_model.dart';
import 'package:app_qldt/view/pages/feed/feed_detail_page.dart';
import 'package:app_qldt/view/pages/profile/profile_other_page.dart';
import 'package:app_qldt/view/widgets/sw_markdown.dart';
import 'package:app_qldt/controller/post_provider.dart';
import 'package:app_qldt/controller/user_provider.dart';

class FeedPost extends ConsumerWidget {
  final String postId;
  const FeedPost({super.key, required this.postId});

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
  Widget build(BuildContext context, WidgetRef ref) {
    final post = ref
        .watch(postProvider)
        .requireValue
        .firstWhere((e) => e.infoPost.postId == postId);
    final likes =
        (post.infoPost.like == null ? <String>[] : post.infoPost.like ?? []);
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

    return InkWell(
      onTap: () => Navigator.of(context, rootNavigator: true).push(
          MaterialPageRoute(
              builder: (context) =>
                  FeedDetailPage(postId: post.infoPost.postId))),
      child: Card(
          color: Palette.white,
          margin: const EdgeInsets.only(top: 8, left: 8, right: 8),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
          elevation: 0,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                  padding: const EdgeInsets.all(8),
                  width: double.infinity,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        children: [
                          GestureDetector(
                            onTap: () => goToProfile(context, ref, post),
                            child: CircleAvatar(
                                backgroundImage: ExtendedNetworkImageProvider(
                                    post.infoAuthor.first.avatar ??
                                        "https://picsum.photos/200"),
                                radius: 24),
                          ),
                          const SizedBox(width: 8),
                          Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                GestureDetector(
                                  onTap: () => goToProfile(context, ref, post),
                                  child: Text(post.infoAuthor.first.displayName,
                                      style: TypeStyle.title4.copyWith(
                                          fontWeight: FontWeight.bold)),
                                ),
                                Text(formatMessageDate(
                                    DateTime.parse(post.infoPost.createdAt)))
                              ]),
                          const Spacer(),
                          PopupMenuButton(
                              itemBuilder: (BuildContext context) => [],
                              child: const Padding(
                                  padding: EdgeInsets.all(8),
                                  child: FaIcon(FaIcons.ellipsisVertical,
                                      size: 18)))
                        ],
                      )
                    ],
                  )),
              Padding(
                  padding: const EdgeInsets.all(8),
                  child: SWMarkdown(data: description)),
              if (medias.isNotEmpty) FeedMediaGrid(medias: medias.toList()),
              Row(
                children: [
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
                  Text(likes.length.toString(),
                      style: TypeStyle.body4
                          .copyWith(fontWeight: FontWeight.bold)),
                  const SizedBox(width: 16),
                  IconButton(
                      onPressed: () {
                        // Navigator.of(context, rootNavigator: true).push(
                        //     MaterialPageRoute(
                        //         builder: (context) => const FeedCommentPage()));
                      },
                      icon: const FaIcon(FaIcons.comment)),
                  Text(
                      post.countComments.firstOrNull?["countComment"]
                              .toString() ??
                          "0",
                      style: TypeStyle.body4
                          .copyWith(fontWeight: FontWeight.bold)),
                ],
              ),
            ],
          )),
    );
  }
}

class FeedMediaGrid extends StatelessWidget {
  const FeedMediaGrid({super.key, required this.medias});

  final List<String> medias;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: medias.length <= 2 ? 2 : 1,
      child: StaggeredGrid.count(
          crossAxisCount: 2,
          crossAxisSpacing: 5,
          mainAxisSpacing: 5,
          children: medias
              .mapIndexed((i, e) => StaggeredGridTile.count(
                    crossAxisCellCount: medias.length == 1 || i == 2 ? 2 : 1,
                    mainAxisCellCount: 1,
                    child: GestureDetector(
                      onTap: () {
                        context.push("$imageRoute?url=$e");
                      },
                      child: ExtendedImage.network(e,
                          fit: BoxFit.cover, cache: true),
                    ),
                  ))
              .toList()),
    );
  }
}

class FeedSearchPost extends ConsumerWidget {
  final InfoPostModel model;
  const FeedSearchPost({super.key, required this.model});

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
  Widget build(BuildContext context, WidgetRef ref) {
    final medias = (model.media == null
        ? <String>[]
        : (jsonDecode(model.media!) as Map<String, dynamic>)
            .values
            .cast<String>());

    return InkWell(
      onTap: () => Navigator.of(context, rootNavigator: true).push(
          MaterialPageRoute(
              builder: (context) => FeedDetailPage(postId: model.postId))),
      child: Card(
          color: Palette.white,
          margin: const EdgeInsets.only(top: 8, left: 8, right: 8),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
          elevation: 0,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                  padding: const EdgeInsets.all(8),
                  width: double.infinity,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        children: [
                          GestureDetector(
                            child: CircleAvatar(
                                backgroundImage: ExtendedNetworkImageProvider(
                                    "https://picsum.photos/200"),
                                radius: 24),
                          ),
                          const SizedBox(width: 8),
                          Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                GestureDetector(
                                  child: Text("post.infoAuthor",
                                      style: TypeStyle.title4.copyWith(
                                          fontWeight: FontWeight.bold)),
                                ),
                                Text(formatMessageDate(
                                    DateTime.parse(model.createdAt)))
                              ]),
                          const Spacer(),
                          PopupMenuButton(
                              itemBuilder: (BuildContext context) => [],
                              child: const Padding(
                                  padding: EdgeInsets.all(8),
                                  child: FaIcon(FaIcons.ellipsisVertical,
                                      size: 18)))
                        ],
                      )
                    ],
                  )),
              Padding(
                  padding: const EdgeInsets.all(8),
                  child: SWMarkdown(data: model.description)),
              if (medias.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: FeedMediaGrid(medias: medias.toList()),
                ),
            ],
          )),
    );
  }
}
