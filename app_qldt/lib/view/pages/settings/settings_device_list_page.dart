import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:font_awesome_flutter/font_awesome_flutter.dart";
import "package:go_router/go_router.dart";
import "package:app_qldt/core/common/types.dart";
import "package:app_qldt/core/theme/typestyle.dart";
import "package:app_qldt/view/pages/settings/settings_device_info_page.dart";
import "package:app_qldt/view/widgets/sw_settings_widget.dart";
import "package:app_qldt/controller/device_list_provider.dart";
import "package:app_qldt/controller/security_provider.dart";

class SettingsDeviceListPage extends StatelessWidget {
  const SettingsDeviceListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text("Danh sách thiết bị"),
          leading: IconButton(
              onPressed: () => context.pop(),
              icon: const FaIcon(FaIcons.arrowLeft))),
      body: const _BuildBody(),
    );
  }
}

class _BuildBody extends ConsumerWidget {
  const _BuildBody();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        ListTileSection(title: "Thiết bị gốc", tiles: [
          Builder(builder: (context) {
            final device = ref.watch(rootDeviceProvider).value;
            return switch (ref.watch(rootDeviceProvider).isLoading) {
              true => const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Center(child: CircularProgressIndicator.adaptive()),
                ),
              false when device != null => ListTile(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => SettingsDeviceInfoPage(
                                device: device, isRootDevice: true)));
                  },
                  title: Text(device.deviceName),
                  leading: const FaIcon(FaIcons.mobileScreen),
                  subtitle:
                      (ref.watch(currentDeviceProvider).value ?? device) ==
                              device
                          ? null
                          : const Text("Thiết bị hiện tại")),
              false => Column(mainAxisSize: MainAxisSize.min, children: [
                  const Center(child: Text("Có lỗi xảy ra. Hãy thử lại.")),
                  TextButton(
                      onPressed: () {
                        ref.invalidate(rootDeviceProvider);
                      },
                      child: const Text("Thử lại"))
                ])
            };
          })
        ]),
        const SizedBox(height: 16),
        ListTileSection(title: "Thiết bị truy cập", tiles: [
          Builder(builder: (context) {
            final accessDevices = ref.watch(accessDeviceProvider).value;
            return switch (ref.watch(accessDeviceProvider).isLoading) {
              true => const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Center(child: CircularProgressIndicator.adaptive()),
                ),
              false when accessDevices?.isNotEmpty ?? false => Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ...accessDevices!.map((e) => ListTile(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => SettingsDeviceInfoPage(
                                      device: e, isRootDevice: false)));
                        },
                        leading: const FaIcon(FaIcons.mobileScreen),
                        title: Text(e.deviceName),
                        subtitle:
                            (ref.watch(currentDeviceProvider).value ?? e) == e
                                ? null
                                : const Text("Thiết bị hiện tại"))),
                  ],
                ),
              false => Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Center(child: Text("Chưa có thiết bị truy cập.")),
                    TextButton(
                        onPressed: () {
                          ref.invalidate(accessDeviceProvider);
                        },
                        child: const Text("Tải lại"))
                  ],
                )
            };
          })
        ]),
        const SizedBox(height: 8),
        if (ref.watch(administratorProvider).value == true &&
            (ref.watch(accessDeviceProvider).value?.isNotEmpty ?? false))
          FilledButton(
              style: FilledButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.error),
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (context) =>
                        const _DeleteAccessDeviceAlertDialog());
              },
              child: const Text("Xóa tất cả thiết bị truy cập"))
      ]),
    );
  }
}

class _DeleteAccessDeviceAlertDialog extends ConsumerStatefulWidget {
  const _DeleteAccessDeviceAlertDialog();

  @override
  ConsumerState<_DeleteAccessDeviceAlertDialog> createState() =>
      _DeleteAccessDeviceAlertDialogState();
}

class _DeleteAccessDeviceAlertDialogState
    extends ConsumerState<_DeleteAccessDeviceAlertDialog> {
  final controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final name = ref.watch(rootDeviceProvider).value?.deviceName ?? "null";
    return AlertDialog(
      title: const Text("Cảnh báo"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text.rich(TextSpan(children: [
            const TextSpan(
                text:
                    "Bạn sẽ gỡ hết tất cả các thiết bị truy cập ra khỏi tài khoản này. Hãy nhập "),
            TextSpan(
                text: name,
                style: TypeStyle.body3.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.error)),
            const TextSpan(text: " để tiếp tục."),
          ])),
          const SizedBox(height: 8),
          TextField(
            controller: controller..addListener(() => setState(() {})),
            decoration: InputDecoration(
                border: const OutlineInputBorder(), hintText: name),
          ),
          const SizedBox(height: 8),
          FilledButton(
              onPressed: controller.text != name
                  ? null
                  : () {
                      ref.read(accessDeviceProvider.notifier).deleteAll();
                      Navigator.pop(context);
                    },
              child: const Text("Tiếp tục"))
        ],
      ),
    );
  }
}
