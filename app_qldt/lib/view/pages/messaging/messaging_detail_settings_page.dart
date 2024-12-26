import 'package:app_qldt/controller/account_provider.dart';
import 'package:app_qldt/core/theme/typestyle.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:app_qldt/core/extension/extension.dart';
import 'package:app_qldt/core/common/types.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../controller/messaging_provider.dart';
import '../../../model/entities/message_model.dart';
import '../../widgets/sw_settings_widget.dart';

class MessagingDetailSettingsPage extends StatelessWidget {
  final MessageUserModel user;

  const MessagingDetailSettingsPage({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          leading: IconButton(
              onPressed: context.pop, icon: const FaIcon(FaIcons.arrowLeft))),
      body: _BuildBody(user: user),
    );
  }
}

class _BuildBody extends ConsumerWidget {
  final MessageUserModel user;

  const _BuildBody({super.key, required this.user});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Consumer(builder: (context, ref, _) {
      final future = ref.read(getUserInfoProvider(user.id.toString()).future); // Lấy Future
      return FutureBuilder<Map<String, dynamic>>(
        future: future,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),  // Hiển thị khi đang chờ dữ liệu
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'), // Hiển thị khi lỗi xảy ra
            );
          } else if (!snapshot.hasData) {
            return const Center(
              child: Text('No data available'), // Khi không có dữ liệu
            );
          }

          final account = snapshot.data!;
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: CircleAvatar(
                    radius: 40,
                    backgroundImage: account['avatar'] != null
                        ? ExtendedNetworkImageProvider('https://drive.google.com/uc?id=${account['avatar'].split('/d/')[1].split('/')[0]}', cache: true)
                        : const AssetImage('images/avatar-trang.jpg')),
              ),
              Text(account['name'], style: TypeStyle.title1),
              const SizedBox(height: 48),
              // Padding(
              //   padding: const EdgeInsets.only(left: 15),
              //   child: Row(
              //     children: [
              //       Text(
              //         'Thông tin ${account["role"] == 'STUDENT'
              //             ? 'sinh viên'
              //             : 'giảng viên'}',
              //         style: TypeStyle.title1,
              //       ),
              //       const Spacer(),
              //     ],
              //   ),
              // ),
              ListTile(
                  title: Text(
                      account['role'] == 'STUDENT' ? 'Sinh viên' : 'Giảng viên',
                      style: TypeStyle.body4),
                  subtitle: Text(account['name'],
                      style: TypeStyle.body3
                          .copyWith(color: Theme
                          .of(context)
                          .colorScheme
                          .primary))),
              InkWell(
                splashFactory: InkRipple.splashFactory,
                onTap: () => launchUrl(Uri.parse("mailto:${account['email']}")),
                child: ListTile(
                    title: const Text("Email", style: TypeStyle.body4),
                    subtitle: Text(account['email'],
                        style: TypeStyle.body3
                            .copyWith(color: Theme
                            .of(context)
                            .colorScheme
                            .primary))),
              ),
              ListTile(
                  title: const Text("Id", style: TypeStyle.body4),
                  subtitle: Text(account['id'],
                      style: TypeStyle.body3
                          .copyWith(color: Theme
                          .of(context)
                          .colorScheme
                          .primary))),
              ListTile(
                  title: const Text("Họ", style: TypeStyle.body4),
                  subtitle: Text(account['ho'],
                      style: TypeStyle.body3
                          .copyWith(color: Theme
                          .of(context)
                          .colorScheme
                          .primary))),
              ListTile(
                  title: const Text("Tên", style: TypeStyle.body4),
                  subtitle: Text(account['ten'],
                      style: TypeStyle.body3
                          .copyWith(color: Theme
                          .of(context)
                          .colorScheme
                          .primary))),
            ],
          );
        },
      );
    });
  }
}