import "package:flutter/material.dart";
import "package:font_awesome_flutter/font_awesome_flutter.dart";
import "package:go_router/go_router.dart";
import "package:app_qldt/core/common/types.dart";
import "package:app_qldt/core/theme/typestyle.dart";

class SettingsInfoPage extends StatelessWidget {
  const SettingsInfoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: const Text("Thông tin", style: TypeStyle.title1),
            leading: IconButton(
                onPressed: () => context.pop(),
                icon: const FaIcon(FaIcons.arrowLeft))),
        body: const _BuildBody());
  }
}

class _BuildBody extends StatelessWidget {
  const _BuildBody();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const ListTile(
            title:
                Text("Điều khoản về quyền riêng tư", style: TypeStyle.title2)),
        const ListTile(
            title: Text("Thỏa thuận cấp phép", style: TypeStyle.title2)),
        ListTile(
            onTap: () => Navigator.push(context,
                MaterialPageRoute(builder: (context) => const LicensePage())),
            title: const Text("Chứng chỉ mã nguồn mở", style: TypeStyle.title2),
            subtitle:
                const Text("Chi tiết chứng chỉ cho phần mềm mã nguồn mở")),
        const ListTile(
            title: Text("app_qldt", style: TypeStyle.title2),
            subtitle: Text("v1.0.0"))
      ],
    );
  }
}
