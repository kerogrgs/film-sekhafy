import 'package:flutter/material.dart';
import '../core/constants/app_colors.dart';

enum ButtonVariant { primary, secondary, success, error, outline }

/// High impact custom sports button with Arabic label, optional icon and glows
class CustomButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final ButtonVariant variant;
  final bool isFullWidth;
  final double height;
  final double fontSize;

  const CustomButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.variant = ButtonVariant.primary,
    this.isFullWidth = true,
    this.height = 54,
    this.fontSize = 17,
  });

  @override
  Widget build(BuildContext context) {
    Color backgroundColor;
    Color foregroundColor;
    List<BoxShadow>? boxShadow;
    Border? border;

    switch (variant) {
      case ButtonVariant.primary:
        backgroundColor = AppColors.primary;
        foregroundColor = AppColors.textDark;
        boxShadow = onPressed != null ? AppColors.primaryGlow : null;
        break;
      case ButtonVariant.secondary:
        backgroundColor = AppColors.surfaceLight;
        foregroundColor = AppColors.textPrimary;
        border = Border.all(color: AppColors.border, width: 1.5);
        break;
      case ButtonVariant.success:
        backgroundColor = AppColors.success;
        foregroundColor = Colors.white;
        boxShadow = onPressed != null ? AppColors.successGlow : null;
        break;
      case ButtonVariant.error:
        backgroundColor = AppColors.error;
        foregroundColor = Colors.white;
        boxShadow = onPressed != null ? AppColors.errorGlow : null;
        break;
      case ButtonVariant.outline:
        backgroundColor = Colors.transparent;
        foregroundColor = AppColors.primary;
        border = Border.all(color: AppColors.primary, width: 2);
        break;
    }

    final childWidget = Row(
      mainAxisSize: isFullWidth ? MainAxisSize.max : MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (icon != null) ...[
          Icon(icon, size: 22, color: foregroundColor),
          const SizedBox(width: 8),
        ],
        Text(
          label,
          style: TextStyle(
            fontSize: fontSize,
            fontWeight: FontWeight.w800,
            color: foregroundColor,
          ),
        ),
      ],
    );

    return Container(
      width: isFullWidth ? double.infinity : null,
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        boxShadow: boxShadow,
      ),
      child: Material(
        color: onPressed == null ? AppColors.surfaceElevated : backgroundColor,
        borderRadius: BorderRadius.circular(14),
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(14),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              border: border,
            ),
            padding: const EdgeInsets.symmetric(horizontal: 20),
            alignment: Alignment.center,
            child: childWidget,
          ),
        ),
      ),
    );
  }
}
