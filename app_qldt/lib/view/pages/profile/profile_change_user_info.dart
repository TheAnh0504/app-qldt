import "dart:io";

import "package:extended_image/extended_image.dart";
import "package:flutter/material.dart";
import "package:flutter/scheduler.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:font_awesome_flutter/font_awesome_flutter.dart";
import "package:go_router/go_router.dart";
import "package:intl/intl.dart";
import "package:app_qldt/core/common/types.dart";
import "package:app_qldt/core/router/url.dart";
import "package:app_qldt/core/theme/component.dart";
import "package:app_qldt/core/theme/palette.dart";
import "package:app_qldt/core/theme/typestyle.dart";
import "package:app_qldt/controller/user_provider.dart";
import "package:app_qldt/model/datastores/swapi.dart";
import "package:wechat_assets_picker/wechat_assets_picker.dart";

class ProfileChangeUserInfoPage extends StatelessWidget {
  const ProfileChangeUserInfoPage({super.key});

  void _onBack(BuildContext context) {
    showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog.adaptive(
                title: const Text("Xác nhận thoát"),
                content: const Text(
                    "Nếu thoát, các thay đổi của bạn sẽ không được lưu. Bạn vẫn muốn thoát chứ?"),
                actions: [
                  TextButton(
                      onPressed: () => context.pop(false),
                      child: const Text("Hủy")),
                  FilledButton(
                      onPressed: () => context.pop(true),
                      child: const Text("Xác nhận")),
                ])).then((value) {
      if (value ?? false) context.go(profileRoute);
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
        appBar: AppBar(
            title: GestureDetector(
                onTap: () {
                  PrimaryScrollController.of(context).position.animateTo(0,
                      duration: const Duration(milliseconds: 100),
                      curve: Curves.linear);
                },
                child: const Text("Chỉnh sửa thông tin")),
            backgroundColor: Colors.transparent,
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
  final schoolId = TextEditingController();

  Gender? gender;
  AssetEntity? avatar;
  DateTime dateOfBirth = DateTime.now();

  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((timestamp) {
      final user = ref.read(userProvider).value;
      setState(() {
        firstName.text = user?.firstName ?? "";
        lastName.text = user?.lastName ?? "";
        phoneNumber.text = user?.phoneNumber ?? "";
        email.text = user?.email ?? "";
        address.text = user?.address ?? "";
        gender = user?.gender;
        dateOfBirth =
            DateTime.tryParse(user?.dateOfBirth ?? "") ?? DateTime.now();
        schoolId.text =
            (user?.school.isEmpty ?? true) == true ? "" : user?.school.first;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

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
                  Text("Thay đổi thông tin sau khi đăng ký",
                      style: Theme.of(context).textTheme.titleLarge),
                  Text.rich(TextSpan(
                      children: [
                        const TextSpan(text: "("),
                        TextSpan(
                            text: "*",
                            style: TypeStyle.body5
                                .copyWith(color: theme.colorScheme.error)),
                        const TextSpan(text: ") Bắt buộc"),
                      ],
                      style: TypeStyle.body5
                          .copyWith(fontStyle: FontStyle.italic))),
                  const SizedBox(height: 32),
                  Row(children: [
                    Expanded(
                        child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                          Text.rich(TextSpan(children: [
                            TextSpan(
                                text: "Họ",
                                style: TypeStyle.body4
                                    .copyWith(fontWeight: FontWeight.bold)),
                            TextSpan(
                                text: "*",
                                style: TypeStyle.body4
                                    .copyWith(color: theme.colorScheme.error))
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
                            TextSpan(
                                text: "Tên",
                                style: TypeStyle.body4
                                    .copyWith(fontWeight: FontWeight.bold)),
                            TextSpan(
                                text: "*",
                                style: TypeStyle.body4
                                    .copyWith(color: theme.colorScheme.error))
                          ])),
                          TextInput(controller: firstName, hintText: "A"),
                        ]))
                  ]),
                  const SizedBox(height: 16),
                  Text("Email",
                      style: TypeStyle.body4
                          .copyWith(fontWeight: FontWeight.bold)),
                  const TextInput(
                      hintText: "teacher@school.edu.vn",
                      keyboardType: TextInputType.emailAddress),
                  const SizedBox(height: 16),
                  Text.rich(TextSpan(children: [
                    TextSpan(
                        text: "Số điện thoại",
                        style: TypeStyle.body4
                            .copyWith(fontWeight: FontWeight.bold)),
                    TextSpan(
                        text: "*",
                        style: TypeStyle.body4
                            .copyWith(color: theme.colorScheme.error))
                  ])),
                  TextInput(
                      controller: phoneNumber,
                      hintText: "0123456789",
                      keyboardType: TextInputType.phone),
                  const SizedBox(height: 16),
                  Text.rich(TextSpan(children: [
                    TextSpan(
                        text: "Địa chỉ",
                        style: TypeStyle.body4
                            .copyWith(fontWeight: FontWeight.bold)),
                    TextSpan(
                        text: "*",
                        style: TypeStyle.body4
                            .copyWith(color: theme.colorScheme.error))
                  ])),
                  TextInput(
                      controller: address,
                      hintText:
                          "85 phố Lương Định Của, phường Phương Mai, quận Đống Đa, TP. Hà Nội."),
                  const SizedBox(height: 16),
                  Text.rich(TextSpan(children: [
                    TextSpan(
                        text: "Ngày sinh",
                        style: TypeStyle.body4
                            .copyWith(fontWeight: FontWeight.bold)),
                    TextSpan(
                        text: "*",
                        style: TypeStyle.body4
                            .copyWith(color: theme.colorScheme.error))
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
                          TextSpan(
                              text: "Giới tính",
                              style: TypeStyle.body4
                                  .copyWith(fontWeight: FontWeight.bold)),
                          TextSpan(
                              text: "*",
                              style: TypeStyle.body4
                                  .copyWith(color: theme.colorScheme.error))
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
                      Text("Avatar",
                          style: TypeStyle.body4
                              .copyWith(fontWeight: FontWeight.bold)),
                      const Spacer(),
                      FilledButton(
                          style: FilledButton.styleFrom(
                              padding: const EdgeInsetsDirectional.symmetric(
                                  horizontal: 8)),
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
                      decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          fillColor: Palette.grey40),
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
                  const SizedBox(height: 16),
                  Text.rich(TextSpan(children: [
                    const TextSpan(text: "Trường học", style: TypeStyle.title4),
                    TextSpan(
                        text: "*",
                        style: TypeStyle.body4.copyWith(
                            color: Theme.of(context).colorScheme.error))
                  ])),
                  Row(
                    children: [
                      const Expanded(
                          child: TextInput(hintText: "Lấy mã trường")),
                      const SizedBox(width: 8),
                      FilledButton(
                          onPressed: () {
                            var textController = TextEditingController();
                            Future? future;
                            showDialog(
                                context: context,
                                builder: (context) => StatefulBuilder(
                                      builder: (context, setState) =>
                                          AlertDialog(
                                        title: TextInput(
                                            hintText: "Tên trường",
                                            controller: textController),
                                        content: FutureBuilder(
                                            future: future,
                                            builder: (context, snapshot) =>
                                                Text(snapshot.data == null ||
                                                        snapshot.data["data"] ==
                                                            null
                                                    ? ""
                                                    : "Mã trường: ${snapshot.data["data"]["schoolId"]}")),
                                        actions: [
                                          FilledButton(
                                              onPressed: () {
                                                setState(() {
                                                  future = ref
                                                      .read(swapiProvider)
                                                      .searchSchool(
                                                          textController.text);
                                                });
                                              },
                                              child: const Text("Tìm kiếm"))
                                        ],
                                      ),
                                    ));
                          },
                          child: const Text("Lấy mã"))
                    ],
                  ),
                  const SizedBox(height: 32),
                  FilledButton(
                    onPressed: () async {
                      ref.read(userProvider.notifier).setUserInfo(
                          firstName: firstName.text,
                          lastName: lastName.text,
                          phoneNumber: phoneNumber.text,
                          address: address.text,
                          dateOfBirth: dateOfBirth,
                          gender: (gender!.index + 1).toString(),
                          school: [schoolId.text],
                          avatar: await avatar?.file,
                          email: email.text == "" ? null : email.text);
                      if (!context.mounted) return;
                      context.go(profileRoute);
                    },
                    child: const Center(child: Text("Xác nhận")),
                  ),
                ]),
          )),
    );
  }
}
