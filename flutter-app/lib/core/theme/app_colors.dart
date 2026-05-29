import 'package:flutter/material.dart';

// Source: design-references/jsx/tokens.jsx — verified values
abstract final class AppColors {
  static const ink         = Color(0xFF0B1228);  // --ink: primary text
  static const inkMute     = Color(0xFF4A5168);  // --ink-mute: secondary text
  static const inkFaint    = Color(0xFF8A91A4);  // --ink-faint: tertiary/disabled
  static const line        = Color(0x140B1228);  // rgba(11,18,40,0.08)
  static const lineStrong  = Color(0x290B1228);  // rgba(11,18,40,0.16)
  static const bg          = Color(0xFFF6F5F0);  // --bg: warm paper
  static const surface     = Color(0xFFFFFFFF);  // --surface: card bg
  static const surfaceMute = Color(0xFFF2F1EB);  // --surfaceMute
  static const surfaceSunk = Color(0xFFEDEBE4);  // --surfaceSunk
  static const accent      = Color(0xFF2356C7);  // --accent: brand blue
  static const accentDark  = Color(0xFF173881);  // accent darkened 35%
  static const accentSoft  = Color(0x1F2356C7);  // accent @ 12% opacity
  static const ok          = Color(0xFF1F8A5B);  // --ok: success
  static const okSoft      = Color(0xFFE2F1EA);  // --okSoft
  static const okLight     = Color(0xFFDCFCE7);  // legacy alias
  static const warn        = Color(0xFFB26A0F);  // --warn: warning
  static const warnSoft    = Color(0xFFF8EEDC);  // --warnSoft
  static const warnLight   = Color(0xFFFEF3C7);  // legacy alias
  static const danger      = Color(0xFFC0392B);  // --danger: error
  static const dangerSoft  = Color(0xFFF8E2DE);  // --dangerSoft
  static const dangerLight = Color(0xFFFEE2E2);  // legacy alias
  static const info        = Color(0xFF2356C7);
  static const infoSoft    = Color(0xFFE6EDFB);  // --infoSoft
}
