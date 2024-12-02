import 'dart:convert';

import 'package:app_qldt/controller/account_provider.dart';
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

import '../../../model/entities/account_model.dart';

class MessagingConversationListPage extends StatelessWidget {
  const MessagingConversationListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          // leading: IconButton(
          //     onPressed: context.pop, icon: const FaIcon(FaIcons.arrowLeft)),
          backgroundColor: Theme.of(context).colorScheme.primary,
          centerTitle: true,
          title: const Align(
            alignment: Alignment(0.2, 0), // Căn phải một chút
            child: Text("Tin nhắn", style: TypeStyle.title1White),
          ),
          actions: [
            // TODO: 1. Tạo tin nhắn mới
            // IconButton(
            //   onPressed: () => handleShowContactInfo(context),
            //   icon: const FaIcon(FaIcons.penToSquare), color: Palette.white,)
          ],
        ),
        body: const _BuildBody());
  }

  // Future<void> handleShowContactInfo(BuildContext context) async {
  //   showModalBottomSheet(
  //       context: context,
  //       backgroundColor: Palette.white,
  //       showDragHandle: true,
  //       builder: (context) => SingleChildScrollView(
  //         child: Container(
  //             width: MediaQuery.sizeOf(context).width,
  //             height: MediaQuery.sizeOf(context).height,
  //             padding: const EdgeInsets.symmetric(horizontal: 8),
  //             decoration: const BoxDecoration(color: Palette.white),
  //             child: Column(
  //               mainAxisSize: MainAxisSize.min,
  //               crossAxisAlignment: CrossAxisAlignment.start,
  //               children: [
  //                 Padding(
  //                   padding: const EdgeInsets.symmetric(horizontal: 0), // Tùy chỉnh padding ngoài
  //                   child: Row(
  //                     mainAxisAlignment: MainAxisAlignment.spaceBetween, // Căn chỉnh đều
  //                     children: [
  //                       const Spacer(), // Tạo khoảng cách để "Tin nhắn mới" căn giữa
  //                       const Center(
  //                         child: Padding(
  //                           padding: EdgeInsets.only(left: 55), // Dịch sang phải một chút
  //                           child: Text(
  //                             "Tin nhắn mới",
  //                             style: TypeStyle.title1,
  //                           ),
  //                         ),
  //                       ),
  //                       const Spacer(), // Tạo khoảng cách sau "Tin nhắn mới"
  //                       TextButton(
  //                         onPressed: () {
  //                           Navigator.pop(context); // Đóng modal
  //                         },
  //                         child: const Text("Hủy"),
  //                       ),
  //                     ],
  //                   ),
  //                 ),
  //                 // ListTile(
  //                 //     title: Text('Đến'),
  //                 //     subtitle: Text('Text2',
  //                 //         style: TypeStyle.body3.copyWith(
  //                 //             color:
  //                 //             Theme.of(context).colorScheme.primary))
  //                 // ),
  //                 Text("Đến", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
  //                 SizedBox(height: 8),
  //                 TextField(
  //                   controller: _controller,
  //                   decoration: InputDecoration(
  //                     hintText: "Nhập email",
  //                     border: OutlineInputBorder(),
  //                     contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
  //                   ),
  //                 ),
  //                 SizedBox(height: 16),
  //                 if (_results.isNotEmpty)
  //                   Expanded(
  //                     child: ListView.builder(
  //                       itemCount: _results.length,
  //                       itemBuilder: (context, index) {
  //                         return ListTile(
  //                           title: Text(_results[index]),
  //                         );
  //                       },
  //                     ),
  //                   )
  //                 else
  //                   Center(child: Text("Không có kết quả tìm kiếm")),
  //
  //               ],
  //             )
  //         ),
  //       )
  //   );
  // }
}

class _BuildBody extends ConsumerStatefulWidget {
  const _BuildBody();

  @override
  ConsumerState<_BuildBody> createState() => _BuildBodyState();
}

class _BuildBodyState extends ConsumerState<_BuildBody> {
  late final pagingController =
      PagingController<int, GroupChatModel>(firstPageKey: 1);

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
    const avatarNull = 'https://drive.google.com/file/d/1TcbEp_FoZKrXbp-_82PfCeBYtgozFzJa/view?usp=sharing';
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
                        model.infoGroup.partnerAvatar != null
                            ? 'https://drive.google.com/uc?id=${model.infoGroup.partnerAvatar?.split('/d/')[1].split('/')[0]}'
                            : 'https://drive.google.com/uc?id=${avatarNull.split('/d/')[1].split('/')[0]}',
                        cache: true)),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                            model.infoGroup.partnerName.toString(),
                            style: TypeStyle.title2),
                        Row(
                          children: [
                            FutureBuilder(
                                future: ref.read(messagesProvider(
                                    (model.infoGroup.groupId, 1)).future),
                                builder: (context, snapshot) {
                                  return Text(
                                      snapshot.data?.first.message ?? "Tin nhắn đã bị xóa",
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: snapshot.data?.first.message == null
                                          ? TypeStyle.body4.copyWith(fontStyle: FontStyle.italic, color: Colors.grey)
                                          : TypeStyle.body4);
                                }),
                            const Spacer(),
                            if (model.numNewMessage > 0)
                              Container(
                                  padding: const EdgeInsets.all(5),
                                  decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Palette.blue),
                                  child: Text(
                                      model.numNewMessage
                                          .toString(),
                                      style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold)))
                          ],
                        ),
                        Text(
                            formatMessageDate(DateTime.parse(model.infoGroup.updatedAt)),
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
