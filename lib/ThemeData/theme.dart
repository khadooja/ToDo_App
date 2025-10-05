import 'package:flutter/material.dart';
import 'colors.dart';

class Themes {
  static final light = ThemeData(
    primaryColor: primaryClr,
    scaffoldBackgroundColor: Colors.white,
    brightness: Brightness.light,
  );

  static final dark = ThemeData(
    primaryColor: darkGreyClr,
    scaffoldBackgroundColor: darkGreyClr,
    brightness: Brightness.dark,
  );
}
