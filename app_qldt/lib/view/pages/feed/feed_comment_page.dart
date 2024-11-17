import 'package:extended_image/extended_image.dart';
import 'package:faker_dart/faker_dart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:app_qldt/core/common/types.dart';
import 'package:app_qldt/core/theme/palette.dart';
import 'package:app_qldt/core/theme/typestyle.dart';
import 'package:app_qldt/controller/post_provider.dart';
import 'package:app_qldt/controller/user_provider.dart';

class FeedCommentPage extends StatelessWidget {
  final String postId;
  final String? commentId;

  const FeedCommentPage({super.key, required this.postId, this.commentId});

  @override
  Widget build(BuildContext context) {
    return _BuildBody(postId, commentId);
  }
}

class _BuildBody extends ConsumerStatefulWidget {
  final String postId;
  final String? commentId;
  const _BuildBody(this.postId, this.commentId);

  @override
  ConsumerState<_BuildBody> createState() => _BuildBodyState();
}

class _BuildBodyState extends ConsumerState<_BuildBody> {
  final _controller = TextEditingController();
  bool isSubmitted = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
              onPressed: context.pop, icon: const FaIcon(FaIcons.arrowLeft)),
          title: const Text("Bình luận"),
        ),
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
                          Faker.instance.image.image(),
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
                        child: TextField(
                            controller: _controller,
                            maxLines: null,
                            style: TypeStyle.body3,
                            decoration: InputDecoration(
                                filled: false,
                                hintText: "Hãy soạn nội dung bình luận...",
                                hintStyle: TypeStyle.body3
                                    .copyWith(color: Palette.grey55),
                                border: InputBorder.none,
                                enabledBorder: InputBorder.none,
                                focusedBorder: InputBorder.none)),
                      ),
                    ],
                  ),
                ),
              ),
              Row(
                children: [
                  const Spacer(),
                  FilledButton(
                      onPressed: isSubmitted
                          ? null
                          : () async {
                              setState(() {
                                isSubmitted = true;
                              });
                              Fluttertoast.showToast(msg: "Đang bình luận...");
                              await ref.read(postProvider.notifier).comment(
                                  description: _controller.text.trim(),
                                  postId: widget.postId,
                                  commentId: widget.commentId);
                              if (context.mounted) context.pop();
                            },
                      child: const Text("Bình luận"))
                ],
              )
            ],
          ),
        ));
  }
}
