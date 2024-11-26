import "package:app_qldt/core/theme/palette.dart";
import "package:app_qldt/core/validator/validator.dart";
import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:fluttertoast/fluttertoast.dart";
import "package:font_awesome_flutter/font_awesome_flutter.dart";
import "package:go_router/go_router.dart";
import "package:app_qldt/core/common/types.dart";
import "package:app_qldt/core/theme/component.dart";
import "package:app_qldt/controller/password_provider.dart";

class SettingsChangePasswordPage extends StatelessWidget {
  const SettingsChangePasswordPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text("Đổi mật khẩu"),
          leading: IconButton(
              onPressed: () => context.pop(),
              icon: const FaIcon(FaIcons.arrowLeft))),
      body: _BuildBody(),
    );
  }
}

class _BuildBody extends ConsumerWidget {
  final oldPassword = TextEditingController();
  final newPassword = TextEditingController();
  final formKey = GlobalKey<FormState>();

  _BuildBody();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(changePasswordProvider, (prev, next) {
      if (prev is AsyncLoading && next is AsyncData) {
        Fluttertoast.showToast(msg: "Đổi mật khẩu thành công");
        context.pop();
      }
      if (prev is AsyncLoading && next is AsyncError) {
        Fluttertoast.showToast(msg: next.error.toString());
      }
    });
    return Form(
      key: formKey,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          // const Text("Mật khẩu của bạn phải <điều kiện>."),
          const SizedBox(height: 16),
          TextInput(
              controller: oldPassword,
              hintText: "Mật khẩu hiện tại",
              isPassword: true,
              validator: Validator.password(),
              autovalidateMode: AutovalidateMode.onUserInteraction,
          ),
          const SizedBox(height: 8),
          TextInput(
            controller: newPassword,
            hintText: "Mật khẩu mới",
            isPassword: true,
            validator: Validator.password(),
            autovalidateMode: AutovalidateMode.onUserInteraction,
          ),
          const SizedBox(height: 8),
          TextInput(hintText: "Xác nhận mật khẩu mới", isPassword: true,
            validator: (str) => str != newPassword.text
                ? "Nhập lại mật khẩu mới không chính xác"
                : null,
          ),
          const SizedBox(height: 8),
          // TextButton(onPressed: () {}, child: const Text("Bạn quên mật khẩu ư?")),
          const Spacer(),
          Center(
            child: FilledButton(
                onPressed: () {
                if (formKey.currentState?.validate() ?? false) {
                    ref
                        .read(changePasswordProvider.notifier)
                        .changePassword(oldPassword.text, newPassword.text);
                  }
                },
                child: const Center(child: Text("Tiếp tục"))),
          )
        ]),
      )
    );
  }
}
