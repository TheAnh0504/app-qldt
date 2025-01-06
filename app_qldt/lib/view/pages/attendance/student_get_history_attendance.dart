import 'package:app_qldt/controller/attendance_provider.dart';
import 'package:app_qldt/controller/material_provider.dart';
import 'package:app_qldt/model/entities/attendance_model.dart';
import 'package:app_qldt/view/pages/material/material_info_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../controller/account_provider.dart';
import '../../../core/common/types.dart';
import '../../../core/theme/palette.dart';
import '../../../core/theme/typestyle.dart';
import '../../../model/entities/class_info_model.dart';
import '../../../model/entities/material_model.dart';

class StudentGetHistoryAttendance extends ConsumerStatefulWidget {
  final ClassInfoModel infoClass;
  final List<String> dataListDay;
  const StudentGetHistoryAttendance({super.key, required this.infoClass, required this.dataListDay});

  @override
  ConsumerState<StudentGetHistoryAttendance> createState() => _StudentGetHistoryAttendance();
}

class _StudentGetHistoryAttendance extends ConsumerState<StudentGetHistoryAttendance> {
  ValueNotifier<List<String>> results = ValueNotifier([]);
  String absenceType = 'edit';

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    results.value = widget.dataListDay;

    return Scaffold(
      appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.primary,
          title: Align(
              alignment: const Alignment(-0.6, 0), // Căn phải một chút
              child: Text("Lịch sử điểm danh lớp ${widget.infoClass.class_id}", style: TypeStyle.title1White)
          ),
          leading: IconButton(
              onPressed: () => context.pop(),
              icon: const FaIcon(FaIcons.arrowLeft, color: Palette.white,))),
      body: SingleChildScrollView(
        child:
        Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              if(results.value.isNotEmpty) Text("Danh sách các ngày chưa điểm danh của bạn:", style: TypeStyle.title1.copyWith(color: Palette.red100)),
              const SizedBox(height: 10),
              ValueListenableBuilder<List<String>>(
                valueListenable: results,
                builder: (context, results1, _) {
                  if (results1.isEmpty) {
                    return const Center(child: Text("Bạn không nghỉ buổi điểm danh nào."));
                  }
                  return SizedBox(
                    height: 560,
                    child: ListView.builder(
                      itemCount: results1.length,
                      itemBuilder: (context, index) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            color: Palette.grey55, // Màu nền
                            borderRadius: BorderRadius.circular(8), // Bo góc
                            // boxShadow: [
                            //   BoxShadow(
                            //     color: Colors.grey.withOpacity(0.3), // Màu đổ bóng
                            //     spreadRadius: 2,
                            //     blurRadius: 4,
                            //     offset: const Offset(0, 3), // Vị trí đổ bóng
                            //   ),
                            // ],
                            // border: Border.all(color: Palette.red100), // Viền
                          ),
                          child: ListTile(
                            title: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Text(
                                //   results1[index],
                                //   style: TypeStyle.title2,
                                // ),
                                // const SizedBox(height: 1),
                                Text.rich(TextSpan(children: [
                                  const TextSpan(text: "Ngày miss điểm danh: ", style: TypeStyle.body3),
                                  TextSpan(
                                      text: results1[index],
                                      style: TypeStyle.body3.copyWith(
                                          color: Theme.of(context).colorScheme.error))
                                ])),
                                // Text.rich(TextSpan(children: [
                                //   const TextSpan(text: "Mô tả tài liệu: ", style: TypeStyle.body3),
                                //   TextSpan(
                                //       text: results1[index].description,
                                //       style: TypeStyle.body3.copyWith(
                                //           color: Theme.of(context).colorScheme.error))
                                // ])),
                                // Text.rich(TextSpan(children: [
                                //   const TextSpan(text: "Loại tài liệu: ", style: TypeStyle.body3),
                                //   TextSpan(
                                //       text: results1[index].material_type,
                                //       style: TypeStyle.body3.copyWith(
                                //           color: Theme.of(context).colorScheme.error))
                                // ])),
                                // if (results1[index].material_link != null) InkWell(
                                //   splashFactory: InkRipple.splashFactory,
                                //   onTap: () => launchUrl(
                                //     Uri.parse(results1[index].material_link ?? ''),
                                //     mode: LaunchMode.externalApplication, // Đảm bảo mở bằng trình duyệt
                                //   ),
                                //   child: Text.rich(TextSpan(children: [
                                //     const TextSpan(text: "Liên kết: ", style: TypeStyle.body3),
                                //     TextSpan(
                                //         text: 'Nhấn để xem tài liệu đính kèm',
                                //         style: TypeStyle.body3.copyWith(
                                //           color: Colors.blue, // Màu xanh giống liên kết
                                //           fontStyle: FontStyle.italic, // Chữ in nghiêng
                                //           decoration: TextDecoration.underline, // Dưới chân giống liên kết
                                //         )
                                //     )
                                //   ])),
                                // )
                              ],
                            ),
                            onTap: ()  {

                            },
                          ),

                        ),
                      ),
                    ),
                  );

                },
              )
            ],
          ),

        ),
      ),
    );
  }

}