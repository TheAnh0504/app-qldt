import 'dart:io';

import 'package:app_qldt/controller/account_provider.dart';
import 'package:app_qldt/controller/list_class_provider.dart';
import 'package:app_qldt/controller/material_provider.dart';
import 'package:app_qldt/controller/survey_provider.dart';
import 'package:app_qldt/model/entities/material_model.dart';
import 'package:app_qldt/model/entities/survey_model.dart';
import 'package:app_qldt/view/pages/material/material_manager_page.dart';
import 'package:app_qldt/view/pages/register_class/register_class_page_home.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:path_provider/path_provider.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:http/http.dart' as http;

import '../../../../core/common/types.dart';
import '../../../../core/router/url.dart';
import '../../../../core/theme/component.dart';
import '../../../../core/theme/palette.dart';
import '../../../../core/theme/typestyle.dart';
import '../../../../core/validator/validator.dart';

class InfoSurvey extends ConsumerStatefulWidget {
  final dynamic dataEdit;
  final bool checkEdit;
  final SurveyModel? surveyModel;
  const InfoSurvey(this.dataEdit, this.checkEdit, this.surveyModel, {super.key});

  @override
  ConsumerState<InfoSurvey> createState() => _InfoSurvey();
}

class _InfoSurvey extends ConsumerState<InfoSurvey> {
  TextEditingController title = TextEditingController();
  TextEditingController description = TextEditingController();
  TextEditingController deadline = TextEditingController();
  TextEditingController classId = TextEditingController();

  final formKey = GlobalKey<FormState>();
  File? selectedFile;
  bool checkShow = false;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (pickedDate != null) {
      String month = pickedDate.month.toString();
      if (month.length == 1) month = "0$month";
      String day = pickedDate.day.toString();
      if (day.length == 1) day = "0$day";
      setState(() =>deadline.text = "${pickedDate.year}-$month-$day");
    }
  }

  @override
  void initState() {
    super.initState();
    classId.text = widget.dataEdit;
    if (widget.checkEdit) {
      title.text = widget.surveyModel?.title ?? '';
      description.text = widget.surveyModel!.description!;
      deadline.text = widget.surveyModel!.deadline!;
      SchedulerBinding.instance.addPostFrameCallback((_) async {
        if (widget.surveyModel!.file_url != null && widget.surveyModel!.file_url != "") {
          try {
            // Gửi yêu cầu tải xuống file
            final response = await http.get(Uri.parse(widget.surveyModel!.file_url ?? ''));
            //
            if (response.statusCode == 200) {
              // Lấy đường dẫn thư mục tạm thời
              final tempDir = await getTemporaryDirectory();
              final filePath = "${tempDir.path}/downloaded_file";

              // Ghi nội dung file
              final file = File(filePath);
              await file.writeAsBytes(response.bodyBytes);

              setState(() {
                selectedFile = file;
              });

              print("File downloaded: ${file.path}");
            } else {
              print("Download failed with status: ${response.statusCode}");
            }
          } catch (e) {
            print("Error downloading file: $e");
          }
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ref, _) {
      final infoMaterialState = ref.watch(infoMaterialProvider);

      return Stack(
        children: [
          // Giao diện chính của màn hình
          Scaffold(
            appBar: AppBar(
                backgroundColor: Theme.of(context).colorScheme.primary,
                title: Align(
                  alignment: const Alignment(-0.4, 0), // Căn phải một chút
                  child: Text(
                      !widget.checkEdit ? "Thêm bài tập lớp ${classId.text}" : "Sửa bài tập lớp ${classId.text}",
                      style: TypeStyle.title1White
                  ),
                ),
                leading: IconButton(
                    onPressed: () => context.pop(),
                    icon: const FaIcon(FaIcons.arrowLeft, color: Palette.white,))),
            body: SingleChildScrollView(
              child: Form(
                  key: formKey,
                  child:
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text.rich(TextSpan(children: [
                          const TextSpan(text: "Tên bài tập", style: TypeStyle.title4),
                          TextSpan(
                              text: "*",
                              style: TypeStyle.body4.copyWith(
                                  color: Theme.of(context).colorScheme.error))
                        ])),
                        const SizedBox(height: 5),
                        TextInput(
                            controller: title,
                            hintText: "Nhập tên bài tập",
                            autovalidateMode: AutovalidateMode.onUserInteraction,
                            readOnly: widget.checkEdit
                        ),
                        const SizedBox(height: 16),

                        Text.rich(TextSpan(children: [
                          const TextSpan(text: "Mô tả", style: TypeStyle.title4),
                          TextSpan(
                              text: "*",
                              style: TypeStyle.body4.copyWith(
                                  color: Theme.of(context).colorScheme.error))
                        ])),
                        const SizedBox(height: 5),
                        TextInput(
                            controller: description,
                            hintText: "Nhập mô tả bài tập",
                            autovalidateMode: AutovalidateMode.onUserInteraction,
                        ),
                        const SizedBox(height: 16),

                        Text.rich(TextSpan(children: [
                          const TextSpan(text: "Ngày hết hạn", style: TypeStyle.title4),
                          TextSpan(
                              text: "*",
                              style: TypeStyle.body4.copyWith(
                                  color: Theme.of(context).colorScheme.error))
                        ])),
                        const SizedBox(height: 5),
                        TextFormField(
                          controller: deadline,
                          readOnly: true, // Không cho phép nhập tay
                          onTap: () => _selectDate(context), // Mở hộp thoại chọn ngày
                          decoration: const InputDecoration(
                            hintText: "Chọn ngày hết hạn",
                            border: OutlineInputBorder(),
                            suffixIcon: Icon(Icons.calendar_today),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Vui lòng chọn ngày hết hạn.";
                            }
                            DateTime startDateCheck = DateTime.parse(deadline.text);
                            if (startDateCheck.isBefore(DateTime.now())) {
                              return "Ngày hết hạn phải sau hôm nay";
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),



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
                                  selectedFile = File(result.files.single.path!);
                                  checkShow = true;
                                  context.go(feedRoute);
                                });
                              } else {
                                // Người dùng hủy chọn file
                                setState(() {
                                  checkShow = false;
                                  context.go(feedRoute);
                                });
                              }
                            },
                            child: Text(selectedFile != null || widget.checkEdit ? "Sửa file" : "Chọn file"), // Nội dung nút
                          ),
                        ),
                        // if (!widget.checkEdit) const SizedBox(height: 5),
                        if (selectedFile != null) // Nếu đã chọn file, hiển thị tên file
                          Text(
                            "File đã chọn: ${selectedFile!.path.split('/').last}",
                            style: const TextStyle(fontSize: 16),
                          ),

                        const SizedBox(height: 16),
                        Center(
                          child: Builder(builder: (context) {
                            return FilledButton(
                              onPressed: () async {
                                if (selectedFile == null) {
                                  Fluttertoast.showToast(msg: "Vui lòng chọn file mô tả bài tập");
                                  return;
                                }
                                if (formKey.currentState?.validate() ?? false) {
                                  showDialog<bool>(
                                      context: context,
                                      builder: (_) => AlertDialog(
                                          title: Text(widget.checkEdit ? "Xác nhận cập nhật thông tin bài tập?" : "Xác nhận thêm mới bài tập?"),
                                          content: SingleChildScrollView(
                                            child: Column(
                                              mainAxisSize: MainAxisSize.min, // Thu nhỏ chiều cao Column
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text.rich(TextSpan(children: [
                                                  TextSpan(
                                                      text: widget.checkEdit ? "Bạn có chắc chắn muốn cập nhật thông tin bài tập với mã bài tập " : "Bạn có chắc chắn muốn thêm bài tập mới cho lớp "
                                                      , style: TypeStyle.body4),
                                                  TextSpan(
                                                      text: widget.checkEdit ? widget.surveyModel?.id.toString() : classId.text,
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
                                  ).then((value) async {
                                    if (value == null) return;
                                    if (value) {
                                      if (widget.checkEdit) {
                                        if (await ref.read(listSurveyProvider.notifier).editSurvey(selectedFile!, widget.surveyModel!.id.toString(), deadline.text, description.text)) {
                                          Fluttertoast.showToast(msg: "Chỉnh sửa bài tập với mã bài tập ${widget.surveyModel!.id.toString()} thành công");
                                          await ref.read(listSurveyProvider.notifier).getAllSurvey(classId.text);
                                          context.pop();
                                        } else {
                                          Fluttertoast.showToast(msg: "Chỉnh sửa bài tập với mã bài tập ${widget.surveyModel!.id.toString()} thất bại");
                                        }
                                      } else {
                                        if (await ref.read(listSurveyProvider.notifier).createSurvey(selectedFile!, classId.text, title.text, deadline.text, description.text)) {
                                          Fluttertoast.showToast(msg: "Thêm mới bài tập vào lớp ${classId.text} thành công");
                                          await ref.read(listSurveyProvider.notifier).getAllSurvey(classId.text);
                                          context.pop();
                                        } else {
                                          Fluttertoast.showToast(msg: "Thêm mới bài tập vào lớp ${classId.text} thất bại");
                                        }
                                      }
                                    }

                                  });
                                }
                              },
                              child: Center(child: Text(widget.checkEdit ? "Cập nhật thông tin tài liệu" : "Thêm tài liệu mới")),
                            );
                          }),
                        ),
                      ],
                    ),
                  )

              ),
            ),
          ),

          // Hiển thị màn hình tải khi trạng thái là loading
          if (infoMaterialState.isLoading)
            Container(
              color: Colors.black.withOpacity(0.5), // Nền mờ
              child: const Center(
                child: CircularProgressIndicator(), // Vòng tròn tải
              ),
            ),
        ],
      );
    });
  }
}