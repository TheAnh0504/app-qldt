import "package:flutter/material.dart";
import "package:font_awesome_flutter/font_awesome_flutter.dart";
import "package:app_qldt/core/common/types.dart";

class ProfileSchoolPage extends StatelessWidget {
  const ProfileSchoolPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text("Trường học"),
          leading: IconButton(
              onPressed: () => Navigator.pop(context),
              icon: const FaIcon(FaIcons.arrowLeft))),
      body: const _BuildBody(),
    );
  }
}

class _BuildBody extends StatelessWidget {
  const _BuildBody();

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        ListTile(
            leading: FaIcon(FaIcons.userGroup),
            title: Text("Đại học Bách Khoa Hà Nội",
                maxLines: 1, overflow: TextOverflow.ellipsis),
            trailing: SizedBox(
              height: 30,
              child: ElevatedButton(onPressed: null, child: Text("Tham gia")),
            )),
        ListTile(
            leading: FaIcon(FaIcons.userGroup),
            title: Text("Đại học Bách Khoa Hà Nội",
                maxLines: 1, overflow: TextOverflow.ellipsis),
            trailing: SizedBox(
              height: 30,
              child: ElevatedButton(onPressed: null, child: Text("Tham gia")),
            )),
        ListTile(
            leading: FaIcon(FaIcons.userGroup),
            title: Text("Đại học Bách Khoa Hà Nội",
                maxLines: 1, overflow: TextOverflow.ellipsis),
            trailing: SizedBox(
              height: 30,
              child: ElevatedButton(onPressed: null, child: Text("Tham gia")),
            )),
      ],
    );
  }
}
