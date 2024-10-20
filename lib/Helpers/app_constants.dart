import 'package:flutter/material.dart';
import 'layout_helper.dart';

const Color colorWhite = Color(0xFFFFFFFF);
const Color colorPrimaryDark = Color(0xFF0000FF);
const Color colorPrimary = Color(0xFF00B0F0);
const Color blackTextColor = Color(0xFF000000);
const Color colorGrey = Color(0xFFE0E0E0);
const String sessionData = "SessionData";
const String dashboardConstant = "DashboardConstants";

const TextStyle regularTxtStyleWithNoSize = TextStyle(
  color: Colors.black,
);

TextStyle smallTxtStyle = TextStyle(
  fontSize: LayoutHelper.instance.fontSize - 4,
  color: Colors.grey[500],
);

TextStyle smallTxtStyleBold = TextStyle(
    fontSize: LayoutHelper.instance.fontSize - 4,
    color: Colors.grey[500],
    fontWeight: FontWeight.w600);

TextStyle smallTxtStyleBoldBlue = TextStyle(
    fontSize: LayoutHelper.instance.fontSize - 4,
    color: colorPrimary,
    fontWeight: FontWeight.w600);

TextStyle smallTxtStyleBoldPriBlue = TextStyle(
    fontSize: LayoutHelper.instance.fontSize - 4,
    color: colorPrimaryDark,
    fontWeight: FontWeight.w600);

TextStyle medTxtStyleBoldPriBlue = TextStyle(
    fontSize: LayoutHelper.instance.fontSize,
    color: colorPrimaryDark,
    fontWeight: FontWeight.w600);

TextStyle regularTxtStyle = TextStyle(
  fontSize: LayoutHelper.instance.fontSize - 2,
  color: colorWhite,
);

TextStyle regularTxtStyleBlack = TextStyle(
  fontSize: LayoutHelper.instance.fontSize - 2,
  color: Colors.black,
);

TextStyle medTxtStyle = TextStyle(
  fontSize: LayoutHelper.instance.fontSize,
  color: colorWhite,
);
TextStyle largeTxtStyle = TextStyle(
  fontSize: LayoutHelper.instance.fontSize + 2,
  color: colorWhite,
);

TextStyle largeTxtStyleBold = TextStyle(
    fontSize: LayoutHelper.instance.fontSize + 2,
    color: colorWhite,
    fontWeight: FontWeight.w600);
TextStyle largeTxtStyleBoldBlack = TextStyle(
    fontSize: LayoutHelper.instance.fontSize + 2,
    color: Colors.black,
    fontWeight: FontWeight.w600);
TextStyle menuTxtStyleSemiBold = TextStyle(
    fontSize: LayoutHelper.instance.fontSize + 2,
    color: Colors.black,
    fontWeight: FontWeight.w600);

TextStyle medTxtStyleSemiBold = TextStyle(
    fontSize: LayoutHelper.instance.fontSize,
    color: colorWhite,
    fontWeight: FontWeight.w600);

TextStyle medTxtStyleSemiBoldBlack = TextStyle(
    fontSize: LayoutHelper.instance.fontSize,
    color: Colors.black,
    fontWeight: FontWeight.w600);

TextStyle semiBoldTxtStyle = TextStyle(
    fontSize: LayoutHelper.instance.fontSize - 2,
    color: blackTextColor,
    fontWeight: FontWeight.w600);

TextStyle boldTxtStyle = TextStyle(
  fontWeight: FontWeight.bold,
  fontSize: LayoutHelper.instance.fontSize + 2,
  color: blackTextColor,
);

TextStyle extraSmallTxtStyle = TextStyle(
  fontSize: LayoutHelper.instance.fontSize - 5,
  color: colorPrimaryDark,
);

String disclamerText = "";
