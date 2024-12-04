import 'dart:async';
import 'dart:convert';

import 'package:any_link_preview/any_link_preview.dart';
import 'package:app_qldt/controller/account_provider.dart';
import 'package:app_qldt/view/pages/messaging/messaging_conversation_list_page.dart';
import 'package:extended_image/extended_image.dart';
import 'package:faker_dart/faker_dart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:app_qldt/core/common/formatter.dart';
import 'package:app_qldt/core/common/types.dart';
import 'package:app_qldt/core/router/url.dart';
import 'package:app_qldt/core/theme/palette.dart';
import 'package:app_qldt/core/theme/typestyle.dart';
import 'package:app_qldt/model/entities/group_chat_model.dart';
import 'package:app_qldt/model/entities/message_model.dart';
import 'package:app_qldt/model/repositories/media_repository.dart';
import 'package:app_qldt/view/widgets/sw_markdown.dart';
import 'package:app_qldt/controller/messaging_provider.dart';
import 'package:app_qldt/controller/user_provider.dart';
import 'package:stomp_dart_client/stomp.dart';
import 'package:stomp_dart_client/stomp_config.dart';
import 'package:stomp_dart_client/stomp_frame.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';

import '../../widgets/sw_popup.dart';
import '../home_skeleton.dart';
import 'messaging_detail_settings_page.dart';

class MessagingDetailPage extends StatelessWidget {
  final GroupChatModel model;
  const MessagingDetailPage({super.key, required this.model});

  @override
  Widget build(BuildContext context) {
    const avatarNull = 'https://drive.google.com/file/d/1TcbEp_FoZKrXbp-_82PfCeBYtgozFzJa/view?usp=sharing';

    return WillPopScope(
      onWillPop: () async {
        // Thực hiện hành động tùy chỉnh trước khi quay lại
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => const MessagingConversationListPage()));

        // Trả về false để ngăn chặn hành động quay lại mặc định
        return Future.value(false);
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.primary,
          leading: IconButton(
            onPressed: () {
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const MessagingConversationListPage()));
            },
            icon: const FaIcon(FaIcons.arrowLeft, color: Palette.white),
          ),
          title: Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundImage: ExtendedNetworkImageProvider(
                    model.infoGroup.partnerAvatar == null
                        ? 'https://drive.google.com/uc?id=${avatarNull.split('/d/')[1].split('/')[0]}'
                        : 'https://drive.google.com/uc?id=${model.infoGroup.partnerAvatar?.split('/d/')[1].split('/')[0]}',
                    cache: true),
              ),
              const SizedBox(width: 10),
              Text.rich(
                  TextSpan(children: [
                    TextSpan(
                        text: model.infoGroup.partnerName.toString().length > 16
                            ? "${model.infoGroup.partnerName.toString().substring(0, 16)}..."
                            : model.infoGroup.partnerName.toString(),
                        style: TypeStyle.title3.copyWith(color: Palette.white)),
                    // TextSpan(
                    //     text: "\nĐang hoạt động",
                    //     style: TypeStyle.body5.copyWith(color: Palette.grey40))
                  ]),
                  overflow: TextOverflow.ellipsis)
            ],
          ),
          actions: [
            IconButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => MessagingDetailSettingsPage(
                              user: MessageUserModel(
                                  id: model.infoGroup.partnerId,
                                  name: model.infoGroup.partnerName,
                                  avatar: model.infoGroup.partnerAvatar))));
                },
                icon: const FaIcon(FaIcons.circleInfo, color: Palette.white))
          ],
        ),
        body: _BuildBody(model),
      ),
    );
  }
}


class _BuildBody extends ConsumerStatefulWidget {
  final GroupChatModel model;
  const _BuildBody(this.model);

  @override
  ConsumerState<_BuildBody> createState() => _BuildBodyState();
}

class _BuildBodyState extends ConsumerState<_BuildBody> {
  final String webSocketUrl = 'http://157.66.24.126:8080/ws';
  late StompClient _client;
  final _controller = TextEditingController();
  final pagingController = PagingController<int, MessageModel>(firstPageKey: 0);

  var currentMessages = [];

  @override
  void initState() {
    super.initState();
    // connect to websocket
    _client = StompClient(
        config: StompConfig.sockJS(url: webSocketUrl, onConnect: onConnectCallback));
    _client.activate();
    pagingController.addPageRequestListener((nextPage) async {
      var model = await ref.read(
          messagesProvider((widget.model.infoGroup.groupId, nextPage, "true")).future);
      if (model.length < 20) {
        pagingController.appendLastPage(model);
      } else {
        pagingController.appendPage(model, nextPage + 1);
      }
      currentMessages = pagingController.value.itemList ?? [];
      if (widget.model.infoGroup.lastMessageUnRead == 1) ref.read(countProvider.notifier).state = widget.model.numNewMessage - 1;
    });
  }

  void _sendMessage() {
    final message = _controller.text;
    if (message.isNotEmpty) {
      print('message1: $message');
      print(_client.connected);
      _client.send(
        destination: '/chat/message', // Replace with your chat ID
        body: json.encode({
          'receiver': { 'id': widget.model.infoGroup.partnerId }, // id người nhân
          'content': message, // nội dung message
          'sender': ref.read(accountProvider).value?.email, // email người gửi
          'token': ref.read(accountProvider).value?.accessToken, // accessToken của người gửi
        }), // Format the message as needed
      );
      _controller.clear();
    }
  }

  void onConnectCallback(StompFrame connectFrame) {
    _client.subscribe(
        destination: '/user/${ref.read(accountProvider).value?.idAccount}/inbox',
        headers: {},
        callback: (frame) {
          print(frame.body);
          setState(() {
              ref.invalidate(messagesProvider);
              // ref.invalidate(groupChatProvider);
              pagingController.refresh();  // Đồng bộ với PagingController  // Thêm tin nhắn mới vào danh sách hiện tại
          });
        }
    );
  }

  @override
  Widget build(BuildContext context) {
    const avatarNull = 'https://drive.google.com/file/d/1TcbEp_FoZKrXbp-_82PfCeBYtgozFzJa/view?usp=sharing';
    return Column(
      children: [
        Expanded(
          child: RefreshIndicator(
            onRefresh: () async {
              ref.invalidate(messagesProvider);
              ref.invalidate(groupChatProvider);
              pagingController.refresh();
            },
            child: PagedListView<int, MessageModel>(
              reverse: true,
              builderDelegate: PagedChildBuilderDelegate(
                firstPageProgressIndicatorBuilder: (context) =>
                    SingleChildScrollView(
                      reverse: true,
                      child: SizedBox(
                        width: MediaQuery.sizeOf(context).width,
                        child: Column(children: [
                          const Text("Loading"),
                          ...currentMessages
                          .map((e) {
                            final isMe = e.user.id.toString() ==
                                ref.watch(accountProvider).value?.idAccount;
                            return isMe
                                ? Align(
                                    alignment: Alignment.centerRight,
                                    child: _MyMessageSection(message: e, conversationId: widget.model.infoGroup.groupId, page: pagingController,))
                                : Align(
                                    alignment: Alignment.centerLeft,
                                    child: _OtherMessageSection(message: e));
                              })
                              .toList()
                              .reversed
                        ]),
                      ),
                    ),
                        itemBuilder: (context, item, index) {
                  final isMe =
                      item.user.id.toString() == ref.watch(accountProvider).value!.idAccount;
                  return isMe
                      ? _MyMessageSection(message: item, conversationId: widget.model.infoGroup.groupId, page: pagingController,)
                      : _OtherMessageSection(message: item);
                },
                noMoreItemsIndicatorBuilder: (context) => Center(
                  child: Column(
                    children: [
                      CircleAvatar(
                          radius: 40,
                          backgroundImage: ExtendedNetworkImageProvider(
                              widget.model.infoGroup.partnerAvatar == null
                                  ? 'https://drive.google.com/uc?id=${avatarNull.split('/d/')[1].split('/')[0]}'
                                  : 'https://drive.google.com/uc?id=${widget.model.infoGroup.partnerAvatar?.split('/d/')[1].split('/')[0]}',
                              cache: true)),
                      const SizedBox(height: 10),
                      Text(
                          widget.model.infoGroup.partnerName.toString().length >
                                  16
                              ? "${widget.model.infoGroup.partnerName.toString().substring(0, 16)}..."
                              : widget.model.infoGroup.partnerName.toString(),
                          style: TypeStyle.title3,
                          overflow: TextOverflow.ellipsis),
                      const SizedBox(height: 40),
                    ],
                  ),
                ),
                noItemsFoundIndicatorBuilder: (context) => Center(
                  child: Column(
                    children: [
                      CircleAvatar(
                          radius: 40,
                          backgroundImage: ExtendedNetworkImageProvider(
                              widget.model.infoGroup.partnerAvatar == null
                                  ? 'https://drive.google.com/uc?id=${avatarNull.split('/d/')[1].split('/')[0]}'
                                  : 'https://drive.google.com/uc?id=${widget.model.infoGroup.partnerAvatar?.split('/d/')[1].split('/')[0]}',
                              cache: true)),
                      const SizedBox(width: 10),
                      Text(
                          widget.model.infoGroup.partnerName.toString().length >
                                  16
                              ? "${widget.model.infoGroup.partnerName.toString().substring(0, 16)}..."
                              : widget.model.infoGroup.partnerName.toString(),
                          style: TypeStyle.title3,
                          overflow: TextOverflow.ellipsis),
                      const SizedBox(height: 16),
                      const Text("Chưa có tin nhắn nào"),
                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ),
              pagingController: pagingController,
            ),
          ),
        ),
        SizedBox(
            height: 64,
            child: Row(children: [
              const SizedBox(width: 8),
              IconButton(
                  onPressed: () {
                    AssetPicker.pickAssets(context,
                            pickerConfig: const AssetPickerConfig(
                                maxAssets: 1, requestType: RequestType.image))
                        .then((value) async {
                      if (value?.isEmpty ?? true) return;
                      // ref
                      //     .read(addMessageProvider((
                      //   widget.model.infoGroup.groupId,
                      //   "first_message",
                      //   await ref
                      //       .read(mediaRepositoryProvider)
                      //       .api
                      //       .addImage((await value!.first.file)!)
                      // )).future)
                      //     .then((_) {
                      //   ref.invalidate(messagesProvider);
                      //   pagingController.refresh();
                      // });
                    });
                  },
                  icon: const FaIcon(FaIcons.image)
              ),
              Expanded(
                child: Container(
                  clipBehavior: Clip.antiAlias,
                  margin: const EdgeInsets.all(8.0),
                  decoration:
                      BoxDecoration(borderRadius: BorderRadius.circular(24)),
                  child: TextField(
                      controller: _controller,
                      decoration: const InputDecoration(
                          hintText: "",
                          focusedBorder: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          border: InputBorder.none,
                          filled: true,
                          fillColor: Palette.grey40)),
                ),
              ),
              IconButton(
                  onPressed: () {
                    _sendMessage();
                  },
                  icon: const FaIcon(FaIcons.solidPaperPlane)
              ),
              const SizedBox(width: 8),
            ]))
      ],
    );
  }

  @override
  void dispose() {
    _client.deactivate();
    _controller.dispose();
    super.dispose();
  }
}

class _MyMessageSection extends StatefulWidget {
  final MessageModel message;
  final int conversationId;
  final dynamic page;

  const _MyMessageSection({required this.message, required this.conversationId, required this.page});

  @override
  State<_MyMessageSection> createState() => _MyMessageSectionState();
}

class _MyMessageSectionState extends State<_MyMessageSection> {
  bool showStatus = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          showStatus = !showStatus;
        });
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (showStatus)
            Center(
                child: Text(
                    formatMessageDate(DateTime.parse(widget.message.createdAt)),
                    style: TypeStyle.body5)
            ),
            widget.message.message != "first_message"
                ? _TextMessageBubble(
                    page: widget.page,
                    messageId: widget.message.messageId,
                    conversationId: widget.conversationId,
                    msg: widget.message.message ?? "Tin nhắn đã bị xóa",
                    foreground: Palette.black,
                    background: Color.lerp(Theme.of(context).colorScheme.primary,
                        Palette.white, 0.5)!,
                    style: widget.message.message != null ? "" : "delete")
                : const SizedBox(),
            if (showStatus)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Text("Đã xem",
                    style: TypeStyle.body5.copyWith(fontWeight: FontWeight.bold)),
              )
        ],
      ),
    );
  }
}

class _TextMessageBubble extends ConsumerStatefulWidget {
  final String msg;
  final Color background;
  final Color foreground;
  final String style;
  final dynamic page;
  final String messageId;
  final int conversationId;

  const _TextMessageBubble(
      {required this.msg, required this.background, required this.foreground, required this.style, required this.page, required this.messageId, required this.conversationId});

  @override
  ConsumerState<_TextMessageBubble> createState() => _TextMessageBubbleState();
}
class _TextMessageBubbleState extends ConsumerState<_TextMessageBubble> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: () {
        showOptionModal(context: context, blocks: [
          [
            BottomSheetListTile(
              leading: FaIcons.solidCopy,
              title: "Sao chép",
              onTap: () {
                if (widget.msg == "Tin nhắn đã bị xóa" && widget.style == "delete") {
                  Navigator.pop(context);
                  Fluttertoast.showToast(msg: "Không thể sao chép tin nhắn đã xóa");
                } else {
                  Clipboard.setData(ClipboardData(text: widget.msg)).then(
                      (value) => {
                        Navigator.pop(context),
                        Fluttertoast.showToast(msg: "Đã sao chép.")
                      },
                );
                }
              },
            ),
            BottomSheetListTile(
              leading: FaIcons.trash,
              title: "Xóa tin nhắn",
              onTap: () {
                if (widget.msg == "Tin nhắn đã bị xóa" && widget.style == "delete") {
                  Navigator.pop(context);
                  Fluttertoast.showToast(msg: "Tin nhắn đã bị xóa");
                } else if (widget.conversationId != -1) {
                  Map<String, dynamic> data = {
                    'message_id': widget.messageId,
                    'conversation_id': widget.conversationId
                  };
                  ref.read(deleteMessageProvider(data).future).then((value) {
                    if (value) {
                      setState(() {
                        ref.invalidate(messagesProvider);
                        ref.invalidate(groupChatProvider);
                        widget.page.refresh();
                        Navigator.pop(context);
                        Fluttertoast.showToast(msg: "Xóa tin nhắn thành công");
                      });
                    } else {
                      Navigator.pop(context);
                      Fluttertoast.showToast(msg: "Xóa tin nhắn thất bại");
                    }
                  });
                } else {
                  Navigator.pop(context);
                  Fluttertoast.showToast(msg: "Không thể xóa tin nhắn của người khác");
                }
              },
            ),
          ],
        ]);
      },
      child: Container(
          clipBehavior: Clip.antiAlias,
          margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
              color: widget.background, borderRadius: BorderRadius.circular(5)),
          constraints: BoxConstraints.loose(
              Size.fromWidth(MediaQuery.sizeOf(context).width / 3 * 2)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: SWMarkdown(data: widget.msg, style: widget.style),
              ),
              AnyLinkPreview(
                  link: widget.msg,
                  errorWidget: const SizedBox(),
                  borderRadius: 0,
                  previewHeight: null,
                  removeElevation: true,
                  titleStyle: TypeStyle.title3,
                  bodyStyle: TypeStyle.body3,
                  backgroundColor: Palette.grey25)
            ],
          )),
    );
  }

  // void openBottomSheet(BuildContext context) {
  //   showModalBottomSheet(
  //       shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
  //       context: context,
  //       builder: (context) => BottomSheet(
  //           enableDrag: false,
  //           backgroundColor: Palette.grey40,
  //           onClosing: () {},
  //           shape:
  //               const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
  //           builder: (context) => SizedBox(
  //                 height: MediaQuery.sizeOf(context).width / 4,
  //                 child: Row(
  //                   children: [
  //                     Expanded(
  //                         child: InkWell(
  //                       onTap: () {
  //                         Clipboard.setData(ClipboardData(text: widget.msg)).then(
  //                             (value) =>
  //                                 Fluttertoast.showToast(msg: "Đã sao chép."));
  //                       },
  //                       child: const Column(
  //                         mainAxisAlignment: MainAxisAlignment.center,
  //                         children: [
  //                           FaIcon(FaIcons.solidCopy),
  //                           SizedBox(height: 8),
  //                           Text("Sao chép")
  //                         ],
  //                       ),
  //                     ))
  //                   ],
  //                 ),
  //               )));
  // }
}

// class _ImageMessageBubble extends StatelessWidget {
//   final String img;
//
//   const _ImageMessageBubble({required this.img});
//
//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: () {
//         context.push("$imageRoute?url=$img");
//       },
//       child: Hero(
//         tag: img,
//         child: Container(
//             clipBehavior: Clip.antiAlias,
//             margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//             decoration: BoxDecoration(borderRadius: BorderRadius.circular(5)),
//             constraints: BoxConstraints.loose(
//                 Size.fromWidth(MediaQuery.sizeOf(context).width / 3 * 2)),
//             child: AspectRatio(
//                 aspectRatio: 16 / 9,
//                 child: ExtendedImage(
//                   image: ExtendedNetworkImageProvider(img, cache: true),
//                   fit: BoxFit.cover,
//                   gaplessPlayback: true,
//                   loadStateChanged: (state) =>
//                       switch (state.extendedImageLoadState) {
//                     LoadState.failed => Container(
//                         alignment: Alignment.center,
//                         color: Palette.grey40,
//                         child: const FaIcon(FaIcons.circleExclamation,
//                             color: Palette.white)),
//                     _ => null
//                   },
//                 ))),
//       ),
//     );
//   }
// }

class _OtherMessageSection extends StatefulWidget {
  final MessageModel message;

  const _OtherMessageSection({required this.message});

  @override
  State<_OtherMessageSection> createState() => _OtherMessageSectionState();
}

class _OtherMessageSectionState extends State<_OtherMessageSection> {
  bool showStatus = false;

  @override
  Widget build(BuildContext context) {
    const avatarNull = 'https://drive.google.com/file/d/1TcbEp_FoZKrXbp-_82PfCeBYtgozFzJa/view?usp=sharing';
    return GestureDetector(
      onTap: () {
        setState(() {
          showStatus = !showStatus;
        });
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (showStatus)
            Center(
                child: Text(
                    formatMessageDate(DateTime.parse(widget.message.createdAt)),
                    style: TypeStyle.body5)),
          // if (widget.message.unread == 1) Center(
          //   child: Text("Chưa đọc",
          //     style:
          //     TypeStyle.body5.copyWith(fontWeight: FontWeight.bold))
          //     ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(4),
                child: CircleAvatar(
                    radius: 20,
                    backgroundImage:  ExtendedNetworkImageProvider(
                          widget.message.user.avatar == null
                          ? 'https://drive.google.com/uc?id=${avatarNull.split('/d/')[1].split('/')[0]}'
                              : 'https://drive.google.com/uc?id=${widget.message.user.avatar?.split('/d/')[1].split('/')[0]}',
                            cache: true)
                        ),
              ),
              widget.message.message != "first_message"
                  ? _TextMessageBubble(
                    messageId: widget.message.messageId,
                    conversationId: -1,
                    page: null,
                    msg: widget.message.message ?? "Tin nhắn đã bị xóa",
                    foreground: Palette.black,
                    background: Color.lerp(Theme.of(context).colorScheme.primary,
                    Palette.white, 0.5)!,
                    style: widget.message.message != null ? "" : "delete",)
                  : const SizedBox(),
            ],
          ),
          if (showStatus)
            Padding(
                padding: const EdgeInsets.only(left: 56),
                child: Text("Đã xem",
                    style:
                        TypeStyle.body5.copyWith(fontWeight: FontWeight.bold))
            )
        ],
      ),
    );
  }
}
