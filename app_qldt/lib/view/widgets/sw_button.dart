import "package:flutter/material.dart";

class CustomTextButton extends StatelessWidget {
  const CustomTextButton(
      {required this.text, required this.color, super.key, this.onTap});
  final void Function()? onTap;
  final Color color;
  final String text;

  @override
  Widget build(BuildContext context) {
    return TextButton(
        onPressed: onTap,
        style: Theme.of(context)
            .textButtonTheme
            .style
            ?.copyWith(foregroundColor: WidgetStatePropertyAll(color)),
        child: Text(text));
  }
}
