import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:font_awesome_flutter/font_awesome_flutter.dart";
import "package:permission_handler/permission_handler.dart";
import "package:app_qldt/core/common/types.dart";
import "package:app_qldt/core/theme/typestyle.dart";
import "package:app_qldt/view/widgets/sw_settings_widget.dart";
import "package:app_qldt/controller/push_notification_provider.dart";

class SettingsNotiPage extends StatelessWidget {
  const SettingsNotiPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: const Text("Thông báo đẩy", style: TypeStyle.title1),
            leading: IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const FaIcon(FaIcons.arrowLeft))),
        body: const _BuildBody());
  }
}

class _BuildBody extends ConsumerWidget {
  const _BuildBody();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(pushNotificationProvider);
    final notifier = ref.read(pushNotificationProvider.notifier);

    return FutureBuilder<Object>(
        future: Permission.notification.status,
        builder: (context, snapshot) {
          if (snapshot.data == null) {
            return const CircularProgressIndicator.adaptive();
          }
          if (snapshot.data != PermissionStatus.granted) {
            return const Padding(
              padding: EdgeInsets.all(32),
              child: Column(children: [
                Text(
                    "Bạn chưa cấp quyền thông báo.\nHãy cấp quyền thông báo cho ứng dụng để có thể sử dụng tính năng này."),
                TextButton(
                    onPressed: openAppSettings, child: Text("Đi tới Cài đặt"))
              ]),
            );
          }
          return state.value == null
              ? const Center(child: CircularProgressIndicator())
              : Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    children: [
                      const SizedBox(height: 8),
                      ListTileSection(
                          title: "Thông báo đẩy",
                          border: Border.all(
                              color: Theme.of(context).colorScheme.primary,
                              width: 1.5),
                          borderRadius: BorderRadius.circular(10),
                          padding: const EdgeInsets.all(8),
                          tiles: [
                            ListTile(
                                contentPadding: EdgeInsets.zero,
                                onTap: () => notifier.toggleNotification(
                                    !state.value!.notificationOn),
                                title: const Text("Thông báo",
                                    style: TypeStyle.title3),
                                subtitle: const Text("Nhận thông báo đẩy"),
                                trailing: Switch.adaptive(
                                    value: state.value!.notificationOn,
                                    onChanged: notifier.toggleNotification)),
                            ListTile(
                                contentPadding: EdgeInsets.zero,
                                onTap: (state.value!.notificationOn)
                                    ? () => notifier
                                        .toggleVibrate(!state.value!.vibrantOn)
                                    : null,
                                title:
                                    const Text("Rung", style: TypeStyle.title3),
                                subtitle:
                                    const Text("Rung khi có thông báo tới"),
                                trailing: Switch.adaptive(
                                    value: state.value!.vibrantOn,
                                    onChanged: (state.value!.notificationOn)
                                        ? notifier.toggleVibrate
                                        : null)),
                            ListTile(
                                contentPadding: EdgeInsets.zero,
                                onTap: (state.value!.notificationOn)
                                    ? () =>
                                        notifier.toggleLed(!state.value!.ledOn)
                                    : null,
                                title: const Text("Đèn LED",
                                    style: TypeStyle.title3),
                                subtitle: const Text(
                                    "Nháy đèn LED khi có thông báo tới"),
                                trailing: Switch.adaptive(
                                    value: state.value!.ledOn,
                                    onChanged: (state.value!.notificationOn)
                                        ? notifier.toggleLed
                                        : null)),
                            ListTile(
                                contentPadding: EdgeInsets.zero,
                                onTap: (state.value!.notificationOn)
                                    ? () => notifier
                                        .toggleSound(!state.value!.soundOn)
                                    : null,
                                title: const Text("Âm thanh",
                                    style: TypeStyle.title3),
                                subtitle: const Text(
                                    "Phát âm thanh khi có thông báo tới"),
                                trailing: Switch.adaptive(
                                    value: state.value!.soundOn,
                                    onChanged: (state.value!.notificationOn)
                                        ? notifier.toggleSound
                                        : null))
                          ])
                    ],
                  ),
                );
        });
  }
}
