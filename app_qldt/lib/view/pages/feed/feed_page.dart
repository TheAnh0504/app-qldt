import "package:app_qldt/controller/account_provider.dart";
import "package:app_qldt/model/entities/class_info_model.dart";
import "package:app_qldt/view/pages/feed/feed_find.dart";
import "package:app_qldt/view/pages/register_class/register_class_page_home.dart";
import "package:extended_image/extended_image.dart";
import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:font_awesome_flutter/font_awesome_flutter.dart";
import "package:go_router/go_router.dart";
import "package:infinite_scroll_pagination/infinite_scroll_pagination.dart";
import "package:app_qldt/core/common/types.dart";
import "package:app_qldt/core/router/url.dart";
import "package:app_qldt/core/theme/typestyle.dart";
import "package:app_qldt/model/entities/post_model.dart";
import "package:app_qldt/view/pages/feed/feed_noti_page.dart";
import "package:app_qldt/controller/post_provider.dart";
import "package:app_qldt/controller/user_provider.dart";
import "package:app_qldt/core/theme/palette.dart";
import "package:intl/intl.dart";

import "../../../controller/list_class_provider.dart";
import "../../../controller/signup_provider.dart";
import "../../../model/entities/account_model.dart";
import "../../../model/entities/group_chat_model.dart";
import "../home_skeleton.dart";
import "../register_class/class_manager_lecturer.dart";
import "../register_class/info_class.dart";

class FeedPage extends ConsumerWidget {
  const FeedPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final countNotification = ref.watch(countNotificationProvider);
    return Scaffold(
      appBar: AppBar(
        // leadingWidth: 50,
        backgroundColor: Theme.of(context).colorScheme.primary,
        // leading: GestureDetector(
        //   onTap: () => context.push(profileRoute),
        //   child: Container(
        //     alignment: Alignment.center,
        //     margin: const EdgeInsets.all(5),
        //     decoration:
        //         BoxDecoration(border: Border.all(), shape: BoxShape.circle),
        //     child: avatar == ""
        //         ? const CircleAvatar(
        //             backgroundImage: AssetImage('images/avatar-trang.jpg'),
        //             radius: 20,
        //           )
        //         : CircleAvatar(
        //         backgroundImage: ExtendedNetworkImageProvider(
        //             avatar ?? "https://picsum.photos/1024"),
        //         radius: 20)
        //         ,
        //   ),
        // ),
        title: const Align(
          alignment: Alignment(0.2, 0), // Căn phải một chút
          child: Text("eHUST", style: TypeStyle.title1White),
        ),
        actions: [
          // IconButton(
          //     onPressed: () {
          //       context.go(searchRoute);
          //     },
          //     icon: const FaIcon(FaIcons.magnifyingGlass)),
          IconButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const FeedNotiPage()));
                // Navigator.of(context, rootNavigator: true).push(
                //     MaterialPageRoute(
                //         builder: (context) => const FeedNotiPage())
                // );
              },
              // icon: const FaIcon(FaIcons.bell, color: Palette.white,),
            icon: Badge(
              // Hiển thị số tin nhắn chưa đọc
              label: Text(
                countNotification.toString(), // Giá trị số
                style: const TextStyle(color: Colors.white, fontSize: 10),
              ),
              isLabelVisible: countNotification > 0,
              child: const FaIcon(FaIcons.bell, color: Palette.white,),
            )
          ),
          // IconButton(
          //     onPressed: () {
          //       Navigator.of(context, rootNavigator: true).push(
          //           MaterialPageRoute(
          //               builder: (context) => const FeedCreatePostPage()));
          //     },
          //     icon: const FaIcon(FaIcons.plus)),
        ],
      ),
      body: const _BuildBody(),
    );
  }
}

class _BuildBody extends ConsumerStatefulWidget {
  const _BuildBody();

  @override
  ConsumerState<_BuildBody> createState() => _BuildBodyState();
}

class _BuildBodyState extends ConsumerState<_BuildBody> {
  // Danh sách trạng thái màu
  List<Color> listColor = List.generate(7, (index) => Colors.grey[300]!);
  int selectedDayIndex = -1;
  bool schedule = true;
  @override
  Widget build(BuildContext context) {
    var avatar = ref.watch(accountProvider).value?.avatar;
    final currentDate = DateTime.now();
    final formattedDate = DateFormat('dd/MM/yyyy').format(currentDate);
    // Tính ngày đầu tiên của tuần (Thứ Hai)
    final firstDayOfWeek = currentDate.subtract(Duration(days: currentDate.weekday - 1));
    final List<String> listDayOfWeek = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"];
    // Tạo danh sách các ngày trong tuần
    final listDay = List.generate(7, (index) {
      final day = firstDayOfWeek.add(Duration(days: index));
      return DateFormat('dd').format(day);
    });
    final indexDay = listDay.indexOf(DateFormat('dd').format(currentDate));
    // Đặt màu đỏ cho ngày hôm nay
    // Đặt màu đỏ cho ngày hôm nay nếu chưa có ngày nào được chọn
    if (selectedDayIndex == -1) {
      selectedDayIndex = indexDay;
      listColor[selectedDayIndex] = Palette.red;
    }
    print(listDay);

    return Consumer(builder: (context, ref, _) {
      final future1 = ref.read(accountProvider.future); // Lấy Future
      final future2 = ref.read(listClassRegisterNowProvider.future); // Lấy Future
      final combinedFuture = Future.wait([
        future1,
        future2,
      ]);
      return FutureBuilder<List<dynamic>>(
        future: combinedFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),  // Hiển thị khi đang chờ dữ liệu
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'), // Hiển thị khi lỗi xảy ra
            );
          } else if (!snapshot.hasData) {
            return const Center(
              child: Text('No data available'), // Khi không có dữ liệu
            );
          }

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
                  child: Row(
                    children: [
                      // Phần ảnh căn trái
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16.0),
                        child: GestureDetector(
                          onTap: () => context.push(profileRoute),
                          child: Container(
                            alignment: Alignment.center,
                            margin: const EdgeInsets.all(5),
                            decoration:
                            BoxDecoration(border: Border.all(), shape: BoxShape.circle),
                            child: avatar == ""
                                ? const CircleAvatar(
                              backgroundImage: AssetImage('images/avatar-trang.jpg'),
                              radius: 20,
                            )
                                : CircleAvatar(
                                backgroundImage: ExtendedNetworkImageProvider(
                                    'https://drive.google.com/uc?id=${avatar?.split('/d/')[1].split('/')[0]}'),
                                radius: 20)
                            ,
                          ),
                        ),
                      ),

                      // Dùng Spacer để tạo khoảng cách giữa ảnh và text
                      const SizedBox(width: 12),

                      // Phần text căn trái
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start, // Căn trái cho cả 2 dòng text
                          mainAxisAlignment: MainAxisAlignment.center, // Căn giữa theo trục dọc trong `Row`
                          children: [
                            Text(
                              "${ref.watch(accountProvider).value!.name} | ${ref.watch(accountProvider).value!.idAccount}",
                              style: TypeStyle.body1,
                              overflow: TextOverflow.ellipsis, // Cắt nội dung nếu quá dài
                              maxLines: 1,
                            ),
                            Text(
                              ref.watch(accountProvider).value!.role == "STUDENT" ? "Sinh viên": "Giảng viên",
                              style: TypeStyle.body4,
                              overflow: TextOverflow.ellipsis, // Cắt nội dung nếu quá dài
                              maxLines: 1,
                            ),
                          ],
                        ),
                      ),

                      // button day phải
                      IconButton(
                        icon: const Icon(Icons.calendar_month, color: Palette.red100,),
                        onPressed: () {
                          setState(() {
                            schedule = !schedule;
                          });
                        },
                      ),
                    ],
                  ),
                ),

                // thời khóa biểu ẩn / hiện
                Container(
                  margin: const EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    color: Colors.white, // Màu nền trắng
                    borderRadius: BorderRadius.circular(12.0), // Bo góc
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.3), // Màu bóng mờ
                        blurRadius: 8, // Độ mờ của bóng
                        offset: Offset(0, 4), // Vị trí bóng
                      ),
                    ],
                  ),
                  child: schedule
                      ? Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Today: $formattedDate",
                              style: TypeStyle.body1,
                            ),
                            IconButton(
                              icon: const Icon(Icons.close),
                              onPressed: () {
                                setState(() {
                                  schedule = false;
                                });
                              },
                            ),
                          ],
                        ),
                        const SizedBox(height: 5),
                        // tuần trong tháng
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: List.generate(7, (index) {
                            return Expanded(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    listDayOfWeek[index],
                                    style: TypeStyle.body2,
                                  ),
                                  Material(
                                    color: listColor[index], // Màu nền xám
                                    shape: const CircleBorder(), // Tạo hình tròn xung quanh
                                    child: IconButton(
                                      icon: Text(
                                        listDay[index],
                                        style: TypeStyle.body2, // Màu chữ
                                      ),
                                      iconSize: 48, // Kích thước vùng ấn
                                      onPressed: () {
                                        setState(() {
                                          for (int i = 0; i < listColor.length; i++) {
                                            listColor[i] = i == index ? Palette.red : Colors.grey[300]!;
                                          }
                                        });
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }),
                        ),
                        const SizedBox(height: 16),
                        const Divider(
                          color: Colors.black,      // Màu đường kẻ
                          thickness: 1,             // Độ dày của đường kẻ
                          indent: 50,                // Khoảng cách từ trái
                          endIndent: 50,             // Khoảng cách từ phải
                        ),
                        const SizedBox(height: 16),

                        // TODO: 1.info class in day

                      ],
                    ),
                  )
                      : const SizedBox(),
                ),
                // link tới page khác
                // TODO: 1. go to other page
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center, // Căn giữa cả Row
                    children: [
                      // Ô vuông 1 sinh viên
                      if (ref.read(accountProvider).value?.role == "STUDENT") Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center, // Căn giữa trong Column
                          children: [
                            GestureDetector(
                              onTap: () async {
                                await ref.read(listClassAllProvider.notifier).getListClassInfo();
                                await ref.read(listClassProvider.notifier).getListClassInfo();
                                await ref.read(listClassRegisterNowProvider.notifier).getRegisterClassNow();
                                // Xử lý khi click vào ô vuông 1
                                // if (
                                //   ref.read(checkExpiredToken).value != null &&
                                //   ref.read(listClassAllProvider).value != null &&
                                //   ref.read(listClassProvider).value != null &&
                                //   ref.read(listClassRegisterNowProvider).value != null
                                // ) {
                                Navigator.push(context, MaterialPageRoute(builder: (context) => const RegisterClassPageHome()));
                                // Navigator.of(context, rootNavigator: true).push(
                                //   MaterialPageRoute(
                                //       builder: (context) => const RegisterClassPageHome())
                                // );
                                // }
                                print("Ô vuông 1 được nhấn!");
                              },
                              child: Container(
                                width: 80, // Chiều rộng ô vuông
                                height: 80, // Chiều cao ô vuông
                                decoration: BoxDecoration(
                                  color: Colors.white, // Màu nền của ô
                                  boxShadow: const [
                                    BoxShadow(
                                      color: Colors.black26, // Màu đổ bóng
                                      blurRadius: 8.0, // Bán kính làm mờ bóng
                                      offset: Offset(2, 2), // Vị trí bóng
                                    ),
                                  ],
                                  borderRadius: BorderRadius.circular(8.0), // Bo góc ô
                                ),
                                child: const Center(
                                  child: Icon(
                                    Icons.add_card,
                                    size: 40.0, // Kích thước icon
                                    color: Palette.red100,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 8), // Khoảng cách giữa ô vuông và text
                            const Text(
                              "Đăng ký lớp học",
                              style: TextStyle(fontSize: 14.0),
                              overflow: TextOverflow.ellipsis, // Cắt nội dung nếu quá dài
                              maxLines: 1,
                            ),
                          ],
                        ),
                      ),
                      // ô vuông 1 giảng viên
                      if (ref.read(accountProvider).value?.role != "STUDENT") Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center, // Căn giữa trong Column
                          children: [
                            GestureDetector(
                              onTap: () async {
                                await ref.read(listClassAllProvider.notifier).getListClassInfo();
                                await ref.read(listClassProvider.notifier).getListClassInfo();
                                await ref.read(listClassRegisterNowProvider.notifier).getRegisterClassNow();
                                // Xử lý khi click vào ô vuông 1
                                // if (
                                // ref.read(checkExpiredToken).value != null &&
                                //     ref.read(listClassAllProvider).value != null &&
                                //     ref.read(listClassProvider).value != null &&
                                //     ref.read(listClassRegisterNowProvider).value != null
                                // ) {
                                Navigator.push(context, MaterialPageRoute(builder: (context) => const ClassManagerLecturer()));
                                // Navigator.of(context, rootNavigator: true).push(
                                //     MaterialPageRoute(
                                //         builder: (
                                //             context) => const ClassManagerLecturer())
                                // );
                                // }
                                print("Ô vuông 1 được nhấn!");
                              },
                              child: Container(
                                width: 80, // Chiều rộng ô vuông
                                height: 80, // Chiều cao ô vuông
                                decoration: BoxDecoration(
                                  color: Colors.white, // Màu nền của ô
                                  boxShadow: const [
                                    BoxShadow(
                                      color: Colors.black26, // Màu đổ bóng
                                      blurRadius: 8.0, // Bán kính làm mờ bóng
                                      offset: Offset(2, 2), // Vị trí bóng
                                    ),
                                  ],
                                  borderRadius: BorderRadius.circular(8.0), // Bo góc ô
                                ),
                                child: const Center(
                                  child: Icon(
                                    Icons.add_card,
                                    size: 40.0, // Kích thước icon
                                    color: Palette.red100,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 8), // Khoảng cách giữa ô vuông và text
                            const Text(
                              "Quản lý lớp học",
                              style: TextStyle(fontSize: 14.0),
                              overflow: TextOverflow.ellipsis, // Cắt nội dung nếu quá dài
                              maxLines: 1,
                            ),
                          ],
                        ),
                      ),
                      // Ô vuông 2
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center, // Căn giữa trong Column
                          children: [
                            GestureDetector(
                              onTap: () {
                                // Xử lý khi click vào ô vuông 2
                                print("Ô vuông 2 được nhấn!");
                                // Navigator.of(context, rootNavigator: true).push(
                                //     MaterialPageRoute(
                                //         builder: (
                                //             context) => const FeedFind()
                                //     )
                                // );
                                Navigator.push(context, MaterialPageRoute(builder: (context) => const FeedFind()));
                              },
                              child: Container(
                                width: 80,
                                height: 80,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  boxShadow: const [
                                    BoxShadow(
                                      color: Colors.black26,
                                      blurRadius: 8.0,
                                      offset: Offset(2, 2),
                                    ),
                                  ],
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                                child: const Center(
                                  child: Icon(
                                    Icons.account_circle_outlined,
                                    size: 40.0,
                                    color: Palette.red100,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 8),
                            const Text(
                              "Tra cứu thông tin",
                              style: TextStyle(fontSize: 14.0),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

              ],
            ),
          );
        },
      );
    });
  }
}

