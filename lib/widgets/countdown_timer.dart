import 'package:flutter/material.dart';
import '../core/constants/app_colors.dart';

/// Animated countdown timer for turns
class CountdownTimerWidget extends StatelessWidget {
  final int remainingSeconds;
  final int totalSeconds;
  final bool isRunning;

  const CountdownTimerWidget({
    super.key,
    required this.remainingSeconds,
    required this.totalSeconds,
    required this.isRunning,
  });

  @override
  Widget build(BuildContext context) {
    if (totalSeconds == 0) {
      // Unlimited timer
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: AppColors.surfaceLight,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColors.border),
        ),
        child: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.all_inclusive, size: 18, color: AppColors.primary),
            SizedBox(width: 6),
            Text(
              'بدون وقت',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
          ],
        ),
      );
    }

    final fraction = totalSeconds > 0 ? (remainingSeconds / totalSeconds).clamp(0.0, 1.0) : 0.0;
    final isCritical = remainingSeconds <= 5;
    final isWarning = remainingSeconds <= 10 && remainingSeconds > 5;

    final color = isCritical
        ? AppColors.error
        : (isWarning ? AppColors.warning : AppColors.primary);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.surfaceLight,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: color.withOpacity(0.4),
          width: 1.5,
        ),
        boxShadow: isCritical
            ? [
                BoxShadow(
                  color: AppColors.error.withOpacity(0.3),
                  blurRadius: 10,
                  spreadRadius: 1,
                )
              ]
            : null,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 22,
            height: 22,
            child: CircularProgressIndicator(
              value: fraction,
              strokeWidth: 3,
              backgroundColor: AppColors.border,
              valueColor: AlwaysStoppedAnimation<Color>(color),
            ),
          ),
          const SizedBox(width: 10),
          Text(
            '$remainingSeconds ثانية',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w800,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
