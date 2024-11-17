import "package:extended_image/extended_image.dart";
import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:font_awesome_flutter/font_awesome_flutter.dart";
import "package:go_router/go_router.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";
import "package:app_qldt/controller/user_provider.dart";
import "package:app_qldt/core/common/types.dart";
import "package:app_qldt/core/router/url.dart";
import "package:app_qldt/core/theme/palette.dart";
import "package:app_qldt/core/theme/typestyle.dart";
import "package:app_qldt/view/pages/feed/feed_post.dart";
import "package:app_qldt/controller/searches_provider.dart";
import "package:app_qldt/view/pages/profile/profile_other_page.dart";

class FeedSearchPage extends ConsumerStatefulWidget {
  const FeedSearchPage({super.key});

  @override
  ConsumerState<FeedSearchPage> createState() => _FeedSearchPageState();
}

class _FeedSearchPageState extends ConsumerState<FeedSearchPage>
    with TickerProviderStateMixin {
  var isShowResult = false;
  final controller = TextEditingController();
  late final tabController = TabController(length: 2, vsync: this);

  void goToProfile(BuildContext context, WidgetRef ref, String userId) {
    if (userId == ref.read(userProvider).value?.userId) {
      context.go(profileRoute);
    } else {
      Navigator.of(context, rootNavigator: true).push(MaterialPageRoute(
          builder: (context) => ProfileOtherPage(userId: userId)));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 100,
        leading: IconButton(
            onPressed: () => context.go(feedRoute),
            icon: const FaIcon(FaIcons.arrowLeft)),
        leadingWidth: 48,
        bottom: PreferredSize(
            preferredSize: const Size.fromHeight(20),
            child: Column(
              children: [
                const Divider(),
                Row(
                  children: [
                    const SizedBox(width: 8),
                    const Text("Tìm kiếm gần đây", style: TypeStyle.title3),
                    const Spacer(),
                    TextButton(
                        onPressed: () {
                          ref
                              .read(oldSearchesProvider.notifier)
                              .deleteOldSearches();
                        },
                        child: const Text("Xóa tất cả")),
                  ],
                )
              ],
            )),
        title: SearchBar(
          controller: controller,
          shape: WidgetStatePropertyAll(
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(5))),
          elevation: const WidgetStatePropertyAll(0),
          surfaceTintColor: const WidgetStatePropertyAll(Palette.grey25),
          onTap: () {
            setState(() {
              isShowResult = false;
            });
          },
          onSubmitted: (value) {
            if (value.isNotEmpty) {
              setState(() {
                isShowResult = true;
              });
              ref.read(oldSearchesProvider.notifier).insertOldSearch(value);
            }
          },
          leading: const FaIcon(FaIcons.magnifyingGlass),
          hintText: "Tìm kiếm...",
        ),
      ),
      body: isShowResult
          ? Column(
              children: [
                TabBar(controller: tabController, tabs: const [
                  Tab(text: "Bài viết"),
                  Tab(text: "Người dùng")
                ]),
                Expanded(
                  child: TabBarView(
                    controller: tabController,
                    children: [
                      SingleChildScrollView(
                        child: SizedBox(
                          width: double.infinity,
                          child: Column(
                              children: ref
                                  .watch(postSearchesProvider(controller.text))
                                  .when(
                                      skipLoadingOnRefresh: false,
                                      data: (value) => value.isNotEmpty
                                          ? value
                                              .map((e) => Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: FeedSearchPost(
                                                        model: e),
                                                  ))
                                              .toList()
                                          : const [
                                              Padding(
                                                padding: EdgeInsets.all(8.0),
                                                child: FaIcon(
                                                    FaIcons.magnifyingGlass,
                                                    size: 48),
                                              ),
                                              Text(
                                                  "Không tìm thấy thông tin liên quan.",
                                                  style: TypeStyle.body2)
                                            ],
                                      error: (_, __) => [
                                            const Text(
                                                "Đã có lỗi xảy ra, xin hãy thử lại sau."),
                                            TextButton(
                                                onPressed: () => ref.invalidate(
                                                    postSearchesProvider(
                                                        controller.text)),
                                                child: const Text("Thử lại"))
                                          ],
                                      loading: () => [
                                            const Center(
                                                child:
                                                    CircularProgressIndicator())
                                          ])),
                        ),
                      ),
                      SingleChildScrollView(
                        child: SizedBox(
                          width: double.infinity,
                          child: Column(
                              children: ref
                                  .watch(userSearchesProvider(controller.text))
                                  .when(
                                      skipLoadingOnRefresh: false,
                                      data: (value) => value.isNotEmpty
                                          ? value
                                              .map((e) => ListTile(
                                                  onTap: () {
                                                    goToProfile(
                                                        context, ref, e.userId);
                                                  },
                                                  leading: CircleAvatar(
                                                      backgroundImage:
                                                          ExtendedNetworkImageProvider(e
                                                                  .avatar ??
                                                              "https://picsum.photos/200")),
                                                  title: Text(e.displayName)))
                                              .toList()
                                          : const [
                                              Padding(
                                                padding: EdgeInsets.all(8.0),
                                                child: FaIcon(
                                                    FaIcons.magnifyingGlass,
                                                    size: 48),
                                              ),
                                              Text(
                                                  "Không tìm thấy thông tin liên quan.",
                                                  style: TypeStyle.body2)
                                            ],
                                      error: (_, __) => [
                                            const Text(
                                                "Đã có lỗi xảy ra, xin hãy thử lại sau."),
                                            TextButton(
                                                onPressed: () => ref.invalidate(
                                                    userSearchesProvider(
                                                        controller.text)),
                                                child: const Text("Thử lại"))
                                          ],
                                      loading: () => [
                                            const Center(
                                                child:
                                                    CircularProgressIndicator())
                                          ])),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            )
          : SingleChildScrollView(
              child: SizedBox(
                width: double.infinity,
                child: Column(
                    children: ref.watch(oldSearchesProvider).when(
                        skipLoadingOnRefresh: false,
                        data: (value) => value.isNotEmpty
                            ? value
                                .map((e) => ListTile(
                                    onTap: () {
                                      setState(() {
                                        controller.text = e;
                                        isShowResult = true;
                                      });
                                      ref
                                          .read(oldSearchesProvider.notifier)
                                          .insertOldSearch(e);
                                    },
                                    leading: const FaIcon(FaIcons.clock),
                                    title: Text(e),
                                    trailing: IconButton(
                                      onPressed: () => ref
                                          .read(oldSearchesProvider.notifier)
                                          .deleteOldSearch(e),
                                      icon: const FaIcon(FaIcons.xmark),
                                    )))
                                .toList()
                            : const [
                                Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child:
                                      FaIcon(FaIcons.magnifyingGlass, size: 48),
                                ),
                                Text("Hiện chưa có tìm kiếm nào được lưu lại.",
                                    style: TypeStyle.body2)
                              ],
                        error: (_, __) => [
                              const Text(
                                  "Đã có lỗi xảy ra, xin hãy thử lại sau."),
                              TextButton(
                                  onPressed: () =>
                                      ref.invalidate(oldSearchesProvider),
                                  child: const Text("Thử lại"))
                            ],
                        loading: () => [
                              const Center(child: CircularProgressIndicator())
                            ])),
              ),
            ),
    );
  }
}
