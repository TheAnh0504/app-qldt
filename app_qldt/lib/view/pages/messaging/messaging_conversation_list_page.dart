import 'dart:convert';

import 'package:app_qldt/controller/account_provider.dart';
import 'package:extended_image/extended_image.dart';
import 'package:faker_dart/faker_dart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
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
import 'package:stomp_dart_client/stomp.dart';
import 'package:stomp_dart_client/stomp_config.dart';
import 'package:stomp_dart_client/stomp_frame.dart';

import '../../../model/entities/account_model.dart';
import '../../../model/entities/message_model.dart';

class MessagingConversationListPage extends ConsumerWidget {
  const MessagingConversationListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
        appBar: AppBar(
          leading: const IconButton(
              onPressed: null, icon: FaIcon(FaIcons.arrowLeft,size: 0,), iconSize: 0,),
          backgroundColor: Theme.of(context).colorScheme.primary,
          centerTitle: true,
          title: const Align(
            alignment: Alignment(0, 0), // Căn phải một chút
            child: Text("Tin nhắn", style: TypeStyle.title1White),
          ),
          actions: [
            // TODO: 1. Tạo tin nhắn mới
            IconButton(
              onPressed: () => handleShowContactInfo(context, ref),
              icon: const FaIcon(FaIcons.penToSquare, color: Palette.white),)
          ],
        ),
        body: const _BuildBody());
  }

  Future<void> handleShowContactInfo(BuildContext context, WidgetRef ref) async {
    final controller = TextEditingController();
    ValueNotifier<List<Map<String, dynamic>>> results = ValueNotifier([]);

    final String webSocketUrl = 'http://157.66.24.126:8080/ws';
    late StompClient _client;
    // connect to websocket
    _client = StompClient(
        config: StompConfig.sockJS(url: webSocketUrl, onConnect: (StompFrame connectFrame) async {
          _client.subscribe(
              destination: '/user/${ref
                  .read(accountProvider)
                  .value
                  ?.idAccount}/inbox',
              headers: {},
              callback: (frame) {
                print(frame.body);
                // Received a frame for this subscription
                Map<String, dynamic> message = jsonDecode(frame.body!);
                GroupChatInfoModel infoGroup = GroupChatInfoModel(
                    groupId: message['conversation_id'],
                    partnerAvatar: message['receiver']['avatar'],
                    partnerId: message['receiver']['id'],
                    partnerName: message['receiver']['name'],
                    lastMessageSenderId: message['sender']['id'],
                    lastMessageSenderName: message['sender']['name'],
                    lastMessageSenderAvatar: message['sender']['avatar'],
                    lastMessageMessage: message['content'],
                    lastMessageCreatedAt: message['created_at'],
                    lastMessageUnRead: 0,
                    createdAt: message['created_at'],
                    updatedAt: message['created_at']
                );
                GroupChatInfoMessageNotRead infoMessageNotRead = GroupChatInfoMessageNotRead(
                    groupId: message['conversation_id'],
                    partnerAvatar: message['receiver']['avatar'],
                    partnerId: message['receiver']['id'],
                    partnerName: message['receiver']['name'],
                    lastMessageSenderId: message['sender']['id'],
                    lastMessageSenderName: message['sender']['name'],
                    lastMessageSenderAvatar: message['sender']['avatar'],
                    lastMessageMessage: message['content'],
                    lastMessageCreatedAt: message['created_at'],
                    lastMessageUnRead: 0,
                    createdAt: message['created_at'],
                    updatedAt: message['created_at']
                );
                GroupChatModel groupChatInfoModel = GroupChatModel(
                    infoGroup: infoGroup,
                    infoMessageNotRead: infoMessageNotRead,
                    numNewMessage: 0
                );
                _client.deactivate();
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            MessagingDetailPage(model: groupChatInfoModel)
                    )
                );
              }
          );
        }));
    _client.activate();

    Future<void> updateResults(String query) async {
      if (query.isEmpty) {
        results.value = [];
      } else {
        await ref.watch(listAccountProvider.notifier).getListAccount(query).then((value) {
          results.value = value;
        });
      }
    }
    const avatarNull = 'https://drive.google.com/file/d/1TcbEp_FoZKrXbp-_82PfCeBYtgozFzJa/view?usp=sharing';

    showModalBottomSheet(
        context: context,
        backgroundColor: Palette.white,
        showDragHandle: true,
        builder: (context) => SingleChildScrollView(
          child: Container(
              width: MediaQuery.sizeOf(context).width,
              height: MediaQuery.sizeOf(context).height,
              padding: const EdgeInsets.symmetric(horizontal: 8),
              decoration: const BoxDecoration(color: Palette.white),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 0), // Tùy chỉnh padding ngoài
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween, // Căn chỉnh đều
                      children: [
                        const Spacer(), // Tạo khoảng cách để "Tin nhắn mới" căn giữa
                        const Center(
                          child: Padding(
                            padding: EdgeInsets.only(left: 55), // Dịch sang phải một chút
                            child: Text(
                              "Tin nhắn mới",
                              style: TypeStyle.title1,
                            ),
                          ),
                        ),
                        const Spacer(), // Tạo khoảng cách sau "Tin nhắn mới"
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context); // Đóng modal
                            ref.invalidate(groupChatProvider); // Làm mới dữ liệu
                          },
                          child: const Text("Hủy"),
                        ),
                      ],
                    ),
                  ),

                  const Text("Đến", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  TextField(
                    controller: controller,
                    decoration: const InputDecoration(
                      hintText: "Nhập email",
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    ),
                    onChanged: updateResults,
                  ),
                  const SizedBox(height: 16),
                  ValueListenableBuilder<List<Map<String,dynamic>>>(
                    valueListenable: results,
                    builder: (context, results, _) {
                      if (results.isEmpty) {
                        return const Center(child: Text("Không có kết quả tìm kiếm"));
                      }
                      return SizedBox(
                        height: 200,
                        child: ListView.builder(
                          itemCount: results.length,
                          itemBuilder: (context, index) => Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
                            child: DecoratedBox(
                              decoration: BoxDecoration(
                                color: Palette.white, // Màu nền
                                borderRadius: BorderRadius.circular(8), // Bo góc
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.3), // Màu đổ bóng
                                    spreadRadius: 2,
                                    blurRadius: 4,
                                    offset: const Offset(0, 3), // Vị trí đổ bóng
                                  ),
                                ],
                                border: Border.all(color: Palette.red100), // Viền
                              ),
                              child: ListTile(
                                leading: CircleAvatar(
                                  backgroundImage: ExtendedNetworkImageProvider(
                                    results[index]["avatar"] != null
                                        ? 'https://drive.google.com/uc?id=${results[index]["avatar"].split('/d/')[1].split('/')[0]}'
                                        : 'https://drive.google.com/uc?id=${avatarNull.split('/d/')[1].split('/')[0]}',
                                  ),
                                  radius: 20, // Kích thước của ảnh
                                ),
                                title: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '${results[index]["first_name"]} ${results[index]["last_name"]}',
                                      style: TypeStyle.title2,
                                    ),
                                    Text(
                                      results[index]["email"],
                                      style: TypeStyle.body3,
                                    ),
                                  ],
                                ),
                                onTap: () {
                                  // Logic xử lý khi nhấn vào
                                  print("Selected: ${results[index]}");
                                  print(_client.connected);
                                  _client.send(
                                    destination: '/chat/message', // Replace with your chat ID
                                    body: json.encode({
                                      'receiver': { 'id': results[index]['account_id'] }, // id người nhân
                                      'content': 'first_message', // nội dung message
                                      'sender': ref.read(accountProvider).value?.email, // email người gửi
                                      'token': ref.read(accountProvider).value?.accessToken, // accessToken của người gửi
                                    }), // Format the message as needed
                                  );
                                },
                              ),

                            ),
                          ),
                        ),
                      );

                    },
                  )

                ],
              )
          ),
        )
    );
  }
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
  void didChangeDependencies() {
    super.didChangeDependencies();
    _refreshData(); // Tự động lấy lại dữ liệu khi trang này được hiển thị.
  }

  Future<void> _refreshData() async {
    ref.invalidate(groupChatProvider);
    ref.invalidate(messagesProvider);
    pagingController.refresh();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        ref.invalidate(groupChatProvider);
        ref.invalidate(messagesProvider);
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
                const Center(child: Text("Đã hết cuộc trò chuyện."))
        ),
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
                onTap: () {
                  Navigator.pop(context);
                  Fluttertoast.showToast(msg: "Xóa cuộc trò chuyện");
                },
              ),
              BottomSheetListTile(
                leading: FaIcons.solidBellSlash,
                title: "Tắt thông báo",
                onTap: () {
                  Navigator.pop(context);
                  Fluttertoast.showToast(msg: "Tắt thông báo");
                },
              ),
              BottomSheetListTile(
                leading: FaIcons.ban,
                title: "Chặn",
                onTap: () {
                  Navigator.pop(context);
                  Fluttertoast.showToast(msg: "Chặn");
                },
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
                    radius: 30,
                    backgroundImage: ExtendedNetworkImageProvider(
                        model.infoGroup.partnerAvatar != null
                            ? 'https://drive.google.com/uc?id=${model.infoGroup.partnerAvatar?.split('/d/')[1].split('/')[0]}'
                            : 'https://drive.google.com/uc?id=${avatarNull.split('/d/')[1].split('/')[0]}',
                        cache: true)),
                const SizedBox(width: 15),
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
                                    (model.infoGroup.groupId, 0, "false")).future),
                                builder: (context, snapshot) {
                                  return model.infoGroup.lastMessageMessage == 'first_message' ? const Spacer() : Text(
                                      snapshot.data?.first.message == null ? "Tin nhắn đã bị xóa" :
                                      ref.read(accountProvider).value?.idAccount == model.infoGroup.lastMessageSenderId.toString()
                                          ? 'Bạn: ${snapshot.data?.first.message}' : snapshot.data?.first.message ?? "",
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: snapshot.data?.first.message == null
                                          ? TypeStyle.body4.copyWith(fontStyle: FontStyle.italic, color: Colors.grey)
                                          : TypeStyle.body4);
                                }
                            ),
                            const Spacer(),
                            if (model.infoGroup.lastMessageUnRead > 0 &&
                                ref.read(accountProvider).value?.idAccount != model.infoGroup.lastMessageSenderId.toString())
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
                        if (model.infoGroup.lastMessageMessage != 'first_message') Text(
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
