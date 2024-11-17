import "package:extended_image/extended_image.dart";
import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:go_router/go_router.dart";
import "package:share_plus/share_plus.dart";
import "package:app_qldt/controller/messaging_provider.dart";
import "package:app_qldt/core/router/router.dart";
import "package:app_qldt/core/router/url.dart";
import "package:app_qldt/core/theme/palette.dart";
import "package:app_qldt/core/theme/typestyle.dart";
import "package:app_qldt/model/entities/user_model.dart";
import "package:app_qldt/controller/user_provider.dart";
import "package:url_launcher/url_launcher.dart";

class ProfileOtherPage extends StatelessWidget {
  const ProfileOtherPage({super.key, required this.userId});

  final String userId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: _BuildBody(userId));
  }
}

class _BuildBody extends ConsumerWidget {
  const _BuildBody(this.userId);
  final String userId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    switch (ref.watch(otherUserProvider(userId))) {
      case AsyncData<(bool, UserModel)> data:
        final displayName = data.value.$2.displayName;
        final avatar = data.value.$2.avatar;
        return CustomScrollView(
          slivers: [
            SliverAppBar.large(
              collapsedHeight: MediaQuery.sizeOf(context).height / 10,
              expandedHeight: MediaQuery.sizeOf(context).height / 2.5,
              floating: true,
              pinned: true,
              stretch: true,
              title: Text(displayName),
              flexibleSpace: FlexibleSpaceBar(
                background: Stack(
                  children: [
                    Positioned.fill(
                      bottom: MediaQuery.sizeOf(context).height / 5,
                      child: GestureDetector(
                        onTap: () => context
                            .push("$imageRoute?url=https://picsum.photos/1024"),
                        child: Hero(
                          tag: "https://picsum.photos/1024",
                          child: Container(
                            clipBehavior: Clip.antiAlias,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.elliptical(
                                      MediaQuery.sizeOf(context).width / 2,
                                      MediaQuery.sizeOf(context).width / 15),
                                  bottomRight: Radius.elliptical(
                                      MediaQuery.sizeOf(context).width / 2,
                                      MediaQuery.sizeOf(context).width / 15)),
                              image: DecorationImage(
                                  colorFilter: const ColorFilter.mode(
                                      Colors.black54, BlendMode.darken),
                                  image: ExtendedNetworkImageProvider(
                                      "https://picsum.photos/1024"),
                                  fit: BoxFit.cover),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      left: MediaQuery.sizeOf(context).width / 20,
                      right: MediaQuery.sizeOf(context).width / 20,
                      child: Column(
                        children: [
                          GestureDetector(
                            onTap: () =>
                                context.push("$imageRoute?url=$avatar"),
                            child: Container(
                              padding: const EdgeInsets.all(5),
                              decoration: const ShapeDecoration(
                                  color: Colors.white, shape: CircleBorder()),
                              child: Hero(
                                tag: avatar ?? "https://picsum.photos/1024",
                                child: CircleAvatar(
                                    backgroundImage:
                                        ExtendedNetworkImageProvider(avatar ??
                                            "https://picsum.photos/1024"),
                                    radius: 45),
                              ),
                            ),
                          ),
                          Row(children: [
                            Text(displayName, style: TypeStyle.title1)
                          ]),
                          Row(children: [
                            data.value.$1
                                ? Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: FilledButton(
                                          style: FilledButton.styleFrom(
                                              backgroundColor: Palette.red),
                                          onPressed: ref
                                              .read(otherUserProvider(userId)
                                                  .notifier)
                                              .unFollowing,
                                          child: const Text("Hủy theo dõi")),
                                    ),
                                  )
                                : Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: FilledButton(
                                          onPressed: ref
                                              .read(otherUserProvider(userId)
                                                  .notifier)
                                              .following,
                                          child: const Text("Theo dõi")),
                                    ),
                                  ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: FilledButton.tonal(
                                    onPressed: () {
                                      ref
                                          .read(addGroupChatProvider((
                                        null,
                                        [
                                          ref.read(userProvider).value!.userId,
                                          userId
                                        ],
                                        null,
                                        "two_people"
                                      )).future)
                                          .then((_) {
                                        rootNavigatorKey.currentContext
                                            ?.push(messagingRoute);
                                      });
                                    },
                                    child: const Text("Nhắn tin")),
                              ),
                            )
                          ]),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
            const SliverFillRemaining(
                child: Center(
              child:
                  Text("Những bài viết trên tường nhà sẽ được hiển thị ở đây"),
            ))
          ],
        );
      case AsyncLoading _:
        return const Center(child: CircularProgressIndicator());
      case AsyncError ae:
        return Center(child: Text(ae.toString()));
      default:
        return const Center(child: Text("Có lỗi xảy ra"));
    }
  }

  Future<void> handleShare() async {
    await Share.shareUri(Uri.parse("https://picsum.photos/256"));
  }

  Future<void> handleShowContactInfo(
      BuildContext context, UserModel user) async {
    showModalBottomSheet(
        context: context,
        backgroundColor: Palette.white,
        showDragHandle: true,
        builder: (context) => SingleChildScrollView(
              child: Container(
                  width: MediaQuery.sizeOf(context).width,
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  decoration: const BoxDecoration(color: Palette.white),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 15),
                        child: Row(
                          children: [
                            const Text("Thông tin người dùng",
                                style: TypeStyle.title1),
                            const Spacer(),
                            TextButton(
                                onPressed: () {
                                  rootNavigatorKey.currentContext
                                      ?.go("$profileRoute/edit");
                                },
                                child: const Text("Chỉnh sửa"))
                          ],
                        ),
                      ),
                      ListTile(
                          title: const Text("Tên", style: TypeStyle.body4),
                          subtitle: Text(user.displayName,
                              style: TypeStyle.body3.copyWith(
                                  color:
                                      Theme.of(context).colorScheme.primary))),
                      if (user.email != null)
                        InkWell(
                          splashFactory: InkRipple.splashFactory,
                          onTap: () =>
                              launchUrl(Uri.parse("mailto:${user.email}")),
                          child: ListTile(
                              title:
                                  const Text("Email", style: TypeStyle.body4),
                              subtitle: Text(user.email!,
                                  style: TypeStyle.body3.copyWith(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .primary))),
                        ),
                      ListTile(
                          title:
                              const Text("Giới tính", style: TypeStyle.body4),
                          subtitle: Text(user.gender.raw,
                              style: TypeStyle.body3.copyWith(
                                  color:
                                      Theme.of(context).colorScheme.primary))),
                      InkWell(
                        splashFactory: InkRipple.splashFactory,
                        onTap: () =>
                            launchUrl(Uri.parse("tel:${user.phoneNumber}")),
                        child: ListTile(
                            title: const Text("Số điện thoại",
                                style: TypeStyle.body4),
                            subtitle: Text(user.phoneNumber,
                                style: TypeStyle.body3.copyWith(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .primary))),
                      ),
                      ListTile(
                          title: const Text("Địa chỉ", style: TypeStyle.body4),
                          subtitle: Text(user.address,
                              style: TypeStyle.body3.copyWith(
                                  color:
                                      Theme.of(context).colorScheme.primary))),
                    ],
                  )),
            ));
  }
}
