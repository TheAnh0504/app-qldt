import 'package:app_qldt/controller/account_provider.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../controller/absence_provider.dart';
import '../../../controller/messaging_provider.dart';
import '../../../core/common/types.dart';
import '../../../core/theme/palette.dart';
import '../../../core/theme/typestyle.dart';
import '../../../model/entities/absence_request_model.dart';
import '../../../model/entities/message_model.dart';
import '../messaging/messaging_detail_settings_page.dart';

class AbsenceRequestManager extends ConsumerStatefulWidget {
  final String classIdLecturer;
  const AbsenceRequestManager({super.key, required this.classIdLecturer});

  @override
  ConsumerState<AbsenceRequestManager> createState() => _AbsenceRequestManager();
}

class _AbsenceRequestManager extends ConsumerState<AbsenceRequestManager> {
  final controller = TextEditingController();
  ValueNotifier<List<AbsenceRequestModel>> results = ValueNotifier([]);
  final classId = TextEditingController();
  String? status;
  TextEditingController startDate = TextEditingController();
  late bool checkStudent;
  String absenceType = '';

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
    } else {
      setState(() => startDate.clear());
    }
  }

  @override
  Widget build(BuildContext context) {
    checkStudent = ref.read(accountProvider).value?.role == "STUDENT";
    if (!checkStudent) {
      status = 'PENDING';
      classId.text = widget.classIdLecturer;
    }
    return Consumer(builder: (context, ref, _) {
      final future = ref.read(absenceProvider.future); // Lấy Future
      return FutureBuilder<List<AbsenceRequestModel>?>(
        future: future,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),  // Hiển thị khi đang chờ dữ liệu
            );
          } else if (snapshot.hasError) {
            return Center(
              child: snapshot.error.toString().contains("9990")
                  ? const Text('Tài khoản đã bị khóa!')
                  : Text('Error: ${snapshot.error}'), // Hiển thị khi lỗi xảy ra
            );
          } else if (!snapshot.hasData) {
            return const Center(
              child: Text('No data available'), // Khi không có dữ liệu
            );
          }

          final data = snapshot.data!;
          results.value = data;
          return Scaffold(
            appBar: AppBar(
                backgroundColor: Theme.of(context).colorScheme.primary,
                title: const Align(
                  alignment: Alignment(-0.25, 0), // Căn phải một chút
                  child: Text("Quản lý nghỉ phép", style: TypeStyle.title1White),
                ),
                leading: IconButton(
                    onPressed: () => context.pop(),
                    icon: const FaIcon(FaIcons.arrowLeft, color: Palette.white,))),
            body: SingleChildScrollView(
              child: Container(
                  width: MediaQuery.sizeOf(context).width,
                  height: MediaQuery.sizeOf(context).height,
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  decoration: const BoxDecoration(color: Palette.white),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 26),
                      // Text("Tìm kiếm: ", style: TypeStyle.body2),
                      Padding(
                        padding: const EdgeInsets.only(left: 15),
                        child: Row(
                          children: [
                            const Text('Lọc đơn xin nghỉ học',
                                style: TypeStyle.title1),
                            const Spacer(),
                            Center(
                              child: FilledButton(
                                onPressed: () async {
                                  List<AbsenceRequestModel>? value = checkStudent
                                      ? await ref.read(absenceProvider.notifier).getAbsenceRequestStudent(classId.text, status, startDate.text)
                                      : await ref.read(absenceProvider.notifier).getAbsenceRequestLecture(classId.text, status, startDate.text);
                                  if (value != null) {
                                    results.value = value;
                                  } else {
                                    results.value = [];
                                  }
                                },
                                child: const Center(child: Text("Tìm kiếm")),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),
                      Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Expanded(
                                child: TextField(
                                  controller: classId,
                                  readOnly: !checkStudent,
                                  decoration: InputDecoration(
                                    hintText: "Nhập mã lớp",
                                    border: const OutlineInputBorder(),
                                    filled: true,
                                      fillColor: !checkStudent
                                          ? Palette.grey55 // Change the background color if readOnly is true
                                          : Palette.white,
                                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                                  ),
                                ),
                              ),
                            ],
                          )
                      ),
                      Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 10),
                          child: Column(
                            // mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              TextFormField(
                                controller: startDate,
                                readOnly: true, // Không cho phép nhập tay
                                onTap: () => _selectDate(context), // Mở hộp thoại chọn ngày
                                decoration: const InputDecoration(
                                  hintText: "Chọn ngày nghỉ học",
                                  border: OutlineInputBorder(),
                                  suffixIcon: Icon(Icons.calendar_today),
                                ),
                              ),
                              const SizedBox(height: 10),
                              DropdownButtonFormField<String>(
                                value: status,
                                decoration: InputDecoration(
                                  hintText: "Chọn trạng thái đơn xin nghỉ học",
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                items: const [
                                  DropdownMenuItem(value: '', child: Text('(All)')),
                                  DropdownMenuItem(value: 'ACCEPTED', child: Text('Đồng ý')),
                                  DropdownMenuItem(value: 'PENDING', child: Text('Chờ duyệt')),
                                  DropdownMenuItem(value: 'REJECTED', child: Text('Từ chối')),
                                ],
                                onChanged: (value) {
                                  if (value != null) {
                                    status = value; // Cập nhật giá trị đã chọn
                                  }
                                },
                              ),
                            ],
                          )
                      ),


                      const SizedBox(height: 16),
                      ValueListenableBuilder<List<AbsenceRequestModel>>(
                        valueListenable: results,
                        builder: (context, results1, _) {
                          if (results1.isEmpty) {
                            return const Center(child: Text("Không có kết quả tìm kiếm"));
                          }
                          return SizedBox(
                            height: 330,
                            child: ListView.builder(
                              itemCount: results1.length,
                              itemBuilder: (context, index) => Padding(
                                padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
                                child: DecoratedBox(
                                  decoration: BoxDecoration(
                                    color: Palette.white, // Màu nền
                                    borderRadius: BorderRadius.circular(8), // Bo góc
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(0.3), // Màu đổ bóng
                                        spreadRadius: 2,
                                        blurRadius: 4,
                                        offset: const Offset(0, 3), // Vị trí đổ bóng
                                      ),
                                    ],
                                    border: Border.all(color: Palette.red100), // Viền
                                  ),
                                  child: ListTile(
                                    // leading: CircleAvatar(
                                    //   backgroundImage: 'results[index]["avatar"]' != null
                                    //       ? ExtendedNetworkImageProvider('https://drive.google.com/uc?id=',
                                    //   ) : const AssetImage('images/avatar-trang.jpg'),
                                    //   radius: 20, // Kích thước của ảnh
                                    // ),
                                    title: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text.rich(TextSpan(children: [
                                          // const TextSpan(text: "MSSV: ", style: TypeStyle.title2),
                                          TextSpan(
                                              text: results1[index].title,
                                              style: TypeStyle.title2.copyWith(
                                                  color: Theme.of(context).colorScheme.error))
                                        ])),
                                        Text.rich(TextSpan(children: [
                                          const TextSpan(text: "Mã đơn: ", style: TypeStyle.body3),
                                          TextSpan(
                                              text: results1[index].id,
                                              style: TypeStyle.body3.copyWith(
                                                  color: Theme.of(context).colorScheme.error))
                                        ])),
                                        Text.rich(TextSpan(children: [
                                          const TextSpan(text: "Mã lớp xin nghỉ: ", style: TypeStyle.body3),
                                          TextSpan(
                                              text: results1[index].class_id,
                                              style: TypeStyle.body3.copyWith(
                                                  color: Theme.of(context).colorScheme.error))
                                        ])),
                                        Text.rich(TextSpan(children: [
                                          const TextSpan(text: "Trạng thái: ", style: TypeStyle.body3),
                                          TextSpan(
                                              text: results1[index].status == 'ACCEPTED' ? 'Đồng ý' :
                                              results1[index].status == 'PENDING' ? 'Chờ duyệt' : 'Từ chối',
                                              style: TypeStyle.body3.copyWith(
                                                  color: Theme.of(context).colorScheme.error))
                                        ])),
                                        Text.rich(TextSpan(children: [
                                          const TextSpan(text: "Ngày xin nghỉ: ", style: TypeStyle.body3),
                                          TextSpan(
                                              text: results1[index].absence_date,
                                              style: TypeStyle.body3.copyWith(
                                                  color: Theme.of(context).colorScheme.error))
                                        ])),
                                        Text.rich(TextSpan(children: [
                                          const TextSpan(text: "Lý do: ", style: TypeStyle.body3),
                                          TextSpan(
                                              text: results1[index].reason,
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
                                            const TextSpan(text: "Hồ sơ: ", style: TypeStyle.body3),
                                            TextSpan(
                                                text: 'Nhấn để xem hồ sơ minh chứng đính kèm',
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
                                    onTap: () {
                                      // Logic xử lý khi nhấn vào
                                      print("Selected: ${results1[index]}");
                                      if (!checkStudent) {
                                        showDialog<bool>(
                                            context: context,
                                            builder: (_) {
                                              return StatefulBuilder(
                                                  builder: (context, setState) {
                                                    return AlertDialog(
                                                        title: const Text("Phê duyệt đơn xin nghỉ học"),
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
                                                                  "Bạn có chắp nhận đơn xin nghỉ học không? "),
                                                              const SizedBox(height: 10),

                                                              RadioListTile<String>(
                                                                title: const Text(
                                                                    "Đồng ý duyệt"),
                                                                value: 'true',
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
                                                                    "Từ chối duyệt"),
                                                                value: "false",
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
                                            if (absenceType == 'true') {
                                              if (await ref.read(absenceProvider1.notifier).reviewAbsenceRequest(results1[index].id, 'ACCEPTED')) {
                                                final filtered = results.value.where((item) => item.id != results1[index].id).toList();
                                                // setState(() {
                                                await ref.read(absenceProvider1.notifier).sendNotify(
                                                    'Mã giảng viên: ${ref.read(accountProvider).value?.idAccount}; Email: ${ref.read(accountProvider).value?.email}; Mã đơn xin nghỉ học: ${results1[index].id}; Ngày xin nghỉ: ${results1[index].absence_date}; Mã lớp: ${results1[index].class_id}; Lý do: ${results1[index].reason}',
                                                    results1[index].student_account?['account_id'], "ACCEPT_ABSENCE_REQUEST"
                                                );
                                                  results.value = filtered;
                                                ref.read(absenceProvider.notifier).forward(AsyncData(filtered));
                                                // });
                                                Fluttertoast.showToast(msg: "Đồng ý duyệt đơn xin nghỉ học thành công");
                                              } else {
                                                Fluttertoast.showToast(msg: "Duyệt đơn xin nghỉ học thất bại");
                                              }
                                            } else if (absenceType == 'false') {
                                              if (await ref.read(absenceProvider1.notifier).reviewAbsenceRequest(results1[index].id, 'REJECTED')) {
                                                final filtered = results.value.where((item) => item.id != results1[index].id).toList();
                                                // setState(() {
                                                await ref.read(absenceProvider1.notifier).sendNotify(
                                                    'Mã giảng viên: ${ref.read(accountProvider).value?.idAccount}; Email: ${ref.read(accountProvider).value?.email}; Mã đơn xin nghỉ học: ${results1[index].id}; Ngày xin nghỉ: ${startDate.text}; Mã lớp: ${results1[index].class_id}; Lý do: ${results1[index].reason}',
                                                    results1[index].student_account?['account_id'], "REJECT_ABSENCE_REQUEST"
                                                );
                                                  results.value = filtered;
                                                ref.read(absenceProvider.notifier).forward(AsyncData(filtered));
                                                // });
                                                Fluttertoast.showToast(msg: "Từ chối đơn xin nghỉ học thành công");
                                              } else {
                                                Fluttertoast.showToast(msg: "Duyệt đơn xin nghỉ học thất bại");
                                              }
                                            }
                                          }
                                        });
                                      }
                                    },
                                  ),

                                ),
                              ),
                            ),
                          );

                        },
                      )

                    ],
                  )
              ),
            ),
          );
        },
      );
    });
  }
}