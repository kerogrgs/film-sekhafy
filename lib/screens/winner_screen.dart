import 'package:flutter/material.dart';
import '../core/constants/app_colors.dart';
import '../models/player.dart';
import '../state/game_state.dart';
import '../widgets/confetti_effect.dart';
import '../widgets/custom_button.dart';
import 'gameplay_screen.dart';

/// Winner & Final Scoreboard Screen with celebration and detailed match recap
class WinnerScreen extends StatelessWidget {
  final GameState gameState;

  const WinnerScreen({super.key, required this.gameState});

  @override
  Widget build(BuildContext context) {
    final ranked = gameState.session?.rankedPlayers ?? [];
    final winner = ranked.isNotEmpty ? ranked.first : null;
    final isDraw = ranked.length > 1 && ranked[0].score == ranked[1].score && ranked[0].score > 0;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: ConfettiEffect(
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 10),
                // Top Trophy & Celebration Title
                Center(
                  child: Column(
                    children: [
                      Container(
                        width: 90,
                        height: 90,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: AppColors.goldPodiumGradient,
                          boxShadow: AppColors.primaryGlow,
                        ),
                        alignment: Alignment.center,
                        child: const Text('🏆', style: TextStyle(fontSize: 48)),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        isDraw ? 'تعادل رائع بين الأبطال!' : 'مبروك لبطل فيلم ثقافي!',
                        style: const TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.w900,
                          color: AppColors.primary,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 6),
                      if (winner != null && !isDraw)
                        Text(
                          'تألق كروي كبير من اللاعب ${winner.name} 👏',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textPrimary,
                          ),
                          textAlign: TextAlign.center,
                        ),
                    ],
                  ),
                ),

                const SizedBox(height: 28),

                // Winner Podium Section (Top 3)
                if (ranked.length >= 2) _buildPodium(ranked),

                const SizedBox(height: 24),

                // Complete Match Leaderboard Table
                Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Row(
                        children: [
                          Icon(Icons.leaderboard_rounded, color: AppColors.primary, size: 20),
                          SizedBox(width: 8),
                          Text(
                            'جدول الترتيب النهائي',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w800,
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),
                      const Divider(color: AppColors.border, height: 1),
                      const SizedBox(height: 10),
                      ...List.generate(ranked.length, (index) {
                        final player = ranked[index];
                        return _buildPlayerScoreRow(player, index + 1);
                      }),
                    ],
                  ),
                ),

                const SizedBox(height: 28),

                // Bottom Action Buttons
                CustomButton(
                  label: 'العب مرة تانية مع نفس اللاعبين 🔄',
                  onPressed: () async {
                    await gameState.rematch();
                    if (context.mounted) {
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          builder: (context) => GameplayScreen(gameState: gameState),
                        ),
                      );
                    }
                  },
                  icon: Icons.replay_rounded,
                  height: 56,
                  fontSize: 17,
                ),
                const SizedBox(height: 12),
                CustomButton(
                  label: 'العودة للقائمة الرئيسية',
                  onPressed: () {
                    gameState.resetGame();
                    Navigator.of(context).popUntil((route) => route.isFirst);
                  },
                  variant: ButtonVariant.secondary,
                  icon: Icons.home_rounded,
                  height: 50,
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Interactive podium rendering 1st, 2nd, and 3rd players
  Widget _buildPodium(List<Player> ranked) {
    final first = ranked[0];
    final second = ranked[1];
    final third = ranked.length > 2 ? ranked[2] : null;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        // 2nd Place (Silver)
        Expanded(
          child: _buildPodiumPillar(
            player: second,
            placeText: '🥈 الثاني',
            height: 110,
            gradient: AppColors.silverPodiumGradient,
            color: const Color(0xFFB0BEC5),
          ),
        ),
        const SizedBox(width: 8),

        // 1st Place (Gold)
        Expanded(
          child: _buildPodiumPillar(
            player: first,
            placeText: '🥇 الأول',
            height: 140,
            gradient: AppColors.goldPodiumGradient,
            color: AppColors.primary,
          ),
        ),
        const SizedBox(width: 8),

        // 3rd Place (Bronze) if 3+ players
        if (third != null)
          Expanded(
            child: _buildPodiumPillar(
              player: third,
              placeText: '🥉 الثالث',
              height: 90,
              gradient: AppColors.bronzePodiumGradient,
              color: const Color(0xFFBCAAA4),
            ),
          )
        else
          const Spacer(),
      ],
    );
  }

  Widget _buildPodiumPillar({
    required Player player,
    required String placeText,
    required double height,
    required LinearGradient gradient,
    required Color color,
  }) {
    return Column(
      children: [
        Text(
          player.avatarIcon,
          style: const TextStyle(fontSize: 28),
        ),
        const SizedBox(height: 4),
        Text(
          player.name,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w800,
            color: color,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 2),
        Text(
          '${player.score} نقطة',
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          height: height,
          width: double.infinity,
          decoration: BoxDecoration(
            gradient: gradient,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
            boxShadow: [
              BoxShadow(
                color: color.withOpacity(0.3),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          alignment: Alignment.center,
          child: Text(
            placeText,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w900,
              color: AppColors.textDark,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPlayerScoreRow(Player player, int rank) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.surfaceLight,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: rank == 1 ? AppColors.primary.withOpacity(0.4) : AppColors.border,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              color: rank == 1 ? AppColors.primary : AppColors.surface,
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: Text(
              '$rank',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w900,
                color: rank == 1 ? AppColors.textDark : AppColors.textSecondary,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Text(player.avatarIcon, style: const TextStyle(fontSize: 18)),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  player.name,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary,
                  ),
                ),
                Text(
                  'أجاب على ${player.correctAnswers} من ${player.totalAnswered}',
                  style: const TextStyle(
                    fontSize: 11,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.15),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              '${player.score} نقطة',
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w900,
                color: AppColors.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
