import "package:flutter/material.dart";
import "package:font_awesome_flutter/font_awesome_flutter.dart";
import "package:go_router/go_router.dart";
import "package:app_qldt/core/common/types.dart";
import "package:app_qldt/core/theme/typestyle.dart";
import "package:url_launcher/url_launcher.dart";

class SettingsHelpPage extends StatelessWidget {
  const SettingsHelpPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text("Hỗ trợ", style: TypeStyle.title1),
          leading: IconButton(
              onPressed: () => context.pop(),
              icon: const FaIcon(FaIcons.arrowLeft))),
      body: const _BuildBody(),
    );
  }
}

class _BuildBody extends StatelessWidget {
  const _BuildBody();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
            onTap: () {
              launchUrl(Uri(
                  scheme: 'mailto',
                  path: 'ntd271102@gmail.com',
                  queryParameters: {'subject': '[app_qldt][Help] <Nội dung>'}));
            },
            title:
                const Text("Liên hệ nhà phát triển", style: TypeStyle.title2),
            subtitle: const Text("Liên hệ qua email: ntd271102@gmail.com")),
        ListTile(
            onTap: () {},
            title: const Text("FAQ", style: TypeStyle.title2),
            subtitle: const Text("Câu trả lời cho các câu hỏi thường gặp"))
      ],
    );
  }
}
