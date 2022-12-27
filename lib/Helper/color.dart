import 'package:flutter/material.dart';

const MaterialColor primary_app = const MaterialColor(
  0xffFE7E7B,
  const <int, Color>{
    50: primary,
    100: primary,
    200: primary,
    300: primary,
    400: primary,
    500: primary,
    600: primary,
    700: primary,
    800: primary,
    900: primary,
  },
);

const Color primary = Color(0xff9F081B);
const Color secondary = Color(0xffD85663);
const Color fontColor = Color(0xff9F081B);
const Color grad1Color = Color(0xff9F081B);
const Color grad2Color = Color(0xffD85663);
const Color lightWhite2 = Color(0xffEEF2F3);

const Color disableColor = Color(0xffEEF2F9);
const Color pink = Color(0xffd4001d);
const Color red = Colors.red;

const Color lightBlack = Color(0xff52575C);
const Color lightBlack2 = Color(0xff999999);
const Color lightWhite = Color(0xffEEF2F9);

const Color white = Color(0xffFFFFFF);
const Color black = Color(0xff000000);

const Color white10 = Colors.white10;
const Color white30 = Colors.white30;
const Color white70 = Colors.white70;

const Color black54 = Colors.black54;
const Color black12 = Colors.black12;
const Color black26 = Colors.black26;

//Color lightWhite = ISDARK != "" && ISDARK == "true" ?darkColor : lightWhite1;
const Color lightWhite1 = Color(0xffEEF2F9);
const Color darkColor = Color(0xff202844);
const Color darkColor2 = Color(0xff273152);
class AppColor {
  static const Color PrimaryDark = Color(0xffFD531F);
  Color colorPrimary() {
    return Color(0xffD85663);

  }

  Color colorPrimaryDark() {
    return Color(0xff9F081B);
  }

  Color colorBg1() {
    return Color(0xffFFFFFF);
  }

  Color colorBg2() {
    return Color(0xffDCEDF7);
  }

  Color colorEdit() {
    return Color(0xffEEF1F9);
  }

  Color colorTextPrimary() {
    return Color(0xff000000);
  }

  Color colorTextSecondary() {
    return Color(0xff929292);
  }

  Color colorTextThird() {
    return Color(0xffFC631D);
  }

  Color colorTextFour() {
    return Color(0xff2a2a2a);
  }
  Color colorBottom() {
    return Color(0xff9B0619);
  }

  Color colorIcon() {
    return Color(0xff9c9b9b);
  }

  Color colorView() {
    return Color(0xff554747);
  }
}
class MyColor {
  static const Color primary = Color(0xff9F081B);
  static const Color primaryLight = Color(0xffD85663);
  static const Color greyText = Color(0xff757575);
  static const Color greyLight = Color(0xffEEF1F9);
}