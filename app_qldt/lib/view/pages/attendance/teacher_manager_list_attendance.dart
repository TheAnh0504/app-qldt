import 'package:app_qldt/controller/attendance_provider.dart';
import 'package:app_qldt/controller/material_provider.dart';
import 'package:app_qldt/model/entities/attendance_model.dart';
import 'package:app_qldt/view/pages/attendance/create_attendance.dart';
import 'package:app_qldt/view/pages/attendance/edit_attendance.dart';
import 'package:app_qldt/view/pages/material/material_info_page.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../controller/account_provider.dart';
import '../../../core/common/types.dart';
import '../../../core/theme/palette.dart';
import '../../../core/theme/typestyle.dart';
import '../../../model/entities/class_info_model.dart';
import '../../../model/entities/material_model.dart';

class TeacherManagerListAttendance extends ConsumerStatefulWidget {
  final ClassInfoModel infoClass;
  final List<String> dataListDay;
  const TeacherManagerListAttendance({super.key, required this.infoClass, required this.dataListDay});

  @override
  ConsumerState<TeacherManagerListAttendance> createState() => _TeacherManagerListAttendance();
}

class _TeacherManagerListAttendance extends ConsumerState<TeacherManagerListAttendance> {
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
              child: Text("Quản lý điểm danh lớp ${widget.infoClass.class_id}", style: TypeStyle.title1White)
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
              if (ref.read(accountProvider).value?.role == 'LECTURER') Text("Chức năng", style: TypeStyle.title1.copyWith(color: Palette.red100)),
              if (ref.read(accountProvider).value?.role == 'LECTURER') const SizedBox(height: 10),

              if (ref.read(accountProvider).value?.role == 'LECTURER') Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(width: 20),
                  Expanded(
                    child: Center(
                      child: FilledButton(
                        onPressed: () {
                          print("Điểm danh");
                          // TODO: create-attendance
                          final currentDate = DateTime.now();
                          final formattedDate = DateFormat('yyyy-MM-dd').format(currentDate);
                          if (widget.dataListDay.contains(formattedDate)) {
                            Fluttertoast.showToast(msg: "Bạn đã điểm danh lớp này hôm nay rồi!");
                          } else {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => CreateAttendance(infoClass: widget.infoClass, date: formattedDate,)));
                          }
                        },
                        child: const Center(child: Text("Điểm danh")),
                      ),
                    ),
                  ),
                  const SizedBox(width: 20),
                ],
              ),

              if (ref.read(accountProvider).value?.role == 'LECTURER') const SizedBox(height: 16),
              Text("Danh sách các ngày đã điểm danh", style: TypeStyle.title1.copyWith(color: Palette.red100)),
              const SizedBox(height: 10),
              ValueListenableBuilder<List<String>>(
                valueListenable: results,
                builder: (context, results1, _) {
                  if (results1.isEmpty) {
                    return Center(child: Text("Lớp ${widget.infoClass.class_id} chưa có buổi điểm danh nào."));
                  }
                  return SizedBox(
                    height: 480,
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
                                Text.rich(TextSpan(children: [
                                  const TextSpan(text: "Ngày điểm danh: ", style: TypeStyle.body3),
                                  TextSpan(
                                      text: results1[index],
                                      style: TypeStyle.body3.copyWith(
                                          color: Theme.of(context).colorScheme.error))
                                ])),
                              ],
                            ),
                            onTap: () async {
                              // TODO: to EditAttendance
                              List<AttendanceModel> data1 = await ref.read(listAttendanceProvider.notifier).getListAttendanceOfDate(widget.infoClass.class_id, results1[index]);
                              Navigator.push(context, MaterialPageRoute(builder: (context) => EditAttendance(infoClass: widget.infoClass, date: results1[index], data: data1)));
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