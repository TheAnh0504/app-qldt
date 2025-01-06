import 'package:app_qldt/controller/material_provider.dart';
import 'package:app_qldt/controller/survey_provider.dart';
import 'package:app_qldt/view/pages/assignment/lecturer/info_survey.dart';
import 'package:app_qldt/view/pages/material/material_info_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../controller/account_provider.dart';
import '../../../../core/common/types.dart';
import '../../../../core/theme/palette.dart';
import '../../../../core/theme/typestyle.dart';
import '../../../../model/entities/class_info_model.dart';
import '../../../../model/entities/material_model.dart';
import '../../../../model/entities/survey_model.dart';

class ManagerLecturerAssiginment extends ConsumerStatefulWidget {
  final ClassInfoModel infoClass;
  final List<SurveyModel> listSurveyModel;
  const ManagerLecturerAssiginment({super.key, required this.infoClass, required this.listSurveyModel});

  @override
  ConsumerState<ManagerLecturerAssiginment> createState() => _ManagerLecturerAssiginment();
}

class _ManagerLecturerAssiginment extends ConsumerState<ManagerLecturerAssiginment> {
  ValueNotifier<List<SurveyModel>> results = ValueNotifier([]);
  String absenceType = 'edit';

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    results.value = widget.listSurveyModel;
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.primary,
          title: Align(
              alignment: const Alignment(-0.6, 0), // Căn phải một chút
              child: Text("Quản lý bài tập lớp ${widget.infoClass.class_id}", style: TypeStyle.title1White)
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
              Text("Chức năng", style: TypeStyle.title1.copyWith(color: Palette.red100)),
              const SizedBox(height: 10),

              // TODO: create-material
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(width: 20),
                  Expanded(
                    child: Center(
                      child: FilledButton(
                        onPressed: () {
                          print("Thêm bài tập");
                          Navigator.push(context, MaterialPageRoute(builder: (context) => InfoSurvey(widget.infoClass.class_id, false, null)));
                        },
                        child: const Center(child: Text("Thêm bài tập")),
                      ),
                    ),
                  ),
                  const SizedBox(width: 20),
                ],
              ),

              const SizedBox(height: 16),
              Text("Danh bài tập của lớp", style: TypeStyle.title1.copyWith(color: Palette.red100)),
              const SizedBox(height: 10),
              ValueListenableBuilder<List<SurveyModel>>(
                valueListenable: results,
                builder: (context, results1, _) {
                  if (results1.isEmpty) {
                    return const Center(child: Text("Lớp chưa có bài tập nào."));
                  }
                  return SizedBox(
                    height: 520,
                    child: ListView.builder(
                      itemCount: results1.length,
                      itemBuilder: (context, index) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            color: Palette.grey55, // Màu nền
                            borderRadius: BorderRadius.circular(8), // Bo góc
                          ),
                          child: ListTile(
                            title: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  results1[index].title ?? '',
                                  style: TypeStyle.title2,
                                ),
                                const SizedBox(height: 1),
                                Text.rich(TextSpan(children: [
                                  const TextSpan(text: "Mã bài tập: ", style: TypeStyle.body3),
                                  TextSpan(
                                      text: results1[index].id.toString(),
                                      style: TypeStyle.body3.copyWith(
                                          color: Theme.of(context).colorScheme.error))
                                ])),
                                Text.rich(TextSpan(children: [
                                  const TextSpan(text: "Mô tả bài tập: ", style: TypeStyle.body3),
                                  TextSpan(
                                      text: results1[index].description,
                                      style: TypeStyle.body3.copyWith(
                                          color: Theme.of(context).colorScheme.error))
                                ])),
                                Text.rich(TextSpan(children: [
                                  const TextSpan(text: "Ngày kết thúc: ", style: TypeStyle.body3),
                                  TextSpan(
                                      text: results1[index].deadline,
                                      style: TypeStyle.body3.copyWith(
                                          color: Theme.of(context).colorScheme.error))
                                ])),
                                if (results1[index].file_url != null) InkWell(
                                  splashFactory: InkRipple.splashFactory,
                                  onTap: () => launchUrl(
                                    Uri.parse(results1[index].file_url ?? ''),
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
                            onTap: () async {
                              // TODO: edit or delete material
                              if (ref.read(accountProvider).value?.role == 'LECTURER') {
                                showDialog<bool>(
                                    context: context,
                                    builder: (_) {
                                      return StatefulBuilder(
                                          builder: (context, setState) {
                                            return AlertDialog(
                                                title: const Text("Chỉnh sửa bài tập"),
                                                content: SingleChildScrollView(
                                                  child: Column(
                                                    mainAxisSize: MainAxisSize.min,
                                                    // Thu nhỏ chiều cao Column
                                                    mainAxisAlignment: MainAxisAlignment
                                                        .center,
                                                    crossAxisAlignment: CrossAxisAlignment
                                                        .start,
                                                    children: [
                                                      const Text(
                                                          "Vui lòng chọn chức năng: "),
                                                      const SizedBox(height: 10),

                                                      RadioListTile<String>(
                                                        title: const Text(
                                                            "Cập nhật thông tin bài tập"),
                                                        value: "edit",
                                                        groupValue: absenceType,
                                                        onChanged: (value) {
                                                          setState(() {
                                                            absenceType = value!;
                                                            print(absenceType);
                                                          });
                                                        },
                                                      ),
                                                      RadioListTile<String>(
                                                        title: const Text(
                                                            "Xóa bài tập"),
                                                        value: "delete",
                                                        groupValue: absenceType,
                                                        onChanged: (value) {
                                                          setState(() {
                                                            absenceType = value!;
                                                            print(absenceType);
                                                          });
                                                        },
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                actions: [
                                                  TextButton(
                                                      onPressed: () => _.pop(true),
                                                      child: const Text(
                                                          "Xác nhận")),
                                                  TextButton(
                                                      onPressed: () => _.pop(false),
                                                      child: const Text("Hủy"))
                                                ]);
                                          });
                                    }
                                ).then((value) async {
                                  if (value == null) return;
                                  if (value) {
                                    if (absenceType == 'delete') {
                                      final formKeyAbsence = GlobalKey<FormState>();
                                      showDialog<bool>(
                                          context: context,
                                          builder: (_) {
                                            return StatefulBuilder(
                                                builder: (context, setState) {
                                                  return AlertDialog(
                                                      title: const Text("Xác nhận xóa bài tập"),
                                                      content: SingleChildScrollView(
                                                        child: Column(
                                                          mainAxisSize: MainAxisSize.min,
                                                          // Thu nhỏ chiều cao Column
                                                          mainAxisAlignment: MainAxisAlignment
                                                              .center,
                                                          crossAxisAlignment: CrossAxisAlignment
                                                              .start,
                                                          children: [
                                                            Text.rich(TextSpan(children: [
                                                              const TextSpan(text: "Bạn có chắc chắn muốn xóa bài tập với mã bài tập là ", style: TypeStyle.body4),
                                                              TextSpan(
                                                                  text: results1[index].id.toString(),
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
                                                            child: const Text(
                                                                "Xác nhận")),
                                                        TextButton(
                                                            onPressed: () => _.pop(false),
                                                            child: const Text("Hủy"))
                                                      ]);
                                                });
                                          }
                                      ).then((value) async {
                                        if (value == null) return;
                                        if (value) {
                                          print(value);
                                          if (await ref.read(listSurveyProvider.notifier).deleteSurvey(results1[index].id.toString())) {
                                            await ref.read(listSurveyProvider.notifier).getAllSurvey(widget.infoClass.class_id);
                                            Fluttertoast.showToast(msg: "Xóa bài tập với mã bài tập ${results1[index].id.toString()} thành công!");
                                          } else {
                                            Fluttertoast.showToast(msg: "Xóa bài tập với mã bài tập ${results1[index].id.toString()} thất bại!");
                                          }
                                        }

                                      });
                                    } else if (absenceType == 'edit') {
                                      // edit
                                      Navigator.push(context, MaterialPageRoute(builder: (context) => InfoSurvey(widget.infoClass.class_id, true, results1[index])));
                                    }
                                  }
                                });
                              }

                              // Logic xử lý khi nhấn vào
                              // print("Selected: ${results1[index]}");
                              // try {
                              //   await ref.read(infoClassDataProvider.notifier).getClassInfo(results1[index].class_id);
                              // } catch (_) {
                              //   Fluttertoast.showToast(msg: "Lấy thông tin lớp ${results1[index].class_id} thất bại");
                              //   return;
                              // }
                              // if (ref.read(infoClassDataProvider).value != null) {
                              //   Navigator.push(context, MaterialPageRoute(builder: (context) => const InfoClassLecturer()));
                              // }
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