

import 'dart:convert';

import 'package:app_qldt/controller/account_provider.dart';
import 'package:app_qldt/controller/list_class_provider.dart';
import 'package:app_qldt/view/pages/register_class/register_class_page_home.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../controller/messaging_provider.dart';
import '../../../controller/signup_provider.dart';
import '../../../core/common/types.dart';
import '../../../core/router/router.dart';
import '../../../core/router/url.dart';
import '../../../core/theme/component.dart';
import '../../../core/theme/palette.dart';
import '../../../core/theme/typestyle.dart';
import '../../../core/validator/validator.dart';
import '../../../model/entities/account_model.dart';
import '../../../model/entities/class_info_model.dart';
import '../../../model/entities/message_model.dart';
import '../messaging/messaging_detail_settings_page.dart';

class FeedFind extends ConsumerStatefulWidget {
  const FeedFind({super.key});

  @override
  ConsumerState<FeedFind> createState() => _FeedFind();
}

class _FeedFind extends ConsumerState<FeedFind> {
  final controller = TextEditingController();
  ValueNotifier<List<Map<String, dynamic>>> results = ValueNotifier([]);

  @override
  void initState() {
    super.initState();
  }

  Future<void> updateResults(String query) async {
    if (query.isEmpty) {
      results.value = [];
    } else {
      await ref.watch(listAccountProvider.notifier).getListAccount(query).then((value) {
        results.value = value;
      });
    }
  }


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.primary,
          title: const Align(
            alignment: Alignment(-0.25, 0), // Căn phải một chút
            child: Text("Tra cứu thông tin", style: TypeStyle.title1White),
          ),
          leading: IconButton(
              onPressed: () => context.pop(),
              icon: const FaIcon(FaIcons.arrowLeft, color: Palette.white,))),
      body: SingleChildScrollView(
        child: Container(
            width: MediaQuery.sizeOf(context).width,
            height: MediaQuery.sizeOf(context).height,
            padding: const EdgeInsets.symmetric(horizontal: 8),
            decoration: const BoxDecoration(color: Palette.white),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 26),
                Text("Nhập email: ", style: TypeStyle.body2),
                const SizedBox(height: 5),
                TextField(
                  controller: controller,
                  decoration: const InputDecoration(
                    hintText: "Nhập email",
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  ),
                  onChanged: updateResults,
                ),
                const SizedBox(height: 16),
                ValueListenableBuilder<List<Map<String,dynamic>>>(
                  valueListenable: results,
                  builder: (context, results, _) {
                    if (results.isEmpty) {
                      return const Center(child: Text("Không có kết quả tìm kiếm"));
                    }
                    return SizedBox(
                      height: 520,
                      child: ListView.builder(
                        itemCount: results.length,
                        itemBuilder: (context, index) => Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              color: Palette.white, // Màu nền
                              borderRadius: BorderRadius.circular(8), // Bo góc
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.3), // Màu đổ bóng
                                  spreadRadius: 2,
                                  blurRadius: 4,
                                  offset: const Offset(0, 3), // Vị trí đổ bóng
                                ),
                              ],
                              border: Border.all(color: Palette.red100), // Viền
                            ),
                            child: ListTile(
                              leading: CircleAvatar(
                                backgroundImage: results[index]["avatar"] != null
                                    ? ExtendedNetworkImageProvider('https://drive.google.com/uc?id=${results[index]["avatar"].split('/d/')[1].split('/')[0]}',
                                ) : const AssetImage('images/avatar-trang.jpg'),
                                radius: 20, // Kích thước của ảnh
                              ),
                              title: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '${results[index]["first_name"]} ${results[index]["last_name"]}',
                                    style: TypeStyle.title2,
                                  ),
                                  Text(
                                    results[index]["email"],
                                    style: TypeStyle.body3,
                                  ),
                                ],
                              ),
                              onTap: () {
                                // Logic xử lý khi nhấn vào
                                print("Selected: ${results[index]}");
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (_) => MessagingDetailSettingsPage(
                                            user: MessageUserModel(
                                                // required
                                                id: int.parse(results[index]["account_id"]),
                                                // face
                                                name: results[index]["first_name"],
                                                avatar: results[index]["email"])))
                                );
                              },
                            ),

                          ),
                        ),
                      ),
                    );

                  },
                )

              ],
            )
        ),
      ),
    );
  }
}