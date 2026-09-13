import 'package:flutter/material.dart';
import 'app_colors.dart';

/// Typography definitions for Film Sekhafy
/// Modern Arabic fonts with bold sports hierarchy
class AppTextStyles {
  static const TextStyle brandTitle = TextStyle(
    fontSize: 34,
    fontWeight: FontWeight.w900,
    color: AppColors.primary,
    letterSpacing: -0.5,
    height: 1.2,
  );

  static const TextStyle screenHeader = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w800,
    color: AppColors.textPrimary,
    height: 1.3,
  );

  static const TextStyle subHeader = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w700,
    color: AppColors.textSecondary,
    height: 1.4,
  );

  static const TextStyle questionText = TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.w800,
    color: AppColors.textPrimary,
    height: 1.45,
  );

  static const TextStyle answerText = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
    height: 1.4,
  );

  static const TextStyle buttonLabel = TextStyle(
    fontSize: 17,
    fontWeight: FontWeight.w800,
    color: AppColors.textDark,
    letterSpacing: 0.2,
  );

  static const TextStyle cardTitle = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w800,
    color: AppColors.textPrimary,
  );

  static const TextStyle categoryBadge = TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w700,
    color: AppColors.primary,
  );

  static const TextStyle scoreNumber = TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.w900,
    color: AppColors.primary,
  );

  static const TextStyle body = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: AppColors.textSecondary,
    height: 1.5,
  );
}
