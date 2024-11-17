import 'dart:async';

import 'package:any_link_preview/any_link_preview.dart';
import 'package:extended_image/extended_image.dart';
import 'package:faker_dart/faker_dart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
import 'package:wechat_assets_picker/wechat_assets_picker.dart';

class MessagingDetailPage extends StatelessWidget {
  final GroupChatModel model;
  const MessagingDetailPage({super.key, required this.model});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
              onPressed: context.pop, icon: const FaIcon(FaIcons.arrowLeft)),
          title: Row(
            children: [
              CircleAvatar(
                  radius: 20,
                  backgroundImage: ExtendedNetworkImageProvider(
                      "https://picsum.photos/200",
                      cache: true)),
              const SizedBox(width: 10),
              Text.rich(
                  TextSpan(children: [
                    TextSpan(
                        text: model.infoGroup.groupName.toString().length > 16
                            ? "${model.infoGroup.groupName.toString().substring(0, 16)}..."
                            : model.infoGroup.groupName.toString(),
                        style: TypeStyle.title3),
                    TextSpan(
                        text: "\nĐang hoạt động",
                        style: TypeStyle.body5.copyWith(color: Palette.grey40))
                  ]),
                  overflow: TextOverflow.ellipsis)
            ],
          ),
          actions: [
            IconButton(
                onPressed: () {
                  // Navigator.push(
                  //     context,
                  //     MaterialPageRoute(
                  //         builder: (_) => const MessagingDetailSettingsPage(
                  //             user: MessageUserModel(
                  //                 userId: "0",
                  //                 displayName: "Nguyễn Văn A",
                  //                 avatar: "https://picsum.photos/200"))));
                },
                icon: const FaIcon(FaIcons.circleInfo))
          ],
        ),
        body: _BuildBody(model));
  }
}

class _BuildBody extends ConsumerStatefulWidget {
  final GroupChatModel model;
  const _BuildBody(this.model);

  @override
  ConsumerState<_BuildBody> createState() => _BuildBodyState();
}

class _BuildBodyState extends ConsumerState<_BuildBody> {
  final textController = TextEditingController();
  final pagingController = PagingController<int, MessageModel>(firstPageKey: 0);

  var currentMessages = [];
  Timer? timer;

  @override
  void initState() {
    super.initState();
    timer = Timer.periodic(const Duration(seconds: 5), (timer) {
      ref.invalidate(messagesProvider);
      pagingController.refresh();
    });
    pagingController.addPageRequestListener((nextPage) async {
      var model = await ref.read(
          messagesProvider((widget.model.infoGroup.groupId, nextPage)).future);
      if (model.length < 20) {
        pagingController.appendLastPage(model);
      } else {
        pagingController.appendPage(model, nextPage + 20);
      }
      currentMessages = pagingController.value.itemList ?? [];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: RefreshIndicator(
            onRefresh: () async {
              ref.invalidate(messagesProvider);
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
                            final isMe = e.user.userId ==
                                ref.watch(userProvider).value?.userId;
                            return isMe
                                ? Align(
                                    alignment: Alignment.centerRight,
                                    child: _MyMessageSection(message: e))
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
                      item.user.userId == ref.watch(userProvider).value?.userId;
                  return isMe
                      ? _MyMessageSection(message: item)
                      : _OtherMessageSection(message: item);
                },
                noMoreItemsIndicatorBuilder: (context) => Center(
                  child: Column(
                    children: [
                      CircleAvatar(
                          radius: 40,
                          backgroundImage: ExtendedNetworkImageProvider(
                              "https://picsum.photos/200",
                              cache: true)),
                      const SizedBox(width: 10),
                      Text(
                          widget.model.infoGroup.groupName.toString().length >
                                  16
                              ? "${widget.model.infoGroup.groupName.toString().substring(0, 16)}..."
                              : widget.model.infoGroup.groupName.toString(),
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
                              "https://picsum.photos/200",
                              cache: true)),
                      const SizedBox(width: 10),
                      Text(
                          widget.model.infoGroup.groupName.toString().length >
                                  16
                              ? "${widget.model.infoGroup.groupName.toString().substring(0, 16)}..."
                              : widget.model.infoGroup.groupName.toString(),
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
                      ref
                          .read(addMessageProvider((
                        widget.model.infoGroup.groupId,
                        "<media_link>",
                        await ref
                            .read(mediaRepositoryProvider)
                            .api
                            .addImage((await value!.first.file)!)
                      )).future)
                          .then((_) {
                        ref.invalidate(messagesProvider);
                        pagingController.refresh();
                      });
                    });
                  },
                  icon: const FaIcon(FaIcons.image)),
              Expanded(
                child: Container(
                  clipBehavior: Clip.antiAlias,
                  margin: const EdgeInsets.all(8.0),
                  decoration:
                      BoxDecoration(borderRadius: BorderRadius.circular(24)),
                  child: TextField(
                      controller: textController,
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
                    ref
                        .read(addMessageProvider((
                      widget.model.infoGroup.groupId,
                      textController.text,
                      null
                    )).future)
                        .then((_) {
                      textController.text = "";
                      ref.invalidate(messagesProvider);
                      pagingController.refresh();
                    });
                  },
                  icon: const FaIcon(FaIcons.solidPaperPlane)),
              const SizedBox(width: 8),
            ]))
      ],
    );
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }
}

class _MyMessageSection extends StatefulWidget {
  final MessageModel message;

  const _MyMessageSection({required this.message});

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
                    formatMessageDate(DateTime.parse(widget.message.createdAt),
                        Localizations.localeOf(context).languageCode),
                    style: TypeStyle.body5)),
          widget.message.message != "<media_link>"
              ? _TextMessageBubble(
                  msg: widget.message.message!,
                  foreground: Palette.black,
                  background: Color.lerp(Theme.of(context).colorScheme.primary,
                      Palette.white, 0.5)!)
              : _ImageMessageBubble(
                  img: widget.message.media ?? Faker.instance.image.image()),
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

class _TextMessageBubble extends StatelessWidget {
  final String msg;
  final Color background;
  final Color foreground;

  const _TextMessageBubble(
      {required this.msg, required this.background, required this.foreground});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: () => openBottomSheet(context),
      child: Container(
          clipBehavior: Clip.antiAlias,
          margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
              color: background, borderRadius: BorderRadius.circular(5)),
          constraints: BoxConstraints.loose(
              Size.fromWidth(MediaQuery.sizeOf(context).width / 3 * 2)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: SWMarkdown(data: msg),
              ),
              AnyLinkPreview(
                  link: msg,
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

  void openBottomSheet(BuildContext context) {
    showModalBottomSheet(
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
        context: context,
        builder: (context) => BottomSheet(
            enableDrag: false,
            backgroundColor: Palette.grey40,
            onClosing: () {},
            shape:
                const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
            builder: (context) => SizedBox(
                  height: MediaQuery.sizeOf(context).width / 4,
                  child: Row(
                    children: [
                      Expanded(
                          child: InkWell(
                        onTap: () {
                          Clipboard.setData(ClipboardData(text: msg)).then(
                              (value) =>
                                  Fluttertoast.showToast(msg: "Đã sao chép."));
                        },
                        child: const Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            FaIcon(FaIcons.solidCopy),
                            SizedBox(height: 8),
                            Text("Sao chép")
                          ],
                        ),
                      ))
                    ],
                  ),
                )));
  }
}

class _ImageMessageBubble extends StatelessWidget {
  final String img;

  const _ImageMessageBubble({required this.img});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.push("$imageRoute?url=$img");
      },
      child: Hero(
        tag: img,
        child: Container(
            clipBehavior: Clip.antiAlias,
            margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(5)),
            constraints: BoxConstraints.loose(
                Size.fromWidth(MediaQuery.sizeOf(context).width / 3 * 2)),
            child: AspectRatio(
                aspectRatio: 16 / 9,
                child: ExtendedImage(
                  image: ExtendedNetworkImageProvider(img, cache: true),
                  fit: BoxFit.cover,
                  gaplessPlayback: true,
                  loadStateChanged: (state) =>
                      switch (state.extendedImageLoadState) {
                    LoadState.failed => Container(
                        alignment: Alignment.center,
                        color: Palette.grey40,
                        child: const FaIcon(FaIcons.circleExclamation,
                            color: Palette.white)),
                    _ => null
                  },
                ))),
      ),
    );
  }
}

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
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(4),
                child: CircleAvatar(
                    radius: 20,
                    backgroundImage: (widget.message.user.avatar != null)
                        ? ExtendedNetworkImageProvider(
                            widget.message.user.avatar!,
                            cache: true)
                        : null),
              ),
              widget.message.message != "<media_link>"
                  ? _TextMessageBubble(
                      msg: widget.message.message!,
                      background: Palette.grey40,
                      foreground: Palette.black)
                  : _ImageMessageBubble(
                      img:
                          widget.message.media ?? Faker.instance.image.image()),
            ],
          ),
          if (showStatus)
            Padding(
                padding: const EdgeInsets.only(left: 56),
                child: Text("Đã xem",
                    style:
                        TypeStyle.body5.copyWith(fontWeight: FontWeight.bold)))
        ],
      ),
    );
  }
}
