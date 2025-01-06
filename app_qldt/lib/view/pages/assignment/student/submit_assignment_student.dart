import 'dart:io';

import 'package:app_qldt/controller/attendance_provider.dart';
import 'package:app_qldt/controller/material_provider.dart';
import 'package:app_qldt/model/entities/attendance_model.dart';
import 'package:app_qldt/view/pages/material/material_info_page.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../controller/survey_provider.dart';
import '../../../../core/common/types.dart';
import '../../../../core/router/url.dart';
import '../../../../core/theme/component.dart';
import '../../../../core/theme/palette.dart';
import '../../../../core/theme/typestyle.dart';
import '../../../../core/validator/validator.dart';
import '../../../../model/entities/class_info_model.dart';


class SubmitAssignmentStudent extends ConsumerStatefulWidget {
  final ClassInfoModel infoClass;
  final Map<String, dynamic> dataListDay;
  const SubmitAssignmentStudent({super.key, required this.infoClass, required this.dataListDay});

  @override
  ConsumerState<SubmitAssignmentStudent> createState() => _SubmitAssignmentStudent();
}

class _SubmitAssignmentStudent extends ConsumerState<SubmitAssignmentStudent> {
  ValueNotifier<List<dynamic>> results = ValueNotifier([]);
  String absenceType = 'edit';
  int selectedIndex = 0;
  File? selectedFile;
  TextEditingController reason = TextEditingController();

  @override
  void initState() {
    super.initState();
    results.value = widget.dataListDay["data"];
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.primary,
          title: Align(
              alignment: const Alignment(-0.6, 0), // Căn phải một chút
              child: Text("Danh sách bài tập lớp ${widget.infoClass.class_id}", style: TypeStyle.title1White)
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
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Phần 1
                  Expanded(
                    child: GestureDetector(
                      onTap: () async {
                        Map<String, dynamic> dataListDay = await ref.read(listSurveyProvider.notifier).getListAssignment("UPCOMING", widget.infoClass.class_id);
                        results.value = dataListDay["data"];
                        setState(() {
                          selectedIndex = 0; // Đặt phần này là được chọn
                        });
                        print("Nghỉ phép");
                      },
                      child: Container(
                        color: selectedIndex == 0 ? Colors.blue : Colors.grey, // Đổi màu nếu được chọn
                        padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 0.0),
                        child: const Center(child: Text("Chưa hoàn thành")),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  // Phần 2
                  Expanded(
                    child: GestureDetector(
                      onTap: () async {
                        Map<String, dynamic> dataListDay = await ref.read(listSurveyProvider.notifier).getListAssignment("COMPLETED", widget.infoClass.class_id);
                        results.value = dataListDay["data"];
                        setState(() {
                          selectedIndex = 1; // Đặt phần này là được chọn
                        });
                        print("Bài tập");
                      },
                      child: Container(
                        color: selectedIndex == 1 ? Colors.blue : Colors.grey, // Đổi màu nếu được chọn
                        padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 8.0),
                        child: const Center(child: Text("Đã hoàn thành")),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  // Phần 3
                  Expanded(
                    child: GestureDetector(
                      onTap: () async {
                        Map<String, dynamic> dataListDay = await ref.read(listSurveyProvider.notifier).getListAssignment("PASS_DUE", widget.infoClass.class_id);
                        results.value = dataListDay["data"];
                        setState(() {
                          selectedIndex = 2; // Đặt phần này là được chọn
                        });
                        print("Nghỉ phép khác");
                      },
                      child: Container(
                        color: selectedIndex == 2 ? Colors.blue : Colors.grey, // Đổi màu nếu được chọn
                        padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 8.0),
                        child: const Center(child: Text("Hết hạn")),
                      ),
                    ),
                  ),
                ],
              ),

              // if(results.value.isNotEmpty) Text("Danh sách các ngày chưa điểm danh của bạn:", style: TypeStyle.title1.copyWith(color: Palette.red100)),
              // const SizedBox(height: 10),
              ValueListenableBuilder<List<dynamic>>(
                valueListenable: results,
                builder: (context, results1, _) {
                  if (results1.isEmpty) {
                    return Container(
                      // color: selectedIndex == 2 ? Colors.blue : Colors.grey, // Đổi màu nếu được chọn
                      padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 8.0),
                      child: const Center(child: Text("Không có bài tập nào để hiển thị.")),
                    );
                  }
                  return SizedBox(
                    height: 650,
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
                              children: [Text(
                                results1[index]["title"] ?? '',
                                style: TypeStyle.title2,
                              ),
                                const SizedBox(height: 1),
                                Text.rich(TextSpan(children: [
                                  const TextSpan(text: "Mã bài tập: ", style: TypeStyle.body3),
                                  TextSpan(
                                      text: results1[index]["id"].toString(),
                                      style: TypeStyle.body3.copyWith(
                                          color: Theme.of(context).colorScheme.error))
                                ])),
                                Text.rich(TextSpan(children: [
                                  const TextSpan(text: "Mô tả bài tập: ", style: TypeStyle.body3),
                                  TextSpan(
                                      text: results1[index]["description"],
                                      style: TypeStyle.body3.copyWith(
                                          color: Theme.of(context).colorScheme.error))
                                ])),
                                Text.rich(TextSpan(children: [
                                  const TextSpan(text: "Ngày kết thúc: ", style: TypeStyle.body3),
                                  TextSpan(
                                      text: results1[index]["deadline"],
                                      style: TypeStyle.body3.copyWith(
                                          color: Theme.of(context).colorScheme.error))
                                ])),
                                if (results1[index]["file_url"] != null) InkWell(
                                  splashFactory: InkRipple.splashFactory,
                                  onTap: () => launchUrl(
                                    Uri.parse(results1[index]["file_url"] ?? ''),
                                    mode: LaunchMode.externalApplication, // Đảm bảo mở bằng trình duyệt
                                  ),
                                  child: Text.rich(TextSpan(children: [
                                    const TextSpan(text: "Liên kết: ", style: TypeStyle.body3),
                                    TextSpan(
                                        text: 'Nhấn để xem bài tập',
                                        style: TypeStyle.body3.copyWith(
                                          color: Colors.blue, // Màu xanh giống liên kết
                                          fontStyle: FontStyle.italic, // Chữ in nghiêng
                                          decoration: TextDecoration.underline, // Dưới chân giống liên kết
                                        )
                                    )
                                  ])),
                                )
                              ],
                            ),
                            onTap: ()  {
                              final formKeyAbsence = GlobalKey<FormState>();
                              showDialog<bool>(
                                  context: context,
                                  builder: (_) => AlertDialog(
                                      title: Text("Nộp bài tập với mã bài tập ${results1[index]["id"].toString()}", style: TypeStyle.title1),
                                      content: SingleChildScrollView(
                                          child: Form(
                                            key: formKeyAbsence,
                                            child: Column(
                                              mainAxisSize: MainAxisSize.min, // Thu nhỏ chiều cao Column
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                const Text("Văn bản trả lời: ", style: TypeStyle.body4),
                                                const SizedBox(height: 5),
                                                TextInput(
                                                  controller: reason,
                                                  validator: Validator.reason(),
                                                  hintText: "Nhập văn bản trả lời",
                                                  autovalidateMode: AutovalidateMode.onUserInteraction,
                                                ),
                                                const SizedBox(height: 10),
                                                const Text("Tệp bài tập: ", style: TypeStyle.body4),
                                                const SizedBox(height: 5),
                                                Center(
                                                  child: ElevatedButton(
                                                    style: ElevatedButton.styleFrom(
                                                      padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 24), // Đặt padding phù hợp
                                                      backgroundColor: Colors.blue, // Màu nền của nút
                                                      foregroundColor: Colors.white, // Màu chữ của nút
                                                    ),
                                                    onPressed: () async {
                                                      // Sử dụng thư viện file_picker để chọn file
                                                      final result = await FilePicker.platform.pickFiles();

                                                      if (result != null && result.files.single.path != null) {
                                                        // Xử lý file được chọn
                                                        setState(() {
                                                          selectedFile = File(result.files.single.path!); // Lưu file đã chọn
                                                          context.go(feedRoute);
                                                        });
                                                      } else {
                                                        // Người dùng hủy chọn file
                                                        setState(() {
                                                          selectedFile = null;
                                                          context.go(feedRoute);
                                                        });
                                                      }
                                                    },
                                                    child: Text(selectedFile == null ? "Chọn file" : "Sửa file"), // Nội dung nút
                                                  ),
                                                ),
                                                const SizedBox(height: 10),
                                                if (selectedFile != null) // Nếu đã chọn file, hiển thị tên file
                                                  Text(
                                                    "File đã chọn: ${selectedFile!.path.split('/').last}",
                                                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                                  ),
                                              ],
                                            ),
                                          )
                                      ),
                                      actions: [
                                        TextButton(
                                            onPressed: () {
                                              if (formKeyAbsence.currentState?.validate() ?? false) {
                                                _.pop(true);
                                              }
                                            },
                                            child: const Text("Gửi")),
                                        TextButton(
                                            onPressed: () => _.pop(false),
                                            child: const Text("Hủy"))
                                      ])
                              ).then((value) async {
                                if (value == null) return;
                                if (value) {
                                  print(value);
                                  if (await ref.read(listSurveyProvider.notifier).submit11(selectedFile, results1[index]["id"].toString(), reason.text)) {
                                    reason.clear();
                                    selectedFile = null;
                                    Map<String, dynamic> dataListDay = await ref.read(listSurveyProvider.notifier).getListAssignment( selectedIndex == 0 ? "UPCOMING" : selectedIndex == 1 ? "COMPLETED" : "PASS_DUE", widget.infoClass.class_id);
                                    results.value = dataListDay["data"];
                                    Fluttertoast.showToast(msg: "Nộp bài tập thành công thành công");
                                  } else {
                                    Fluttertoast.showToast(msg: "Nộp bài tập thất bại!");
                                  }
                                }

                              });
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