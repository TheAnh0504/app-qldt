import 'package:app_qldt/core/theme/palette.dart';
import 'package:flutter/material.dart';

class TypeStyle {
  static const headingBig = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 36,
      letterSpacing: 0.1,
      height: 1.5,
      color: Palette.red100);
  static const heading = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 24,
      letterSpacing: 0.1,
      height: 1.5,
      color: Palette.red100);
  static const title1 = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 20,
      letterSpacing: 0.0,
      height: 1.2);
  static const title1White = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 20,
      letterSpacing: 0.0,
      height: 1.2,
      color: Colors.white
  );
  static const title2 = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 16,
      letterSpacing: -0.1,
      height: 1.2);
  static const title3 = title2;
  static const title4 = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 16,
      letterSpacing: 0.0,
      height: 1.2);
  static const bodySemiBold = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 16,
      letterSpacing: 0.6,
      height: 1.5);
  static const body1 = TextStyle(
      fontSize: 18,
      letterSpacing: 0.4,
      fontWeight: FontWeight.w400,
      height: 1.5);
  static const body2 = TextStyle(
      fontSize: 16,
      letterSpacing: -0.2,
      fontWeight: FontWeight.w400,
      height: 1.5);
  static const body3 = body2;
  static const body4 = TextStyle(
      fontSize: 14,
      letterSpacing: -0.1,
      fontWeight: FontWeight.w400,
      height: 1.5);
  static const body5 = TextStyle(
      fontSize: 12,
      letterSpacing: -0.1,
      fontWeight: FontWeight.w400,
      height: 1.5);
  static const caption = TextStyle(
      fontSize: 14, letterSpacing: 2, fontWeight: FontWeight.w400, height: 1.5);
}
