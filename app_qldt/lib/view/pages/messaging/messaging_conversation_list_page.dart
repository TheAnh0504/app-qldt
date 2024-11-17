import 'dart:convert';

import 'package:extended_image/extended_image.dart';
import 'package:faker_dart/faker_dart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:app_qldt/controller/user_provider.dart';
import 'package:app_qldt/core/common/formatter.dart';
import 'package:app_qldt/core/common/types.dart';
import 'package:app_qldt/core/theme/palette.dart';
import 'package:app_qldt/core/theme/typestyle.dart';
import 'package:app_qldt/model/entities/group_chat_model.dart';
import 'package:app_qldt/view/pages/messaging/messaging_detail_page.dart';
import 'package:app_qldt/view/widgets/sw_popup.dart';
import 'package:app_qldt/controller/messaging_provider.dart';

class MessagingConversationListPage extends StatelessWidget {
  const MessagingConversationListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
              onPressed: context.pop, icon: const FaIcon(FaIcons.arrowLeft)),
          centerTitle: true,
          title: const Text("Nhắn tin", style: TypeStyle.title1),
          actions: [
            IconButton(
                onPressed: () {}, icon: const FaIcon(FaIcons.penToSquare))
          ],
        ),
        body: const _BuildBody());
  }
}

class _BuildBody extends ConsumerStatefulWidget {
  const _BuildBody();

  @override
  ConsumerState<_BuildBody> createState() => _BuildBodyState();
}

class _BuildBodyState extends ConsumerState<_BuildBody> {
  late final pagingController =
      PagingController<int, GroupChatModel>(firstPageKey: 0);

  @override
  void initState() {
    super.initState();
    pagingController.addPageRequestListener((nextPage) async {
      final model = await ref.read(groupChatProvider(nextPage).future);
      if (model.length < 10) {
        pagingController.appendLastPage(model);
      } else {
        pagingController.appendPage(model, nextPage + 10);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        ref.invalidate(groupChatProvider);
        pagingController.refresh();
      },
      child: PagedListView<int, GroupChatModel>(
        pagingController: pagingController,
        physics: const AlwaysScrollableScrollPhysics(),
        builderDelegate: PagedChildBuilderDelegate(
            itemBuilder: (context, e, index) => _MessagingConversationItem(e),
            noItemsFoundIndicatorBuilder: (context) => const Center(
                child: Text("Không tìm thấy cuộc trò chuyện nào.")),
            noMoreItemsIndicatorBuilder: (context) =>
                const Center(child: Text("Đã hết cuộc trò chuyện."))),
      ),
    );
  }
}

class _MessagingConversationItem extends ConsumerWidget {
  final GroupChatModel model;
  const _MessagingConversationItem(this.model);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      color: Palette.grey25,
      elevation: 0,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: InkWell(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => MessagingDetailPage(model: model)));
        },
        onLongPress: () {
          showOptionModal(context: context, blocks: [
            [
              BottomSheetListTile(
                leading: FaIcons.trash,
                title: "Xóa",
                onTap: () {},
              ),
              BottomSheetListTile(
                leading: FaIcons.solidBellSlash,
                title: "Tắt thông báo",
                onTap: () {},
              ),
              BottomSheetListTile(
                leading: FaIcons.ban,
                title: "Chặn",
                onTap: () {},
              ),
            ]
          ]);
        },
        child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                    radius: 20,
                    backgroundImage: ExtendedNetworkImageProvider(
                        model.infoGroup.image ?? Faker.instance.image.image(),
                        cache: true)),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                            jsonDecode(model.infoGroup.groupName.toString())
                                .entries
                                .firstWhere((e) =>
                                    e.key !=
                                    ref.read(userProvider).value?.userId)
                                .value,
                            style: TypeStyle.title2),
                        Row(
                          children: [
                            FutureBuilder(
                                future: ref.read(messagesProvider(
                                    (model.infoGroup.groupId, 0)).future),
                                builder: (context, snapshot) {
                                  return Text(
                                      snapshot.data?.first.message ??
                                          (snapshot.data?.first.media == null
                                              ? "${jsonDecode(model.infoGroup.groupName.toString()).entries.firstWhere((e) => e.key != ref.read(userProvider).value?.userId).value} đã gửi một tin nhắn."
                                              : ""),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TypeStyle.body4);
                                }),
                            const Spacer(),
                            if (model.infoMessageNotRead.countMessageNotRead >
                                0)
                              Container(
                                  padding: const EdgeInsets.all(5),
                                  decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Palette.blue),
                                  child: Text(
                                      model.infoMessageNotRead
                                          .countMessageNotRead
                                          .toString(),
                                      style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold)))
                          ],
                        ),
                        Text(
                            formatMessageDate(Faker.instance.date
                                .past(DateTime.now(), rangeInYears: 1)),
                            style: TypeStyle.body5)
                      ]),
                )
              ],
            )),
      ),
    );
  }
}

// contendPadding: const EdgeInsets.symmetric(horizontal: 8),
//         title: const Text("Nguyễn Văn A", style: TypeStyle.title4),
//         subtitle: Text(
//             "lastMessage - ${formatMessageDate(DateTime.now().subtract(const Duration(minutes: 30)))}",
//             style: TypeStyle.body5.copyWith(color: Palette.grey70)),
//         trailing: const FaIcon(FaIcons.circleCheck, size: 15
