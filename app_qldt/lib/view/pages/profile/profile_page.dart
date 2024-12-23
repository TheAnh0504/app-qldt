import "package:app_qldt/controller/account_provider.dart";
import "package:app_qldt/model/entities/account_model.dart";
import "package:extended_image/extended_image.dart";
import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:font_awesome_flutter/font_awesome_flutter.dart";
import "package:go_router/go_router.dart";
import "package:share_plus/share_plus.dart";
import "package:app_qldt/core/common/types.dart";
import "package:app_qldt/core/router/router.dart";
import "package:app_qldt/core/router/url.dart";
import "package:app_qldt/core/theme/palette.dart";
import "package:app_qldt/core/theme/typestyle.dart";
import "package:app_qldt/model/entities/user_model.dart";
import "package:app_qldt/controller/user_provider.dart";
import "package:url_launcher/url_launcher.dart";

import "../../../controller/list_class_provider.dart";
import "../../../model/entities/class_info_model.dart";

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: _BuildBody());
  }
}

class _BuildBody extends ConsumerWidget {
  const _BuildBody();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ref.watch(accountProvider).when(
        skipLoadingOnRefresh: false,
        data: (data) {
          final idAccount = data?.idAccount;
          var ho = data?.ho;
          var ten = data?.ten;
          final name = data?.name;
          final email = data?.email;
          final role = data?.role;
          final status = data?.status;
          var avatar = data?.avatar != ""
              ? 'https://drive.google.com/uc?id=${data?.avatar.split('/d/')[1].split('/')[0]}'
              : null;
          var linkAvatarHust = 'https://drive.google.com/file/d/1RD5P0nSyYtL8DcSbaUDb7iBWUgK7MBEC/view?usp=sharing';
          var avatarHust = 'https://drive.google.com/uc?id=${linkAvatarHust.split('/d/')[1].split('/')[0]}';
          final List<ClassInfoModel>? classList = ref.read(listClassRegisterNowProvider).value!;
          print("list class: $classList");
          return RefreshIndicator(
            onRefresh: () async {
              await ref.read(listClassRegisterNowProvider.notifier).getRegisterClassNow();
            },
            child: CustomScrollView(
              slivers: [
                SliverAppBar.large(
                  collapsedHeight: MediaQuery.sizeOf(context).height / 10,
                  expandedHeight: MediaQuery.sizeOf(context).height / 3,
                  floating: true,
                  pinned: true,
                  stretch: true,
                  title: Text(name!),
                  flexibleSpace: FlexibleSpaceBar(
                    background: Stack(
                      children: [
                        Positioned.fill(
                          bottom: MediaQuery.sizeOf(context).height / 6,
                          child: GestureDetector(
                            onTap: () => context.push(
                                "$imageRoute?url=$avatarHust"),
                            child: Hero(
                              tag: linkAvatarHust,
                              child: Container(
                                clipBehavior: Clip.antiAlias,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                      bottomLeft: Radius.elliptical(
                                          MediaQuery.sizeOf(context).width / 2,
                                          MediaQuery.sizeOf(context).width /
                                              15),
                                      bottomRight: Radius.elliptical(
                                          MediaQuery.sizeOf(context).width / 2,
                                          MediaQuery.sizeOf(context).width /
                                              15)),
                                  image: const DecorationImage(
                                      colorFilter: ColorFilter.mode(
                                          Colors.black54, BlendMode.darken),
                                      image: AssetImage('images/hust.png'),
                                      fit: BoxFit.cover),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 40,
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
                                      color: Colors.white,
                                      shape: CircleBorder()),
                                  child: Hero(
                                    tag: avatar ?? "Default avatar",
                                    child: avatar == null
                                        ? const CircleAvatar(
                                      backgroundImage: AssetImage('images/avatar-trang.jpg'),
                                      radius: 45,
                                    ) : CircleAvatar(
                                        backgroundImage:
                                            ExtendedNetworkImageProvider(avatar),
                                        radius: 45),
                                  ),
                                ),
                              ),
                              Row(
                                children: [
                                  Text(name, style: TypeStyle.title1),
                                  const Spacer(),
                                  IconButton(
                                      onPressed: () =>
                                          handleShowContactInfo(context, data!),
                                      icon: const FaIcon(FaIcons.addressCard)
                                  ),
                                  // IconButton(
                                  //     onPressed: handleShare,
                                  //     icon: const FaIcon(FaIcons.share))
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SliverFillRemaining(
                    child: Center(
                  child: Column(
                    children: [
                       // Text("Tìm kiếm gần đây", style: TypeStyle.title3)
                      //TODO: table- list class: click -> info class
                    ],
                  )
                )),
              ],
            ),
          );
        },
        error: (_, __) => const Center(child: Text("Có lỗi xảy ra")),
        loading: () => const Center(child: CircularProgressIndicator()));
  }

  Future<void> handleShare() async {
    await Share.shareUri(Uri.parse("https://picsum.photos/256"));
  }

  Future<void> handleShowContactInfo(BuildContext context, AccountModel account) async {
    showModalBottomSheet(
        context: context,
        backgroundColor: Palette.white,
        showDragHandle: true,
        isScrollControlled: true, // Cho phép tùy chỉnh chiều cao
        builder: (context) => FractionallySizedBox(
        heightFactor: 6/10, // Chiều cao bằng 2/3 màn hình
        child: SingleChildScrollView(
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
                             Text('Thông tin ${account.role == 'STUDENT' ? 'sinh viên' : 'giảng viên'}',
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
                          title: Text(account.role == 'STUDENT' ? 'Sinh viên' : 'Giảng viên', style: TypeStyle.body4),
                          subtitle: Text(account.name,
                              style: TypeStyle.body3.copyWith(
                                  color:
                                      Theme.of(context).colorScheme.primary))),
                      InkWell(
                        splashFactory: InkRipple.splashFactory,
                        onTap: () =>
                            launchUrl(Uri.parse("mailto:${account.email}")),
                        child: ListTile(
                            title:
                                const Text("Email", style: TypeStyle.body4),
                            subtitle: Text(account.email,
                                style: TypeStyle.body3.copyWith(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .primary))),
                      ),
                      ListTile(
                          title: const Text("MSSV", style: TypeStyle.body4),
                          subtitle: Text(account.idAccount,
                              style: TypeStyle.body3.copyWith(
                                  color:
                                  Theme.of(context).colorScheme.primary))),
                      ListTile(
                          title: const Text("Họ", style: TypeStyle.body4),
                          subtitle: Text(account.ho,
                              style: TypeStyle.body3.copyWith(
                                  color:
                                      Theme.of(context).colorScheme.primary))),
                      ListTile(
                          title: const Text("Tên", style: TypeStyle.body4),
                          subtitle: Text(account.ten,
                              style: TypeStyle.body3.copyWith(
                                  color:
                                  Theme.of(context).colorScheme.primary))),
                      // InkWell(
                      //   splashFactory: InkRipple.splashFactory,
                      //   onTap: () =>
                      //       launchUrl(Uri.parse("tel:${account.idAccount}")),
                      //   child: ListTile(
                      //       title: const Text("Số điện thoại",
                      //           style: TypeStyle.body4),
                      //       subtitle: Text(account.idAccount,
                      //           style: TypeStyle.body3.copyWith(
                      //               color: Theme.of(context)
                      //                   .colorScheme
                      //                   .primary))),
                      // ),
                    ],
                  )
              ),)
        )
    );
  }
}
