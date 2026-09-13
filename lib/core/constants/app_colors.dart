import 'package:flutter/material.dart';

/// App color palette designed for "فيلم ثقافي"
/// Dark football/sports aesthetic with electric yellow/gold accents
class AppColors {
  // Backgrounds
  static const Color background = Color(0xFF0D1117);
  static const Color surface = Color(0xFF161B22);
  static const Color surfaceLight = Color(0xFF21262D);
  static const Color surfaceElevated = Color(0xFF2A313C);
  static const Color border = Color(0xFF30363D);

  // Brand Accents (Vibrant Football Yellow / Gold)
  static const Color primary = Color(0xFFFFD700); // Electric Gold/Yellow
  static const Color primaryLight = Color(0xFFFFE66D);
  static const Color primaryDark = Color(0xFFD4AF37);
  static const Color secondary = Color(0xFF00E5FF); // Electric Cyan

  // Action / Feedback
  static const Color success = Color(0xFF10B981); // Emerald Green (Correct)
  static const Color successLight = Color(0xFF34D399);
  static const Color error = Color(0xFFEF4444); // Crimson Red (Incorrect)
  static const Color errorLight = Color(0xFFF87171);
  static const Color warning = Color(0xFFF59E0B); // Amber

  // Text
  static const Color textPrimary = Color(0xFFF0F6FC);
  static const Color textSecondary = Color(0xFF8B949E);
  static const Color textMuted = Color(0xFF6E7681);
  static const Color textDark = Color(0xFF0D1117);

  // Player Color Accents
  static const List<Color> playerColors = [
    Color(0xFFFFD700), // Player 1: Gold
    Color(0xFF00E5FF), // Player 2: Neon Cyan
    Color(0xFFFF5252), // Player 3: Coral Red
    Color(0xFF69F0AE), // Player 4: Neon Green
  ];

  // Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFFFFD700), Color(0xFFFFA000)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient cardGradient = LinearGradient(
    colors: [Color(0xFF1F2633), Color(0xFF161B22)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static const LinearGradient goldPodiumGradient = LinearGradient(
    colors: [Color(0xFFFFDF00), Color(0xFFD4AF37)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static const LinearGradient silverPodiumGradient = LinearGradient(
    colors: [Color(0xFFE0E0E0), Color(0xFF9E9E9E)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static const LinearGradient bronzePodiumGradient = LinearGradient(
    colors: [Color(0xFFCD7F32), Color(0xFF8C5523)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  // Glow Box Shadows
  static List<BoxShadow> primaryGlow = [
    BoxShadow(
      color: primary.withOpacity(0.35),
      blurRadius: 18,
      spreadRadius: 2,
      offset: const Offset(0, 4),
    ),
  ];

  static List<BoxShadow> successGlow = [
    BoxShadow(
      color: success.withOpacity(0.35),
      blurRadius: 16,
      spreadRadius: 2,
      offset: const Offset(0, 4),
    ),
  ];

  static List<BoxShadow> errorGlow = [
    BoxShadow(
      color: error.withOpacity(0.35),
      blurRadius: 16,
      spreadRadius: 2,
      offset: const Offset(0, 4),
    ),
  ];
}
