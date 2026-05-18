import 'package:flutter/material.dart';

// Source: design-references/jsx/tokens.jsx — verified values
abstract final class AppColors {
  static const ink       = Color(0xFF0B1228);  // --ink: primary text
  static const inkMute   = Color(0xFF4A5168);  // --ink-mute: secondary text
  static const inkFaint  = Color(0xFF8A91A4);  // --ink-faint: tertiary/disabled
  static const line      = Color(0x140B1228);  // --line: rgba(11,18,40,0.08)
  static const lineStrong = Color(0x290B1228); // rgba(11,18,40,0.16)
  static const bg        = Color(0xFFF6F5F0);  // --bg: warm paper
  static const surface   = Color(0xFFFFFFFF);  // --surface: card bg
  static const accent    = Color(0xFF2356C7);  // --accent: brand blue
  static const accentSoft = Color(0x1F2356C7); // accent @ 12% opacity
  static const ok        = Color(0xFF1F8A5B);  // --ok: success
  static const okLight   = Color(0xFFDCFCE7);
  static const warn      = Color(0xFFB26A0F);  // --warn: warning
  static const warnLight = Color(0xFFFEF3C7);
  static const danger    = Color(0xFFC0392B);  // --danger: error
  static const dangerLight = Color(0xFFFEE2E2);
  static const info      = Color(0xFF2356C7);
}
