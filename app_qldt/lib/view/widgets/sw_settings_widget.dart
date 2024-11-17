import "package:flutter/material.dart";
import "package:app_qldt/core/theme/typestyle.dart";

class ListTileSection extends StatelessWidget {
  final String title;
  final List<Widget> tiles;
  final Border? border;
  final BorderRadius? borderRadius;
  final EdgeInsetsGeometry? padding;

  const ListTileSection(
      {required this.title,
      required this.tiles,
      super.key,
      this.border,
      this.borderRadius,
      this.padding});

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      if (title != "")
        Text(title,
            style: TypeStyle.title4
                .copyWith(color: Theme.of(context).colorScheme.primary)),
      Container(
          padding: padding,
          decoration: BoxDecoration(border: border, borderRadius: borderRadius),
          margin: const EdgeInsets.only(top: 8),
          child: Column(children: tiles.isEmpty ? [] : tiles))
    ]);
  }
}

class SWListTile extends StatelessWidget {
  const SWListTile(
      {required this.leading,
      required this.title,
      super.key,
      this.subtitle,
      this.onTap,
      this.trailing,
      this.foregroundColor,
      this.backgroundColor,
      this.contendPadding});

  final Widget leading;
  final Widget title;
  final Widget? subtitle;
  final Widget? trailing;
  final Color? foregroundColor;
  final Color? backgroundColor;
  final EdgeInsetsGeometry? contendPadding;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
        color: backgroundColor,
        child: ListTile(
            contentPadding: contendPadding,
            titleTextStyle: TypeStyle.title4
                .copyWith(fontWeight: FontWeight.w500, color: foregroundColor),
            iconColor: foregroundColor,
            leading: leading,
            minLeadingWidth: 30,
            onTap: onTap,
            title: title,
            subtitle: subtitle,
            trailing: trailing));
  }
}
