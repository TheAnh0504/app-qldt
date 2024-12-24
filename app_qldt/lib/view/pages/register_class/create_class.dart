

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
  final attachedCode = TextEditingController();

  Future<void> _selectDate(BuildContext context, String type) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (pickedDate != null) {
      setState(() {
        type == "startDate"
            ? startDate.text = "${pickedDate.year}-${pickedDate.month}-${pickedDate.day}"
            : endDate.text = "${pickedDate.year}-${pickedDate.month}-${pickedDate.day}";
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

                  Text.rich(TextSpan(children: [
                    const TextSpan(text: "Mã lớp kèm", style: TypeStyle.title4),
                    TextSpan(
                        text: "*",
                        style: TypeStyle.body4.copyWith(
                            color: Theme.of(context).colorScheme.error))
                  ])),
                  const SizedBox(height: 5),
                  TextInput(
                    controller: attachedCode,
                    hintText: "Nhập mã lớp kèm",
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: Validator.attachedCode(),
                  ),
                  const SizedBox(height: 16),

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
                      DropdownMenuItem(value: 'LT', child: Text('Lý thuyết')),
                      DropdownMenuItem(value: 'BT', child: Text('Bài tập')),
                      DropdownMenuItem(value: 'LT_BT', child: Text('Cả lý thuyết và bài tập')),
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
                        onPressed: () {
                          if (formKey.currentState?.validate() ?? false) {
                            // ref.read(signupProvider.notifier).signup(ho.text, ten.text, email.text, password.text, selectedRole);
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