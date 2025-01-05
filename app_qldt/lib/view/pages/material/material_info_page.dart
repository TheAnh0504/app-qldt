import 'dart:io';

import 'package:app_qldt/controller/account_provider.dart';
import 'package:app_qldt/controller/list_class_provider.dart';
import 'package:app_qldt/controller/material_provider.dart';
import 'package:app_qldt/model/entities/material_model.dart';
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
import '../register_class/class_manager_lecturer.dart';
import 'package:http/http.dart' as http;

class MaterialInfoPage extends ConsumerStatefulWidget {
  final dynamic dataEdit;
  final bool checkEdit;
  const MaterialInfoPage(this.dataEdit, this.checkEdit, {super.key});

  @override
  ConsumerState<MaterialInfoPage> createState() => _MaterialInfoPage();
}

class _MaterialInfoPage extends ConsumerState<MaterialInfoPage> {
  TextEditingController id = TextEditingController();
  TextEditingController classId = TextEditingController();
  TextEditingController materialName = TextEditingController();
  TextEditingController description = TextEditingController();
  TextEditingController materialLink = TextEditingController();
  TextEditingController materialType = TextEditingController();

  final formKey = GlobalKey<FormState>();
  MaterialModel? data;
  File? selectedFile;
  bool checkShow = false;

  @override
  void initState() {
    super.initState();
    if (widget.checkEdit) {
      data = ref.read(infoMaterialProvider).value!;
      id.text = data!.id;
      classId.text = data!.class_id;
      materialName.text = data!.material_name;
      description.text = data!.description;
      materialLink.text = data!.material_link ?? '';
      materialType.text = data!.material_type;
      SchedulerBinding.instance.addPostFrameCallback((_) async {
        if (data?.material_link != null && data?.material_link != "") {
          try {
            // Gửi yêu cầu tải xuống file
            final response = await http.get(Uri.parse(data!.material_link ?? ''));
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
    } else {
      classId.text = widget.dataEdit;
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
                      !widget.checkEdit ? "Thêm tài liệu lớp ${classId.text}" : "Sửa tài liệu lớp ${classId.text}",
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
                        if (widget.checkEdit) Text.rich(TextSpan(children: [
                          const TextSpan(text: "Mã tài liệu", style: TypeStyle.title4),
                          TextSpan(
                              text: "*",
                              style: TypeStyle.body4.copyWith(
                                  color: Theme.of(context).colorScheme.error))
                        ])),
                        if (widget.checkEdit) const SizedBox(height: 5),
                        if (widget.checkEdit) TextInput(
                            controller: id,
                            hintText: "",
                            autovalidateMode: AutovalidateMode.onUserInteraction,
                            readOnly: true
                        ),
                        if (widget.checkEdit) const SizedBox(height: 16),

                        Text.rich(TextSpan(children: [
                          const TextSpan(text: "Mã lớp", style: TypeStyle.title4),
                          TextSpan(
                              text: "*",
                              style: TypeStyle.body4.copyWith(
                                  color: Theme.of(context).colorScheme.error))
                        ])),
                        const SizedBox(height: 5),
                        TextInput(
                            controller: classId,
                            hintText: "",
                            autovalidateMode: AutovalidateMode.onUserInteraction,
                            readOnly: true
                        ),
                        const SizedBox(height: 16),

                        Text.rich(TextSpan(children: [
                          const TextSpan(text: "Tên tài liệu", style: TypeStyle.title4),
                          TextSpan(
                              text: "*",
                              style: TypeStyle.body4.copyWith(
                                  color: Theme.of(context).colorScheme.error))
                        ])),
                        const SizedBox(height: 5),
                        TextInput(
                          controller: materialName,
                          hintText: "Nhập tên tài liệu",
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          validator: Validator.materialName(),
                        ),
                        const SizedBox(height: 16),

                        Text.rich(TextSpan(children: [
                          const TextSpan(text: "Mô tả tài liệu", style: TypeStyle.title4),
                          TextSpan(
                              text: "*",
                              style: TypeStyle.body4.copyWith(
                                  color: Theme.of(context).colorScheme.error))
                        ])),
                        const SizedBox(height: 5),
                        TextInput(
                          controller: description,
                          hintText: "Mô tả tài liệu này",
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          validator: Validator.description(),
                        ),
                        const SizedBox(height: 16),

                        Text.rich(TextSpan(children: [
                          const TextSpan(text: "Loại tài liệu", style: TypeStyle.title4),
                          TextSpan(
                              text: "*",
                              style: TypeStyle.body4.copyWith(
                                  color: Theme.of(context).colorScheme.error))
                        ])),
                        const SizedBox(height: 5),
                        TextInput(
                          controller: materialType,
                          validator: Validator.materialType(),
                          hintText: "Nhập loại tài liệu",
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                        ),
                        const SizedBox(height: 16),

                        // edit
                        if (widget.checkEdit) Text.rich(TextSpan(children: [
                          const TextSpan(text: "Link tài liệu", style: TypeStyle.title4),
                          TextSpan(
                              text: "*",
                              style: TypeStyle.body4.copyWith(
                                  color: Theme.of(context).colorScheme.error))
                        ])),
                        if (widget.checkEdit) const SizedBox(height: 5),
                        if (widget.checkEdit) TextInput(
                          controller: materialLink,
                          hintText: "",
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          readOnly: true,
                        ),
                        if (widget.checkEdit) const SizedBox(height: 10),
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
                                  materialLink.text = '';// Lưu file đã chọn
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
                        if (selectedFile != null && checkShow) // Nếu đã chọn file, hiển thị tên file
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
                                  Fluttertoast.showToast(msg: "Vui lòng chọn file tài liệu");
                                  return;
                                }
                                if (formKey.currentState?.validate() ?? false) {
                                  showDialog<bool>(
                                      context: context,
                                      builder: (_) => AlertDialog(
                                          title: Text(widget.checkEdit ? "Xác nhận cập nhật thông tin tài liệu?" : "Xác nhận thêm mới tài liệu?"),
                                          content: SingleChildScrollView(
                                            child: Column(
                                              mainAxisSize: MainAxisSize.min, // Thu nhỏ chiều cao Column
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text.rich(TextSpan(children: [
                                                  TextSpan(
                                                      text: widget.checkEdit ? "Bạn có chắc chắn muốn cập nhật thông tin tài liệu với mã tài liệu " : "Bạn có chắc chắn muốn thêm tài liệu mới cho lớp "
                                                      , style: TypeStyle.body4),
                                                  TextSpan(
                                                      text: widget.checkEdit ? id.text : classId.text,
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
                                        if (await ref.read(infoMaterialProvider.notifier).editMaterial(selectedFile!, id.text, materialName.text, description.text, materialType.text)) {
                                          Fluttertoast.showToast(msg: "Chỉnh sửa tài liệu với mã tài liệu ${id.text} thành công");
                                          await ref.read(listMaterialProvider.notifier).getListMaterial(classId.text);
                                          context.pop();
                                        } else {
                                          Fluttertoast.showToast(msg: "Chỉnh sửa tài liệu với mã tài liệu ${id.text} thất bại");
                                        }
                                      } else {
                                        if (await ref.read(infoMaterialProvider.notifier).uploadMaterial(selectedFile!, classId.text, materialName.text, description.text, materialType.text)) {
                                          Fluttertoast.showToast(msg: "Thêm mới tài liệu vào lớp ${classId.text} thành công");
                                          await ref.read(listMaterialProvider.notifier).getListMaterial(classId.text);
                                          context.pop();
                                        } else {
                                          Fluttertoast.showToast(msg: "Thêm mới tài liệu vào lớp ${classId.text} thất bại");
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