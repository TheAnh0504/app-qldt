import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:fluttertoast/fluttertoast.dart";
import "package:font_awesome_flutter/font_awesome_flutter.dart";
import "package:go_router/go_router.dart";
import "package:app_qldt/core/common/types.dart";
import "package:app_qldt/core/router/url.dart";
import "package:app_qldt/core/theme/component.dart";
import "package:app_qldt/core/validator/validator.dart";
import "package:app_qldt/controller/password_provider.dart";

class ForgetPasswordPage extends StatelessWidget {
  static const routeName = "/forget";

  const ForgetPasswordPage({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) => context.go(loginRoute),
      child: Scaffold(
        appBar: AppBar(
            backgroundColor: Colors.transparent,
            leading: IconButton(
                onPressed: () => context.go(loginRoute),
                icon: const FaIcon(FaIcons.arrowLeft))),
        body: const _BuildBody(),
      ),
    );
  }
}

class _BuildBody extends ConsumerStatefulWidget {
  const _BuildBody();

  @override
  ConsumerState<_BuildBody> createState() => _BuildBodyState();
}

class _BuildBodyState extends ConsumerState<_BuildBody> {
  final username = TextEditingController();

  @override
  Widget build(BuildContext context) {
    ref.listen(forgetPasswordProvider, (prev, next) {
      if (next is AsyncData) {
        context.go("$forgetRoute/verify");
      } else if (next is AsyncError) {
        Fluttertoast.showToast(msg: next.error.toString());
      }
    });
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Tìm tài khoản", style: Theme.of(context).textTheme.titleLarge),
          const Text("Nhập địa chỉ email của bạn"),
          const SizedBox(height: 16),
          TextInput(
              controller: username,
              hintText: "Tài khoản",
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: Validator.username()),
          const SizedBox(height: 16),
          FilledButton(
            onPressed: () {
              ref
                  .read(forgetPasswordProvider.notifier)
                  .forgetPassword(username.text);
            },
            child: const Center(child: Text("Tiếp tục")),
          )
        ],
      ),
    );
  }
}
