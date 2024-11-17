import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:fluttertoast/fluttertoast.dart";
import "package:font_awesome_flutter/font_awesome_flutter.dart";
import "package:go_router/go_router.dart";
import "package:app_qldt/core/common/types.dart";
import "package:app_qldt/core/router/url.dart";
import "package:app_qldt/core/theme/component.dart";
import "package:app_qldt/model/entities/account_model.dart";
import "package:app_qldt/controller/account_provider.dart";
import "package:app_qldt/controller/password_provider.dart";

class ForceChangePasswordPage extends StatelessWidget {
  const ForceChangePasswordPage({super.key});

  void _onBack(BuildContext context) {
    showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog.adaptive(
                title: const Text("Xác nhận thoát"),
                content: const Text(
                    "Nếu thoát, bạn sẽ phải làm mới mật khẩu trong lần đăng nhập kế tiếp. Bạn có chắc chắn muốn thoát?"),
                actions: [
                  TextButton(
                      onPressed: () => context.pop(false),
                      child: const Text("Hủy")),
                  FilledButton(
                      onPressed: () => context.pop(true),
                      child: const Text("Xác nhận")),
                ])).then((value) {
      if (value ?? false) context.go(loginRoute);
    });
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) => _onBack(context),
      child: Scaffold(
        appBar: AppBar(
            backgroundColor: Colors.transparent,
            title: const Text("Đổi mật khẩu"),
            leading: IconButton(
                onPressed: () => context.pop(),
                icon: const FaIcon(FaIcons.arrowLeft))),
        body: _BuildBody(),
      ),
    );
  }
}

class _BuildBody extends ConsumerWidget {
  final oldPassword = TextEditingController();
  final newPassword = TextEditingController();

  _BuildBody();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(changePasswordProvider, (prev, next) {
      if (prev is AsyncLoading && next is AsyncData) {
        Fluttertoast.showToast(msg: "Đổi mật khẩu thành công");
      }
      if (prev is AsyncLoading && next is AsyncError) {
        Fluttertoast.showToast(msg: next.error.toString());
      }
    });
    ref.listen(accountProvider, (prev, next) {
      if (next is AsyncData<AccountModel?> &&
          next.value?.statusAccount == AccountStatus.ACTIVE) {
        context.go(feedRoute);
      }
    });
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Text("Mật khẩu của bạn phải <điều kiện>."),
        const SizedBox(height: 16),
        TextInput(controller: oldPassword, hintText: "Mật khẩu hiện tại"),
        const SizedBox(height: 8),
        TextInput(controller: newPassword, hintText: "Mật khẩu mới"),
        const SizedBox(height: 8),
        const TextInput(hintText: "Xác nhận mật khẩu mới"),
        const SizedBox(height: 8),
        const Spacer(),
        ElevatedButton(
            onPressed: () {
              ref
                  .read(changePasswordProvider.notifier)
                  .changePassword(oldPassword.text, newPassword.text);
            },
            child: const Center(child: Text("Tiếp tục")))
      ]),
    );
  }
}
