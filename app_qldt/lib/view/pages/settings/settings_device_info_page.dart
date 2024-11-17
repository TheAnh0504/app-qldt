import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:fluttertoast/fluttertoast.dart";
import "package:font_awesome_flutter/font_awesome_flutter.dart";
import "package:go_router/go_router.dart";
import "package:app_qldt/core/common/types.dart";
import "package:app_qldt/core/theme/palette.dart";
import "package:app_qldt/core/theme/typestyle.dart";
import "package:app_qldt/model/entities/device_model.dart";
import "package:app_qldt/view/widgets/sw_settings_widget.dart";
import "package:app_qldt/controller/device_list_provider.dart";
import "package:app_qldt/controller/security_provider.dart";

class SettingsDeviceInfoPage extends StatelessWidget {
  final DeviceModel device;
  final bool isRootDevice;

  const SettingsDeviceInfoPage(
      {super.key, required this.device, required this.isRootDevice});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(device.deviceName),
          leading: IconButton(
              onPressed: () => context.pop(),
              icon: const FaIcon(FaIcons.arrowLeft))),
      body: _BuildBody(device: device, isRootDevice: isRootDevice),
    );
  }
}

class _BuildBody extends ConsumerWidget {
  final DeviceModel device;
  final bool isRootDevice;

  const _BuildBody({required this.device, required this.isRootDevice});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        ListTileSection(title: "Thông tin thiết bị", tiles: [
          Container(
              padding: const EdgeInsets.all(8),
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: Palette.white),
              child: Column(mainAxisSize: MainAxisSize.min, children: [
                Text.rich(TextSpan(children: [
                  TextSpan(
                      text: "ID thiết bị: ",
                      style: TypeStyle.body3
                          .copyWith(fontWeight: FontWeight.bold)),
                  TextSpan(text: device.deviceId),
                  WidgetSpan(
                      child: GestureDetector(
                          onTap: () {
                            Clipboard.setData(
                                    ClipboardData(text: device.deviceId))
                                .then((_) {
                              Fluttertoast.showToast(
                                  msg:
                                      "Đã sao chép ID thiết bị vào bộ nhớ tạm.");
                            });
                          },
                          child: const FaIcon(FaIcons.copy, size: 20)),
                      alignment: PlaceholderAlignment.middle)
                ])),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: Text.rich(TextSpan(children: [
                        TextSpan(
                            text: "Tên thiết bị: ",
                            style: TypeStyle.body3
                                .copyWith(fontWeight: FontWeight.bold)),
                        TextSpan(text: device.deviceName)
                      ])),
                    ),
                    Expanded(
                      child: Text.rich(TextSpan(children: [
                        TextSpan(
                            text: "Loại thiết bị: ",
                            style: TypeStyle.body3
                                .copyWith(fontWeight: FontWeight.bold)),
                        TextSpan(text: device.type)
                      ])),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text.rich(TextSpan(children: [
                        TextSpan(
                            text: "Số seri: ",
                            style: TypeStyle.body3
                                .copyWith(fontWeight: FontWeight.bold)),
                        TextSpan(text: device.serial)
                      ])),
                    ),
                    Expanded(
                      child: Text.rich(TextSpan(children: [
                        TextSpan(
                            text: "Hệ điều hành: ",
                            style: TypeStyle.body3
                                .copyWith(fontWeight: FontWeight.bold)),
                        TextSpan(text: device.OS)
                      ])),
                    ),
                  ],
                ),
              ])),
        ]),
        if (ref.watch(administratorProvider).value == true &&
            !isRootDevice) ...[
          const SizedBox(height: 8),
          FilledButton(
              onPressed: () => showDialog(
                  context: context,
                  builder: (_) => _ChangeRootDeviceAlertDialog(device: device)),
              child: const Center(child: Text("Chỉ định làm thiết bị gốc"))),
          FilledButton(
              style: FilledButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.error),
              onPressed: () => showDialog(
                  context: context,
                  builder: (_) =>
                      _DeleteAccessDeviceAlertDialog(device: device)),
              child: const Center(child: Text("Tước quyền truy cập")))
        ]
      ]),
    );
  }
}

class _DeleteAccessDeviceAlertDialog extends ConsumerStatefulWidget {
  final DeviceModel device;

  const _DeleteAccessDeviceAlertDialog({required this.device});

  @override
  ConsumerState<_DeleteAccessDeviceAlertDialog> createState() =>
      _DeleteAccessDeviceAlertDialogState();
}

class _DeleteAccessDeviceAlertDialogState
    extends ConsumerState<_DeleteAccessDeviceAlertDialog> {
  final controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
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
                text: widget.device.deviceName,
                style: TypeStyle.body3.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.error)),
            const TextSpan(text: " để tiếp tục."),
          ])),
          const SizedBox(height: 8),
          TextField(
            controller: controller..addListener(() => setState(() {})),
            decoration: InputDecoration(
                border: const OutlineInputBorder(),
                hintText: widget.device.deviceName),
          ),
          const SizedBox(height: 8),
          FilledButton(
              style: FilledButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.error),
              onPressed: controller.text != widget.device.deviceName
                  ? null
                  : () {
                      ref
                          .read(accessDeviceProvider.notifier)
                          .delete(widget.device);
                      Navigator.pop(context);
                      Navigator.pop(context);
                    },
              child: const Center(child: Text("Tiếp tục")))
        ],
      ),
    );
  }
}

class _ChangeRootDeviceAlertDialog extends ConsumerStatefulWidget {
  final DeviceModel device;

  const _ChangeRootDeviceAlertDialog({required this.device});

  @override
  ConsumerState<_ChangeRootDeviceAlertDialog> createState() =>
      _ChangeRootDeviceAlertDialogState();
}

class _ChangeRootDeviceAlertDialogState
    extends ConsumerState<_ChangeRootDeviceAlertDialog> {
  final controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Cảnh báo"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text.rich(TextSpan(children: [
            const TextSpan(
                text:
                    "Bạn sẽ chuyển thiết bị gô sang thiết bị khác và mất đi quyền dùng thiết bị gốc hiện tại. Hãy nhập "),
            TextSpan(
                text: widget.device.deviceName,
                style: TypeStyle.body3.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.error)),
            const TextSpan(text: " để tiếp tục."),
          ])),
          const SizedBox(height: 8),
          TextField(
            controller: controller..addListener(() => setState(() {})),
            decoration: InputDecoration(
                border: const OutlineInputBorder(),
                hintText: widget.device.deviceName),
          ),
          const SizedBox(height: 8),
          FilledButton(
              style: FilledButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.error),
              onPressed: controller.text != widget.device.deviceName
                  ? null
                  : () {
                      ref
                          .read(rootDeviceProvider.notifier)
                          .changeRoot(widget.device);
                      Navigator.pop(context);
                      Navigator.pop(context);
                    },
              child: const Text("Tiếp tục"))
        ],
      ),
    );
  }
}
