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

class EditAttendance extends ConsumerStatefulWidget {
  final ClassInfoModel infoClass;
  final String date;
  final List<AttendanceModel> data;
  const EditAttendance({super.key, required this.infoClass, required this.date, required this.data});

  @override
  ConsumerState<EditAttendance> createState() => _EditAttendance();
}

class _EditAttendance extends ConsumerState<EditAttendance> {
  ValueNotifier<List<Map<String, dynamic>>?> results = ValueNotifier([]);
  String absenceType = 'edit';
  late List<String> listStatusOfStudent;

  @override
  void initState() {
    super.initState();
    listStatusOfStudent = List.generate(widget.infoClass.student_accounts!.length, (index) {
      String status = 'PRESENT'; // Giá trị mặc định
      for (int i = 0; i < widget.data.length; i++) {
        if (widget.infoClass.student_accounts?[index]["student_id"] == widget.data[i].student_id) {
          status = widget.data[i].status;
          break; // Thoát vòng lặp ngay khi tìm thấy
        }
      }
      return status;
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
              Text.rich(TextSpan(children: [
                const TextSpan(text: "Ngày điểm danh: ", style: TypeStyle.title1),
                TextSpan(
                    text: widget.date,
                    style: TypeStyle.title1.copyWith(
                        color: Theme.of(context).colorScheme.error))
              ])),
              const SizedBox(height: 10),
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
                                            showDialog<bool>(
                                                context: context,
                                                builder: (_) => AlertDialog(
                                                    title: const Text("Xác nhận cập nhật trạng thái điểm danh của sinh viên?"),
                                                    content: SingleChildScrollView(
                                                      child: Column(
                                                        mainAxisSize: MainAxisSize.min, // Thu nhỏ chiều cao Column
                                                        mainAxisAlignment: MainAxisAlignment.center,
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                          Text.rich(TextSpan(children: [
                                                            const TextSpan(text: "Bạn có chắc chắn muốn cập nhật thông tin trạng thái điểm danh của sinh viên ", style: TypeStyle.body4),
                                                            TextSpan(
                                                                text: '${results1[index]["first_name"]} ${results1[index]["last_name"]}',
                                                                style: TypeStyle.body4.copyWith(
                                                                    color: Theme.of(context).colorScheme.error)
                                                            ),
                                                            const TextSpan(text: " với MSSV: ", style: TypeStyle.body4),
                                                            TextSpan(
                                                                text: results1[index]["account_id"],
                                                                style: TypeStyle.body4.copyWith(
                                                                    color: Theme.of(context).colorScheme.error)
                                                            ),
                                                            const TextSpan(text: " thành ", style: TypeStyle.body4),
                                                            TextSpan(
                                                                text: 'Có mặt',
                                                                style: TypeStyle.body4.copyWith(
                                                                    color: Theme.of(context).colorScheme.error)
                                                            ),
                                                            const TextSpan(text: " không?", style: TypeStyle.body4)
                                                          ])),
                                                        ],
                                                      ),
                                                    ),
                                                    actions: [
                                                      TextButton(
                                                          onPressed: () => _.pop(true),
                                                          child: const Text("Xác nhận")),
                                                      TextButton(
                                                          onPressed: () => _.pop(false),
                                                          child: const Text("Hủy"))
                                                    ])
                                            ).then((value1) async {
                                              if (value1 == null) return;
                                              if (value1) {
                                                String attendance_id = '';
                                                for (int i = 0; i < widget.data.length; i++) {
                                                  if (results1[index]["student_id"] == widget.data[i].student_id) {
                                                    attendance_id = widget.data[i].attendance_id;
                                                    break; // Thoát vòng lặp ngay khi tìm thấy
                                                  }
                                                }
                                                if (await ref.read(listAttendanceProvider.notifier).updateAttendance(attendance_id, "PRESENT")) {
                                                  setState(() {
                                                    listStatusOfStudent[index] = value!;
                                                    print(listStatusOfStudent[index]);
                                                  });
                                                  Fluttertoast.showToast(msg: "Cập nhật trạng thái điểm danh của sinh viên ${results1[index]["first_name"]} ${results1[index]["last_name"]} thành công");
                                                } else {
                                                  Fluttertoast.showToast(msg: "Cập nhật trạng thái điểm danh của sinh viên ${results1[index]["first_name"]} ${results1[index]["last_name"]} thất bại");
                                                }
                                              }

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
                                            showDialog<bool>(
                                                context: context,
                                                builder: (_) => AlertDialog(
                                                    title: const Text("Xác nhận cập nhật trạng thái điểm danh của sinh viên?"),
                                                    content: SingleChildScrollView(
                                                      child: Column(
                                                        mainAxisSize: MainAxisSize.min, // Thu nhỏ chiều cao Column
                                                        mainAxisAlignment: MainAxisAlignment.center,
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                          Text.rich(TextSpan(children: [
                                                            const TextSpan(text: "Bạn có chắc chắn muốn cập nhật thông tin trạng thái điểm danh của sinh viên ", style: TypeStyle.body4),
                                                            TextSpan(
                                                                text: '${results1[index]["first_name"]} ${results1[index]["last_name"]}',
                                                                style: TypeStyle.body4.copyWith(
                                                                    color: Theme.of(context).colorScheme.error)
                                                            ),
                                                            const TextSpan(text: " với MSSV: ", style: TypeStyle.body4),
                                                            TextSpan(
                                                                text: results1[index]["account_id"],
                                                                style: TypeStyle.body4.copyWith(
                                                                    color: Theme.of(context).colorScheme.error)
                                                            ),
                                                            const TextSpan(text: " thành ", style: TypeStyle.body4),
                                                            TextSpan(
                                                                text: 'Vắng mặt có lý do',
                                                                style: TypeStyle.body4.copyWith(
                                                                    color: Theme.of(context).colorScheme.error)
                                                            ),
                                                            const TextSpan(text: " không?", style: TypeStyle.body4)
                                                          ])),
                                                        ],
                                                      ),
                                                    ),
                                                    actions: [
                                                      TextButton(
                                                          onPressed: () => _.pop(true),
                                                          child: const Text("Xác nhận")),
                                                      TextButton(
                                                          onPressed: () => _.pop(false),
                                                          child: const Text("Hủy"))
                                                    ])
                                            ).then((value1) async {
                                              if (value1 == null) return;
                                              if (value1) {
                                                String attendance_id = '';
                                                for (int i = 0; i < widget.data.length; i++) {
                                                  if (results1[index]["student_id"] == widget.data[i].student_id) {
                                                    attendance_id = widget.data[i].attendance_id;
                                                    break; // Thoát vòng lặp ngay khi tìm thấy
                                                  }
                                                }
                                                if (await ref.read(listAttendanceProvider.notifier).updateAttendance(attendance_id, "EXCUSED_ABSENCE")) {
                                                  setState(() {
                                                    listStatusOfStudent[index] = value!;
                                                    print(listStatusOfStudent[index]);
                                                  });
                                                  Fluttertoast.showToast(msg: "Cập nhật trạng thái điểm danh của sinh viên ${results1[index]["first_name"]} ${results1[index]["last_name"]} thành công");
                                                } else {
                                                  Fluttertoast.showToast(msg: "Cập nhật trạng thái điểm danh của sinh viên ${results1[index]["first_name"]} ${results1[index]["last_name"]} thất bại");
                                                }
                                              }
                                            });
                                            // setState(() {
                                            //   listStatusOfStudent[index] = value!;
                                            //   print(listStatusOfStudent[index]);
                                            // });
                                          },
                                        ),
                                        const Text("Vắng mặt có lý do"),
                                      ],
                                    ),
                                    Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Radio<String>(
                                          value: "UNEXCUSED_ABSENCE",
                                          groupValue: listStatusOfStudent[index],
                                          onChanged: (value) {
                                            showDialog<bool>(
                                                context: context,
                                                builder: (_) => AlertDialog(
                                                    title: const Text("Xác nhận cập nhật trạng thái điểm danh của sinh viên?"),
                                                    content: SingleChildScrollView(
                                                      child: Column(
                                                        mainAxisSize: MainAxisSize.min, // Thu nhỏ chiều cao Column
                                                        mainAxisAlignment: MainAxisAlignment.center,
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                          Text.rich(TextSpan(children: [
                                                            const TextSpan(text: "Bạn có chắc chắn muốn cập nhật thông tin trạng thái điểm danh của sinh viên ", style: TypeStyle.body4),
                                                            TextSpan(
                                                                text: '${results1[index]["first_name"]} ${results1[index]["last_name"]}',
                                                                style: TypeStyle.body4.copyWith(
                                                                    color: Theme.of(context).colorScheme.error)
                                                            ),
                                                            const TextSpan(text: " với MSSV: ", style: TypeStyle.body4),
                                                            TextSpan(
                                                                text: results1[index]["account_id"],
                                                                style: TypeStyle.body4.copyWith(
                                                                    color: Theme.of(context).colorScheme.error)
                                                            ),
                                                            const TextSpan(text: " thành ", style: TypeStyle.body4),
                                                            TextSpan(
                                                                text: 'Vắng mặt không lý do',
                                                                style: TypeStyle.body4.copyWith(
                                                                    color: Theme.of(context).colorScheme.error)
                                                            ),
                                                            const TextSpan(text: " không?", style: TypeStyle.body4)
                                                          ])),
                                                        ],
                                                      ),
                                                    ),
                                                    actions: [
                                                      TextButton(
                                                          onPressed: () => _.pop(true),
                                                          child: const Text("Xác nhận")),
                                                      TextButton(
                                                          onPressed: () => _.pop(false),
                                                          child: const Text("Hủy"))
                                                    ])
                                            ).then((value1) async {
                                              if (value1 == null) return;
                                              if (value1) {
                                                String attendance_id = '';
                                                for (int i = 0; i < widget.data.length; i++) {
                                                  if (results1[index]["student_id"] == widget.data[i].student_id) {
                                                    attendance_id = widget.data[i].attendance_id;
                                                    break; // Thoát vòng lặp ngay khi tìm thấy
                                                  }
                                                }
                                                if (await ref.read(listAttendanceProvider.notifier).updateAttendance(attendance_id, "UNEXCUSED_ABSENCE")) {
                                                  setState(() {
                                                    listStatusOfStudent[index] = value!;
                                                    print(listStatusOfStudent[index]);
                                                  });
                                                  Fluttertoast.showToast(msg: "Cập nhật trạng thái điểm danh của sinh viên ${results1[index]["first_name"]} ${results1[index]["last_name"]} thành công");
                                                } else {
                                                  Fluttertoast.showToast(msg: "Cập nhật trạng thái điểm danh của sinh viên ${results1[index]["first_name"]} ${results1[index]["last_name"]} thất bại");
                                                }
                                              }

                                            });
                                            // setState(() {
                                            //   listStatusOfStudent[index] = value!;
                                            //   print(listStatusOfStudent[index]);
                                            // });
                                          },
                                        ),
                                        const Text("Vắng mặt không lý do"),
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
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.center,
              //   children: [
              //     const SizedBox(width: 20),
              //     Expanded(
              //       child: Center(
              //         child: FilledButton(
              //           onPressed: () async {
              //             List<String> attendance_list = [];
              //             for (int i = 0; i < listStatusOfStudent.length; i++) {
              //               if (listStatusOfStudent[i] != 'PRESENT') attendance_list.add(widget.infoClass.student_accounts?[i]["student_id"]);
              //             }
              //             if (await ref.read(listAttendanceProvider.notifier).createAttendance(widget.infoClass.class_id, widget.date, attendance_list)) {
              //               Fluttertoast.showToast(msg: "Lưu thông tin điểm danh thành công");
              //               // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => CreateAttendance(infoClass: widget.infoClass, date: formattedDate,)));
              //               Navigator.pushAndRemoveUntil(context,
              //                   MaterialPageRoute(builder: (context) => const InfoClassLecturer()),
              //                       (Route<dynamic> route) => route.isFirst
              //               );
              //             } else {
              //               Fluttertoast.showToast(msg: "Lưu thông tin điểm danh thất bại!");
              //             }
              //           },
              //           child: const Center(child: Text("Lưu thông tin điểm danh")),
              //         ),
              //       ),
              //     ),
              //     const SizedBox(width: 20),
              //   ],
              // ),
            ],
          ),

        ),
      ),
    );
  }

}