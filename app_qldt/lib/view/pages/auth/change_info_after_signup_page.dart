import "dart:io";

import "package:extended_image/extended_image.dart";
import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:fluttertoast/fluttertoast.dart";
import "package:font_awesome_flutter/font_awesome_flutter.dart";
import "package:go_router/go_router.dart";
import "package:intl/intl.dart";
import "package:app_qldt/core/common/types.dart";
import "package:app_qldt/core/router/url.dart";
import "package:app_qldt/core/theme/component.dart";
import "package:app_qldt/core/theme/palette.dart";
import "package:app_qldt/core/theme/typestyle.dart";
import "package:app_qldt/controller/account_provider.dart";
import "package:app_qldt/controller/signup_provider.dart";
import "package:wechat_assets_picker/wechat_assets_picker.dart";

class ChangeInfoAfterSignupPage extends StatelessWidget {
  const ChangeInfoAfterSignupPage({super.key});

  void _onBack(BuildContext context) {
    showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
                backgroundColor: Palette.white,
                title: const Text("Xác nhận thoát"),
                content: const Text(
                    "Nếu thoát, bạn sẽ phải thay đổi thông tin trong lần đăng nhập kế tiếp. Bạn có chắc chắn muốn thoát?"),
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
      onPopInvoked: (didPop) {
        _onBack(context);
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            leading: IconButton(
                onPressed: () => _onBack(context),
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
  final formKey = GlobalKey<FormState>();

  final firstName = TextEditingController();
  final lastName = TextEditingController();
  final phoneNumber = TextEditingController();
  final email = TextEditingController();
  final address = TextEditingController();

  Gender? gender;
  AssetEntity? avatar;
  DateTime dateOfBirth = DateTime.now();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Padding(
          padding: const EdgeInsets.all(32),
          child: SingleChildScrollView(
            primary: true,
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Thêm thông tin", style: TypeStyle.heading),
                  Text.rich(TextSpan(
                      children: [
                        const TextSpan(text: "("),
                        TextSpan(
                            text: "*",
                            style: TypeStyle.body4.copyWith(
                                color: Theme.of(context).colorScheme.error)),
                        const TextSpan(text: ") Bắt buộc"),
                      ],
                      style: TypeStyle.body4
                          .copyWith(fontStyle: FontStyle.italic))),
                  const SizedBox(height: 32),
                  Row(children: [
                    Expanded(
                        child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                          Text.rich(TextSpan(children: [
                            const TextSpan(text: "Họ", style: TypeStyle.title4),
                            TextSpan(
                                text: "*",
                                style: TypeStyle.body4.copyWith(
                                    color: Theme.of(context).colorScheme.error))
                          ])),
                          TextInput(controller: lastName, hintText: "Nguyễn"),
                        ])),
                    const SizedBox(width: 16),
                    Expanded(
                        child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                          Text.rich(TextSpan(children: [
                            const TextSpan(
                                text: "Tên", style: TypeStyle.title4),
                            TextSpan(
                                text: "*",
                                style: TypeStyle.body4.copyWith(
                                    color: Theme.of(context).colorScheme.error))
                          ])),
                          TextInput(controller: firstName, hintText: "A"),
                        ]))
                  ]),
                  const SizedBox(height: 16),
                  const Text("Email", style: TypeStyle.title4),
                  const TextInput(hintText: "teacher@school.edu.vn"),
                  const SizedBox(height: 16),
                  Text.rich(TextSpan(children: [
                    const TextSpan(
                        text: "Số điện thoại", style: TypeStyle.title4),
                    TextSpan(
                        text: "*",
                        style: TypeStyle.body4.copyWith(
                            color: Theme.of(context).colorScheme.error))
                  ])),
                  TextInput(controller: phoneNumber, hintText: "0123456789"),
                  const SizedBox(height: 16),
                  Text.rich(TextSpan(children: [
                    const TextSpan(text: "Địa chỉ", style: TypeStyle.title4),
                    TextSpan(
                        text: "*",
                        style: TypeStyle.body4.copyWith(
                            color: Theme.of(context).colorScheme.error))
                  ])),
                  TextInput(
                      controller: address,
                      hintText:
                          "85 phố Lương Định Của, phường Phương Mai, quận Đống Đa, TP. Hà Nội."),
                  const SizedBox(height: 16),
                  Text.rich(TextSpan(children: [
                    const TextSpan(text: "Ngày sinh", style: TypeStyle.title4),
                    TextSpan(
                        text: "*",
                        style: TypeStyle.body4.copyWith(
                            color: Theme.of(context).colorScheme.error))
                  ])),
                  DateInput(
                      dateFormat: DateFormat("dd/MM/yyyy"),
                      hintText: "11/11/1111"),
                  const SizedBox(height: 16),
                  Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text.rich(TextSpan(children: [
                          const TextSpan(
                              text: "Giới tính", style: TypeStyle.title4),
                          TextSpan(
                              text: "*",
                              style: TypeStyle.body4.copyWith(
                                  color: Theme.of(context).colorScheme.error))
                        ])),
                        DropdownInput<Gender>(
                            items: Gender.values
                                .map((e) => DropdownMenuItem(
                                    value: e, child: Text(e.raw)))
                                .toList(),
                            onChanged: (value) {
                              if (value == null) return;
                              setState(() {
                                gender = value;
                              });
                            },
                            value: gender),
                      ]),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      const Text("Avatar", style: TypeStyle.title4),
                      const Spacer(),
                      FilledButton(
                          style: FilledButton.styleFrom(
                              padding: const EdgeInsets.all(4)),
                          onPressed: () async {
                            final assets = await AssetPicker.pickAssets(context,
                                pickerConfig: AssetPickerConfig(
                                    maxAssets: 1,
                                    selectedAssets:
                                        avatar == null ? [] : [avatar!],
                                    requestType: RequestType.image));
                            if (assets?.isEmpty ?? true) {
                              return setState(() => avatar = null);
                            }
                            setState(() => avatar = assets!.first);
                          },
                          child: Text(
                              avatar == null ? "+ Thêm ảnh" : "Chọn ảnh khác"))
                    ],
                  ),
                  const SizedBox(height: 8),
                  if (avatar != null)
                    InputDecorator(
                      decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color:
                                      Theme.of(context).colorScheme.primary))),
                      child: FutureBuilder<File?>(
                          future: avatar?.file,
                          builder: (context, snapshot) {
                            return CircleAvatar(
                              radius: 70,
                              backgroundImage: snapshot.data != null
                                  ? ExtendedFileImageProvider(snapshot.data!)
                                  : null,
                            );
                          }),
                    ),
                  const SizedBox(height: 32),
                  Center(
                    child: Consumer(builder: (context, ref, child) {
                      ref.listen(accountProvider, (prev, next) {
                        if (next is AsyncError) {
                          Fluttertoast.showToast(msg: next.error.toString());
                        }
                        if (next is AsyncData &&
                            next.value?.statusAccount == AccountStatus.ACTIVE) {
                          context.go(feedRoute);
                        }
                      });
                      return FilledButton(
                        onPressed: () async {
                          ref
                              .read(changeInfoAfterSignupProvider.notifier)
                              .changeInfoAfterSignup(
                                  firstName: firstName.text,
                                  lastName: lastName.text,
                                  phoneNumber: phoneNumber.text,
                                  address: address.text,
                                  dateOfBirth: dateOfBirth,
                                  gender: (gender!.index + 1).toString(),
                                  avatar: await avatar?.file,
                                  email: email.text == "" ? null : email.text);
                        },
                        child: const Center(child: Text("Xác nhận")),
                      );
                    }),
                  ),
                ]),
          )),
    );
  }
}
