import 'package:flutter/material.dart';

/// Centralized color palette matching the Inventa / Student Registration
/// Figma design.
class AppColors {
  AppColors._();

  // ── Primary blues ──────────────────────────────────────────────────────
  /// Dark navy used for top header bars, navigation, and prominent headings.
  static const Color primaryNavy = Color(0xFF1A3A5C);

  /// Slightly lighter navy for secondary text/icons on dark surfaces.
  static const Color primaryNavyLight = Color(0xFF254E78);

  /// Bright blue used for CTA buttons (Next, Submit, Save, etc.).
  static const Color accentBlue = Color(0xFF2B7DE9);

  /// Lighter tint of accent blue – hover / pressed states.
  static const Color accentBlueLight = Color(0xFF5A9DF4);

  // ── Backgrounds ────────────────────────────────────────────────────────
  /// Page / scaffold background – light cool grey.
  static const Color scaffoldBackground = Color(0xFFF5F5F5);

  /// Card / container surface – pure white.
  static const Color cardWhite = Color(0xFFFFFFFF);

  // ── Text ───────────────────────────────────────────────────────────────
  /// Primary heading text on light surfaces.
  static const Color textDark = Color(0xFF1A1A2E);

  /// Secondary / body text.
  static const Color textMedium = Color(0xFF4A4A68);

  /// Hint & placeholder text.
  static const Color textHint = Color(0xFF9E9EB8);

  // ── Borders & dividers ─────────────────────────────────────────────────
  static const Color border = Color(0xFFE0E0E0);
  static const Color borderFocused = Color(0xFF2B7DE9);

  // ── Success accent ─────────────────────────────────────────────────────
  static const Color successGreen = Color(0xFF34C759);

  // ── Misc ───────────────────────────────────────────────────────────────
  static const Color white = Colors.white;
  static const Color shadow = Color(0x1A000000); // 10 % black
}
