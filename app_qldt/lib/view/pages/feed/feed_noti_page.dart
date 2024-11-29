import "package:extended_image/extended_image.dart";
import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:font_awesome_flutter/font_awesome_flutter.dart";
import "package:go_router/go_router.dart";
import "package:infinite_scroll_pagination/infinite_scroll_pagination.dart";
import "package:app_qldt/controller/push_notification_provider.dart";
import "package:app_qldt/core/common/types.dart";
import "package:app_qldt/core/theme/typestyle.dart";
import "package:app_qldt/model/entities/push_noti.dart";
import "package:app_qldt/core/theme/palette.dart";

class FeedNotiPage extends ConsumerStatefulWidget {
  const FeedNotiPage({super.key});

  @override
  ConsumerState<FeedNotiPage> createState() => _FeedNotiPageState();
}

class _FeedNotiPageState extends ConsumerState<FeedNotiPage> {
  final pagingController = PagingController<int, PushNoti>(firstPageKey: 0);

  @override
  void initState() {
    super.initState();
    pagingController.addPageRequestListener((nextPage) async {
      final pushNotis = await ref.read(notificationProvider(nextPage).future);
      if (pushNotis.length < 15) {
        pagingController.appendLastPage(pushNotis);
      } else {
        pagingController.appendPage(pushNotis, 15);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.primary,
          title: const Align(
            alignment: Alignment(-0.25, 0), // Căn phải một chút
            child: Text("Thông báo", style: TypeStyle.title1White),
          ),
          leading: IconButton(
              onPressed: () => context.pop(),
              icon: const FaIcon(FaIcons.arrowLeft, color: Palette.white,))),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: PagedListView<int, PushNoti>(
            pagingController: pagingController,
            builderDelegate: PagedChildBuilderDelegate(
              itemBuilder: (context, item, index) {
                return ListTile(
                  leading: CircleAvatar(
                    radius: 20,
                    backgroundImage: ExtendedNetworkImageProvider(
                        item.user["avatar"] ?? "https://picsum.photos/200"),
                  ),
                  title: Text.rich(TextSpan(children: [
                    TextSpan(
                        text: item.user["displayName"],
                        style: TypeStyle.body3
                            .copyWith(fontWeight: FontWeight.bold)),
                    TextSpan(
                        text: " đã ${switch (item.notification["action"]) {
                          "add_post" => "thêm bài viết mới.",
                          "like" => "thích bài viết của bạn.",
                          "comment" => "bình luận bài viết của bạn.",
                          _ => ""
                        }}",
                        style: TypeStyle.body3),
                  ])),
                );
              },
              noItemsFoundIndicatorBuilder: (context) => const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Chưa có thông báo nào\n", style: TypeStyle.title3),
                    Text(
                        "Hãy thử quan tâm tới bài viết nào đó của giáo viên khác.")
                  ]),
              noMoreItemsIndicatorBuilder: (context) =>
                  const Center(child: Text("Đã tải hết thông báo")),
            )),
      ),
    );
  }
}
