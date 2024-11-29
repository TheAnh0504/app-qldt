import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:font_awesome_flutter/font_awesome_flutter.dart";
import "package:go_router/go_router.dart";
import "package:app_qldt/core/common/types.dart";
import "package:app_qldt/core/router/router.dart";
import "package:app_qldt/core/router/url.dart";
import "package:app_qldt/core/theme/typestyle.dart";
import "package:app_qldt/view/pages/settings/settings_change_password_page.dart";
import "package:app_qldt/view/pages/settings/settings_device_list_page.dart";
import "package:app_qldt/view/pages/settings/settings_digital_signature_page.dart";
import "package:app_qldt/view/pages/settings/settings_help_page.dart";
import "package:app_qldt/view/pages/settings/settings_info_page.dart";
import "package:app_qldt/view/pages/settings/settings_lock_account_page.dart";
import "package:app_qldt/view/pages/settings/settings_noti_page.dart";
import "package:app_qldt/view/pages/settings/settings_security_noti_page.dart";
import "package:app_qldt/view/widgets/sw_settings_widget.dart";
import "package:app_qldt/controller/account_provider.dart";
import "package:app_qldt/controller/security_provider.dart";
import "package:url_launcher/url_launcher.dart";

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: _BuildBody(),
    );
  }
}

class _BuildBody extends ConsumerWidget {
  const _BuildBody();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16, top: 32),
      child: SingleChildScrollView(
        child: Column(children: [
          // ListTileSection(title: "Chung", tiles: [
          //   ListTile(
          //       onTap: () =>
          //           rootNavigatorKey.currentContext?.push(messagingRoute),
          //       leading: const FaIcon(FaIcons.solidComments),
          //       title: const Text("Nhắn tin"),
          //       trailing: const FaIcon(FaIcons.chevronRight, size: 20)),
          // ]),
          // const SizedBox(height: 16),
          ListTileSection(title: "Thông báo", tiles: [
            ListTile(
                onTap: () => Navigator.push(
                    rootNavigatorKey.currentContext!,
                    MaterialPageRoute(
                        builder: (context) => const SettingsNotiPage())),
                leading: const FaIcon(FaIcons.solidBell),
                title: const Text("Thông báo"),
                trailing: const FaIcon(FaIcons.chevronRight, size: 20)),
          ]),
          const SizedBox(height: 16),
          // ListTileSection(title: "Hỗ trợ", tiles: [
          //   ListTile(
          //       onTap: () => Navigator.push(
          //           rootNavigatorKey.currentContext!,
          //           MaterialPageRoute(
          //               builder: (context) => const SettingsInfoPage())),
          //       leading: const FaIcon(FaIcons.circleInfo),
          //       title: const Text("Thông tin"),
          //       trailing: const Row(
          //         mainAxisSize: MainAxisSize.min,
          //         children: [
          //           Text("v1.0.0"),
          //           SizedBox(width: 16),
          //           FaIcon(FaIcons.chevronRight, size: 20),
          //         ],
          //       )),
          //   ListTile(
          //       onTap: () {
          //         launchUrl(Uri.parse("market://search?q=app_qldt&c=apps"));
          //       },
          //       leading: const FaIcon(FaIcons.solidStar),
          //       title: const Text("Đánh giá 5 sao"),
          //       trailing: const FaIcon(FaIcons.chevronRight, size: 20)),
          //   ListTile(
          //       onTap: () {
          //         launchUrl(Uri(
          //             scheme: 'mailto',
          //             path: 'ntd271102@gmail.com',
          //             queryParameters: {
          //               'subject': '[app_qldt][Feedback] <Nội dung>'
          //             }));
          //       },
          //       leading: const FaIcon(FaIcons.envelopesBulk),
          //       title: const Text("Phản hồi"),
          //       trailing: const FaIcon(FaIcons.chevronRight, size: 20)),
          //   ListTile(
          //       onTap: () {
          //         Navigator.push(
          //             rootNavigatorKey.currentContext!,
          //             MaterialPageRoute(
          //                 builder: (context) => const SettingsHelpPage()));
          //       },
          //       leading: const FaIcon(FaIcons.solidCircleQuestion),
          //       title: const Text("Hỗ trợ"),
          //       trailing: const FaIcon(FaIcons.chevronRight, size: 20)),
          // ]),
          // const SizedBox(height: 16),
          ListTileSection(title: "Bảo mật", tiles: [
            ListTile(
                onTap: () {
                  Navigator.push(
                      rootNavigatorKey.currentContext!,
                      MaterialPageRoute(
                          builder: (context) =>
                              const SettingsChangePasswordPage()));
                },
                leading: const FaIcon(FaIcons.key),
                title: const Text("Đổi mật khẩu"),
                trailing: const FaIcon(FaIcons.chevronRight, size: 20)),
            // ListTile(
            //     onTap: () {
            //       Navigator.push(
            //           rootNavigatorKey.currentContext!,
            //           MaterialPageRoute(
            //               builder: (context) =>
            //                   const SettingsLockAccountPage()));
            //     },
            //     leading: const FaIcon(FaIcons.userLock),
            //     title: const Text("Khóa tài khoản"),
            //     trailing: const FaIcon(FaIcons.chevronRight, size: 20)),
            // ListTile(
            //     onTap: () {
            //       Navigator.push(
            //           rootNavigatorKey.currentContext!,
            //           MaterialPageRoute(
            //               builder: (context) =>
            //                   const SettingsDeviceListPage()));
            //     },
            //     leading: const FaIcon(FaIcons.mobile),
            //     title: const Text("Danh sách thiết bị"),
            //     trailing: const FaIcon(FaIcons.chevronRight, size: 20)),
            // ListTile(
            //     onTap: () {
            //       Navigator.push(
            //           rootNavigatorKey.currentContext!,
            //           MaterialPageRoute(
            //               builder: (context) =>
            //                   const SettingsSecurityNotiPage()));
            //     },
            //     leading: Badge(
            //         isLabelVisible:
            //             ref.watch(securityNotificationProvider).value != null,
            //         child: const FaIcon(FaIcons.circleExclamation)),
            //     title: const Text("Thông báo bảo mật"),
            //     trailing: const FaIcon(FaIcons.chevronRight, size: 20)),
            // ListTile(
            //     onTap: () {
            //       Navigator.push(
            //           rootNavigatorKey.currentContext!,
            //           MaterialPageRoute(
            //               builder: (context) =>
            //                   const SettingsDigitalSignaturePage()));
            //     },
            //     leading: const FaIcon(FaIcons.mobileScreen),
            //     title: const Text("Xác thực trên thiết bị gốc"),
            //     trailing: const FaIcon(FaIcons.chevronRight, size: 20)),
          ]),
          const Divider(),
          ListTileSection(title: "", tiles: [
            ListTile(
                leading: FaIcon(FaIcons.rightFromBracket,
                    color: Theme.of(context).colorScheme.error),
                onTap: () {
                  final user = ref.read(accountProvider).value!;
                  if (user.saved) {
                    ref.read(accountProvider.notifier).logout(isSaved: true);
                    return;
                  }
                  showDialog<bool>(
                      context: context,
                      builder: (_) => AlertDialog(
                              title: const Text("Bạn có chắc muốn đăng xuất?"),
                              content: const Text(
                                  "Bạn chưa lưu thông tin đăng nhập. Bạn có muốn lưu không?"),
                              actions: [
                                TextButton(
                                    onPressed: () => _.pop(true),
                                    child: const Text("Lưu")),
                                TextButton(
                                    onPressed: () => _.pop(false),
                                    child: const Text("Đăng xuất")),
                                TextButton(
                                    onPressed: () => _.pop(),
                                    child: const Text("Hủy"))
                              ])).then((value) {
                    if (value == null) return;
                    ref.read(accountProvider.notifier).logout(isSaved: value);
                  });
                },
                title: Text("Đăng xuất",
                    style: TypeStyle.body3.copyWith(
                        fontWeight: FontWeight.w600,
                        color: Theme.of(context).colorScheme.error)),
                trailing: FaIcon(FaIcons.chevronRight,
                    size: 20, color: Theme.of(context).colorScheme.error)),
          ]),
          const SizedBox(height: 16)
        ]),
      ),
    );
  }
}
