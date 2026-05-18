import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:builder_bridge/core/theme/app_colors.dart';

// Source: design-references/jsx/tokens.jsx
// Manrope = body, labels. Fraunces = headings/display.
abstract final class AppTypography {
  static TextStyle get displayLarge => GoogleFonts.fraunces(
        fontSize: 28, fontWeight: FontWeight.w600, color: AppColors.ink, height: 1.2);

  static TextStyle get headlineMedium => GoogleFonts.fraunces(
        fontSize: 22, fontWeight: FontWeight.w600, color: AppColors.ink, height: 1.3);

  static TextStyle get headlineSmall => GoogleFonts.fraunces(
        fontSize: 18, fontWeight: FontWeight.w600, color: AppColors.ink, height: 1.4);

  static TextStyle get bodyLarge => GoogleFonts.manrope(
        fontSize: 16, fontWeight: FontWeight.w400, color: AppColors.ink, height: 1.5);

  static TextStyle get bodyMedium => GoogleFonts.manrope(
        fontSize: 14, fontWeight: FontWeight.w400, color: AppColors.ink, height: 1.5);

  static TextStyle get bodySmall => GoogleFonts.manrope(
        fontSize: 12, fontWeight: FontWeight.w400, color: AppColors.inkMute, height: 1.4);

  static TextStyle get labelLarge => GoogleFonts.manrope(
        fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.ink, height: 1.4);

  static TextStyle get labelMedium => GoogleFonts.manrope(
        fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.ink, height: 1.4);

  static TextStyle get labelSmall => GoogleFonts.manrope(
        fontSize: 11, fontWeight: FontWeight.w500, color: AppColors.inkMute, height: 1.3);

  static TextStyle get mono => const TextStyle(
        fontFamily: 'monospace', fontSize: 13,
        fontWeight: FontWeight.w400, color: AppColors.ink, height: 1.4);
}
