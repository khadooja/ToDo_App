import 'package:flutter/material.dart';

// --- Legacy tokens ----------------------------------------------------
// Kept exactly as before. Screens not yet touched by the UI/UX polish pass
// (add_task_page.dart, advancedDrawer.dart, button.dart, input_field.dart)
// still reference these directly.
const Color bluishClr = Color(0xFF4e5ae8);
const Color orangeClr = Color(0xCFFF8746);
const Color pinkClr = Color(0xFFff4667);
const Color white = Colors.white;
const primaryClr = bluishClr;
const Color darkGreyClr = Color(0xFF121212);
const Color darkHeaderClr = Color(0xFF424242);

// --- New design tokens (UI/UX polish phase) ----------------------------
// A richer palette layered on top of the legacy colors above — additive,
// not a replacement, so nothing that already works needs to change.
class AppColors {
  AppColors._();

  static const primary = bluishClr;

  // Task accent colors: same 3 categories as the existing TaskColor enum,
  // just also exposed as soft "tint" backgrounds for card surfaces instead
  // of the old full-bleed saturated fill.
  static Color taskTint(Color base, bool isDark) {
    // ignore: deprecated_member_use
    return isDark ? base.withOpacity(0.18) : base.withOpacity(0.10);
  }

  // Surfaces
  static const lightBackground = Color(0xFFF7F7FB);
  static const lightSurface = Colors.white;
  static const darkBackground = Color(0xFF121212);
  static const darkSurface = Color(0xFF1E1E22);

  // Text
  static const lightTextPrimary = Color(0xFF1B1B1F);
  static const lightTextSecondary = Color(0xFF6B6B76);
  static const darkTextPrimary = Colors.white;
  static const darkTextSecondary = Color(0xFFA3A3AD);

  // Semantic
  static const success = Color(0xFF2FB380);
  static const danger = Color(0xFFE5484D);
  static const warning = Color(0xFFF5A524);
}
