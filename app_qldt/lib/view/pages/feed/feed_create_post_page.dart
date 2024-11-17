import 'dart:io';

import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mentions/flutter_mentions.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:app_qldt/core/common/types.dart';
import 'package:app_qldt/core/theme/palette.dart';
import 'package:app_qldt/core/theme/typestyle.dart';
import 'package:app_qldt/controller/post_provider.dart';
import 'package:app_qldt/controller/user_provider.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';

class FeedCreatePostPage extends StatelessWidget {
  const FeedCreatePostPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const _BuildBody();
  }
}

class _BuildBody extends ConsumerStatefulWidget {
  const _BuildBody();

  @override
  ConsumerState<_BuildBody> createState() => _BuildBodyState();
}

class _BuildBodyState extends ConsumerState<_BuildBody> {
  final key = GlobalKey<FlutterMentionsState>();
  bool isSubmitted = false;
  List<AssetEntity> _assets = const [];

  @override
  Widget build(BuildContext context) {
    print([
      ...?ref.watch(userFollowerProvider).value?.map(
          (e) => {"id": e.userId, "display": e.displayName, "avatar": e.avatar})
    ]);

    return Scaffold(
      appBar: AppBar(
          title: const Text("Tạo bài viết"),
          leading: IconButton(
              onPressed: () => context.pop(),
              icon: const FaIcon(FaIcons.arrowLeft))),
      body: Container(
        decoration: BoxDecoration(
            color: Palette.white, borderRadius: BorderRadius.circular(10)),
        padding: const EdgeInsets.all(8),
        margin: const EdgeInsets.all(8),
        child: Column(
          children: [
            Row(
              children: [
                CircleAvatar(
                    radius: 20,
                    backgroundImage: ExtendedNetworkImageProvider(
                        ref.read(userProvider).value?.avatar ??
                            "https://picsum.photos/1024",
                        cache: true)),
                const SizedBox(width: 14),
                Text(ref.watch(userProvider).value?.displayName ?? "",
                    style: TypeStyle.title3),
              ],
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: FlutterMentions(
                          key: key,
                          mentions: [
                            Mention(
                                trigger: "@",
                                style: const TextStyle(color: Colors.amber),
                                data: [
                                  ...?ref
                                      .watch(userFollowerProvider)
                                      .value
                                      ?.map((e) => {
                                            "id": e.userId,
                                            "display": e.displayName,
                                            "avatar": e.avatar
                                          })
                                ],
                                markupBuilder: (trigger, mention, value) {
                                  return "$trigger[$mention]";
                                },
                                suggestionBuilder: (data) {
                                  return Container(
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 20.0),
                                    decoration:
                                        BoxDecoration(border: Border.all()),
                                    child: Row(
                                      children: <Widget>[
                                        CircleAvatar(
                                            backgroundImage:
                                                NetworkImage(data['avatar'])),
                                        const SizedBox(width: 20.0),
                                        Text('@${data['display']}')
                                      ],
                                    ),
                                  );
                                }),
                          ],
                          minLines: 1,
                          maxLines: 10,
                          style: TypeStyle.body3,
                          decoration: InputDecoration(
                              filled: false,
                              hintText: "Hãy soạn nội dung bài viết...*",
                              hintStyle: TypeStyle.body3
                                  .copyWith(color: Palette.grey55),
                              border: InputBorder.none,
                              enabledBorder: InputBorder.none,
                              focusedBorder: InputBorder.none)),
                    ),
                    FutureBuilder(
                        future: Future.wait(_assets
                            .map(
                              (e) async => ExtendedImage.file((await e.file)!,
                                  height: double.infinity, fit: BoxFit.cover),
                            )
                            .toList()),
                        builder: (context, snapshot) {
                          if (snapshot.data?.isEmpty ?? true) {
                            return Container();
                          }
                          return AspectRatio(
                            aspectRatio: 1,
                            child: GridView.count(
                                mainAxisSpacing: 10,
                                crossAxisSpacing: 10,
                                childAspectRatio: 1,
                                crossAxisCount: snapshot.data!.length,
                                children:
                                    snapshot.data!.map((e) => e).toList()),
                          );
                        }),
                  ],
                ),
              ),
            ),
            Row(
              children: [
                IconButton(
                    onPressed: () async {
                      var assets = await AssetPicker.pickAssets(context,
                          pickerConfig: AssetPickerConfig(
                              selectedAssets: _assets,
                              requestType: RequestType.image,
                              maxAssets: 4));
                      setState(() {
                        _assets = assets ?? [];
                      });
                    },
                    icon: const FaIcon(FaIcons.image)),
                IconButton(
                    onPressed: () async {
                      var assets = await AssetPicker.pickAssets(context,
                          pickerConfig: AssetPickerConfig(
                              selectedAssets: _assets,
                              requestType: RequestType.video,
                              maxAssets: 1));
                      setState(() {
                        _assets = assets ?? [];
                      });
                    },
                    icon: const FaIcon(FaIcons.video)),
                const Spacer(),
                FilledButton(
                    onPressed: isSubmitted
                        ? null
                        : () async {
                            setState(() {
                              isSubmitted = true;
                            });
                            Fluttertoast.showToast(
                                msg: "Đang đăng tải bài viết...");
                            await ref.read(postProvider.notifier).addPost(
                                description:
                                    key.currentState!.controller!.markupText,
                                tag: key
                                    .currentState!.controller!.mapping.values
                                    .map((e) => "${e.id}")
                                    .toList(),
                                media: await Future.wait(_assets.map((e) => e
                                    .file
                                    .then((value) => value ?? File("")))));
                            if (context.mounted) context.pop();
                          },
                    child: const Text("Đăng"))
              ],
            )
          ],
        ),
      ),
    );
  }
}
