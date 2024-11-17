import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:font_awesome_flutter/font_awesome_flutter.dart";
import "package:go_router/go_router.dart";
import "package:introduction_screen/introduction_screen.dart";
import "package:app_qldt/core/common/types.dart";
import "package:app_qldt/core/router/url.dart";
import "package:app_qldt/controller/saved_account_provider.dart";

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: _BuildBody());
  }
}

class _BuildBody extends ConsumerWidget {
  const _BuildBody();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return IntroductionScreen(
      pages: [
        PageViewModel(
            image: const Padding(
              padding: EdgeInsets.only(bottom: 16),
              child: FaIcon(FaIcons.house, size: 72),
            ),
            title: "Bảng tin chi tiết",
            bodyWidget: const Text(
                "Nhận thông tin chia sẻ từ các giao viên khác ngay lúc này.",
                textAlign: TextAlign.center)),
        PageViewModel(
            image: const Padding(
              padding: EdgeInsets.only(bottom: 16),
              child: FaIcon(FaIcons.chartLine, size: 72),
            ),
            title: "Công cụ hữu ích",
            bodyWidget: const Text(
                "Công cụ hoàn hảo để theo dõi và có phương án phù hợp với tình trạng căng thẳng của học sinh.",
                textAlign: TextAlign.center)),
        PageViewModel(
            image: const Padding(
              padding: EdgeInsets.only(bottom: 16),
              child: FaIcon(FaIcons.solidCircleUser, size: 72),
            ),
            title: "Thông tin cá nhân",
            bodyWidget: const Text(
                "Trang thông tin cá nhân để giúp mọi người biết về bạn.",
                textAlign: TextAlign.center)),
        PageViewModel(
            image: const Padding(
              padding: EdgeInsets.only(bottom: 16),
              child: FaIcon(FaIcons.gear, size: 72),
            ),
            title: "Cài đặt đa năng",
            bodyWidget: const Text(
                "Mọi lựa chọn về hiển thị, thông báo, bảo mật đều có tại đây.",
                textAlign: TextAlign.center))
      ],
      done: const Text("Bắt đầu"),
      onDone: () => _navigate(ref, context),
      next: const Text("Tiếp theo"),
    );
  }

  void _navigate(WidgetRef ref, BuildContext context) async {
    var accounts = await ref.read(savedAccountProvider.future);
    if (accounts.isEmpty && context.mounted) context.go(loginRoute);
  }
}
