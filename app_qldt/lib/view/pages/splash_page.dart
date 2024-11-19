import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:go_router/go_router.dart";
import "package:shared_preferences/shared_preferences.dart";
import "package:app_qldt/core/common/types.dart";
import "package:app_qldt/core/router/url.dart";
import "package:app_qldt/model/datastores/sw_shared_preferences.dart";
import "package:app_qldt/controller/account_provider.dart";
import "package:app_qldt/controller/saved_account_provider.dart";

class SplashPage extends ConsumerStatefulWidget {
  const SplashPage({super.key});

  @override
  ConsumerState<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends ConsumerState<SplashPage> {
  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    try {} finally {
      _navigate();
    }
  }

  Future<void> _navigate() async {
    final pref = await SharedPreferences.getInstance();
    if (pref.getCurrentAccount() != null && mounted) {
      if (pref.getCurrentAccount()?.status == "Kích hoạt") {
        ref.read(accountProvider);
        Future.microtask(() => ref
            .read(accountProvider.notifier)
            .forward(AsyncData(pref.getCurrentAccount())));
        return context.go(feedRoute);
      } else {
        ref.read(accountProvider.notifier).deleteCurrentInfo();
      }
    }

    var accounts = await ref.read(savedAccountProvider.future);
    if (accounts.isEmpty && mounted) return context.go(loginRoute);
    if (accounts.isNotEmpty && mounted) {
      return context.go("$loginRoute/saved");
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: _BuildBody());
  }
}

class _BuildBody extends StatelessWidget {
  const _BuildBody();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
              padding: const EdgeInsets.all(8),
              child: CircularProgressIndicator(
                  color: Theme.of(context).colorScheme.primary)),
          const Text("Đang thiết lập...")
        ],
      ),
    );
  }
}
