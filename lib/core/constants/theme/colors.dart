import 'package:flutter/material.dart';

class AppColor {
  static const darkWhite = Color(0xFFDDDDDD);
  static const white = Color(0xFFFFFFFF);
  static const black = Color(0xFF000000);
  static const transparent = Color(0x00000000);
  static const transparentBlack50 = Color(0x80000000);
  static const orange = Color(0xFFFFA500);
  static const accent50 = Color(0xFFFFF3DE);
  static const accent400 = Color(0xFFFFA500);
  static const yellow50 = Color(0xFFFBF7E0);
  static const purple50 = Color(0xFFF3E9FD);
  static const purple400 = Color(0xFF9F5BF5);
  static const blue500 = Color(0xFF2A5ABF);
  static const darkBlue50 = Color(0xFFEAEBFF);
  static const blue50 = Color(0xFFE2F2FE);
  static const red500 = Color(0xFFE30052);
  static const green500 = Color(0xFF68C31D);
  static const sliderBgGray = Color(0xFFEDEDEF);
  static const darkBlue = Color(0xFF212529);
  static const background = Color(0xFFF4F4F4);
  static const statusButtonGray = Color(0xFF8E8E93);
  static const statusButtonBlue = Color(0xFF14429E);
  static const statusButtonRed = Color(0xFFB20049);
  static const statusButtonGreen = Color(0xFF419F05);
  static const statusButtonYellow = Color(0xFFEE7B0C);
  static const gray200 = Color(0xFFE4E4EA);
  static const gray400 = Color(0xFFAEAEB4);
  static const gray700 = Color(0xFF535358);
  static const gray = Color(0xFFADB5BD);
  static const grayDivider = Color(0xFFD9D9DD);
  static const grayBorder = Color(0xFFC7C7CC);
  static const gray900 = Color(0xFF151519);
  static const darkGray = Color(0xFF8E8E93);
  static const grayControls = Color(0xFFEDEDEF);
  static const grayCupertino = Color(0xFF8F8F8F);
}

extension HexColor on Color {
  static Color fromHex(String hexString) {
    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) {
      buffer.write('ff');
    }

    buffer.write(hexString.replaceFirst('#', ''));

    return Color(int.parse(buffer.toString(), radix: 16));
  }
}