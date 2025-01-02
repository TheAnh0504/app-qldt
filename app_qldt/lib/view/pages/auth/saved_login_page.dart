import "package:connectivity_plus/connectivity_plus.dart";
import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:fluttertoast/fluttertoast.dart";
import "package:font_awesome_flutter/font_awesome_flutter.dart";
import "package:go_router/go_router.dart";
import "package:app_qldt/core/common/types.dart";
import "package:app_qldt/core/router/url.dart";
import "package:app_qldt/core/theme/palette.dart";
import "package:app_qldt/view/widgets/sw_popup.dart";
import "package:app_qldt/controller/account_provider.dart";
import "package:app_qldt/controller/saved_account_provider.dart";

import "../../../core/theme/typestyle.dart";

class SavedLoginPage extends StatelessWidget {
  const SavedLoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      extendBodyBehindAppBar: true,
      body: const _BuildBody(),
    );
  }
}

class _BuildBody extends ConsumerStatefulWidget {
  const _BuildBody();

  @override
  ConsumerState<_BuildBody> createState() => _BuildBodyState();
}

class _BuildBodyState extends ConsumerState<_BuildBody> {
  final username = TextEditingController();
  final password = TextEditingController();
  bool isHidden = true;

  @override
  Widget build(BuildContext context) {
    ref.listen(accountProvider, (prev, next) {
      if (next is AsyncError) {
        Fluttertoast.showToast(msg: next.error.toString());
      }
      if (next is AsyncData &&
          next.value?.status == "Kích hoạt") {
        context.go(feedRoute);
      }
    });

    ref.listen(savedAccountProvider, (prev, next) {
      if (next is AsyncData && (next.value?.isEmpty ?? true)) {
        context.go(loginRoute);
      }
    });

    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: const BoxDecoration(
          color: Palette.white,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(0), topRight: Radius.circular(0))),
      margin: EdgeInsets.only(top: MediaQuery.sizeOf(context).width / 5),
      padding: const EdgeInsets.all(32),
      child: Column(children: [
        const Spacer(),
        Container(
          padding: const EdgeInsets.all(8),
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
              color: Palette.white, borderRadius: BorderRadius.circular(5)),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                ...?ref.watch(savedAccountProvider).value?.map((e) => ListTile(
                      contentPadding: const EdgeInsets.only(left: 8),
                      onTap: () async {
                        final List<ConnectivityResult> connectivityResult = await (Connectivity().checkConnectivity());
                        if (connectivityResult.contains(ConnectivityResult.none)) {
                          showDialog<bool>(
                              context: context,
                              builder: (_) {
                                return StatefulBuilder(
                                    builder: (context, setState) {
                                      return AlertDialog(
                                          title: const Text("Thông báo"),
                                          content: SingleChildScrollView(
                                            child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              // Thu nhỏ chiều cao Column
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                // const Text("Thông báo: "),
                                                // const SizedBox(height: 10),

                                                Text.rich(TextSpan(children: [
                                                  TextSpan(
                                                      text: "Mất kết nối mạng, vui lòng thử lại sau!",
                                                      style: TypeStyle.body4.copyWith(
                                                          color: Theme.of(context).colorScheme.error))
                                                ]))
                                              ],
                                            ),
                                          ),
                                          actions: [
                                            // TextButton(
                                            //     onPressed: () => _.pop(true),
                                            //     child: const Text(
                                            //         "Xác nhận")),
                                            TextButton(
                                                onPressed: () => _.pop(false),
                                                child: const Text("Đồng ý"))
                                          ]);
                                    });
                              }
                          ).then((value) async {
                            if (value == null) return;
                            if (value) {}
                          });
                          // No available network types
                        } else {
                          print('Đã kết nối mạng');
                          // Thực hiện các hành động khi có kết nối
                          ref.read(accountProvider.notifier).fastLogin(e);
                        }
                      },
                      leading: const FaIcon(FaIcons.solidCircleUser),
                      title: Text(e.email),
                      trailing: PopupMenuButton(
                          itemBuilder: (context) => [
                                PopupMenuItem<int>(
                                    onTap: () {
                                      ref
                                          .read(savedAccountProvider.notifier)
                                          .deleteSavedAccount(e);
                                    },
                                    child: const Text("Xóa tài khoản này"))
                              ],
                          icon: const FaIcon(FaIcons.ellipsisVertical)),
                    )),
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: ElevatedButton(
                    onPressed: () => context.push(loginRoute),
                    child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [Text("Đăng nhập bằng tài khoản khác")]),
                  ),
                ),
              ]),
        ),
        const Spacer(),
        TextButton(
            onPressed: _gotoHelpCenter, child: const Text("Trung tâm hỗ trợ"))
      ]),
    );
  }

  Future<void> _gotoHelpCenter() async {
    showOptionModal(context: context, blocks: [
      [
        BottomSheetListTile(
            leading: FaIcons.key,
            title: "Quên mật khẩu",
            onTap: () => context.go(forgetRoute)),
        BottomSheetListTile(
            leading: FaIcons.lock, title: "Khóa ứng dụng", onTap: () => {}),
      ]
    ]);
  }
}
