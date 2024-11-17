import "package:flutter/material.dart";
import "package:font_awesome_flutter/font_awesome_flutter.dart";
import "package:app_qldt/core/theme/palette.dart";
import "package:app_qldt/core/theme/typestyle.dart";

Future<T?> showOptionModal<T>(
    {required BuildContext context,
    Widget? header,
    required List<List<BottomSheetListTile>> blocks}) {
  return showModalBottomSheet<T>(
      context: context,
      builder: (context) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (header != null)
              Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: header),
            if (header != null) const SizedBox(height: 8),
            ListView.builder(
                shrinkWrap: true,
                itemBuilder: (context, index) => Container(
                    clipBehavior: Clip.hardEdge,
                    margin:
                        const EdgeInsets.only(left: 10, right: 10, bottom: 15),
                    decoration:
                        BoxDecoration(borderRadius: BorderRadius.circular(5)),
                    child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: blocks[index]
                            .map(
                                (e) => Material(color: Palette.white, child: e))
                            .toList())),
                itemCount: blocks.length)
          ],
        );
      },
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      showDragHandle: true);
}

class BottomSheetListTile extends StatelessWidget {
  const BottomSheetListTile(
      {super.key,
      required this.onTap,
      this.leading,
      this.title,
      this.subtitle,
      this.color});

  final void Function()? onTap;
  final IconData? leading;
  final String? title;
  final String? subtitle;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashFactory: InkRipple.splashFactory,
      onTap: onTap,
      child: ListTile(
          leading: FaIcon(leading),
          title: title == null ? null : Text(title!),
          iconColor: color,
          subtitle:
              subtitle == null ? null : Text(subtitle!, style: TypeStyle.body4),
          contentPadding: const EdgeInsets.symmetric(horizontal: 8),
          dense: true),
    );
  }
}
