import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  static const Color background = Color(0xFF0B0B0E);
  static const Color surface = Color(0xFF16161A);
  static const Color surfaceSecondary = Color(0xFF1F1F24);
  static const Color cardBorder = Color(0x14FFFFFF);

  static const Color primaryOrange = Color(0xFFFF5714);
  static const Color primaryOrangeLight = Color(0xFFFF6A28);
  static const Color primaryOrangeGlow = Color(0x40FF5714);
  static const Color primaryOrangeSoft = Color(0x1AFF5714);

  static const LinearGradient orangeGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFFF6A28), Color(0xFFFF4800)],
  );

  static const Color textPrimary = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xFF8E8E93);
  static const Color textMuted = Color(0xFF55555C);

  static const Color success = Color(0xFF34C759);
  static const Color successSoft = Color(0x1A34C759);
  static const Color warning = Color(0xFFFF9F0A);
  static const Color warningSoft = Color(0x1AFF9F0A);
  static const Color info = Color(0xFF0A84FF);
  static const Color infoSoft = Color(0x1A0A84FF);
  static const Color purple = Color(0xFFBF5AF2);
  static const Color purpleSoft = Color(0x1ABF5AF2);

  static const Color activeChipText = Color(0xFF0B0B0E);
  static const Color chipBackground = Color(0xFF18181D);
}

// Reusable theme-level colors as random-access helper
const Map<String, Color> tagColors = {
  'work': Color(0xFF0A84FF),
  'personal': Color(0xFFBF5AF2),
  'urgent': Color(0xFFFF5714),
  'health': Color(0xFF34C759),
  'study': Color(0xFFFF9F0A),
};
