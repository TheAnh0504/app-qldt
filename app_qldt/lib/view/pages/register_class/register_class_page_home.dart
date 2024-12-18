

import 'package:app_qldt/controller/account_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/common/types.dart';
import '../../../core/router/router.dart';
import '../../../core/router/url.dart';
import '../../../core/theme/palette.dart';
import '../../../core/theme/typestyle.dart';
import '../../../model/entities/account_model.dart';

class RegisterClassPageHome extends ConsumerStatefulWidget {
  const RegisterClassPageHome({super.key});

  @override
  ConsumerState<RegisterClassPageHome> createState() => _RegisterClassPageHomeState();
}

class _RegisterClassPageHomeState extends ConsumerState<RegisterClassPageHome> {
  final classCode = TextEditingController();
  final ten = TextEditingController();
  final formKey = GlobalKey<FormState>();

  late EmployeeDataSource _employeeDataSource;
  List<Employee> _employees = <Employee>[];

  @override
  void initState() {
    super.initState();
    _employees = getEmployeeData();
    _employeeDataSource = EmployeeDataSource(employees: _employees);
  }

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> classData = List.generate(10, (index) {
      return {
        'isChecked': index % 2 == 0 ? true : false,
        'maLop': 'L${1000 + index}',
        'maLopKem': 'K${1000 + index}',
        'tenLop': 'Lớp ${index + 1}',
        'trangThai': index % 2 == 0 ? 'Đã đăng ký' : 'Chưa đăng ký',
      };
    });

    // return Scaffold(
    //   appBar: AppBar(
    //       backgroundColor: Theme.of(context).colorScheme.primary,
    //       title: const Align(
    //         alignment: Alignment(-0.25, 0), // Căn phải một chút
    //         child: Text("Đăng ký lớp học", style: TypeStyle.title1White),
    //       ),
    //       leading: IconButton(
    //           onPressed: () => context.pop(),
    //           icon: const FaIcon(FaIcons.arrowLeft, color: Palette.white,))),
    //   body: SingleChildScrollView(
    //     child: Form(
    //         key: formKey,
    //         child:
    //         Padding(
    //           padding: const EdgeInsets.all(16),
    //           child: Column(
    //             mainAxisAlignment: MainAxisAlignment.center,
    //             crossAxisAlignment: CrossAxisAlignment.start,
    //             children: [
    //               Row(
    //                 mainAxisAlignment: MainAxisAlignment.center,
    //                 children: [
    //                   Expanded(
    //                     child: TextFormField(
    //                       controller: classCode,
    //                       decoration: const InputDecoration(
    //                         hintText: "Mã lớp",
    //                         border: OutlineInputBorder(),
    //                       ),
    //                       autovalidateMode: AutovalidateMode.onUserInteraction,
    //                       validator: (value) {
    //                         if (value == null || value.isEmpty) {
    //                           Fluttertoast.showToast(msg: 'Vui lòng nhập mã lớp');
    //                         }
    //                         return null;
    //                       },
    //                     ),
    //                   ),
    //                   const SizedBox(width: 32),
    //                   Center(
    //                     child: FilledButton(
    //                       onPressed: () {
    //                         if (formKey.currentState?.validate() ?? false) {
    //                           print("đăng ký lơớp");
    //                           // ref.read(signupProvider.notifier).signup(
    //                           //     ho.text, ten.text, email.text, password.text, selectedRole);
    //                         }
    //                       },
    //                       child: const Center(child: Text("Đăng ký")),
    //                     ),
    //                   ),
    //                 ],
    //               ),
    //               const SizedBox(height: 32),
    //               Center(
    //                 child: Container(
    //                   height: 450,
    //                   margin: const EdgeInsets.all(0),
    //                   padding: const EdgeInsets.all(0),
    //                   decoration: BoxDecoration(
    //                     color: Colors.white,
    //                     // borderRadius: BorderRadius.circular(12),
    //                     border: Border.all(color: const Color(0xFF000000), width: 2),
    //                     boxShadow: [
    //                       BoxShadow(
    //                         color: Colors.grey.withOpacity(0.3),
    //                         spreadRadius: 2,
    //                         blurRadius: 5,
    //                         offset: const Offset(0, 3),
    //                       ),
    //                     ],
    //                   ),
    //                   child: SingleChildScrollView(
    //                     scrollDirection: Axis.horizontal,
    //                     child: SingleChildScrollView(
    //                       scrollDirection: Axis.vertical,
    //                       child: DataTable(
    //                         headingRowColor: WidgetStateProperty.all(Colors.blue[50]),
    //                         columns: const [
    //                           DataColumn(label: Text('Chọn', style: TextStyle(fontWeight: FontWeight.bold))),
    //                           DataColumn(label: Text('Mã lớp', style: TextStyle(fontWeight: FontWeight.bold))),
    //                           DataColumn(label: Text('Mã lớp kèm', style: TextStyle(fontWeight: FontWeight.bold))),
    //                           DataColumn(label: Text('Tên lớp', style: TextStyle(fontWeight: FontWeight.bold))),
    //                           DataColumn(label: Text('Trạng thái đăng ký lớp', style: TextStyle(fontWeight: FontWeight.bold))),
    //                         ],
    //                         rows: classData.isEmpty
    //                             ? [
    //                                 const DataRow(
    //                                   cells: [
    //                                     DataCell(
    //                                       Center(
    //                                         child: Text(
    //                                           'Sinh viên chưa đăng ký lớp nào',
    //                                           style: TextStyle(fontStyle: FontStyle.italic, color: Colors.grey),
    //                                         ),
    //                                       ),
    //                                     ),
    //                                   ],
    //                                 ),
    //                             ]
    //                             : classData.map((data) => DataRow(
    //                           color: WidgetStateProperty.resolveWith<Color?>(
    //                                 (Set<WidgetState> states) {
    //                               // Alternate row colors
    //                               if (classData.indexOf(data) % 2 == 0) {
    //                                 return Colors.grey[100]; // Light grey for even rows
    //                               }
    //                               return Colors.white; // White for odd rows
    //                             },
    //                           ),
    //                           cells: [
    //                             DataCell(
    //                                 Checkbox(
    //                                   value: classData[classData.indexOf(data)]['isChecked'], // Sử dụng false nếu isChecked là null
    //                                   onChanged: (value) {
    //                                     print("Trước cập nhật: ${classData[classData.indexOf(data)]['isChecked']}");
    //                                     classData = List.from(classData);
    //                                     classData[classData.indexOf(data)]['isChecked'] = !classData[classData.indexOf(data)]['isChecked'];
    //                                     print("Sau cập nhật: ${classData[classData.indexOf(data)]['isChecked']}");
    //                                   },
    //                                 )
    //                             ),
    //                             DataCell(Center(child: Text(data['maLop'] ?? ''))),
    //                             DataCell(Center(child: Text(data['maLopKem'] ?? ''))),
    //                             DataCell(Center(child: Text(data['tenLop'] ?? ''))),
    //                             DataCell(Center(child: Text(data['trangThai'] ?? ''))),
    //                           ],
    //                         )).toList(),
    //                       ),
    //                     ),
    //                   ),
    //                 ),
    //               ),
    //               const SizedBox(height: 20),
    //               Row(
    //                 mainAxisAlignment: MainAxisAlignment.center,
    //                 children: [
    //                   const SizedBox(width: 32),
    //                   Expanded(
    //                     child: Center(
    //                       child: FilledButton(
    //                         onPressed: () {
    //                           if (formKey.currentState?.validate() ?? false) {
    //                             print("đăng ký lơớp");
    //                             // ref.read(signupProvider.notifier).signup(
    //                             //     ho.text, ten.text, email.text, password.text, selectedRole);
    //                           }
    //                         },
    //                         child: const Center(child: Text("Gửi đăng ký")),
    //                       ),
    //                     ),
    //                   ),
    //                   const SizedBox(width: 32),
    //                   Expanded(
    //                     child: Center(
    //                       child: FilledButton(
    //                         onPressed: () {
    //                           if (formKey.currentState?.validate() ?? false) {
    //                             print("đăng ký lơớp");
    //                             // ref.read(signupProvider.notifier).signup(
    //                             //     ho.text, ten.text, email.text, password.text, selectedRole);
    //                           }
    //                         },
    //                         child: const Center(child: Text("Xóa lớp")),
    //                       ),
    //                     ),
    //                   ),
    //                   const SizedBox(width: 32),
    //                 ],
    //               ),
    //               const SizedBox(height: 20),
    //               Center(
    //                 child: TextButton(
    //                   onPressed: () => handleShowContactInfo(context, ref.read(accountProvider).value!, classData),
    //                   child: Text(
    //                       'Thông tin danh sách các lớp mở',
    //                       style: TypeStyle.title3.copyWith(fontStyle: FontStyle.italic, decoration: TextDecoration.underline,)
    //                   ),
    //                 ),
    //               ),
    //             ],
    //           ),
    //         )
    //
    //     ),
    //   ),
    // );
    // TODO: sửa lại bảng rồi ghép api cho đăng ký lớp, get list lớp mở, search lớp mở để đăng ký (Slide 3)
    return Scaffold(
        body: SfDataGrid(
            source: _employeeDataSource,
            showCheckboxColumn: true,
            checkboxColumnSettings: DataGridCheckboxColumnSettings(
                label: Text('Selector'), width: 100),
            selectionMode: SelectionMode.multiple,
            columns: [
              GridColumn(
                  columnName: 'id',
                  label: Container(
                      padding: EdgeInsets.symmetric(horizontal: 16.0),
                      alignment: Alignment.centerRight,
                      child: Text(
                        'ID',
                        overflow: TextOverflow.ellipsis,
                      ))),
              GridColumn(
                  columnName: 'name',
                  label: Container(
                      padding: EdgeInsets.symmetric(horizontal: 16.0),
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Name',
                        overflow: TextOverflow.ellipsis,
                      ))),
              GridColumn(
                  columnName: 'designation',
                  label: Container(
                      padding: EdgeInsets.symmetric(horizontal: 16.0),
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Designation',
                        overflow: TextOverflow.ellipsis,
                      ))),
              GridColumn(
                  columnName: 'salary',
                  label: Container(
                      padding: EdgeInsets.symmetric(horizontal: 16.0),
                      alignment: Alignment.centerRight,
                      child: Text(
                        'Salary',
                        overflow: TextOverflow.ellipsis,
                      ))),
            ]));
  }

  Future<void> handleShowContactInfo(BuildContext context, AccountModel account, List<Map<String, dynamic>> classData) async {
    showModalBottomSheet(
        context: context,
        backgroundColor: Palette.white,
        showDragHandle: true,
        builder: (context) => SingleChildScrollView(
          child: Container(
              width: MediaQuery.sizeOf(context).width,
              padding: const EdgeInsets.symmetric(horizontal: 8),
              decoration: const BoxDecoration(color: Palette.white),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      // height: 450,
                      margin: const EdgeInsets.all(0),
                      padding: const EdgeInsets.all(0),
                      // decoration: BoxDecoration(
                      //   color: Colors.white,
                      //   // borderRadius: BorderRadius.circular(12),
                      //   border: Border.all(color: const Color(0xFF000000), width: 2),
                      //   boxShadow: [
                      //     BoxShadow(
                      //       color: Colors.grey.withOpacity(0.3),
                      //       spreadRadius: 2,
                      //       blurRadius: 5,
                      //       offset: const Offset(0, 3),
                      //     ),
                      //   ],
                      // ),
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: SingleChildScrollView(
                          scrollDirection: Axis.vertical,
                          child: DataTable(
                            headingRowColor: WidgetStateProperty.all(Colors.blue[50]),
                            columns: const [
                              // DataColumn(label: Text('Chọn', style: TextStyle(fontWeight: FontWeight.bold))),
                              DataColumn(label: Text('Mã lớp', style: TextStyle(fontWeight: FontWeight.bold))),
                              DataColumn(label: Text('Mã lớp kèm', style: TextStyle(fontWeight: FontWeight.bold))),
                              DataColumn(label: Text('Tên lớp', style: TextStyle(fontWeight: FontWeight.bold))),
                              DataColumn(label: Text('Trạng thái đăng ký lớp', style: TextStyle(fontWeight: FontWeight.bold))),
                            ],
                            rows: classData.isEmpty
                                ? [
                              const DataRow(
                                cells: [
                                  DataCell(
                                    Center(
                                      child: Text(
                                        'Không có lớp nào đang mở',
                                        style: TextStyle(fontStyle: FontStyle.italic, color: Colors.grey),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ]
                                : classData.map((data) => DataRow(
                              color: WidgetStateProperty.resolveWith<Color?>(
                                    (Set<WidgetState> states) {
                                  // Alternate row colors
                                  if (classData.indexOf(data) % 2 == 0) {
                                    return Colors.grey[100]; // Light grey for even rows
                                  }
                                  return Colors.white; // White for odd rows
                                },
                              ),
                              cells: [
                                DataCell(Center(child: Text(data['maLop'] ?? ''))),
                                DataCell(Center(child: Text(data['maLopKem'] ?? ''))),
                                DataCell(Center(child: Text(data['tenLop'] ?? ''))),
                                DataCell(Center(child: Text(data['trangThai'] ?? ''))),
                              ],
                            )).toList(),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 15),
                    child: Row(
                      children: [
                        Text('Thông tin ${account.role == 'STUDENT' ? 'sinh viên' : 'giảng viên'}',
                            style: TypeStyle.title1),
                        const Spacer(),
                        TextButton(
                            onPressed: () {
                              rootNavigatorKey.currentContext
                                  ?.go("$profileRoute/edit");
                            },
                            child: const Text("Chỉnh sửa"))
                      ],
                    ),
                  ),
                  ListTile(
                      title: Text(account.role == 'STUDENT' ? 'Sinh viên' : 'Giảng viên', style: TypeStyle.body4),
                      subtitle: Text(account.name,
                          style: TypeStyle.body3.copyWith(
                              color:
                              Theme.of(context).colorScheme.primary))),
                  InkWell(
                    splashFactory: InkRipple.splashFactory,
                    onTap: () =>
                        launchUrl(Uri.parse("mailto:${account.email}")),
                    child: ListTile(
                        title:
                        const Text("Email", style: TypeStyle.body4),
                        subtitle: Text(account.email,
                            style: TypeStyle.body3.copyWith(
                                color: Theme.of(context)
                                    .colorScheme
                                    .primary))),
                  ),
                  ListTile(
                      title: const Text("Id", style: TypeStyle.body4),
                      subtitle: Text(account.idAccount,
                          style: TypeStyle.body3.copyWith(
                              color:
                              Theme.of(context).colorScheme.primary))),
                  ListTile(
                      title: const Text("Họ", style: TypeStyle.body4),
                      subtitle: Text(account.ho,
                          style: TypeStyle.body3.copyWith(
                              color:
                              Theme.of(context).colorScheme.primary))),
                  ListTile(
                      title: const Text("Tên", style: TypeStyle.body4),
                      subtitle: Text(account.ten,
                          style: TypeStyle.body3.copyWith(
                              color:
                              Theme.of(context).colorScheme.primary))),
                  // InkWell(
                  //   splashFactory: InkRipple.splashFactory,
                  //   onTap: () =>
                  //       launchUrl(Uri.parse("tel:${account.idAccount}")),
                  //   child: ListTile(
                  //       title: const Text("Số điện thoại",
                  //           style: TypeStyle.body4),
                  //       subtitle: Text(account.idAccount,
                  //           style: TypeStyle.body3.copyWith(
                  //               color: Theme.of(context)
                  //                   .colorScheme
                  //                   .primary))),
                  // ),
                ],
              )
          ),
        )
    );
  }
}

class EmployeeDataSource extends DataGridSource {
  EmployeeDataSource({required List<Employee> employees}) {
    dataGridRows = employees
        .map<DataGridRow>((dataGridRow) => DataGridRow(cells: [
      DataGridCell<int>(columnName: 'id', value: dataGridRow.id),
      DataGridCell<String>(columnName: 'name', value: dataGridRow.name),
      DataGridCell<String>(
          columnName: 'designation', value: dataGridRow.designation),
      DataGridCell<int>(
          columnName: 'salary', value: dataGridRow.salary),
    ]))
        .toList();
  }

  List<DataGridRow> dataGridRows = [];

  @override
  List<DataGridRow> get rows => dataGridRows;

  @override
  DataGridRowAdapter? buildRow(DataGridRow row) {
    return DataGridRowAdapter(
        cells: row.getCells().map<Widget>((dataGridCell) {
          return Container(
              alignment: (dataGridCell.columnName == 'id' ||
                  dataGridCell.columnName == 'salary')
                  ? Alignment.centerRight
                  : Alignment.centerLeft,
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                dataGridCell.value.toString(),
                overflow: TextOverflow.ellipsis,
              ));
        }).toList());
  }
}

class Employee {
  Employee(this.id, this.name, this.designation, this.salary);
  int id;
  String name;
  String designation;
  int salary;
}

List<Employee> getEmployeeData() {
  return [
    Employee(10001, 'James', 'Project Lead', 20000),
    Employee(10002, 'Kathryn', 'Manager', 30000),
    Employee(10003, 'Lara', 'Developer', 15000),
    Employee(10004, 'Michael', 'Designer', 10000),
    Employee(10005, 'Martin', 'Developer', 20000),
    Employee(10006, 'Newberry', 'Manager', 25000),
    Employee(10007, 'Balnc', 'Developer', 35000),
    Employee(10008, 'Perry', 'Designer', 45000),
    Employee(10009, 'Gable', 'Developer', 10000),
    Employee(10010, 'Grimes', 'Developer', 30000),
    Employee(10001, 'James', 'Project Lead', 20000),
    Employee(10002, 'Kathryn', 'Manager', 30000),
    Employee(10003, 'Lara', 'Developer', 15000),
    Employee(10004, 'Michael', 'Designer', 10000),
    Employee(10005, 'Martin', 'Developer', 20000),
    Employee(10006, 'Newberry', 'Manager', 25000),
    Employee(10007, 'Balnc', 'Developer', 35000),
    Employee(10008, 'Perry', 'Designer', 45000),
    Employee(10009, 'Gable', 'Developer', 10000),
    Employee(10010, 'Grimes', 'Developer', 30000),
    Employee(10001, 'James', 'Project Lead', 20000),
    Employee(10002, 'Kathryn', 'Manager', 30000),
    Employee(10003, 'Lara', 'Developer', 15000),
    Employee(10004, 'Michael', 'Designer', 10000),
    Employee(10005, 'Martin', 'Developer', 20000),
    Employee(10006, 'Newberry', 'Manager', 25000),
    Employee(10007, 'Balnc', 'Developer', 35000),
    Employee(10008, 'Perry', 'Designer', 45000),
    Employee(10009, 'Gable', 'Developer', 10000),
    Employee(10010, 'Grimes', 'Developer', 30000),
  ];
}