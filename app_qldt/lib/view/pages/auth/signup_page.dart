import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:fluttertoast/fluttertoast.dart";
import "package:go_router/go_router.dart";
import "package:app_qldt/core/common/types.dart";
import "package:app_qldt/core/router/url.dart";
import "package:app_qldt/core/theme/component.dart";
import "package:app_qldt/core/theme/palette.dart";
import "package:app_qldt/core/theme/typestyle.dart";
import "package:app_qldt/core/validator/validator.dart";
import "package:app_qldt/model/entities/account_model.dart";
import "package:app_qldt/controller/account_provider.dart";
import "package:app_qldt/controller/signup_provider.dart";

class SignupPage extends StatelessWidget {
  const SignupPage({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) => context.go(loginRoute),
      child: Scaffold(
          backgroundColor: Theme.of(context).colorScheme.primary,
          body: const _BuildBody()),
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
  final password = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    ref.listen(accountProvider, (prev, next) {
      switch (next) {
        case AsyncError(error: final err):
          Fluttertoast.showToast(msg: err.toString());
        case AsyncData<AccountModel?> data
            when data.value?.statusAccount == AccountStatus.INIT:
          context.go("$signupRoute/verify");
      }
    });

    return Form(
      key: formKey,
      child: Container(
          clipBehavior: Clip.antiAlias,
          height: MediaQuery.sizeOf(context).height -
              MediaQuery.sizeOf(context).width / 3,
          decoration: const BoxDecoration(
              color: Palette.white,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(24), topRight: Radius.circular(24))),
          margin: EdgeInsets.only(top: MediaQuery.sizeOf(context).width / 3),
          padding: const EdgeInsets.all(32),
          child: SingleChildScrollView(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Đăng ký tài khoản", style: TypeStyle.heading),
                  Text.rich(TextSpan(children: [
                    const TextSpan(text: "("),
                    TextSpan(
                        text: "*",
                        style: TypeStyle.body5.copyWith(
                            color: Theme.of(context).colorScheme.error)),
                    const TextSpan(text: ") Bắt buộc"),
                  ], style: TypeStyle.body5)),
                  const SizedBox(height: 32),
                  Text.rich(TextSpan(children: [
                    const TextSpan(text: "Tài khoản", style: TypeStyle.title4),
                    TextSpan(
                        text: "*",
                        style: TypeStyle.body4.copyWith(
                            color: Theme.of(context).colorScheme.error))
                  ])),
                  TextInput(
                    controller: username,
                    hintText: "teacher@school.edu.vn",
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: Validator.username(),
                  ),
                  const SizedBox(height: 16),
                  Text.rich(TextSpan(children: [
                    const TextSpan(text: "Mật khẩu", style: TypeStyle.title4),
                    TextSpan(
                        text: "*",
                        style: TypeStyle.body4.copyWith(
                            color: Theme.of(context).colorScheme.error))
                  ])),
                  TextInput(
                    isPassword: true,
                    controller: password,
                    hintText: "Mật khẩu",
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: Validator.password(),
                  ),
                  const SizedBox(height: 16),
                  Text.rich(TextSpan(children: [
                    const TextSpan(
                        text: "Xác nhận mật khẩu", style: TypeStyle.title4),
                    TextSpan(
                        text: "*",
                        style: TypeStyle.body4.copyWith(
                            color: Theme.of(context).colorScheme.error))
                  ])),
                  TextInput(
                      isPassword: true,
                      validator: (str) => str != password.text
                          ? "Mật khẩu được nhập không khớp"
                          : null,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      hintText: "Xác nhận mật khẩu"),
                  const SizedBox(height: 32),
                  Center(
                    child: Builder(builder: (context) {
                      return FilledButton(
                        onPressed: ref.watch(accountProvider) is AsyncLoading
                            ? null
                            : () {
                                if (formKey.currentState?.validate() ?? false) {
                                  ref
                                      .read(signupProvider.notifier)
                                      .signup(username.text, password.text);
                                }
                              },
                        child: const Center(child: Text("Đăng ký")),
                      );
                    }),
                  ),
                ]),
          )),
    );
  }
}
