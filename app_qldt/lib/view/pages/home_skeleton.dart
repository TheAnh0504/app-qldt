import "package:flutter/material.dart";
import "package:flutter/scheduler.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:font_awesome_flutter/font_awesome_flutter.dart";
import "package:go_router/go_router.dart";
import "package:app_qldt/core/common/types.dart";
import "package:app_qldt/core/router/url.dart";
import "package:app_qldt/model/datastores/sw_method_channel.dart";
import "package:app_qldt/controller/account_provider.dart";
import "package:app_qldt/controller/device_list_provider.dart";
import "package:app_qldt/controller/security_provider.dart";

class HomeSkeleton extends ConsumerStatefulWidget {
  const HomeSkeleton({required this.child, super.key});

  final Widget child;

  @override
  ConsumerState<HomeSkeleton> createState() => _HomeSkeletonState();
}

class _HomeSkeletonState extends ConsumerState<HomeSkeleton> {
  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        ref
          ..read(rootDeviceProvider.notifier)
          ..read(accessDeviceProvider.notifier)
          ..read(securityNotificationProvider.notifier);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(accountProvider, (prev, next) async {
      if (next is AsyncData && next.value == null && context.mounted) {
        await showDialog(
            context: context,
            builder: (_) => AlertDialog(
                  title: const Text("Thông báo"),
                  content: const Text(
                      "Đã hết phiên đăng nhập. Vui lòng đăng nhập lại."),
                  actions: [
                    TextButton(
                        onPressed: () => _.pop(), child: const Text("OK"))
                  ],
                ));
        await ref.read(accountProvider.notifier).deleteCurrentInfo();
        if (!context.mounted) return;
        context.go(splashRoute);
      }
    });
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) => SWMethodChannel.services.moveTaskToBack(),
      child: Scaffold(
        body: widget.child,
        bottomNavigationBar: NavigationBar(
            selectedIndex: ![
              feedRoute,
              monitorRoute,
              profileRoute,
              settingsRoute
            ].contains(GoRouter.of(context)
                    .routeInformationProvider
                    .value
                    .uri
                    .toString())
                ? 3
                : [feedRoute, monitorRoute, profileRoute, settingsRoute]
                    .indexOf(GoRouter.of(context)
                        .routeInformationProvider
                        .value
                        .uri
                        .toString()),
            onDestinationSelected: (value) => context.go(
                [feedRoute, monitorRoute, profileRoute, settingsRoute][value]),
            destinations: [
              const NavigationDestination(
                  icon: FaIcon(FaIcons.house), label: "Bảng tin"),
              const NavigationDestination(
                  icon: FaIcon(FaIcons.chartLine), label: "Giám sát"),
              const NavigationDestination(
                  icon: FaIcon(FaIcons.solidCircleUser), label: "Hồ sơ"),
              NavigationDestination(
                  icon: Badge(
                      isLabelVisible:
                          ref.watch(securityNotificationProvider).value != null,
                      child: const FaIcon(FaIcons.gear)),
                  label: "Cài đặt")
            ],
            labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected),
      ),
    );
  }
}
