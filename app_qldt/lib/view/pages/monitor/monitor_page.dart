import "package:extended_image/extended_image.dart";
import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:app_qldt/controller/student_provider.dart";
import "package:app_qldt/controller/user_provider.dart";
import "package:app_qldt/core/common/formatter.dart";
import "package:app_qldt/core/theme/typestyle.dart";

class MonitorPage extends ConsumerWidget {
  const MonitorPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
        body: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 24),
          const Text("Danh sách học sinh", style: TypeStyle.title1),
          Expanded(
            child: FutureBuilder(
                future: ref.watch(
                    studentProvider(ref.watch(userProvider).value!.userId)
                        .future),
                builder: (context, snapshot) {
                  return Column(
                      children: snapshot.data != null
                          ? snapshot.data!
                              .map((e) => ListTile(
                                    leading: CircleAvatar(
                                        backgroundImage:
                                            ExtendedNetworkImageProvider(
                                                e["avatar"])),
                                    title: Text(e["displayName"]),
                                    trailing: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        IconButton(
                                            onPressed: () {
                                              Navigator.of(context,
                                                      rootNavigator: true)
                                                  .push(MaterialPageRoute(
                                                      builder: (context) =>
                                                          MonitorNoti(
                                                              studentId: e[
                                                                  "studentId"])));
                                            },
                                            icon: const Icon(
                                                Icons.notifications)),
                                        IconButton(
                                            onPressed: () {
                                              showDialog(
                                                  context: context,
                                                  builder: (context) =>
                                                      AlertDialog(
                                                          content: Column(
                                                              mainAxisSize:
                                                                  MainAxisSize
                                                                      .min,
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                            const Text(
                                                                "Thông tin học sinh",
                                                                style: TypeStyle
                                                                    .title2),
                                                            Text(
                                                                "Họ: ${e["lastName"]}"),
                                                            Text(
                                                                "Tên: ${e["firstName"]}"),
                                                            Text(
                                                                "Giới tính: ${switch (e["gender"]) {
                                                              "1" => "Nam",
                                                              "2" => "Nữ",
                                                              _ => "Không rõ"
                                                            }}"),
                                                            Text(
                                                                "SĐT phụ huynh: ${e["phoneNumberParent"]}")
                                                          ])));
                                            },
                                            icon: const Icon(Icons.info))
                                      ],
                                    ),
                                  ))
                              .toList()
                          : <Widget>[]);
                }),
          ),
        ],
      ),
    ));
  }
}

class MonitorNoti extends ConsumerWidget {
  final String studentId;
  const MonitorNoti({super.key, required this.studentId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
        appBar: AppBar(title: const Text("Danh sách cảnh báo")),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 24),
              Expanded(
                child: FutureBuilder(
                    future:
                        ref.watch(notifyByStudentProvider(studentId).future),
                    builder: (context, snapshot) {
                      return SingleChildScrollView(
                        child: Column(
                            children: (snapshot.data?.isEmpty ?? true) == false
                                ? snapshot.data!
                                    .map((e) => ListTile(
                                          title: Text(
                                              "Cảnh báo: ${e["prediction"]}"),
                                          subtitle: Text(
                                              "Thời gian: ${formatMessageDate(DateTime.parse(e["dateTime"]))}"),
                                        ))
                                    .toList()
                                : <Widget>[const Text("Hiện chưa có cảnh báo nào.")]),
                      );
                    }),
              ),
            ],
          ),
        ));
  }
}
