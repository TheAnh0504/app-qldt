

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

  @override
  void initState() {
    super.initState();
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
                              text: data.class_type == "LT" ? "Lý thuyết"
                              : data.class_type == "BT" ? "Bài tập" : "Cả lý thuyết và bài tập",
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
                        // selectRegister = infoClassController.selectedRow!;

                      },
                      onCellDoubleTap: (_) async {
                        // selectRegister = infoClassController.selectedRow!;
                        // TODO: mở 1 handle chứa thông tin chi tiết của sinh viên vừa chọn
                        // await ref.read(infoClassDataProvider.notifier).getClassInfo(infoClassController.selectedRow!.getCells().first.value);
                        // if (ref.read(infoClassDataProvider).value != null) {
                        //   Navigator.of(context, rootNavigator: true).push(
                        //     MaterialPageRoute(
                        //       builder: (context) => const InfoClassLecturer(),
                        //     ),
                        //   );
                        // }
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

                  const SizedBox(height: 20),
                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.center,
                  //   children: [
                  //     const SizedBox(width: 32),
                  //     Expanded(
                  //       child: Center(
                  //         child: FilledButton(
                  //           onPressed: () async {
                  //             if (_listRegisterClass.isNotEmpty) {
                  //               print("Tạo lớp học");
                  //               // TODO: Tạo lớp học (chuyển page)
                  //               // List<String> classIds = [];
                  //               // for (var classInfo in _listRegisterClass) {
                  //               //   classIds.add(classInfo.class_id);
                  //               // }
                  //               // _listRegisterClass = (await ref.read(listClassRegisterNowProvider.notifier).registerClass(classIds, _listRegisterClass))!;
                  //               setState(() {
                  //                 _listRegisterClassDataSource = RegisterClassDataSource(
                  //                   listRegisterClass: _listRegisterClass,
                  //                 );
                  //               });
                  //               Fluttertoast.showToast(msg: "Đăng ký lớp thành công, vui lòng kiểm tra Trạng thái đăng ký lớp!");
                  //             } else {
                  //               Fluttertoast.showToast(msg: "Danh sách lớp trống. Vui lòng đăng ký lớp trước khi gửi đăng ký!");
                  //             }
                  //           },
                  //           child: const Center(child: Text("Tạo lớp học")),
                  //         ),
                  //       ),
                  //     ),
                  //     const SizedBox(width: 32),
                  //     Expanded(
                  //       child: Center(
                  //         child: FilledButton(
                  //           onPressed: () {
                  //             print("Chỉnh sửa");
                  //             // TODO: Chỉnh sửa lớp học có xóa lớp ở trong (chuyển page)
                  //             // String message = "";
                  //             // for (int i = 0; i < selectRegister.length; i++) {
                  //             //   if (i != 0) {
                  //             //     message = "$message, ";
                  //             //   }
                  //             //   message = message + selectRegister[i].getCells().first.value;
                  //             // }
                  //             // Fluttertoast.showToast(msg: "Chưa có api xóa lớp, danh sách lớp xóa: $message");
                  //           },
                  //           child: const Center(child: Text("Chỉnh sửa")),
                  //         ),
                  //       ),
                  //     ),
                  //     const SizedBox(width: 32),
                  //   ],
                  // ),
                  // const SizedBox(height: 10),
                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.center,
                  //   children: [
                  //     const SizedBox(width: 90),
                  //     Expanded(
                  //       child: Center(
                  //         child: FilledButton(
                  //           onPressed: () {
                  //             print("Add sinh viên vào lớp học");
                  //             // TODO: Add sinh viên vào lớp học
                  //             // String message = "";
                  //             // for (int i = 0; i < selectRegister.length; i++) {
                  //             //   if (i != 0) {
                  //             //     message = "$message, ";
                  //             //   }
                  //             //   message = message + selectRegister[i].getCells().first.value;
                  //             // }
                  //             // Fluttertoast.showToast(msg: "Chưa có api xóa lớp, danh sách lớp xóa: $message");
                  //           },
                  //           child: const Center(child: Text("Thêm sinh viên vào lớp")),
                  //         ),
                  //       ),
                  //     ),
                  //     const SizedBox(width: 90),
                  //   ],
                  // ),



                  // const SizedBox(height: 30),
                  // Center(
                  //   child: TextButton(
                  //     onPressed: () => handleShowContactInfo(context, ref.read(accountProvider).value!),
                  //     child: Text(
                  //         'Thông tin danh sách các lớp mở',
                  //         style: TypeStyle.title3.copyWith(fontStyle: FontStyle.italic, decoration: TextDecoration.underline,)
                  //     ),
                  //   ),
                  // ),



                ],
              ),
            )

        ),
      ),
    );
  }

//   Future<void> handleShowContactInfo(BuildContext context, AccountModel account) async {
//     // show list Open class
//     showModalBottomSheet(
//         context: context,
//         backgroundColor: Palette.white,
//         showDragHandle: true,
//         isScrollControlled: true, // Cho phép tùy chỉnh chiều cao
//         builder: (context) => FractionallySizedBox(
//             heightFactor: 8 / 10, // Chiều cao bằng 2/3 màn hình
//             child: SingleChildScrollView(
//               child: Container(
//                   width: MediaQuery.sizeOf(context).width,
//                   padding: const EdgeInsets.symmetric(horizontal: 8),
//                   decoration: const BoxDecoration(color: Palette.white),
//                   child: Column(
//                     mainAxisSize: MainAxisSize.min,
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Padding(
//                         padding: const EdgeInsets.only(left: 15),
//                         child: Row(
//                           children: [
//                             const Text('Tìm kiếm lớp học',
//                                 style: TypeStyle.title1),
//                             const Spacer(),
//                             Center(
//                               child: FilledButton(
//                                 onPressed: () async {
//                                   await ref.read(listClassProvider.notifier).getListClassInfoBy(classId.text, className.text, status, classType);
//                                 },
//                                 child: const Center(child: Text("Tìm kiếm")),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                       Padding(
//                           padding: const EdgeInsets.symmetric(
//                               horizontal: 10, vertical: 0),
//                           child: Row(
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             children: [
//                               // Expanded(
//                               //   child: TextFormField(
//                               //     controller: classId,
//                               //     decoration: const InputDecoration(
//                               //       hintText: "Mã lớp",
//                               //       border: OutlineInputBorder(),
//                               //     ),
//                               //     autovalidateMode: AutovalidateMode.onUserInteraction,
//                               //   ),
//                               // ),
//                               // const SizedBox(width: 10),
//                               Expanded(
//                                 child: TextFormField(
//                                   controller: className,
//                                   decoration: const InputDecoration(
//                                     hintText: "Tên lớp",
//                                     border: OutlineInputBorder(),
//                                   ),
//                                   autovalidateMode: AutovalidateMode.onUserInteraction,
//                                 ),
//                               ),
//                             ],
//                           )
//                       ),
//                       Padding(
//                           padding: const EdgeInsets.all(10),
//                           child: Column(
//                             // mainAxisAlignment: MainAxisAlignment.center,
//                             children: [
//                               DropdownButtonFormField<String>(
//                                 value: status,
//                                 decoration: InputDecoration(
//                                   hintText: "- Chọn trạng thái lớp -",
//                                   border: OutlineInputBorder(
//                                     borderRadius: BorderRadius.circular(8),
//                                   ),
//                                 ),
//                                 items: const [
//                                   DropdownMenuItem(value: '', child: Text('(All)')),
//                                   DropdownMenuItem(value: 'ACTIVE', child: Text('ACTIVE')),
//                                   DropdownMenuItem(value: 'UPCOMING', child: Text('UPCOMING')),
//                                   DropdownMenuItem(value: 'COMPLETED', child: Text('COMPLETED')),
//                                 ],
//                                 onChanged: (value) {
//                                   if (value != null) {
//                                     status = value; // Cập nhật giá trị đã chọn
//                                   }
//                                 },
//                               ),
//                               const SizedBox(height: 10),
//                               DropdownButtonFormField<String>(
//                                 value: classType,
//                                 decoration: InputDecoration(
//                                   hintText: "- Chọn loại lớp -",
//                                   border: OutlineInputBorder(
//                                     borderRadius: BorderRadius.circular(8),
//                                   ),
//                                 ),
//                                 items: const [
//                                   DropdownMenuItem(value: '', child: Text('(All)')),
//                                   DropdownMenuItem(value: 'LT', child: Text('Lý thuyết')),
//                                   DropdownMenuItem(value: 'BT', child: Text('Bài tập')),
//                                   DropdownMenuItem(value: 'LT_BT', child: Text('Cả lý thuyết và bài tập')),
//                                 ],
//                                 onChanged: (value) {
//                                   if (value != null) {
//                                     classType = value; // Cập nhật giá trị đã chọn
//                                   }
//                                 },
//                               ),
//                             ],
//                           )
//                       ),
//
//                       const SizedBox(height: 16),
//                       SfDataGrid(
//                           source: _listOpenClassDataSource,
//                           controller: _dataGridOpenClassController,
//                           // showCheckboxColumn: true,
//                           // checkboxColumnSettings: const DataGridCheckboxColumnSettings(
//                           //     label: Text(''), width: 50),
//                           selectionMode: SelectionMode.multiple,
//                           // onSelectionChanged: (List<DataGridRow> addedRows, List<DataGridRow> removedRows) {
//                           //   selectRegister = _dataGridRegisterClassController.selectedRows;
//                           // },
//                           columns: [
//                             GridColumn(
//                               columnName: 'class_id',
//                               width: 100,
//                               label: Container(
//                                   padding: const EdgeInsets.symmetric(horizontal: 16.0),
//                                   alignment: Alignment.centerLeft,
//                                   child: const Text(
//                                     'Mã lớp',
//                                     overflow: TextOverflow.ellipsis,
//                                   )),
//                             ),
//                             GridColumn(
//                                 columnName: 'class_name',
//                                 width: 200,
//                                 label: Container(
//                                     padding: const EdgeInsets.symmetric(horizontal: 16.0),
//                                     alignment: Alignment.centerLeft,
//                                     child: const Text(
//                                       'Tên lớp',
//                                       overflow: TextOverflow.ellipsis,
//                                     ))),
//                             GridColumn(
//                                 columnName: 'attached_code',
//                                 width: 110,
//                                 label: Container(
//                                     padding: const EdgeInsets.symmetric(horizontal: 16.0),
//                                     alignment: Alignment.centerLeft,
//                                     child: const Text(
//                                       'Mã lớp kèm',
//                                       overflow: TextOverflow.ellipsis,
//                                     ))),
//                             GridColumn(
//                                 columnName: 'class_type',
//                                 width: 90,
//                                 label: Container(
//                                     padding: const EdgeInsets.symmetric(horizontal: 16.0),
//                                     alignment: Alignment.center,
//                                     child: const Text(
//                                       'Loại lớp',
//                                       overflow: TextOverflow.ellipsis,
//                                     )
//                                 )
//                             ),
//                             GridColumn(
//                                 columnName: 'lecturer_name',
//                                 width: 200,
//                                 label: Container(
//                                     padding: const EdgeInsets.symmetric(horizontal: 16.0),
//                                     alignment: Alignment.centerLeft,
//                                     child: const Text(
//                                       'Tên giảng viên',
//                                       overflow: TextOverflow.ellipsis,
//                                     ))),
//                             GridColumn(
//                                 columnName: 'student_count',
//                                 width: 170,
//                                 label: Container(
//                                     padding: const EdgeInsets.symmetric(horizontal: 16.0),
//                                     alignment: Alignment.center,
//                                     child: const Text(
//                                       'Số sinh viên đăng ký',
//                                       overflow: TextOverflow.ellipsis,
//                                     )
//                                 )
//                             ),
//                             GridColumn(
//                                 columnName: 'start_date',
//                                 width: 120,
//                                 label: Container(
//                                     padding: const EdgeInsets.symmetric(horizontal: 16.0),
//                                     alignment: Alignment.center,
//                                     child: const Text(
//                                       'Ngày bắt đầu',
//                                       overflow: TextOverflow.ellipsis,
//                                     ))),
//                             GridColumn(
//                                 columnName: 'end_date',
//                                 width: 120,
//                                 label: Container(
//                                     padding: const EdgeInsets.symmetric(horizontal: 16.0),
//                                     alignment: Alignment.center,
//                                     child: const Text(
//                                       'Ngày kết thúc',
//                                       overflow: TextOverflow.ellipsis,
//                                     )
//                                 )
//                             ),
//                             GridColumn(
//                                 columnName: 'status',
//                                 width: 120,
//                                 label: Container(
//                                     padding: const EdgeInsets.symmetric(horizontal: 16.0),
//                                     alignment: Alignment.center,
//                                     child: const Text(
//                                       'Trạng thái lớp',
//                                       overflow: TextOverflow.ellipsis,
//                                     ))),
//                             GridColumn(
//                                 columnName: 'status_register',
//                                 width: 0,
//                                 label: Container(
//                                     padding: const EdgeInsets.symmetric(horizontal: 16.0),
//                                     alignment: Alignment.center,
//                                     child: const Text(
//                                       'Trạng thái đăng ký',
//                                       overflow: TextOverflow.ellipsis,
//                                     ))),
//                           ]
//                       ),
//                     ],
//                     // tiếp ở đây
//                   )
//               ),)
//         )
//     );
//   }
}