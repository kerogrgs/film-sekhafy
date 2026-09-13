import 'package:flutter/material.dart';
import '../core/constants/app_colors.dart';
import '../models/player.dart';

/// Player Avatar widget displaying color badge, emoji avatar, score & active indicator
class PlayerAvatar extends StatelessWidget {
  final Player player;
  final bool isActive;
  final bool showScore;
  final double size;

  const PlayerAvatar({
    super.key,
    required this.player,
    this.isActive = false,
    this.showScore = true,
    this.size = 56,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            // Outer glowing ring if active
            Container(
              width: size + 8,
              height: size + 8,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isActive ? player.color : Colors.transparent,
                  width: 3,
                ),
                boxShadow: isActive
                    ? [
                        BoxShadow(
                          color: player.color.withOpacity(0.4),
                          blurRadius: 12,
                          spreadRadius: 2,
                        ),
                      ]
                    : null,
              ),
            ),
            // Avatar Circle
            Container(
              width: size,
              height: size,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: player.color.withOpacity(0.2),
                border: Border.all(
                  color: player.color,
                  width: 2,
                ),
              ),
              alignment: Alignment.center,
              child: Text(
                player.avatarIcon,
                style: TextStyle(fontSize: size * 0.45),
              ),
            ),
            // Player number badge
            Positioned(
              bottom: 0,
              right: 0,
              child: Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  color: player.color,
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.background, width: 2),
                ),
                alignment: Alignment.center,
                child: Text(
                  '${player.id}',
                  style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w900,
                    color: AppColors.textDark,
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        // Player Name
        Text(
          player.name,
          style: TextStyle(
            fontSize: 13,
            fontWeight: isActive ? FontWeight.w800 : FontWeight.w600,
            color: isActive ? AppColors.textPrimary : AppColors.textSecondary,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        if (showScore) ...[
          const SizedBox(height: 2),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              color: AppColors.surfaceLight,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: isActive ? player.color.withOpacity(0.5) : AppColors.border,
                width: 1,
              ),
            ),
            child: Text(
              '${player.score} نقطة',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w800,
                color: isActive ? player.color : AppColors.textSecondary,
              ),
            ),
          ),
        ],
      ],
    );
  }
}
