import "package:extended_image/extended_image.dart";
import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:font_awesome_flutter/font_awesome_flutter.dart";
import "package:go_router/go_router.dart";
import "package:infinite_scroll_pagination/infinite_scroll_pagination.dart";
import "package:app_qldt/core/common/types.dart";
import "package:app_qldt/core/router/url.dart";
import "package:app_qldt/core/theme/typestyle.dart";
import "package:app_qldt/model/entities/post_model.dart";
import "package:app_qldt/view/pages/feed/feed_create_post_page.dart";
import "package:app_qldt/view/pages/feed/feed_noti_page.dart";
import "package:app_qldt/view/pages/feed/feed_post.dart";
import "package:app_qldt/controller/post_provider.dart";
import "package:app_qldt/controller/user_provider.dart";

class FeedPage extends ConsumerWidget {
  const FeedPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var avatar = ref.watch(userProvider).value?.avatar;
    return Scaffold(
      appBar: AppBar(
        leadingWidth: 50,
        leading: GestureDetector(
          onTap: () => context.push(profileRoute),
          child: Container(
            alignment: Alignment.center,
            margin: const EdgeInsets.all(5),
            decoration:
                BoxDecoration(border: Border.all(), shape: BoxShape.circle),
            child: CircleAvatar(
                backgroundImage: ExtendedNetworkImageProvider(
                    avatar ?? "https://picsum.photos/1024"),
                radius: 20),
          ),
        ),
        title: const Text("Bảng tin", style: TypeStyle.title3),
        actions: [
          IconButton(
              onPressed: () {
                context.go(searchRoute);
              },
              icon: const FaIcon(FaIcons.magnifyingGlass)),
          IconButton(
              onPressed: () {
                Navigator.of(context, rootNavigator: true).push(
                    MaterialPageRoute(
                        builder: (context) => const FeedNotiPage()));
              },
              icon: const FaIcon(FaIcons.bell)),
          IconButton(
              onPressed: () {
                Navigator.of(context, rootNavigator: true).push(
                    MaterialPageRoute(
                        builder: (context) => const FeedCreatePostPage()));
              },
              icon: const FaIcon(FaIcons.plus)),
        ],
      ),
      body: const _BuildBody(),
    );
  }
}

class _BuildBody extends ConsumerStatefulWidget {
  const _BuildBody();

  @override
  ConsumerState<_BuildBody> createState() => _BuildBodyState();
}

class _BuildBodyState extends ConsumerState<_BuildBody> {
  late final PagingController<int, PostModel> pagingController;

  @override
  void initState() {
    super.initState();
    pagingController = PagingController<int, PostModel>(
        firstPageKey: ref.read(postProvider.notifier).offset);
    pagingController.itemList = ref.read(postProvider).value;
    pagingController.addPageRequestListener((nextPage) {
      ref.read(postProvider.notifier).morePost(nextPage).then((value) {
        pagingController.appendPage(value, value.length + nextPage);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final listPost = ref.watch(postProvider);

    return RefreshIndicator(
      onRefresh: () async {
        ref.invalidate(postProvider);
        pagingController.value =
            const PagingState(nextPageKey: 0, itemList: null);
      },
      child: switch (listPost) {
        AsyncLoading() => const Center(
              child: Padding(
            padding: EdgeInsets.all(8.0),
            child: CircularProgressIndicator(),
          )),
        AsyncData(value: final _) => PagedListView<int, PostModel>(
            pagingController: pagingController,
            builderDelegate: PagedChildBuilderDelegate(
                itemBuilder: (context, item, index) =>
                    FeedPost(postId: item.infoPost.postId),
                noItemsFoundIndicatorBuilder: (context) =>
                    const Center(child: Text("Không có bài viết nào cả.")))),
        _ => SizedBox(
            height: MediaQuery.sizeOf(context).height -
                kToolbarHeight * 2 -
                kBottomNavigationBarHeight,
            child: const Center(child: Text("Không có bài viết")))
      },
    );
  }
}
