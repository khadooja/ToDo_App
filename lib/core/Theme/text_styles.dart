import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'colors.dart';

const String fontFamilyLato = 'Lato';

TextStyle get headingStyle => TextStyle(
  fontFamily: fontFamilyLato,
  fontSize: 24,
  fontWeight: FontWeight.bold,
  color: Get.isDarkMode ? Colors.white : darkGreyClr,
);

TextStyle get subheadingStyle => TextStyle(
  fontFamily: fontFamilyLato,
  fontSize: 20,
  fontWeight: FontWeight.bold,
  color: Get.isDarkMode ? Colors.white : darkGreyClr,
);

TextStyle get titelStyle => TextStyle(
  fontFamily: fontFamilyLato,
  fontSize: 18,
  fontWeight: FontWeight.bold,
  color: Get.isDarkMode ? Colors.white : darkGreyClr,
);

TextStyle get subtitelStyle => TextStyle(
  fontFamily: fontFamilyLato,
  fontSize: 16,
  fontWeight: FontWeight.w400,
  color: Get.isDarkMode ? Colors.white : darkGreyClr,
);

TextStyle get bodyStyle => TextStyle(
  fontFamily: fontFamilyLato,
  fontSize: 14,
  fontWeight: FontWeight.w400,
  color: Get.isDarkMode ? Colors.white : darkGreyClr,
);

TextStyle get body2Style => TextStyle(
  fontFamily: fontFamilyLato,
  fontSize: 14,
  fontWeight: FontWeight.w400,
  color: Get.isDarkMode ? Colors.grey[200] : darkGreyClr,
);
