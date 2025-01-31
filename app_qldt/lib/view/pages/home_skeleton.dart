import "package:app_qldt/controller/messaging_provider.dart";
import "package:app_qldt/controller/push_notification_provider.dart";
import "package:connectivity_plus/connectivity_plus.dart";
import "package:flutter/material.dart";
import "package:flutter/scheduler.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:fluttertoast/fluttertoast.dart";
import "package:font_awesome_flutter/font_awesome_flutter.dart";
import "package:go_router/go_router.dart";
import "package:app_qldt/core/common/types.dart";
import "package:app_qldt/core/router/url.dart";
import "package:app_qldt/model/datastores/sw_method_channel.dart";
import "package:app_qldt/controller/account_provider.dart";
import "package:app_qldt/controller/device_list_provider.dart";
import "package:app_qldt/controller/security_provider.dart";
import "package:stomp_dart_client/stomp.dart";
import "package:stomp_dart_client/stomp_config.dart";
import "package:stomp_dart_client/stomp_frame.dart";

import "../../controller/list_class_provider.dart";
import "../../core/theme/typestyle.dart";

class HomeSkeleton extends ConsumerStatefulWidget {
  const HomeSkeleton({required this.child, super.key});

  final Widget child;

  @override
  ConsumerState<HomeSkeleton> createState() => _HomeSkeletonState();
}

// tin nhắn
final countProvider = StateProvider<int>((ref) => 0);
final checkCountProvider = StateProvider<int>((ref) => 0);
// thông báo
final countNotificationProvider = StateProvider<int>((ref) => 0);

class _HomeSkeletonState extends ConsumerState<HomeSkeleton> with WidgetsBindingObserver {
  final String webSocketUrl = 'http://157.66.24.126:8080/ws';
  late StompClient _client;
  bool _isDialogShowing = false;
  // check internet
  late final Connectivity _connectivity;
  late final Stream<List<ConnectivityResult>> _connectivityStream;
  late List<ConnectivityResult> _checkOldInternet;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    // connect to websocket
    _client = StompClient(
        config: StompConfig.sockJS(url: webSocketUrl, onConnect: onConnectCallback));
    _client.activate();
    // check internet
    _connectivity = Connectivity();
    _connectivityStream = _connectivity.onConnectivityChanged;

    // Lắng nghe sự thay đổi kết nối
    _connectivityStream.listen((List<ConnectivityResult> result) {
      if (result.contains(ConnectivityResult.none)) {
        _checkOldInternet = result;
        _showNoConnectivityDialog();
      } else {
        debugPrint('Đã kết nối mạng: $result');
        if (_checkOldInternet.contains(ConnectivityResult.none)) {
          Fluttertoast.showToast(msg: "Đã kết nối lại mạng!");
          _checkOldInternet = result;
        } else {
          _checkOldInternet = result;
        }
      }
    });
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      if (mounted && ref.read(accountProvider).value != null
        && ref.read(checkExpiredToken).value != null
      ) {
        print("111111111");
        ref.read(checkCountProvider.notifier).state = ref.watch(checkCountProvider) + 1;
        ref.invalidate(listClassRegisterNowProvider);
        await ref.read(listClassRegisterNowProvider.notifier).getRegisterClassNow();
        ref.read(countNotificationProvider.notifier).state = await ref.read(countGetNotificationProvider.future);
        final listMess = await ref.read(groupChatProvider(0).future);
        final newCount = listMess.isNotEmpty ? listMess.first.numNewMessage : 0;
        // Update the count value using the provider
        ref.read(countProvider.notifier).state = newCount;
        // get info-class
        // await ref.read(listClassProvider.notifier).getListClassInfo();
        // await ref.read(listClassAllProvider.notifier).getListClassInfo();

      }
    });
  }

  Future<void> _showNoConnectivityDialog() async {
    showDialog<bool>(
      context: context,
      barrierDismissible: false, // Không cho phép đóng khi nhấn bên ngoài
      builder: (_) {
        return AlertDialog(
          title: const Text("Thông báo"),
          content: const Text(
            "Mất kết nối mạng, vui lòng thử lại sau!",
            style: TextStyle(color: Colors.red),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: const Text("Đồng ý"),
            ),
          ],
        );
      },
    );
  }

  void onConnectCallback(StompFrame connectFrame) {
    _client.subscribe(
        destination: '/user/${ref.read(accountProvider).value?.idAccount}/inbox',
        headers: {},
        callback: (frame) async {
          ref.invalidate(groupChatProvider);
          final listMess = await ref.read(groupChatProvider(0).future);
          final newCount = listMess.first.numNewMessage;
          // Update the count value using the provider
          ref.read(countProvider.notifier).state = newCount;
          ref.read(checkCountProvider.notifier).state = ref.watch(checkCountProvider) + 1;
          print(frame.body);
        }
    );
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Future<void> didChangeAppLifecycleState(AppLifecycleState state) async {
    if (state == AppLifecycleState.resumed) {
      // Ứng dụng quay trở lại foreground
      print("Ứng dụng đã quay lại foreground");
      // Thực thi lệnh mong muốn
      ref.invalidate(countGetNotificationProvider);
      ref.read(countNotificationProvider.notifier).state = await ref.read(countGetNotificationProvider.future);
    }
  }

  @override
  Widget build(BuildContext context) {
    final count = ref.watch(countProvider);
    final countNotification = ref.watch(countNotificationProvider);
    ref.listen(checkExpiredToken, (prev, next) async {
      if (next is AsyncData && next.value == null && context.mounted) {
        // Nếu hộp thoại đang hiển thị, không làm gì cả
        if (_isDialogShowing) return;

        // Đặt cờ hiển thị
        _isDialogShowing = true;
        await showDialog(
            context: context,
            builder: (_) => AlertDialog(
                  title: const Text("Thông báo"),
                  content: const Text(
                      "Token hết hạn. Vui lòng đăng nhập lại"),
                  actions: [
                    TextButton(
                        onPressed: () => context.go(splashRoute)
                        , child: const Text("OK"))
                  ],
                ));
        // await ref.read(accountProvider.notifier).deleteCurrentInfo();
        // ref.read(accountProvider.notifier).logout(isSaved: false);
        // if (!context.mounted) return;
        // context.go(splashRoute);
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
              messagingRoute,
              profileRoute,
              settingsRoute
            ].contains(GoRouter.of(context)
                    .routeInformationProvider
                    .value
                    .uri
                    .toString())
                ? 3
                : [feedRoute, messagingRoute, profileRoute, settingsRoute]
                    .indexOf(GoRouter.of(context)
                        .routeInformationProvider
                        .value
                        .uri
                        .toString()),
            onDestinationSelected: (value) {
              if (value == 2) {
                if (ref.read(listClassRegisterNowProvider).value == null) {
                  Fluttertoast.showToast(msg: "Mạng không khả dụng, vui lòng thử lại sau");
                  return;
                }
              }
              context.go([feedRoute, messagingRoute, profileRoute, settingsRoute][value]);
            },
            destinations: [
              NavigationDestination(
                icon: Badge(
                  label: Text(
                    countNotification < 10 ? countNotification.toString() : "9+", // Giá trị số
                    style: const TextStyle(color: Colors.white, fontSize: 10),
                  ),
                  isLabelVisible: countNotification > 0,
                  child: const FaIcon(FaIcons.house)
                ),
                label: "Trang chủ"
              ),
              NavigationDestination(
                icon: Badge(
                  // Hiển thị số tin nhắn chưa đọc
                  label: Text(
                    count.toString(), // Giá trị số
                    style: const TextStyle(color: Colors.white, fontSize: 10),
                  ),
                  isLabelVisible: count > 0,
                  child: const FaIcon(FaIcons.solidComments),
                ),
                label: "Tin nhắn",
              ),
              const NavigationDestination(
                  icon: FaIcon(FaIcons.solidCircleUser), label: "Hồ sơ"),
              const NavigationDestination(
                icon: FaIcon(FaIcons.gear),
                label: "Cài đặt")
            ],
            labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected),
      ),
    );
  }
}
