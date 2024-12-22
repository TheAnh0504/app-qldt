

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
import '../../../model/entities/account_model.dart';
import '../../../model/entities/class_info_model.dart';

class ClassManagerLecturer extends ConsumerStatefulWidget {
  const ClassManagerLecturer({super.key});

  @override
  ConsumerState<ClassManagerLecturer> createState() => _ClassManagerLecturer();
}

class _ClassManagerLecturer extends ConsumerState<ClassManagerLecturer> {
  final classCode = TextEditingController();

  final formKey = GlobalKey<FormState>();
  // checked rows - selected class in register-form (Xóa lớp)
  DataGridRow selectRegister = const DataGridRow(cells: []);

  final classId = TextEditingController();
  final className = TextEditingController();
  String? status;
  String? classType;

  RegisterClassDataSource _listRegisterClassDataSource = RegisterClassDataSource(listRegisterClass: []);
  // all class in register-form (Gửi đăng ký)
  List<ClassInfoModel> _listRegisterClass = <ClassInfoModel>[];
  DataGridController _dataGridRegisterClassController = DataGridController();

  RegisterClassDataSource _listOpenClassDataSource = RegisterClassDataSource(listRegisterClass: []);
  List<ClassInfoModel> _listOpenClass = <ClassInfoModel>[];
  List<ClassInfoModel> _listAllOpenClass = <ClassInfoModel>[];
  DataGridController _dataGridOpenClassController = DataGridController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _listAllOpenClass = ref.read(listClassAllProvider).value!;

    _listOpenClass = ref.read(listClassProvider).value!;
    _listOpenClassDataSource = RegisterClassDataSource(
      listRegisterClass: _listOpenClass,
    );

    _listRegisterClass = ref.read(listClassRegisterNowProvider).value!;
    // for (var classInfo in listClass) {
    //   _listRegisterClass.add(classInfo.copyWith(status_register: "SUCCESS"));
    // }
    _listRegisterClassDataSource = RegisterClassDataSource(
      listRegisterClass: _listRegisterClass,
    );

    ref.listen(listClassProvider, (prev, next) {
      if (next is AsyncError) {
        Fluttertoast.showToast(msg: next.error.toString());
      }
      if (next is AsyncData) {
        _listOpenClassDataSource = RegisterClassDataSource(
          listRegisterClass: next.value ?? [],
        );
        context.go(feedRoute);
      }
    });

    // ref.listen(listClassFilterProvider, (prev, next) {
    //   if (next is AsyncError) {
    //     Fluttertoast.showToast(msg: next.error.toString());
    //   }
    //   if (next is AsyncData) {
    //     _listRegisterClassDataSource = RegisterClassDataSource(
    //       listRegisterClass: next.value ?? [],
    //     );
    //     context.go(feedRoute);
    //   }
    // });

    return Scaffold(
      appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.primary,
          title: const Align(
            alignment: Alignment(-0.25, 0), // Căn phải một chút
            child: Text("Đăng ký lớp học", style: TypeStyle.title1White),
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
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: classCode,
                          decoration: const InputDecoration(
                            hintText: "Mã lớp",
                            border: OutlineInputBorder(),
                          ),
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              Fluttertoast.showToast(msg: 'Vui lòng nhập mã lớp');
                            }
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(width: 32),
                      Center(
                        child: FilledButton(
                          onPressed: () {
                            if (formKey.currentState?.validate() ?? false) {
                              print(_listAllOpenClass.length);

                              if (_listRegisterClass.any((value) => value.class_id == classCode.text)) {
                                // TODO: chuyển sang page chỉnh sửa lớp học có xóa lớp học ở trong
                                // _listRegisterClass.add(
                                //     _listAllOpenClass.firstWhere((value) => value.class_id == classCode.text)
                                // );
                                // Fluttertoast.showToast(msg: 'Bạn đã thêm lớp với mã lớp: ${classCode.text} vào danh sách đăng ký lớp!');
                              } else {
                                Fluttertoast.showToast(msg: 'Bạn không phải giảng viên của lớp với mã lớp ${classCode.text}');
                              }

                              // setState(() {
                              //   _listRegisterClassDataSource = RegisterClassDataSource(
                              //     listRegisterClass: _listRegisterClass,
                              //   );
                              // });
                              // print("đăng ký lơớp");
                              // ref.read(signupProvider.notifier).signup(
                              //     ho.text, ten.text, email.text, password.text, selectedRole);
                            }
                          },
                          child: const Center(child: Text("Tìm kiếm")),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),
                  if (_listRegisterClassDataSource.dataGridRows.isNotEmpty) const SizedBox(height: 32),
                  if (_listRegisterClassDataSource.dataGridRows.isEmpty)
                    Text('Giảng viên chưa giảng dạy lớp nào!', style: TypeStyle.body3.copyWith(color: Palette.redBackground)),
                  if (_listRegisterClassDataSource.dataGridRows.isEmpty) const SizedBox(height: 12),
                  SfDataGrid(
                      source: _listRegisterClassDataSource,
                      controller: _dataGridRegisterClassController,
                      showCheckboxColumn: true,
                      checkboxColumnSettings: const DataGridCheckboxColumnSettings(
                          label: Text(''), width: 50),
                      selectionMode: SelectionMode.single,
                      onSelectionChanged: (List<DataGridRow> addedRows, List<DataGridRow> removedRows) {
                        selectRegister = _dataGridRegisterClassController.selectedRow!;
                        // TODO: mở 1 handle chứa thông tin chi tiết của class vừa chọn (mô phỏng edit-class + d/s sinh viên)
                      },
                      columns: [
                        GridColumn(
                          columnName: 'class_id',
                          width: 100,
                          label: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 16.0),
                              alignment: Alignment.centerLeft,
                              child: const Text(
                                'Mã lớp',
                                overflow: TextOverflow.ellipsis,
                              )),
                        ),
                        GridColumn(
                            columnName: 'class_name',
                            width: 200,
                            label: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                                alignment: Alignment.centerLeft,
                                child: const Text(
                                  'Tên lớp',
                                  overflow: TextOverflow.ellipsis,
                                ))),
                        GridColumn(
                            columnName: 'attached_code',
                            width: 110,
                            label: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                                alignment: Alignment.centerLeft,
                                child: const Text(
                                  'Mã lớp kèm',
                                  overflow: TextOverflow.ellipsis,
                                ))),
                        GridColumn(
                            columnName: 'class_type',
                            width: 90,
                            label: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                                alignment: Alignment.center,
                                child: const Text(
                                  'Loại lớp',
                                  overflow: TextOverflow.ellipsis,
                                )
                            )
                        ),
                        GridColumn(
                            columnName: 'lecturer_name',
                            width: 200,
                            label: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                                alignment: Alignment.centerLeft,
                                child: const Text(
                                  'Tên giảng viên',
                                  overflow: TextOverflow.ellipsis,
                                ))),
                        GridColumn(
                            columnName: 'student_count',
                            width: 170,
                            label: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                                alignment: Alignment.center,
                                child: const Text(
                                  'Số sinh viên đăng ký',
                                  overflow: TextOverflow.ellipsis,
                                )
                            )
                        ),
                        GridColumn(
                            columnName: 'start_date',
                            width: 120,
                            label: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                                alignment: Alignment.center,
                                child: const Text(
                                  'Ngày bắt đầu',
                                  overflow: TextOverflow.ellipsis,
                                ))),
                        GridColumn(
                            columnName: 'end_date',
                            width: 120,
                            label: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                                alignment: Alignment.center,
                                child: const Text(
                                  'Ngày kết thúc',
                                  overflow: TextOverflow.ellipsis,
                                )
                            )
                        ),
                        GridColumn(
                            columnName: 'status',
                            width: 120,
                            label: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                                alignment: Alignment.center,
                                child: const Text(
                                  'Trạng thái lớp',
                                  overflow: TextOverflow.ellipsis,
                                ))),
                        GridColumn(
                            columnName: 'status_register',
                            width: 0,
                            label: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                                alignment: Alignment.center,
                                child: const Text(
                                  'Trạng thái đăng ký',
                                  overflow: TextOverflow.ellipsis,
                                ))),
                      ]
                  ),

                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(width: 32),
                      Expanded(
                        child: Center(
                          child: FilledButton(
                            onPressed: () async {
                              if (_listRegisterClass.isNotEmpty) {
                                print("Tạo lớp học");
                                // TODO: Tạo lớp học (chuyển page)
                                // List<String> classIds = [];
                                // for (var classInfo in _listRegisterClass) {
                                //   classIds.add(classInfo.class_id);
                                // }
                                // _listRegisterClass = (await ref.read(listClassRegisterNowProvider.notifier).registerClass(classIds, _listRegisterClass))!;
                                setState(() {
                                  _listRegisterClassDataSource = RegisterClassDataSource(
                                    listRegisterClass: _listRegisterClass,
                                  );
                                });
                                Fluttertoast.showToast(msg: "Đăng ký lớp thành công, vui lòng kiểm tra Trạng thái đăng ký lớp!");
                              } else {
                                Fluttertoast.showToast(msg: "Danh sách lớp trống. Vui lòng đăng ký lớp trước khi gửi đăng ký!");
                              }
                            },
                            child: const Center(child: Text("Tạo lớp học")),
                          ),
                        ),
                      ),
                      const SizedBox(width: 32),
                      Expanded(
                        child: Center(
                          child: FilledButton(
                            onPressed: () {
                              print("Chỉnh sửa");
                              // TODO: Chỉnh sửa lớp học có xóa lớp ở trong (chuyển page)
                              // String message = "";
                              // for (int i = 0; i < selectRegister.length; i++) {
                              //   if (i != 0) {
                              //     message = "$message, ";
                              //   }
                              //   message = message + selectRegister[i].getCells().first.value;
                              // }
                              // Fluttertoast.showToast(msg: "Chưa có api xóa lớp, danh sách lớp xóa: $message");
                            },
                            child: const Center(child: Text("Chỉnh sửa")),
                          ),
                        ),
                      ),
                      const SizedBox(width: 32),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(width: 90),
                      Expanded(
                        child: Center(
                          child: FilledButton(
                            onPressed: () {
                              print("Add sinh viên vào lớp học");
                              // TODO: Add sinh viên vào lớp học
                              // String message = "";
                              // for (int i = 0; i < selectRegister.length; i++) {
                              //   if (i != 0) {
                              //     message = "$message, ";
                              //   }
                              //   message = message + selectRegister[i].getCells().first.value;
                              // }
                              // Fluttertoast.showToast(msg: "Chưa có api xóa lớp, danh sách lớp xóa: $message");
                            },
                            child: const Center(child: Text("Thêm sinh viên vào lớp")),
                          ),
                        ),
                      ),
                      const SizedBox(width: 90),
                    ],
                  ),
                  const SizedBox(height: 30),
                  Center(
                    child: TextButton(
                      onPressed: () => handleShowContactInfo(context, ref.read(accountProvider).value!),
                      child: Text(
                          'Thông tin danh sách các lớp mở',
                          style: TypeStyle.title3.copyWith(fontStyle: FontStyle.italic, decoration: TextDecoration.underline,)
                      ),
                    ),
                  ),
                ],
              ),
            )

        ),
      ),
    );
  }

  Future<void> handleShowContactInfo(BuildContext context, AccountModel account) async {
    // show list Open class
    showModalBottomSheet(
        context: context,
        backgroundColor: Palette.white,
        showDragHandle: true,
        isScrollControlled: true, // Cho phép tùy chỉnh chiều cao
        builder: (context) => FractionallySizedBox(
            heightFactor: 8 / 10, // Chiều cao bằng 2/3 màn hình
            child: SingleChildScrollView(
              child: Container(
                  width: MediaQuery.sizeOf(context).width,
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  decoration: const BoxDecoration(color: Palette.white),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 15),
                        child: Row(
                          children: [
                            const Text('Tìm kiếm lớp học',
                                style: TypeStyle.title1),
                            const Spacer(),
                            Center(
                              child: FilledButton(
                                onPressed: () async {
                                  await ref.read(listClassProvider.notifier).getListClassInfoBy(classId.text, className.text, status, classType);
                                },
                                child: const Center(child: Text("Tìm kiếm")),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              // Expanded(
                              //   child: TextFormField(
                              //     controller: classId,
                              //     decoration: const InputDecoration(
                              //       hintText: "Mã lớp",
                              //       border: OutlineInputBorder(),
                              //     ),
                              //     autovalidateMode: AutovalidateMode.onUserInteraction,
                              //   ),
                              // ),
                              // const SizedBox(width: 10),
                              Expanded(
                                child: TextFormField(
                                  controller: className,
                                  decoration: const InputDecoration(
                                    hintText: "Tên lớp",
                                    border: OutlineInputBorder(),
                                  ),
                                  autovalidateMode: AutovalidateMode.onUserInteraction,
                                ),
                              ),
                            ],
                          )
                      ),
                      Padding(
                          padding: const EdgeInsets.all(10),
                          child: Column(
                            // mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              DropdownButtonFormField<String>(
                                value: status,
                                decoration: InputDecoration(
                                  hintText: "- Chọn trạng thái lớp -",
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                items: const [
                                  DropdownMenuItem(value: '', child: Text('(All)')),
                                  DropdownMenuItem(value: 'ACTIVE', child: Text('ACTIVE')),
                                  DropdownMenuItem(value: 'UPCOMING', child: Text('UPCOMING')),
                                  DropdownMenuItem(value: 'COMPLETED', child: Text('COMPLETED')),
                                ],
                                onChanged: (value) {
                                  if (value != null) {
                                    status = value; // Cập nhật giá trị đã chọn
                                  }
                                },
                              ),
                              const SizedBox(height: 10),
                              DropdownButtonFormField<String>(
                                value: classType,
                                decoration: InputDecoration(
                                  hintText: "- Chọn loại lớp -",
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                items: const [
                                  DropdownMenuItem(value: '', child: Text('(All)')),
                                  DropdownMenuItem(value: 'LT', child: Text('Lý thuyết')),
                                  DropdownMenuItem(value: 'BT', child: Text('Bài tập')),
                                  DropdownMenuItem(value: 'LT_BT', child: Text('Cả lý thuyết và bài tập')),
                                ],
                                onChanged: (value) {
                                  if (value != null) {
                                    classType = value; // Cập nhật giá trị đã chọn
                                  }
                                },
                              ),
                            ],
                          )
                      ),

                      const SizedBox(height: 16),
                      SfDataGrid(
                          source: _listOpenClassDataSource,
                          controller: _dataGridOpenClassController,
                          // showCheckboxColumn: true,
                          // checkboxColumnSettings: const DataGridCheckboxColumnSettings(
                          //     label: Text(''), width: 50),
                          selectionMode: SelectionMode.multiple,
                          // onSelectionChanged: (List<DataGridRow> addedRows, List<DataGridRow> removedRows) {
                          //   selectRegister = _dataGridRegisterClassController.selectedRows;
                          // },
                          columns: [
                            GridColumn(
                              columnName: 'class_id',
                              width: 100,
                              label: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                                  alignment: Alignment.centerLeft,
                                  child: const Text(
                                    'Mã lớp',
                                    overflow: TextOverflow.ellipsis,
                                  )),
                            ),
                            GridColumn(
                                columnName: 'class_name',
                                width: 200,
                                label: Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                                    alignment: Alignment.centerLeft,
                                    child: const Text(
                                      'Tên lớp',
                                      overflow: TextOverflow.ellipsis,
                                    ))),
                            GridColumn(
                                columnName: 'attached_code',
                                width: 110,
                                label: Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                                    alignment: Alignment.centerLeft,
                                    child: const Text(
                                      'Mã lớp kèm',
                                      overflow: TextOverflow.ellipsis,
                                    ))),
                            GridColumn(
                                columnName: 'class_type',
                                width: 90,
                                label: Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                                    alignment: Alignment.center,
                                    child: const Text(
                                      'Loại lớp',
                                      overflow: TextOverflow.ellipsis,
                                    )
                                )
                            ),
                            GridColumn(
                                columnName: 'lecturer_name',
                                width: 200,
                                label: Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                                    alignment: Alignment.centerLeft,
                                    child: const Text(
                                      'Tên giảng viên',
                                      overflow: TextOverflow.ellipsis,
                                    ))),
                            GridColumn(
                                columnName: 'student_count',
                                width: 170,
                                label: Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                                    alignment: Alignment.center,
                                    child: const Text(
                                      'Số sinh viên đăng ký',
                                      overflow: TextOverflow.ellipsis,
                                    )
                                )
                            ),
                            GridColumn(
                                columnName: 'start_date',
                                width: 120,
                                label: Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                                    alignment: Alignment.center,
                                    child: const Text(
                                      'Ngày bắt đầu',
                                      overflow: TextOverflow.ellipsis,
                                    ))),
                            GridColumn(
                                columnName: 'end_date',
                                width: 120,
                                label: Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                                    alignment: Alignment.center,
                                    child: const Text(
                                      'Ngày kết thúc',
                                      overflow: TextOverflow.ellipsis,
                                    )
                                )
                            ),
                            GridColumn(
                                columnName: 'status',
                                width: 120,
                                label: Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                                    alignment: Alignment.center,
                                    child: const Text(
                                      'Trạng thái lớp',
                                      overflow: TextOverflow.ellipsis,
                                    ))),
                            GridColumn(
                                columnName: 'status_register',
                                width: 0,
                                label: Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                                    alignment: Alignment.center,
                                    child: const Text(
                                      'Trạng thái đăng ký',
                                      overflow: TextOverflow.ellipsis,
                                    ))),
                          ]
                      ),
                    ],
                    // tiếp ở đây
                  )
              ),)
        )
    );
  }
}