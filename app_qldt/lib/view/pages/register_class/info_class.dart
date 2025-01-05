

import 'dart:io';

import 'package:app_qldt/controller/absence_provider.dart';
import 'package:app_qldt/controller/account_provider.dart';
import 'package:app_qldt/controller/list_class_provider.dart';
import 'package:app_qldt/view/pages/material/material_manager_page.dart';
import 'package:app_qldt/view/pages/register_class/register_class_page_home.dart';
import 'package:extended_image/extended_image.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';

import '../../../controller/material_provider.dart';
import '../../../controller/signup_provider.dart';
import '../../../core/common/types.dart';
import '../../../core/router/router.dart';
import '../../../core/router/url.dart';
import '../../../core/theme/component.dart';
import '../../../core/theme/palette.dart';
import '../../../core/theme/typestyle.dart';
import '../../../core/validator/validator.dart';
import '../../../model/entities/absence_request_model.dart';
import '../../../model/entities/account_model.dart';
import '../../../model/entities/class_info_model.dart';
import '../../../model/entities/message_model.dart';
import '../messaging/messaging_detail_settings_page.dart';
import 'absence_request_manager.dart';

class ListStudentInClassDataSource extends DataGridSource {
  ListStudentInClassDataSource({required ClassInfoModel infoClass}) {
    dataGridRows = infoClass.student_accounts != []
        ? infoClass.student_accounts!
            .map<DataGridRow>((dataGridRow) => DataGridRow(cells: [
              DataGridCell<String>(columnName: 'account_id', value: dataGridRow["account_id"]),
              DataGridCell<String>(columnName: 'last_name', value: dataGridRow["last_name"]),
              DataGridCell<String>(columnName: 'first_name', value: dataGridRow["first_name"]),
              DataGridCell<String>(columnName: 'email', value: dataGridRow["email"]),
              DataGridCell<String>(columnName: 'student_id', value: dataGridRow["student_id"])
            ])).toList()
        : [];
  }

  List<DataGridRow> dataGridRows = [];

  @override
  List<DataGridRow> get rows => dataGridRows;

  @override
  DataGridRowAdapter? buildRow(DataGridRow row) {
    return DataGridRowAdapter(
        cells: row.getCells().map<Widget>((dataGridCell) {
          return Container(
              alignment: (
                  dataGridCell.columnName == 'account_id' ||
                  dataGridCell.columnName == 'student_id'
              )
                  ? Alignment.center
                  : Alignment.centerLeft,
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                dataGridCell.value.toString(),
                overflow: TextOverflow.ellipsis,
              ));
        }).toList());
  }
}

class InfoClassLecturer extends ConsumerStatefulWidget {
  const InfoClassLecturer({super.key});

  @override
  ConsumerState<InfoClassLecturer> createState() => _InfoClassLecturer();
}

class _InfoClassLecturer extends ConsumerState<InfoClassLecturer> {
  late ClassInfoModel data;
  late AccountModel accountModel;
  late ListStudentInClassDataSource infoClassDataSource;
  DataGridController infoClassController = DataGridController();
  DataGridRow selectRegister = const DataGridRow(cells: []);
  String absenceType = 'absence_request';
  TextEditingController startDate = TextEditingController();
  TextEditingController reason = TextEditingController();
  File? selectedFile;

  @override
  void initState() {
    super.initState();
  }

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
      setState(() =>startDate.text = "${pickedDate.year}-$month-$day");
    }
  }

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    data = ref.read(infoClassDataProvider).value!;
    accountModel = ref.read(accountProvider).value!;
    infoClassDataSource = ListStudentInClassDataSource(
      infoClass: data,
    );

    ref.listen(infoClassDataProvider, (prev, next) {
      if (next is AsyncError) {
        Fluttertoast.showToast(msg: next.error.toString());
      }
      if (next is AsyncData) {
        infoClassDataSource = ListStudentInClassDataSource(
          infoClass: next.value!
        );
        context.go(feedRoute);
      }
    });

    return Scaffold(
      appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.primary,
          title: Align(
            alignment: const Alignment(-0.3, 0), // Căn phải một chút
            child: accountModel.role == "LECTURER"
              ? Text("Quản lý lớp ${data.class_id}", style: TypeStyle.title1White)
              : Text("Thông tin lớp ${data.class_id}", style: TypeStyle.title1White),
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
                  Text("Thông tin cơ bản", style: TypeStyle.title1.copyWith(color: Palette.red100)),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Text.rich(TextSpan(children: [
                          const TextSpan(text: "Mã lớp: ", style: TypeStyle.body4),
                          TextSpan(
                              text: data.class_id,
                              style: TypeStyle.body4.copyWith(
                                  color: Theme.of(context).colorScheme.error))
                        ])),
                      ),
                      Expanded(
                        child: Text.rich(TextSpan(children: [
                          const TextSpan(text: "Tên lớp: ", style: TypeStyle.body4),
                          TextSpan(
                              text: data.class_name,
                              style: TypeStyle.body4.copyWith(
                                  color: Theme.of(context).colorScheme.error))
                        ])),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Text.rich(TextSpan(children: [
                          const TextSpan(text: "Mã lớp kèm: ", style: TypeStyle.body4),
                          TextSpan(
                              text: data.attached_code,
                              style: TypeStyle.body4.copyWith(
                                  color: Theme.of(context).colorScheme.error))
                        ])),
                      ),
                      Expanded(
                        child: Text.rich(TextSpan(children: [
                          const TextSpan(text: "Loại lớp: ", style: TypeStyle.body4),
                          TextSpan(
                              text: data.class_type,
                              style: TypeStyle.body4.copyWith(
                                  color: Theme.of(context).colorScheme.error))
                        ])),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Text.rich(TextSpan(children: [
                          const TextSpan(text: "Mã số giảng viên: ", style: TypeStyle.body4),
                          TextSpan(
                              text: data.lecturer_account_id,
                              style: TypeStyle.body4.copyWith(
                                  color: Theme.of(context).colorScheme.error))
                        ])),
                      ),
                      Expanded(
                        child: Text.rich(TextSpan(children: [
                          const TextSpan(text: "Tên giảng viên: ", style: TypeStyle.body4),
                          TextSpan(
                              text: data.lecturer_name,
                              style: TypeStyle.body4.copyWith(
                                  color: Theme.of(context).colorScheme.error))
                        ])),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Text.rich(TextSpan(children: [
                          const TextSpan(text: "Ngày bắt đầu: ", style: TypeStyle.body4),
                          TextSpan(
                              text: data.start_date,
                              style: TypeStyle.body4.copyWith(
                                  color: Theme.of(context).colorScheme.error))
                        ])),
                      ),
                      Expanded(
                        child: Text.rich(TextSpan(children: [
                          const TextSpan(text: "Ngày kết thúc: ", style: TypeStyle.body4),
                          TextSpan(
                              text: data.end_date,
                              style: TypeStyle.body4.copyWith(
                                  color: Theme.of(context).colorScheme.error))
                        ])),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Text.rich(TextSpan(children: [
                          const TextSpan(text: "Số sinh viên: ", style: TypeStyle.body4),
                          TextSpan(
                              text: '${data.student_count}/${data.max_student_amount}',
                              style: TypeStyle.body4.copyWith(
                                  color: Theme.of(context).colorScheme.error))
                        ])),
                      ),
                      Expanded(
                        child: Text.rich(TextSpan(children: [
                          const TextSpan(text: "Trạng thái lớp: ", style: TypeStyle.body4),
                          TextSpan(
                              text: data.status,
                              style: TypeStyle.body4.copyWith(
                                  color: Theme.of(context).colorScheme.error))
                        ])),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text("Chức năng", style: TypeStyle.title1.copyWith(color: Palette.red100)),
                  const SizedBox(height: 10),

                  // TODO: Nghỉ phép - Done
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(width: 20),
                      Expanded(
                        child: Center(
                          child: FilledButton(
                            onPressed: () async {
                              print("Xin nghỉ học");
                              if (ref.read(accountProvider).value?.role == 'LECTURER') {
                                List<AbsenceRequestModel>? value = await ref.read(absenceProvider.notifier).getAbsenceRequestLecture(data.class_id, 'PENDING', null);
                                Navigator.push(context, MaterialPageRoute(builder: (context) => AbsenceRequestManager(value, classIdLecturer: data.class_id, dateStart: null,  status: 'PENDING',)));
                              } else {
                                showDialog<bool>(
                                    context: context,
                                    builder: (_) {
                                      return StatefulBuilder(
                                          builder: (context, setState) {
                                            return AlertDialog(
                                                title: const Text("Xin nghỉ học"),
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
                                                            "Tạo đơn xin nghỉ học"),
                                                        value: "absence_request",
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
                                                            "Xem đơn xin nghỉ học trước đó"),
                                                        value: "get_absence",
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
                                    if (absenceType == 'absence_request') {
                                      final formKeyAbsence = GlobalKey<FormState>();
                                      showDialog<bool>(
                                          context: context,
                                          builder: (_) => AlertDialog(
                                              title: Text("Đơn xin nghỉ học lớp ${data.class_id}", style: TypeStyle.title1),
                                              content: SingleChildScrollView(
                                                  child: Form(
                                                    key: formKeyAbsence,
                                                    child: Column(
                                                      mainAxisSize: MainAxisSize.min, // Thu nhỏ chiều cao Column
                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        // Text("Bạn có chắc chắn muốn thêm sinh viên sau vào lớp ${selectRegister.getCells().first.value} không?"),
                                                        // const SizedBox(height: 10),
                                                        Text.rich(TextSpan(children: [
                                                          const TextSpan(text: "MSSV: ", style: TypeStyle.body4),
                                                          TextSpan(
                                                              text: ref.read(accountProvider).value?.idAccount,
                                                              style: TypeStyle.body4.copyWith(
                                                                  color: Theme.of(context).colorScheme.error))
                                                        ])),
                                                        const SizedBox(height: 10),
                                                        Text.rich(TextSpan(children: [
                                                          const TextSpan(text: "Sinh viên: ", style: TypeStyle.body4),
                                                          TextSpan(
                                                              text: ref.read(accountProvider).value?.name,
                                                              style: TypeStyle.body4.copyWith(
                                                                  color: Theme.of(context).colorScheme.error))
                                                        ])),
                                                        const SizedBox(height: 10),
                                                        Text.rich(TextSpan(children: [
                                                          const TextSpan(text: "Email: ", style: TypeStyle.body4),
                                                          TextSpan(
                                                              text: ref.read(accountProvider).value?.email,
                                                              style: TypeStyle.body4.copyWith(
                                                                  color: Theme.of(context).colorScheme.error))
                                                        ])),
                                                        const SizedBox(height: 10),
                                                        TextFormField(
                                                          controller: startDate,
                                                          readOnly: true, // Không cho phép nhập tay
                                                          onTap: () => _selectDate(context), // Mở hộp thoại chọn ngày
                                                          decoration: const InputDecoration(
                                                            hintText: "Chọn ngày xin nghỉ",
                                                            border: OutlineInputBorder(),
                                                            suffixIcon: Icon(Icons.calendar_today),
                                                          ),
                                                          validator: (value) {
                                                            if (value == null || value.isEmpty) {
                                                              return "Vui lòng chọn ngày xin nghỉ.";
                                                            }
                                                            DateTime startDateCheck = DateTime.parse(startDate.text);
                                                            if (startDateCheck.isBefore(DateTime.now())) {
                                                              return "Ngày xin nghỉ phải sau hôm nay";
                                                            }
                                                            return null;
                                                          },
                                                        ),
                                                        const SizedBox(height: 10),
                                                        const Text("Lý do: ", style: TypeStyle.body4),
                                                        const SizedBox(height: 5),
                                                        TextInput(
                                                          controller: reason,
                                                          validator: Validator.reason(),
                                                          hintText: "Nhập lý do xin nghỉ học",
                                                          autovalidateMode: AutovalidateMode.onUserInteraction,
                                                        ),
                                                        const SizedBox(height: 10),
                                                        const Text("Hồ sơ minh chứng: ", style: TypeStyle.body4),
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
                                          if (await ref.read(absenceProvider1.notifier).requestAbsence(data.class_id, startDate.text, reason.text, selectedFile, "Đơn xin nghỉ học")) {
                                            await ref.read(absenceProvider1.notifier).sendNotify(
                                                'MSSV: ${ref.read(accountProvider).value?.idAccount}; Email: ${ref.read(accountProvider).value?.email}; Ngày xin nghỉ: ${startDate.text}; Lớp: ${data.class_id} - ${data.class_name}; Lý do: ${reason.text}',
                                                data.lecturer_account_id, "ABSENCE"
                                            );
                                            startDate.clear();
                                            reason.clear();
                                            selectedFile = null;
                                            Fluttertoast.showToast(msg: "Gửi đơn xin nghỉ học thành công");
                                          } else {
                                            Fluttertoast.showToast(msg: "Gửi đơn xin nghỉ học thất bại!");
                                          }
                                        }

                                      });
                                    } else if (absenceType == 'get_absence') {
                                      List<AbsenceRequestModel>? value = await ref.read(absenceProvider.notifier).getAbsenceRequestStudent(null, null, null);
                                      Navigator.push(context, MaterialPageRoute(builder: (context) => AbsenceRequestManager(value, classIdLecturer: data.class_id, dateStart: null, status: null,)));
                                    }
                                  }
                                });
                              }
                            },
                            child: const Center(child: Text("Nghỉ phép")),
                          ),
                        ),
                      ),
                      const SizedBox(width: 20),
                      // TODO: Bài tập
                      Expanded(
                        child: Center(
                          child: FilledButton(
                            onPressed: () async {
                              print("Bài tập");
                              // print("select row: ${selectRegister.getCells().first.value}");
                              if (selectRegister.getCells().isNotEmpty) {
                                try {
                                  await ref.read(infoClassDataProvider.notifier).getClassInfo(selectRegister.getCells().first.value);
                                } catch (_) {
                                  Fluttertoast.showToast(msg: "Lấy thông tin lớp ${selectRegister.getCells().first.value} thất bại");
                                  return;
                                }
                                if (ref.read(infoClassDataProvider).value != null) {
                                  // Navigator.push(context, MaterialPageRoute(builder: (context) => const EditClass()));
                                }
                              } else {
                                Fluttertoast.showToast(msg: "Vui lòng chọn lớp để thực hiện chức năng này");
                              }
                            },
                            child: const Center(child: Text("Bài tập")),
                          ),
                        ),
                      ),
                      const SizedBox(width: 20),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(width: 20),
                      // TODO: Tài liệu - Done
                      Expanded(
                        child: Center(
                          child: FilledButton(
                            onPressed: () async {
                              print("Tài liệu môn học");
                              await ref.read(listMaterialProvider.notifier).getListMaterial(data.class_id);
                              Navigator.push(context, MaterialPageRoute(builder: (context) => MaterialManagerPage(infoClass: data,)));
                            },
                            child: const Center(child: Text("Tài liệu")),
                          ),
                        ),
                      ),
                      const SizedBox(width: 20),
                      // if (ref.read(accountProvider).value?.role == 'STUDENT') const SizedBox(width: 20),
                      // TODO: Điểm danh
                      Expanded(
                        child: Center(
                          child: FilledButton(
                            onPressed: () {
                              print("Điểm danh");
                              // print("select row: ${selectRegister.getCells().first.value}");
                              if (selectRegister.getCells().isNotEmpty) {
                                showDialog<bool>(
                                    context: context,
                                    builder: (_) => AlertDialog(
                                        title: Text("Xác nhận xóa lớp ${selectRegister.getCells().first.value}?"),
                                        content: SingleChildScrollView(
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min, // Thu nhỏ chiều cao Column
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text("Bạn có chắc chắn muốn xóa lớp ${selectRegister.getCells().first.value} không?"),
                                              const SizedBox(height: 10),
                                              Text.rich(TextSpan(children: [
                                                TextSpan(text: " Lưu ý: ", style: TypeStyle.body4.copyWith(
                                                    color: Theme.of(context).colorScheme.error)),
                                                TextSpan(
                                                    text: "Hành động xóa lớp không thể hoàn tác.",
                                                    style: TypeStyle.body4.copyWith(
                                                        color: Theme.of(context).colorScheme.error))
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
                                    if (await ref.read(listClassRegisterNowProvider.notifier).deleteClass(selectRegister.getCells().first.value)) {
                                      // _listRegisterClass.removeWhere((classInfo) => classInfo.class_id == selectRegister.getCells().first.value);
                                      // setState(() {
                                      //   _listRegisterClassDataSource = RegisterClassDataSource(
                                      //     listRegisterClass: _listRegisterClass,
                                      //   );
                                      // });
                                      Fluttertoast.showToast(msg: "Xóa lớp ${selectRegister.getCells().first.value} thành công!");
                                    } else {
                                      Fluttertoast.showToast(msg: "Xóa lớp ${selectRegister.getCells().first.value} thất bại!");
                                    }
                                  }
                                });
                              } else {
                                Fluttertoast.showToast(msg: "Vui lòng chọn lớp để thực hiện chức năng này");
                              }


                              // List<String> classIds = [];
                              // for (var classInfo in _listRegisterClass) {
                              //   classIds.add(classInfo.class_id);
                              // }
                              // _listRegisterClass = (await ref.read(listClassRegisterNowProvider.notifier).registerClass(classIds, _listRegisterClass))!;
                              // setState(() {
                              //   _listRegisterClassDataSource = RegisterClassDataSource(
                              //     listRegisterClass: _listRegisterClass,
                              //   );
                              // });
                              // Fluttertoast.showToast(msg: "Đăng ký lớp thành công, vui lòng kiểm tra Trạng thái đăng ký lớp!");


                              // String message = "";
                              // for (int i = 0; i < selectRegister.length; i++) {
                              //   if (i != 0) {
                              //     message = "$message, ";
                              //   }
                              //   message = message + selectRegister[i].getCells().first.value;
                              // }
                              // Fluttertoast.showToast(msg: "Chưa có api xóa lớp, danh sách lớp xóa: $message");
                            },
                            child: const Center(child: Text("Điểm danh")),
                          ),
                        ),
                      ),
                      const SizedBox(width: 20),
                    ],
                  ),





                  const SizedBox(height: 16),
                  Text("Thông tin sinh viên trong lớp", style: TypeStyle.title1.copyWith(color: Palette.red100)),
                  const SizedBox(height: 10),
                  SfDataGrid(
                      source: infoClassDataSource,
                      controller: infoClassController,
                      showCheckboxColumn: true,
                      checkboxColumnSettings: const DataGridCheckboxColumnSettings(
                          label: Text(''), width: 50),
                      selectionMode: SelectionMode.single,
                      onSelectionChanged: (List<DataGridRow> addedRows, List<DataGridRow> removedRows) {
                        selectRegister = infoClassController.selectedRow!;
                      },
                      onCellDoubleTap: (_) {
                        selectRegister = infoClassController.selectedRow!;
                        Navigator.push(context, MaterialPageRoute(
                            builder: (_) => MessagingDetailSettingsPage(
                                user: MessageUserModel(
                                  // required
                                    id: int.parse(selectRegister.getCells().first.value),
                                    // face
                                    name: 'check',
                                    avatar: 'check'
                                )
                            )
                        ));
                      },
                      onCellLongPress: (_) {
                        selectRegister = infoClassController.selectedRow!;
                        Navigator.push(context, MaterialPageRoute(
                            builder: (_) => MessagingDetailSettingsPage(
                                user: MessageUserModel(
                                  // required
                                    id: int.parse(selectRegister.getCells().first.value),
                                    // face
                                    name: 'check',
                                    avatar: 'check'
                                )
                            )
                        ));
                      },
                      columns: [
                        GridColumn(
                          columnName: 'account_id',
                          width: 80,
                          label: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 16.0),
                              alignment: Alignment.center,
                              child: const Text(
                                'MSSV',
                                overflow: TextOverflow.ellipsis,
                              )),
                        ),
                        GridColumn(
                            columnName: 'first_name',
                            width: 100,
                            label: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                                alignment: Alignment.centerLeft,
                                child: const Text(
                                  'Họ',
                                  overflow: TextOverflow.ellipsis,
                                ))),
                        GridColumn(
                            columnName: 'last_name',
                            width: 100,
                            label: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                                alignment: Alignment.centerLeft,
                                child: const Text(
                                  'Tên',
                                  overflow: TextOverflow.ellipsis,
                                ))),
                        GridColumn(
                            columnName: 'email',
                            width: 200,
                            label: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                                alignment: Alignment.centerLeft,
                                child: const Text(
                                  'Email',
                                  overflow: TextOverflow.ellipsis,
                                )
                            )
                        ),
                        GridColumn(
                            columnName: 'student_id',
                            width: 0,
                            label: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                                alignment: Alignment.center,
                                child: const Text(
                                  'Mã sinh viên',
                                  overflow: TextOverflow.ellipsis,
                                ))),
                      ]
                  ),

                ],
              ),
            )

        ),
      ),
    );
  }

  // Future<void> handleShowAbsenceRequestInfo(BuildContext context, AccountModel account) async {
  //   // show list Open class
  //   showModalBottomSheet(
  //       context: context,
  //       backgroundColor: Palette.white,
  //       showDragHandle: true,
  //       isScrollControlled: true, // Cho phép tùy chỉnh chiều cao
  //       builder: (context) => FractionallySizedBox(
  //           heightFactor: 8 / 10, // Chiều cao bằng 2/3 màn hình
  //           child: SingleChildScrollView(
  //             child: Container(
  //                 width: MediaQuery.sizeOf(context).width,
  //                 padding: const EdgeInsets.symmetric(horizontal: 8),
  //                 decoration: const BoxDecoration(color: Palette.white),
  //                 child: Column(
  //                   mainAxisSize: MainAxisSize.min,
  //                   crossAxisAlignment: CrossAxisAlignment.start,
  //                   children: [
  //                     Padding(
  //                       padding: const EdgeInsets.only(left: 15),
  //                       child: Row(
  //                         children: [
  //                           const Text('Tìm kiếm lớp học',
  //                               style: TypeStyle.title1),
  //                           const Spacer(),
  //                           Center(
  //                             child: FilledButton(
  //                               onPressed: () async {
  //                                 // await ref.read(listClassProvider.notifier).getListClassInfoBy(classId.text, className.text, status, classType);
  //                               },
  //                               child: const Center(child: Text("Tìm kiếm")),
  //                             ),
  //                           ),
  //                         ],
  //                       ),
  //                     ),
  //                     Padding(
  //                         padding: const EdgeInsets.symmetric(
  //                             horizontal: 10, vertical: 0),
  //                         child: Row(
  //                           mainAxisAlignment: MainAxisAlignment.center,
  //                           children: [
  //                             // Expanded(
  //                             //   child: TextFormField(
  //                             //     controller: className,
  //                             //     decoration: const InputDecoration(
  //                             //       hintText: "Tên lớp",
  //                             //       border: OutlineInputBorder(),
  //                             //     ),
  //                             //     autovalidateMode: AutovalidateMode.onUserInteraction,
  //                             //   ),
  //                             // ),
  //                           ],
  //                         )
  //                     ),
  //                     Padding(
  //                         padding: const EdgeInsets.all(10),
  //                         child: Column(
  //                           // mainAxisAlignment: MainAxisAlignment.center,
  //                           children: [
  //                             // DropdownButtonFormField<String>(
  //                             //   value: status,
  //                             //   decoration: InputDecoration(
  //                             //     hintText: "- Chọn trạng thái lớp -",
  //                             //     border: OutlineInputBorder(
  //                             //       borderRadius: BorderRadius.circular(8),
  //                             //     ),
  //                             //   ),
  //                             //   items: const [
  //                             //     DropdownMenuItem(value: '', child: Text('(All)')),
  //                             //     DropdownMenuItem(value: 'ACTIVE', child: Text('ACTIVE')),
  //                             //     DropdownMenuItem(value: 'UPCOMING', child: Text('UPCOMING')),
  //                             //     DropdownMenuItem(value: 'COMPLETED', child: Text('COMPLETED')),
  //                             //   ],
  //                             //   onChanged: (value) {
  //                             //     if (value != null) {
  //                             //       status = value; // Cập nhật giá trị đã chọn
  //                             //     }
  //                             //   },
  //                             // ),
  //                           ],
  //                         )
  //                     ),
  //
  //                     const SizedBox(height: 16),
  //
  //                   ],
  //                   // tiếp ở đây
  //                 )
  //             ),)
  //       )
  //   );
  // }
}