import 'colors.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';

const String fontFamilyLato = 'Lato';

// --- Legacy styles ------------------------------------------------------
// Unchanged. add_task_page.dart, advancedDrawer.dart, button.dart, and
// input_field.dart (not touched this phase) still use these directly.

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

/// Correctly-spelled alias for [titelStyle]. New code (this UI/UX pass and
/// beyond) should prefer this name; `titelStyle` stays available for
/// screens not yet migrated.
TextStyle get titleStyle => titelStyle;

// --- New typography hierarchy (UI/UX polish phase) -----------------------

/// Small muted label above a title, e.g. "Good morning".
TextStyle get greetingStyle => TextStyle(
  fontFamily: fontFamilyLato,
  fontSize: 14,
  fontWeight: FontWeight.w500,
  color: Get.isDarkMode
      ? AppColors.darkTextSecondary
      : AppColors.lightTextSecondary,
);

/// All-caps small label for grouping sections (e.g. "MORNING").
TextStyle get sectionHeaderStyle => TextStyle(
  fontFamily: fontFamilyLato,
  fontSize: 12,
  fontWeight: FontWeight.w700,
  letterSpacing: 0.8,
  color: Get.isDarkMode
      ? AppColors.darkTextSecondary
      : AppColors.lightTextSecondary,
);

/// Smallest text — metadata like times, badges, counts.
TextStyle get captionStyle => TextStyle(
  fontFamily: fontFamilyLato,
  fontSize: 12,
  fontWeight: FontWeight.w500,
  color: Get.isDarkMode
      ? AppColors.darkTextSecondary
      : AppColors.lightTextSecondary,
);
