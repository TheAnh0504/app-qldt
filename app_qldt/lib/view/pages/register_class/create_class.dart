

import 'package:app_qldt/controller/account_provider.dart';
import 'package:app_qldt/controller/list_class_provider.dart';
import 'package:app_qldt/view/pages/register_class/register_class_page_home.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
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
import 'class_manager_lecturer.dart';

class CreateClass extends ConsumerStatefulWidget {
  const CreateClass({super.key});

  @override
  ConsumerState<CreateClass> createState() => _CreateClass();
}

class _CreateClass extends ConsumerState<CreateClass> {
  final classId = TextEditingController();
  final className = TextEditingController();
  String classType = "LT";
  final TextEditingController startDate = TextEditingController();
  final TextEditingController endDate = TextEditingController();
  final maxStudentAmount = TextEditingController();
  // final attachedCode = TextEditingController();

  Future<void> _selectDate(BuildContext context, String type) async {
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
      setState(() {
        type == "startDate"
            ? startDate.text = "${pickedDate.year}-$month-$day"
            : endDate.text = "${pickedDate.year}-$month-$day";
      });
    }
  }

  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.primary,
          title: const Align(
            alignment: Alignment(-0.25, 0), // Căn phải một chút
            child: Text("Tạo lớp mới", style: TypeStyle.title1White),
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
                    const TextSpan(text: "Mã lớp", style: TypeStyle.title4),
                    TextSpan(
                        text: "*",
                        style: TypeStyle.body4.copyWith(
                            color: Theme.of(context).colorScheme.error))
                  ])),
                  const SizedBox(height: 5),
                  TextInput(
                    controller: classId,
                    hintText: "Nhập mã lớp",
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: Validator.classId(),
                  ),
                  const SizedBox(height: 16),

                  // Text.rich(TextSpan(children: [
                  //   const TextSpan(text: "Mã lớp kèm", style: TypeStyle.title4),
                  //   TextSpan(
                  //       text: "*",
                  //       style: TypeStyle.body4.copyWith(
                  //           color: Theme.of(context).colorScheme.error))
                  // ])),
                  // const SizedBox(height: 5),
                  // TextInput(
                  //   controller: attachedCode,
                  //   hintText: "Nhập mã lớp kèm",
                  //   autovalidateMode: AutovalidateMode.onUserInteraction,
                  //   validator: Validator.attachedCode(),
                  // ),
                  // const SizedBox(height: 16),

                  Text.rich(TextSpan(children: [
                    const TextSpan(text: "Tên lớp", style: TypeStyle.title4),
                    TextSpan(
                        text: "*",
                        style: TypeStyle.body4.copyWith(
                            color: Theme.of(context).colorScheme.error))
                  ])),
                  const SizedBox(height: 5),
                  TextInput(
                    controller: className,
                    validator: Validator.className(),
                    hintText: "Nhập tên lớp",
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                  ),
                  const SizedBox(height: 16),

                  Text.rich(TextSpan(children: [
                    const TextSpan(text: "Loại lớp", style: TypeStyle.title4),
                    TextSpan(
                        text: "*",
                        style: TypeStyle.body4.copyWith(
                            color: Theme.of(context).colorScheme.error))
                  ])),
                  const SizedBox(height: 5),
                  DropdownButtonFormField<String>(
                    value: classType,
                    decoration: InputDecoration(
                      hintText: "Chọn loại lớp",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    items: const [
                      DropdownMenuItem(value: 'LT', child: Text('LT')),
                      DropdownMenuItem(value: 'BT', child: Text('BT')),
                      DropdownMenuItem(value: 'LT_BT', child: Text('LT+BT')),
                    ],
                    onChanged: (value) {
                      if (value != null) {
                        classType = value; // Cập nhật giá trị đã chọn
                      }
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Vui lòng chọn loại lớp";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  Text.rich(TextSpan(children: [
                    const TextSpan(text: "Số lượng sinh viên tối đa", style: TypeStyle.title4),
                    TextSpan(
                        text: "*",
                        style: TypeStyle.body4.copyWith(
                            color: Theme.of(context).colorScheme.error))
                  ])),
                  const SizedBox(height: 5),
                  TextInput(
                    controller: maxStudentAmount,
                    validator: Validator.maxStudentAmount(),
                    hintText: "Nhập số lượng sinh viên tối đa",
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                  ),
                  const SizedBox(height: 16),

                  Text.rich(TextSpan(children: [
                    const TextSpan(text: "Ngày bắt đầu", style: TypeStyle.title4),
                    TextSpan(
                        text: "*",
                        style: TypeStyle.body4.copyWith(
                            color: Theme.of(context).colorScheme.error))
                  ])),
                  const SizedBox(height: 5),
                  TextFormField(
                    controller: startDate,
                    readOnly: true, // Không cho phép nhập tay
                    onTap: () => _selectDate(context, "startDate"), // Mở hộp thoại chọn ngày
                    decoration: const InputDecoration(
                      hintText: "Chọn ngày bắt đầu",
                      border: OutlineInputBorder(),
                      suffixIcon: Icon(Icons.calendar_today),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Vui lòng chọn ngày bắt đầu.";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  Text.rich(TextSpan(children: [
                    const TextSpan(text: "Ngày kết thúc", style: TypeStyle.title4),
                    TextSpan(
                        text: "*",
                        style: TypeStyle.body4.copyWith(
                            color: Theme.of(context).colorScheme.error))
                  ])),
                  const SizedBox(height: 5),
                  TextFormField(
                    controller: endDate,
                    readOnly: true, // Không cho phép nhập tay
                    onTap: () => _selectDate(context, "endDate"), // Mở hộp thoại chọn ngày
                    decoration: const InputDecoration(
                      hintText: "Chọn ngày kết thúc",
                      border: OutlineInputBorder(),
                      suffixIcon: Icon(Icons.calendar_today),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Vui lòng chọn ngày kết thúc.";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  Center(
                    child: Builder(builder: (context) {
                      return FilledButton(
                        onPressed: () async {
                          if (formKey.currentState?.validate() ?? false) {
                            DateTime startDateCheck = DateTime.parse(startDate.text);
                            DateTime endDateCheck = DateTime.parse(endDate.text);

                            if (startDateCheck.isBefore(endDateCheck)) {
                              showDialog<bool>(
                                  context: context,
                                  builder: (_) => AlertDialog(
                                      title: const Text("Xác nhận tạo lớp mới?"),
                                      content: SingleChildScrollView(
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min, // Thu nhỏ chiều cao Column
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text.rich(TextSpan(children: [
                                              const TextSpan(text: "Bạn có chắc chắn muốn tạo lớp ", style: TypeStyle.body4),
                                              TextSpan(
                                                  text: className.text,
                                                  style: TypeStyle.body4.copyWith(
                                                      color: Theme.of(context).colorScheme.error)
                                              ),
                                              const TextSpan(text: " với mã lớp ", style: TypeStyle.body4),
                                              TextSpan(
                                                  text: classId.text,
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
                                  if (await ref.read(listClassRegisterNowProvider.notifier).addClass(classId.text, className.text, classType, startDate.text, endDate.text, maxStudentAmount.text)) {
                                    ClassInfoModel classNew = ClassInfoModel(
                                        class_id: classId.text,
                                        class_name: className.text,
                                        class_type: classType,
                                        lecturer_name: ref.read(accountProvider).value?.name,
                                        lecturer_account_id: ref.read(accountProvider).value!.idAccount,
                                        student_count: "0",
                                        start_date: startDate.text,
                                        end_date: endDate.text,
                                        status: "ACTIVE",
                                        student_accounts: []
                                    );
                                    List<ClassInfoModel>? registerNow = ref.watch(listClassRegisterNowProvider).value;
                                    List<ClassInfoModel>? listClass = ref.watch(listClassProvider).value;
                                    List<ClassInfoModel>? listClassAll = ref.watch(listClassAllProvider).value;
                                    registerNow?.add(classNew);
                                    listClass?.add(classNew);
                                    listClassAll?.add(classNew);
                                    ref.read(listClassRegisterNowProvider.notifier).forward(AsyncData(registerNow));
                                    ref.read(listClassProvider.notifier).forward(AsyncData(listClass));
                                    ref.read(listClassAllProvider.notifier).forward(AsyncData(listClassAll));
                                    // push chỉ có 1 page này thôi: xóa các page giống cũ
                                    // Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
                                    //   MaterialPageRoute(
                                    //     builder: (context) => const ClassManagerLecturer(),
                                    //   ), (Route<dynamic> route) => route.isFirst, // Chỉ giữ lại trang đầu tiên.
                                    // );
                                    Navigator.pushAndRemoveUntil(context,
                                        MaterialPageRoute(builder: (context) => const ClassManagerLecturer()),
                                        (Route<dynamic> route) => route.isFirst
                                    );
                                    Fluttertoast.showToast(msg: "Tạo lớp ${classId.text} thành công");
                                  } else {
                                    Fluttertoast.showToast(msg: "Tạo lớp ${classId.text} thất bại");
                                  }
                                }
                              });
                            } else {
                              Fluttertoast.showToast(msg: "Ngày bắt đầu phải nhỏ hơn ngày kết thúc của lớp học");
                            }
                          }
                        },
                        child: const Center(child: Text("Tạo lớp học")),
                      );
                    }),
                  ),
                ],
              ),
            )

        ),
      ),
    );
  }
}