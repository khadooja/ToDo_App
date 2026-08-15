import 'colors.dart';
import 'app_spacing.dart';
import 'package:flutter/material.dart';
 
class Themes {
  static final light = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    primaryColor: primaryClr,
    scaffoldBackgroundColor: AppColors.lightBackground,
    colorScheme: ColorScheme.fromSeed(
      seedColor: primaryClr,
      brightness: Brightness.light,
    ).copyWith(surface: AppColors.lightSurface),
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      centerTitle: false,
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: primaryClr,
      foregroundColor: Colors.white,
      elevation: 2,
      extendedTextStyle: const TextStyle(fontWeight: FontWeight.w700),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.pill),
      ),
    ),
    // Themes the full calendar picker opened from the date strip (see
    // TaskDateStrip) to match the app's accent color instead of Flutter's
    // generic Material default.
    datePickerTheme: DatePickerThemeData(
      backgroundColor: AppColors.lightSurface,
      headerBackgroundColor: primaryClr,
      headerForegroundColor: Colors.white,
      todayForegroundColor: WidgetStateProperty.all(primaryClr),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.lg),
      ),
    ),
  );
 
  static final dark = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    primaryColor: darkGreyClr,
    scaffoldBackgroundColor: AppColors.darkBackground,
    colorScheme: ColorScheme.fromSeed(
      seedColor: primaryClr,
      brightness: Brightness.dark,
    ).copyWith(surface: AppColors.darkSurface),
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      centerTitle: false,
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: primaryClr,
      foregroundColor: Colors.white,
      elevation: 2,
      extendedTextStyle: const TextStyle(fontWeight: FontWeight.w700),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.pill),
      ),
    ),
    datePickerTheme: DatePickerThemeData(
      backgroundColor: AppColors.darkSurface,
      headerBackgroundColor: primaryClr,
      headerForegroundColor: Colors.white,
      todayForegroundColor: WidgetStateProperty.all(primaryClr),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.lg),
      ),
    ),
  );
}
 