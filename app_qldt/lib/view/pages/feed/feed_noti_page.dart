import "package:extended_image/extended_image.dart";
import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:fluttertoast/fluttertoast.dart";
import "package:font_awesome_flutter/font_awesome_flutter.dart";
import "package:go_router/go_router.dart";
import "package:infinite_scroll_pagination/infinite_scroll_pagination.dart";
import "package:app_qldt/controller/push_notification_provider.dart";
import "package:app_qldt/core/common/types.dart";
import "package:app_qldt/core/theme/typestyle.dart";
import "package:app_qldt/model/entities/push_noti.dart";
import "package:app_qldt/core/theme/palette.dart";

import "../../../controller/messaging_provider.dart";
import "../../../core/common/formatter.dart";
import "../home_skeleton.dart";

class FeedNotiPage extends ConsumerStatefulWidget {
  const FeedNotiPage({super.key});

  @override
  ConsumerState<FeedNotiPage> createState() => _FeedNotiPageState();
}

class _FeedNotiPageState extends ConsumerState<FeedNotiPage> {
  final pagingController = PagingController<int, PushNoti>(firstPageKey: 0);

  // Trạng thái click của thông báo - chưa đọc là true
  final List<bool> clickedNotifications = [];
  final List<Map<String, dynamic>> listSender = [];

  @override
  void initState() {
    super.initState();
    pagingController.addPageRequestListener((nextPage) async {
      final pushNotis = await ref.read(notificationProvider(nextPage).future);
      // Khởi tạo trạng thái `false` cho mỗi thông báo mới
      clickedNotifications.addAll(List.generate(pushNotis.length, (index) => pushNotis[index].status == 'UNREAD'));
      for (var i = 0; i < pushNotis.length; i++) {
        final userInfo = await ref.read(getUserInfoProvider(pushNotis[i].fromUser.toString()).future);
        listSender.add(userInfo);
      }
      if (pushNotis.length < 20) {
        pagingController.appendLastPage(pushNotis);
      } else {
        pagingController.appendPage(pushNotis, nextPage + 1);
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
                return GestureDetector(
                  onTap: () async {
                    if (clickedNotifications[index]) {
                      final notify = await ref.read(readNotificationProvider(item.id).future);
                      setState(() {
                        clickedNotifications[index] = false; // Đánh dấu là đã click
                        Fluttertoast.showToast(msg: notify);
                        ref.read(countNotificationProvider.notifier).state = ref.watch(countNotificationProvider) - 1;
                      });
                    }
                  },
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 12), // Khoảng cách giữa các thông báo
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: clickedNotifications[index]
                          ? Palette.red_1 // chưa đọc
                          : Palette.red_, // đã đọc
                      border: Border.all(color: Colors.black45, width: 1), // Viền của thông báo
                      borderRadius: BorderRadius.circular(8), // Góc bo tròn
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        item.imageUrl == null ? const CircleAvatar(
                          backgroundImage: AssetImage('images/avatar-trang.jpg'),
                          radius: 20,
                        ) : CircleAvatar(
                            backgroundImage: ExtendedNetworkImageProvider(
                                'https://drive.google.com/uc?id=${item.imageUrl?.split('/d/')[1].split('/')[0]}'),
                            radius: 20
                        ),
                        const SizedBox(width: 12), // Khoảng cách giữa avatar và nội dung
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              RichText(
                                text: TextSpan(
                                  children: [
                                    TextSpan(
                                      text: item.titlePushNotification,
                                      style: TypeStyle.body3
                                          .copyWith(fontWeight: FontWeight.bold, color: Colors.black),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 4),
                              RichText(
                                text: TextSpan(
                                  children: [
                                    TextSpan(
                                      text: "Người gửi: ",
                                      style: TypeStyle.body4.copyWith(color: Colors.black),
                                    ),
                                    TextSpan(
                                      text: listSender[index]['name'],
                                      style: TypeStyle.body4.copyWith(color: Colors.blue),
                                    ),
                                  ],
                                ),
                              ),
                              RichText(
                                text: TextSpan(
                                  children: [
                                    TextSpan(
                                      text: '${item.message?.split('; ')[0].split(': ')[0]}: ',
                                      style: TypeStyle.body4.copyWith(color: Colors.black),
                                    ),
                                    TextSpan(
                                      text: item.message?.split('; ')[0].split(': ')[1],
                                      style: TypeStyle.body4.copyWith(color: Colors.blue),
                                    ),
                                  ],
                                ),
                              ),
                              RichText(
                                text: TextSpan(
                                  children: [
                                    TextSpan(
                                      text: '${item.message?.split('; ')[1].split(': ')[0]}: ',
                                      style: TypeStyle.body4.copyWith(color: Colors.black),
                                    ),
                                    TextSpan(
                                      text: item.message?.split('; ')[1].split(': ')[1],
                                      style: TypeStyle.body4.copyWith(color: Colors.blue),
                                    ),
                                  ],
                                ),
                              ),
                              RichText(
                                text: TextSpan(
                                  children: [
                                    TextSpan(
                                      text: "Nội dung:\n",
                                      style: TypeStyle.body4.copyWith(color: Colors.black),
                                    ),
                                    ...?item.message
                                        ?.split('; ')
                                        .where((messagePart) => !messagePart.contains('MSSV') && !messagePart.contains('Email'))
                                        .map(
                                          (messagePart) =>
                                              TextSpan(
                                        text: "   • $messagePart\n", // Thêm dấu bullet cho từng mục
                                        style: TypeStyle.body4.copyWith(color: Colors.black),
                                      ),
                                    )
                                        .toList(),
                                  ],
                                ),
                              )

                            ],
                          ),
                        ),
                        const SizedBox(width: 12), // Khoảng cách giữa nội dung và ngày
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                                formatMessageDate(DateTime.parse(item.sentTime)), // Định dạng ngày tháng
                                // style: TypeStyle.caption.copyWith(color: Colors.grey),
                                style: TypeStyle.body5
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
              noItemsFoundIndicatorBuilder: (context) => const Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Chưa có thông báo nào!\n", style: TypeStyle.title3),
                  ]),
              noMoreItemsIndicatorBuilder: (context) =>
                  const Center(child: Text("Đã tải hết thông báo")),
            )),
      ),
    );
  }
}
