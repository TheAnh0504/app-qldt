import "package:app_qldt/controller/account_provider.dart";
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
import "package:app_qldt/view/pages/feed/feed_create_post_page.dart";
import "package:app_qldt/view/pages/feed/feed_noti_page.dart";
import "package:app_qldt/view/pages/feed/feed_post.dart";
import "package:app_qldt/controller/post_provider.dart";
import "package:app_qldt/controller/user_provider.dart";
import "package:app_qldt/core/theme/palette.dart";

class FeedPage extends ConsumerWidget {
  const FeedPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        leadingWidth: 50,
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
                Navigator.of(context, rootNavigator: true).push(
                    MaterialPageRoute(
                        builder: (context) => const FeedNotiPage()));
              },
              icon: const FaIcon(FaIcons.bell, color: Palette.white,),
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
  @override
  Widget build(BuildContext context) {
    var avatar = ref.watch(accountProvider).value?.avatar;
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
                              avatar ?? "https://picsum.photos/1024"),
                          radius: 20)
                      ,
                    ),
                  ),
                ),

                // Dùng Spacer để tạo khoảng cách giữa ảnh và text
                const SizedBox(width: 12),

                // Phần text căn trái
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start, // Căn trái cho cả 2 dòng text
                    mainAxisAlignment: MainAxisAlignment.center, // Căn giữa theo trục dọc trong `Row`
                    children: [
                      Text(
                        "Hoàng Thế Anh | 20204508",
                        style: TypeStyle.body1,
                        overflow: TextOverflow.ellipsis, // Cắt nội dung nếu quá dài
                        maxLines: 1,
                      ),
                      Text(
                        "Giảng viên or Sinh viên",
                        style: TypeStyle.body4,
                        overflow: TextOverflow.ellipsis, // Cắt nội dung nếu quá dài
                        maxLines: 1,
                      ),
                    ],
                  ),
                ),

                // Spacer để đẩy button sang phải
                IconButton(
                  icon: const Icon(Icons.calendar_month),
                  onPressed: () {
                    // Xử lý khi nhấn nút
                  },
                ),
              ],
            ),
          ),

          // 2 IconButton với text mô tả
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center, // Căn giữa cả Row
              children: [
                // IconButton 1
                Expanded( // Cho phép chia đều không gian giữa các Column
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center, // Căn giữa trong Column
                    children: [
                      IconButton(
                        icon: const Icon(Icons.thumb_up),
                        iconSize: 40.0, // Kích thước icon lớn hơn
                        onPressed: () {
                          // Xử lý khi nhấn nút 1
                        },
                      ),
                      const Text(
                        "Thời khóa biểu",
                        style: TypeStyle.body1,
                        overflow: TextOverflow.ellipsis, // Cắt nội dung nếu quá dài
                        maxLines: 1,
                      ),
                    ],
                  ),
                ),
                // IconButton 2
                Expanded( // Cho phép chia đều không gian giữa các Column
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center, // Căn giữa trong Column
                    children: [
                      IconButton(
                        icon: const Icon(Icons.comment),
                        iconSize: 40.0,
                        onPressed: () {
                          // Xử lý cho nút 2
                        },
                      ),
                      const Text(
                        "Thời khóa biểu",
                        style: TypeStyle.body1,
                        overflow: TextOverflow.ellipsis, // Cắt nội dung nếu quá dài
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
  }
}

