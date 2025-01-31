import "package:connectivity_plus/connectivity_plus.dart";
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
import "package:app_qldt/model/entities/account_model.dart";
import "package:app_qldt/controller/account_provider.dart";
import "package:app_qldt/controller/signup_provider.dart";

class SignupPage extends StatelessWidget {
  const SignupPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.primary,
          title: const Align(
            alignment: Alignment(-0.25, 0), // Căn phải một chút
            child: Text("Đăng ký tài khoản", style: TypeStyle.title1White),
          ),
          leading: IconButton(
              onPressed: () => context.pop(),
              icon: const FaIcon(FaIcons.arrowLeft, color: Palette.white,))),
      body: const _BuildBody());
    // return PopScope(
    //   canPop: false,
    //   onPopInvoked: (didPop) => context.go(loginRoute),
    //   child: Scaffold(
    //       backgroundColor: Theme.of(context).colorScheme.primary,
    //       body: const _BuildBody()),
    // );
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
  final ho = TextEditingController();
  final ten = TextEditingController();
  final formKey = GlobalKey<FormState>();
  String selectedRole = 'STUDENT';

  @override
  Widget build(BuildContext context) {
    ref.listen(accountProvider, (prev, next) {
      switch (next) {
        case AsyncError(error: final err):
          Fluttertoast.showToast(msg: err.toString());
          break;
        case AsyncData<AccountModel?> data:
          if (data.value?.accessToken == "signup") {
            context.go("$signupRoute/verify");
          }
          break;
      }
    });

    return Form(
      key: formKey,
      child: Container(
          clipBehavior: Clip.antiAlias,
          // height: MediaQuery.sizeOf(context).height -
          //     MediaQuery.sizeOf(context).width / 5,
          decoration: const BoxDecoration(
              color: Palette.white,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(0), topRight: Radius.circular(0))),
          // margin: EdgeInsets.only(top: MediaQuery.sizeOf(context).width / 5),
          padding: const EdgeInsets.all(32),
          child: SingleChildScrollView(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // const Center(child: Text("Đăng ký tài khoản eHust", style: TypeStyle.heading),),
                  // Text.rich(TextSpan(children: [
                  //   const TextSpan(text: "("),
                  //   TextSpan(
                  //       text: "*",
                  //       style: TypeStyle.body5.copyWith(
                  //           color: Theme.of(context).colorScheme.error)),
                  //   const TextSpan(text: ") Bắt buộc"),
                  // ], style: TypeStyle.body5)),
                  // const SizedBox(height: 22),
                  Text.rich(TextSpan(children: [
                    const TextSpan(text: "Họ", style: TypeStyle.title4),
                    TextSpan(
                        text: "*",
                        style: TypeStyle.body4.copyWith(
                            color: Theme.of(context).colorScheme.error))
                  ])),
                  TextInput(
                    controller: ho,
                    hintText: "first name",
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: Validator.ho(),
                  ),
                  const SizedBox(height: 16),
                  Text.rich(TextSpan(children: [
                    const TextSpan(text: "Tên", style: TypeStyle.title4),
                    TextSpan(
                        text: "*",
                        style: TypeStyle.body4.copyWith(
                            color: Theme.of(context).colorScheme.error))
                  ])),
                  TextInput(
                    controller: ten,
                    hintText: "last name",
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: Validator.ten(),
                  ),
                  const SizedBox(height: 16),
                  Text.rich(TextSpan(children: [
                    const TextSpan(text: "Email", style: TypeStyle.title4),
                    TextSpan(
                        text: "*",
                        style: TypeStyle.body4.copyWith(
                            color: Theme.of(context).colorScheme.error))
                  ])),
                  TextInput(
                    controller: email,
                    hintText: "student@sis.hust.edu.vn",
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: Validator.email(),
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
                    hintText: "password@123",
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
                          ? "Nhập lại mật khẩu không chính xác"
                          : null,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      hintText: "password@123"),

                  // Thêm vào Column của form
                  const SizedBox(height: 16),
                  Text.rich(TextSpan(children: [
                    const TextSpan(text: "Loại tài khoản", style: TypeStyle.title4),
                    TextSpan(
                        text: "*",
                        style: TypeStyle.body4.copyWith(
                            color: Theme.of(context).colorScheme.error))
                  ])),
                  DropdownButtonFormField<String>(
                    value: selectedRole,
                    decoration: InputDecoration(
                      hintText: "Chọn loại tài khoản",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    items: const [
                      DropdownMenuItem(value: 'STUDENT', child: Text('Học sinh')),
                      DropdownMenuItem(value: 'LECTURER', child: Text('Giảng viên')),
                    ],
                    onChanged: (value) {
                      if (value != null) {
                        selectedRole = value; // Cập nhật giá trị đã chọn
                      }
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Vui lòng chọn loại tài khoản";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 32),

                  Center(
                    child: Builder(builder: (context) {
                      return FilledButton(
                        onPressed: ref.watch(accountProvider) is AsyncLoading
                            ? null
                            : () async {
                                if (formKey.currentState?.validate() ?? false) {
                                  final List<ConnectivityResult> connectivityResult = await (Connectivity().checkConnectivity());
                                  if (connectivityResult.contains(ConnectivityResult.none)) {
                                    showDialog<bool>(
                                        context: context,
                                        builder: (_) {
                                          return StatefulBuilder(
                                              builder: (context, setState) {
                                                return AlertDialog(
                                                    title: const Text("Thông báo"),
                                                    content: SingleChildScrollView(
                                                      child: Column(
                                                        mainAxisSize: MainAxisSize.min,
                                                        // Thu nhỏ chiều cao Column
                                                        mainAxisAlignment: MainAxisAlignment.center,
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                          // const Text("Thông báo: "),
                                                          // const SizedBox(height: 10),

                                                          Text.rich(TextSpan(children: [
                                                            TextSpan(
                                                                text: "Mất kết nối mạng, vui lòng thử lại sau!",
                                                                style: TypeStyle.body4.copyWith(
                                                                    color: Theme.of(context).colorScheme.error))
                                                          ]))
                                                        ],
                                                      ),
                                                    ),
                                                    actions: [
                                                      // TextButton(
                                                      //     onPressed: () => _.pop(true),
                                                      //     child: const Text(
                                                      //         "Xác nhận")),
                                                      TextButton(
                                                          onPressed: () => _.pop(false),
                                                          child: const Text("Đồng ý"))
                                                    ]);
                                              });
                                        }
                                    ).then((value) async {
                                      if (value == null) return;
                                      if (value) {}
                                    });
                                    // No available network types
                                  } else {
                                    print('Đã kết nối mạng');
                                    // Thực hiện các hành động khi có kết nối
                                    ref.read(signupProvider.notifier).signup(ho.text, ten.text, email.text, password.text, selectedRole);
                                  }

                                }
                              },
                        child: const Center(child: Text("Đăng ký")),
                      );
                    }),
                  ),
                  const SizedBox(height: 70),
                ]),
          )
      ),
    );
  }
}
