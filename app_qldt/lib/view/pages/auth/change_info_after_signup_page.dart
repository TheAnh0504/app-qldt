import "dart:io";

import "package:extended_image/extended_image.dart";
import "package:flutter/material.dart";
import "package:flutter/services.dart";
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
import "package:path_provider/path_provider.dart";
import "package:permission_handler/permission_handler.dart";
import "package:wechat_assets_picker/wechat_assets_picker.dart";

import "../../../model/repositories/auth_repository.dart";
import "../../../model/repositories/media_repository.dart";

class ChangeInfoAfterSignupPage extends StatelessWidget {
  const ChangeInfoAfterSignupPage({super.key});

  void _onBack(BuildContext context) {
    showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
                backgroundColor: Palette.white,
                title: const Text("Xác nhận thoát"),
                content: const Text(
                    "Bạn chưa hoàn thành cập nhật thông tin tài khoản. Bạn có chắc chắn muốn thoát?"),
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
            backgroundColor: Theme.of(context).colorScheme.primary,
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
                  const Center( child: Text("Chọn ảnh đại diện", style: TypeStyle.heading)),
                  const SizedBox(height: 32),
                  Center(
                    child: FilledButton(
                      style: FilledButton.styleFrom(
                        padding: EdgeInsets.zero,  // Xóa padding
                        backgroundColor: Colors.white,
                        side: BorderSide.none,
                      ),
                      onPressed: () async {
                        if (await Permission.mediaLibrary.request().isGranted) {
                          final assets = await AssetPicker.pickAssets(context,
                              pickerConfig: AssetPickerConfig(
                                  maxAssets: 1,
                                  selectedAssets:
                                  avatar == null ? [] : [avatar!],
                                  requestType: RequestType.image));
                          if (assets?.isEmpty ?? true) {
                            return setState(() => avatar = null);
                          } else {
                            setState(() => avatar = assets!.first);
                          }
                        } else {
                          // Nếu quyền bị từ chối
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text("Quyền truy cập bị từ chối", style: TypeStyle.title1),
                              content: const Text("Vui lòng cấp quyền truy cập thư viện ảnh để sử dụng tính năng này."),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: const Text("OK"),
                                ),
                              ],
                            ),
                          );
                        }
                      },
                      child: InputDecorator(
                        decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                          contentPadding: EdgeInsets.zero,
                        ),
                        child: FutureBuilder<File?>(
                          future: avatar?.file,
                          builder: (context, snapshot) {
                            return Container(
                              width: 300,  // Chiều rộng của ảnh vuông
                              height: 300, // Chiều cao của ảnh vuông
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(0), // Tùy chọn để tạo các góc bo tròn nhẹ
                                image: snapshot.data != null
                                    ? DecorationImage(
                                  image: ExtendedFileImageProvider(snapshot.data!),
                                  fit: BoxFit.cover, // Đảm bảo ảnh phủ hết không gian của container
                                )
                                    : const DecorationImage(
                                  image: AssetImage('images/avatar-trang.jpg'), // Hình ảnh mặc định
                                  fit: BoxFit.cover, // Đảm bảo ảnh phủ hết không gian của container
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                  Center(
                    child: Consumer(builder: (context, ref, child) {
                      ref.listen(accountProvider, (prev, next) {
                        if (next is AsyncError) {
                          Fluttertoast.showToast(msg: next.error.toString());
                        }
                        if (next is AsyncData &&
                            next.value?.status == "Kích hoạt") {
                          context.go(feedRoute);
                        }
                      });
                      return FilledButton(
                        onPressed: () async {
                          ref
                              .read(changeInfoAfterSignupProvider.notifier)
                              .changeInfoAfterSignup(
                                  avatar: await avatar?.file);
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
