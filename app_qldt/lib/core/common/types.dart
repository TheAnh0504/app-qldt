// ignore_for_file: constant_identifier_names

import "package:flutter/material.dart";
import "package:font_awesome_flutter/font_awesome_flutter.dart";
import "package:freezed_annotation/freezed_annotation.dart";

typedef FaIcons = FontAwesomeIcons;

enum AccountStatus { NO, INIT, CONFIRMED_OTP, LOCKED, ACTIVE, CHANGE_PASSWORD }

enum VerifyCodeState { init, sent, success }

enum VerifyCodeType { add_user, first_login, forget_pas, unlock_acc }

enum Gender {
  male,
  female,
  unknown;

  const Gender();
  // cách dùng Gender gender = Gender.male; gender.raw;
  String get raw =>
      {
        Gender.male: "Nam",
        Gender.female: "Nữ",
        Gender.unknown: "Không rõ"
      }[this] ??
      "Không rõ";
}
// chế độ màu sáng, tối, theo phone
class ThemeModeConverter extends JsonConverter<ThemeMode, int> {
  const ThemeModeConverter();

  @override
  ThemeMode fromJson(int json) {
    return ThemeMode.values[json];
  }

  @override
  int toJson(ThemeMode object) {
    return ThemeMode.values.indexOf(object);
  }
}
// chuyển value of Gender to Number String
class GenderConverter extends JsonConverter<Gender, String> {
  const GenderConverter();

  @override
  Gender fromJson(String json) {
    return Gender.values[int.parse(json) - 1];
  }

  @override
  String toJson(Gender object) {
    return (object.index + 1).toString();
  }
}
