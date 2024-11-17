import "dart:async";

import "package:flutter/material.dart";
import "package:flutter/scheduler.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:font_awesome_flutter/font_awesome_flutter.dart";
import "package:go_router/go_router.dart";
import "package:app_qldt/core/common/types.dart";
import "package:app_qldt/core/router/url.dart";
import "package:app_qldt/core/theme/palette.dart";
import "package:app_qldt/core/theme/typestyle.dart";
import "package:app_qldt/model/entities/security_notification_model.dart";
import "package:app_qldt/controller/security_provider.dart";

class SettingsSecurityNotiPage extends StatelessWidget {
  const SettingsSecurityNotiPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text("Thông báo bảo mật"),
          leading: IconButton(
              onPressed: () => context.pop(),
              icon: const FaIcon(FaIcons.arrowLeft))),
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
  int remainingSeconds = 5;

  void setTimer() {
    remainingSeconds = 5;
    SchedulerBinding.instance.addPostFrameCallback((timestamp) {
      Timer.periodic(const Duration(seconds: 1), (timer) {
        if (!mounted) return;
        setState(() {
          remainingSeconds--;
        });
        if (remainingSeconds == 0) timer.cancel();
      });
    });
  }

  @override
  void initState() {
    super.initState();
    setTimer();
  }

  @override
  Widget build(BuildContext context) {
    return switch (ref.watch(securityNotificationProvider)) {
      AsyncData<SecurityNotificationModel?> data when data.isLoading =>
        const Padding(
          padding: EdgeInsets.all(8.0),
          child: Center(child: CircularProgressIndicator.adaptive()),
        ),
      AsyncData<SecurityNotificationModel?> data when data.value != null =>
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Container(
                  width: MediaQuery.sizeOf(context).width,
                  padding: const EdgeInsets.all(8),
                  clipBehavior: Clip.antiAlias,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      color: Palette.white),
                  child: Column(mainAxisSize: MainAxisSize.min, children: [
                    Text("Đây có phải là bạn không?",
                        style: TypeStyle.body3
                            .copyWith(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    const Text(
                        "Bạn đăng nhập từ một thiết bị lạ nên chúng tôi cần xác nhận và đảm bảo đó là bạn.",
                        textAlign: TextAlign.center),
                    const Divider(),
                    ListTile(
                        leading: const FaIcon(FaIcons.clock),
                        title: Text(data.value!.requestSending)),
                    ListTile(
                        leading: const FaIcon(FaIcons.mobileScreen),
                        title: Text(data.value!.device.toString()))
                  ])),
              const SizedBox(height: 8),
              Row(children: [
                Expanded(
                    child: FilledButton(
                        onPressed: () {},
                        child: const Text("Đây không phải tôi"))),
                const SizedBox(width: 8),
                Expanded(
                    child: FilledButton(
                        style: FilledButton.styleFrom(
                            backgroundColor:
                                Theme.of(context).colorScheme.error),
                        onPressed: remainingSeconds != 0
                            ? null
                            : () {
                                context.push("$verifyRoute/first_login");
                              },
                        child: Text(
                            "Đây là tôi${remainingSeconds != 0 ? " (${remainingSeconds}s)" : ""}")))
              ])
            ],
          ),
        ),
      AsyncData<SecurityNotificationModel?> data when data.value == null =>
        Column(mainAxisSize: MainAxisSize.min, children: [
          const Center(
              child: Text("Không có thông báo bảo mật. Hãy thử tải lại.")),
          TextButton(
              onPressed: () {
                ref.invalidate(securityNotificationProvider);
              },
              child: const Text("Thử lại"))
        ]),
      _ => Column(mainAxisSize: MainAxisSize.min, children: [
          const Center(child: Text("Có lỗi xảy ra. Hãy thử lại.")),
          TextButton(
              onPressed: () {
                ref.invalidate(securityNotificationProvider);
              },
              child: const Text("Thử lại"))
        ]),
    };
  }
}
