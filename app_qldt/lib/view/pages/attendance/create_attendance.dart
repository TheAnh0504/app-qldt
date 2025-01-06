import 'package:app_qldt/controller/attendance_provider.dart';
import 'package:app_qldt/controller/material_provider.dart';
import 'package:app_qldt/model/entities/attendance_model.dart';
import 'package:app_qldt/view/pages/material/material_info_page.dart';
import 'package:app_qldt/view/pages/register_class/info_class.dart';
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
import '../register_class/class_manager_lecturer.dart';

class CreateAttendance extends ConsumerStatefulWidget {
  final ClassInfoModel infoClass;
  final String date;
  const CreateAttendance({super.key, required this.infoClass, required this.date});

  @override
  ConsumerState<CreateAttendance> createState() => _CreateAttendance();
}

class _CreateAttendance extends ConsumerState<CreateAttendance> {
  ValueNotifier<List<Map<String, dynamic>>?> results = ValueNotifier([]);
  String absenceType = 'edit';
  late List<String> listStatusOfStudent;

  @override
  void initState() {
    super.initState();
    listStatusOfStudent = List.generate(widget.infoClass.student_accounts!.length, (index) {
      return 'PRESENT';
    });
  }

  @override
  Widget build(BuildContext context) {
    results.value = widget.infoClass.student_accounts;
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.primary,
          title: Align(
              alignment: const Alignment(-0.6, 0), // Căn phải một chút
              child: Text("Điểm danh lớp ${widget.infoClass.class_id}", style: TypeStyle.title1White)
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
              // Text("Danh sách sinh viên trong lớp", style: TypeStyle.title1.copyWith(color: Palette.red100)),
              // const SizedBox(height: 10),
              ValueListenableBuilder<List<Map<String, dynamic>>?>(
                valueListenable: results,
                builder: (context, results1, _) {
                  if (results1 == null || results1.isEmpty) {
                    return Center(child: Text("Lớp ${widget.infoClass.class_id} chưa có buổi điểm danh nào."));
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
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: ListTile(
                            title: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text.rich(TextSpan(children: [
                                  const TextSpan(text: "Tên sinh viên: ", style: TypeStyle.body3),
                                  TextSpan(
                                      text: '${results1[index]["first_name"]} ${results1[index]["last_name"]}',
                                      style: TypeStyle.body3.copyWith(
                                          color: Theme.of(context).colorScheme.error))
                                ])),
                                Text.rich(TextSpan(children: [
                                  const TextSpan(text: "MSSV: ", style: TypeStyle.body3),
                                  TextSpan(
                                      text: results1[index]["account_id"],
                                      style: TypeStyle.body3.copyWith(
                                          color: Theme.of(context).colorScheme.error))
                                ])),
                                Text.rich(TextSpan(children: [
                                  const TextSpan(text: "Email: ", style: TypeStyle.body3),
                                  TextSpan(
                                      text: results1[index]["email"],
                                      style: TypeStyle.body3.copyWith(
                                          color: Theme.of(context).colorScheme.error))
                                ])),
                                // DropdownButtonFormField<String>(
                                //   value: listStatusOfStudent[index],
                                //   decoration: InputDecoration(
                                //     hintText: "Điểm danh",
                                //     border: OutlineInputBorder(
                                //       borderRadius: BorderRadius.circular(8),
                                //     ),
                                //   ),
                                //   items: const [
                                //     DropdownMenuItem(value: 'PRESENT', child: Text('Có mặt')),
                                //     DropdownMenuItem(value: 'EXCUSED_ABSENCE', child: Text('Vắng có lý do')),
                                //     DropdownMenuItem(value: 'UNEXCUSED_ABSENCE', child: Text('Vắng không lý do')),
                                //   ],
                                //   onChanged: (value) {
                                //     if (value != null) {
                                //       listStatusOfStudent[index] = value; // Cập nhật giá trị đã chọn
                                //     }
                                //   },
                                //   validator: (value) {
                                //     if (value == null || value.isEmpty) {
                                //       return "Vui lòng điểm danh cho sinh viên ${results1[index]["first_name"]} ${results1[index]["last_name"]} có MSSV là: ${results1[index]["account_id"]}";
                                //     }
                                //     return null;
                                //   },
                                // ),
                                Wrap(
                                  spacing: 30, // Khoảng cách ngang giữa các phần tử
                                  runSpacing: -20, // Khoảng cách dọc giữa các dòng
                                  children: [
                                    Row(
                                      mainAxisSize: MainAxisSize.min, // Đảm bảo không chiếm toàn bộ chiều ngang
                                      children: [
                                        Radio<String>(
                                          value: "PRESENT",
                                          groupValue: listStatusOfStudent[index],
                                          onChanged: (value) {
                                            setState(() {
                                              listStatusOfStudent[index] = value!;
                                              print(listStatusOfStudent[index]);
                                            });
                                          },
                                        ),
                                        const Text("Có mặt"),
                                      ],
                                    ),
                                    Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Radio<String>(
                                          value: "EXCUSED_ABSENCE",
                                          groupValue: listStatusOfStudent[index],
                                          onChanged: (value) {
                                            setState(() {
                                              listStatusOfStudent[index] = value!;
                                              print(listStatusOfStudent[index]);
                                            });
                                          },
                                        ),
                                        const Text("Vắng có lý do"),
                                      ],
                                    ),
                                    Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Radio<String>(
                                          value: "UNEXCUSED_ABSENCE",
                                          groupValue: listStatusOfStudent[index],
                                          onChanged: (value) {
                                            setState(() {
                                              listStatusOfStudent[index] = value!;
                                              print(listStatusOfStudent[index]);
                                            });
                                          },
                                        ),
                                        const Text("Vắng không lý do"),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            onTap: () {

                            },
                          ),

                        ),
                      ),
                    ),
                  );

                },
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(width: 20),
                  Expanded(
                    child: Center(
                      child: FilledButton(
                        onPressed: () async {
                          List<String> attendance_list = [];
                          for (int i = 0; i < listStatusOfStudent.length; i++) {
                            if (listStatusOfStudent[i] != 'PRESENT') attendance_list.add(widget.infoClass.student_accounts?[i]["student_id"]);
                          }
                          if (await ref.read(listAttendanceProvider.notifier).createAttendance(widget.infoClass.class_id, widget.date, attendance_list)) {
                            Fluttertoast.showToast(msg: "Lưu thông tin điểm danh thành công");
                            // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => CreateAttendance(infoClass: widget.infoClass, date: formattedDate,)));
                            Navigator.pushAndRemoveUntil(context,
                                MaterialPageRoute(builder: (context) => const InfoClassLecturer()),
                                    (Route<dynamic> route) => route.isFirst
                            );
                          } else {
                            Fluttertoast.showToast(msg: "Lưu thông tin điểm danh thất bại!");
                          }
                        },
                        child: const Center(child: Text("Lưu thông tin điểm danh")),
                      ),
                    ),
                  ),
                  const SizedBox(width: 20),
                ],
              ),
            ],
          ),

        ),
      ),
    );
  }

}