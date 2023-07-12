import 'dart:ui';
import 'package:flutter/material.dart';
import 'LayoutHelper.dart';

const Color COLOR_WHITE = Color(0xFFFFFFFFF);
const Color COLOR_PRIMARY_DARK = Color(0xFF0000FF);
const Color COLOR_PRIMARY = Color(0xFF00B0F0);
const Color BLACK_TEXT_COLOR = Color(0xFF000000);
const Color COLOR_GREY = Color(0xFFE0E0E0);
const String? SESSION_DATA = "SessionData";
const String DASHBOARD_CONSTANT = "DashboardConstants";

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
    color: COLOR_PRIMARY,
    fontWeight: FontWeight.w600);

TextStyle smallTxtStyleBoldPriBlue = TextStyle(
    fontSize: LayoutHelper.instance.fontSize - 4,
    color: COLOR_PRIMARY_DARK,
    fontWeight: FontWeight.w600);

TextStyle medTxtStyleBoldPriBlue = TextStyle(
    fontSize: LayoutHelper.instance.fontSize,
    color: COLOR_PRIMARY_DARK,
    fontWeight: FontWeight.w600);

TextStyle regularTxtStyle = TextStyle(
  fontSize: LayoutHelper.instance.fontSize - 2,
  color: COLOR_WHITE,
);

TextStyle regularTxtStyleBlack = TextStyle(
  fontSize: LayoutHelper.instance.fontSize - 2,
  color: Colors.black,
);

TextStyle medTxtStyle = TextStyle(
  fontSize: LayoutHelper.instance.fontSize,
  color: COLOR_WHITE,
);
TextStyle largeTxtStyle = TextStyle(
  fontSize: LayoutHelper.instance.fontSize + 2,
  color: COLOR_WHITE,
);

TextStyle largeTxtStyleBold = TextStyle(
    fontSize: LayoutHelper.instance.fontSize + 2,
    color: COLOR_WHITE,
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
    color: COLOR_WHITE,
    fontWeight: FontWeight.w600);

TextStyle medTxtStyleSemiBoldBlack = TextStyle(
    fontSize: LayoutHelper.instance.fontSize,
    color: Colors.black,
    fontWeight: FontWeight.w600);

TextStyle semiBoldTxtStyle = TextStyle(
    fontSize: LayoutHelper.instance.fontSize - 2,
    color: BLACK_TEXT_COLOR,
    fontWeight: FontWeight.w600);

TextStyle boldTxtStyle = TextStyle(
  fontWeight: FontWeight.bold,
  fontSize: LayoutHelper.instance.fontSize + 2,
  color: BLACK_TEXT_COLOR,
);

TextStyle extraSmallTxtStyle = TextStyle(
  fontSize: LayoutHelper.instance.fontSize - 5,
  color: COLOR_PRIMARY_DARK,
);

String disclamerText = "";
