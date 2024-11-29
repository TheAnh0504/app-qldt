import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:fluttertoast/fluttertoast.dart";
import "package:font_awesome_flutter/font_awesome_flutter.dart";
import "package:go_router/go_router.dart";
import "package:app_qldt/core/common/types.dart";
import "package:app_qldt/core/router/url.dart";
import "package:app_qldt/core/theme/component.dart";
import "package:app_qldt/core/theme/palette.dart";
import "package:app_qldt/core/theme/typestyle.dart";
import "package:app_qldt/core/validator/validator.dart";
import "package:app_qldt/model/datastores/sw_method_channel.dart";
import "package:app_qldt/view/widgets/sw_popup.dart";
import "package:app_qldt/controller/account_provider.dart";
import "package:app_qldt/controller/verify_code_provider.dart";

class LoginPage extends ConsumerWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // tạo nút back lại page trước, nếu ko có thì null
    return PopScope(
      canPop: context.canPop(),
      onPopInvoked: (didPop) =>
          (!didPop) ? SWMethodChannel.services.moveTaskToBack() : null,
      child: Scaffold(
        extendBodyBehindAppBar: true,
        resizeToAvoidBottomInset: false,
        backgroundColor: Theme.of(context).colorScheme.primary,
        appBar: AppBar(
            elevation: 50,
            backgroundColor: Theme.of(context).colorScheme.primary,
            leading: context.canPop()
                ? IconButton(
                    onPressed: () => context.pop(),
                    icon: const FaIcon(FaIcons.arrowLeft, color: Palette.white,))
                : null),
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
  final email = TextEditingController();
  final password = TextEditingController();
  final formKey = GlobalKey<FormState>();

  bool validUsername = false;
  bool validPassword = false;

  @override
  Widget build(BuildContext context) {
    ref.listen(accountProvider, (prev, next) {
      if (next is AsyncError) {
        Fluttertoast.showToast(msg: next.error.toString());
        if ("Đã yêu cầu mở khóa tài khoản thành công." ==
            next.error.toString()) {
          context.go("$verifyRoute/unlock_acc");
        }
        if (next.error.toString() ==
            "Đã yêu cầu đăng nhập lần đầu thành công. Hãy đợi phê duyệt.") {
          return;
        }
      }
      // if (next is AsyncData &&
      //     next.value?.statusAccount == AccountStatus.INIT) {
      //   ref
      //       .read(verifyCodeProvider(VerifyCodeType.add_user).notifier)
      //       .getVerifyCode();
      //   context.go("$signupRoute/verify");
      // }
      // if (next is AsyncData &&
      //     next.value?.statusAccount == AccountStatus.CONFIRMED_OTP) {
      //   context.go("$signupRoute/info");
      // }
      // if (next is AsyncData &&
      //     next.value?.statusAccount == AccountStatus.CHANGE_PASSWORD) {
      //   context.go(changePasswordRoute);
      // }
      if (next is AsyncData &&
          next.value?.status == "Kích hoạt") {
        context.go(feedRoute);
      }
    });

    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: const BoxDecoration(
          color: Palette.white,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(0), topRight: Radius.circular(0))),
      margin: EdgeInsets.only(top: MediaQuery.sizeOf(context).width / 5),
      padding: const EdgeInsets.all(32),
      child: Form(
        key: formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(),
            const Center(child: Text("eHust", style: TypeStyle.headingBig),),
            const SizedBox(height: 40),
            TextInput(
                controller: email,
                hintText: "Email",
                validator: Validator.email(),
                autovalidateMode: AutovalidateMode.onUserInteraction),
            const SizedBox(height: 20),
            TextInput(
                isPassword: true,
                controller: password,
                hintText: "Mật khẩu",
                validator: Validator.password(),
                autovalidateMode: AutovalidateMode.onUserInteraction),
            const SizedBox(height: 40),
            FilledButton(
                onPressed: ref.watch(accountProvider) is AsyncLoading
                    ? null
                    : () {
                        if (formKey.currentState?.validate() ?? false) {
                          ref
                              .read(accountProvider.notifier)
                              .login(email.text, password.text);
                        }
                      },
                child: const Center(child: Text("Đăng nhập"))),
            const SizedBox(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Bạn chưa có tài khoản?", style: TypeStyle.body3),
                TextButton(
                    child: const Text("Đăng ký ngay"),
                    onPressed: () {
                      context.go(signupRoute);
                    })
              ],
            ),
            const Spacer(),
            TextButton(
                onPressed:  () {
                  context.go(forgetRoute);
                },
                child: const Text("Quên mật khẩu"))
          ],
        ),
      ),
    );
  }
}
