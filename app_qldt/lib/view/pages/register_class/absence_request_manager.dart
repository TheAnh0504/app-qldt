import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';

import '../../../controller/absence_provider.dart';
import '../../../controller/messaging_provider.dart';
import '../../../core/common/types.dart';
import '../../../core/theme/palette.dart';
import '../../../core/theme/typestyle.dart';
import '../../../model/entities/message_model.dart';
import '../messaging/messaging_detail_settings_page.dart';

class AbsenceRequestManager extends ConsumerStatefulWidget {
  const AbsenceRequestManager({super.key});

  @override
  ConsumerState<AbsenceRequestManager> createState() => _AbsenceRequestManager();
}

class _AbsenceRequestManager extends ConsumerState<AbsenceRequestManager> {
  final controller = TextEditingController();
  ValueNotifier<List<Map<String, dynamic>>> results = ValueNotifier([]);
  final classId = TextEditingController();
  String? status;
  TextEditingController startDate = TextEditingController();

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

    return Scaffold(
      appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.primary,
          title: const Align(
            alignment: Alignment(-0.25, 0), // Căn phải một chút
            child: Text("Đơn xin nghỉ học", style: TypeStyle.title1White),
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
                            results.value = await ref.read(absenceProvider.notifier).getAbsenceRequestStudent(classId.text, status, startDate.text);
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
                            decoration: const InputDecoration(
                              hintText: "Nhập mã lớp",
                              border: OutlineInputBorder(),
                              contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
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
                        const SizedBox(height: 10),
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
                      ],
                    )
                ),


                const SizedBox(height: 16),
                ValueListenableBuilder<List<Map<String,dynamic>>>(
                  valueListenable: results,
                  builder: (context, results, _) {
                    if (results.isEmpty) {
                      return const Center(child: Text("Không có kết quả tìm kiếm"));
                    }
                    return SizedBox(
                      height: 520,
                      child: ListView.builder(
                        itemCount: results.length,
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
                              leading: CircleAvatar(
                                backgroundImage: results[index]["avatar"] != null
                                    ? ExtendedNetworkImageProvider('https://drive.google.com/uc?id=${results[index]["avatar"].split('/d/')[1].split('/')[0]}',
                                ) : const AssetImage('images/avatar-trang.jpg'),
                                radius: 20, // Kích thước của ảnh
                              ),
                              title: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '${results[index]["first_name"]} ${results[index]["last_name"]}',
                                    style: TypeStyle.title2,
                                  ),
                                  Text(
                                    results[index]["email"],
                                    style: TypeStyle.body3,
                                  ),
                                ],
                              ),
                              onTap: () {
                                // Logic xử lý khi nhấn vào
                                print("Selected: ${results[index]}");
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (_) => MessagingDetailSettingsPage(
                                            user: MessageUserModel(
                                              // required
                                                id: int.parse(results[index]["account_id"]),
                                                // face
                                                name: results[index]["first_name"],
                                                avatar: results[index]["email"])))
                                );
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
  }
}