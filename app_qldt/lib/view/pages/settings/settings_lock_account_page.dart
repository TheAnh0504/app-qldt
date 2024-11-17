import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:fluttertoast/fluttertoast.dart";
import "package:font_awesome_flutter/font_awesome_flutter.dart";
import "package:go_router/go_router.dart";
import "package:app_qldt/core/common/types.dart";
import "package:app_qldt/core/theme/component.dart";
import "package:app_qldt/controller/account_provider.dart";

class SettingsLockAccountPage extends StatelessWidget {
  const SettingsLockAccountPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text("Khóa tài khoản"),
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
    ref.listen(lockAccountProvider, (prev, next) {
      if (next is AsyncData) {
        Fluttertoast.showToast(msg: "Khóa tài khoản thành công.");
      } else if (next is AsyncError) {
        Fluttertoast.showToast(msg: next.error.toString());
      }
    });
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Text(
            "Vì lý do bảo mật, bạn cần nhập mật khẩu của mình để khóa tài khoản."),
        const SizedBox(height: 16),
        const TextInput(hintText: "Mật khẩu"),
        const Spacer(),
        Center(
          child: FilledButton(
              style: FilledButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.error),
              onPressed: ref.watch(lockAccountProvider) is! AsyncLoading
                  ? () {
                      ref.read(lockAccountProvider.notifier).lock();
                    }
                  : null,
              child: const Center(child: Text("Khóa tài khoản"))),
        )
      ]),
    );
  }
}
