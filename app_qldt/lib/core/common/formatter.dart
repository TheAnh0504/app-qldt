import "dart:math";

import "package:flutter/services.dart";
// định ngày giờ quốc tế hóa
import "package:intl/intl.dart";

// show time message
String formatMessageDate(DateTime date, [String? locale]) {
  // 17/12 backend add múi giờ vào date, app ko add múi giờ nữa
  // date = date.add(DateTime.now().timeZoneOffset);
  locale ??= Intl.getCurrentLocale();
  if (!DateFormat.localeExists(locale)) {
    locale = 'en'; // Fallback sang ngôn ngữ mặc định
  }
  final now = DateTime.now();
  // final now = DateTime.now().add(DateTime.now().timeZoneOffset);
  // print(date);
  // print(now);
  // khoảng time chênh lệch giữa now và date
  final duration = now.difference(date);
  if (duration.inDays > 365) {
    return DateFormat("dd/MM/yyyy HH:mm", locale).format(date);
  }
  if (duration.inDays > 7) {
    return DateFormat("dd/MM HH:mm", locale).format(date);
  }
  if (duration.inHours > 24) {
    return DateFormat("EEE HH:mm", locale).format(date);
  }
  if (date.day != now.day || date.month != now.month || date.year != now.year) {
    return DateFormat("EEE HH:mm", locale).format(date);
  }
  if (duration.inMinutes > 1) return DateFormat("HH:mm", locale).format(date);
  return "Vừa xong";
}
bool isDifferentDate(DateTime date, DateTime now) {
  return date.day != now.day || date.month != now.month || date.year != now.year;
}
// convert to text datetime: 12/03/2024 (auto add / when select number)
class DateTextFormatter extends TextInputFormatter {
  static const _maxChars = 8;

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    final text = _format(newValue.text, "/");
    return newValue.copyWith(text: text, selection: updateCursorPosition(text));
  }

  String _format(String value, String seperator) {
    value = value.replaceAll(seperator, "");
    var newString = "";

    for (int i = 0; i < min(value.length, _maxChars); i++) {
      newString += value[i];
      if ((i == 1 || i == 3) && i != value.length - 1) {
        newString += seperator;
      }
    }

    return newString;
  }

  TextSelection updateCursorPosition(String text) {
    return TextSelection.fromPosition(TextPosition(offset: text.length));
  }
}
