import 'package:flutter/material.dart';
import '../core/constants/app_colors.dart';
import '../models/game_session.dart';
import '../state/game_state.dart';
import '../widgets/answer_reveal_card.dart';
import '../widgets/countdown_timer.dart';
import '../widgets/custom_button.dart';
import '../widgets/player_avatar.dart';
import 'winner_screen.dart';

/// Main Gameplay Screen for "Three in One" (تلاتة في واحد) local multiplayer mode
class GameplayScreen extends StatefulWidget {
  final GameState gameState;

  const GameplayScreen({super.key, required this.gameState});

  @override
  State<GameplayScreen> createState() => _GameplayScreenState();
}

class _GameplayScreenState extends State<GameplayScreen> {
  @override
  void initState() {
    super.initState();
    widget.gameState.addListener(_onGameStateChanged);
  }

  @override
  void dispose() {
    widget.gameState.removeListener(_onGameStateChanged);
    super.dispose();
  }

  void _onGameStateChanged() {
    if (!mounted) return;
    if (widget.gameState.status == GameStatus.finished) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => WinnerScreen(gameState: widget.gameState),
        ),
      );
    } else {
      setState(() {});
    }
  }

  void _confirmQuit(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.warning_amber_rounded, color: AppColors.error),
            SizedBox(width: 8),
            Text(
              'إنهاء اللعبة؟',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
            ),
          ],
        ),
        content: const Text(
          'هل تريد الخروج والعودة للقائمة الرئيسية؟ ستفقد التقدم الحالي.',
          style: TextStyle(fontSize: 14, color: AppColors.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('إلغاء', style: TextStyle(color: AppColors.textSecondary)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
            onPressed: () {
              widget.gameState.resetGame();
              Navigator.pop(ctx);
              Navigator.of(context).popUntil((route) => route.isFirst);
            },
            child: const Text('خروج', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final session = widget.gameState.session;
    if (session == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator(color: AppColors.primary)),
      );
    }

    final activePlayer = widget.gameState.activePlayer;
    final currentQuestion = widget.gameState.currentQuestion;
    final isPassPhase = widget.gameState.status == GameStatus.readyToPass;

    return WillPopScope(
      onWillPop: () async {
        _confirmQuit(context);
        return false;
      },
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          title: Text('الجولة ${widget.gameState.currentRound} من ${widget.gameState.totalRounds}'),
          leading: IconButton(
            icon: const Icon(Icons.close, color: AppColors.textSecondary),
            onPressed: () => _confirmQuit(context),
            tooltip: 'إنهاء التحدي',
          ),
          actions: [
            // Turn timer display
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
              child: CountdownTimerWidget(
                remainingSeconds: widget.gameState.remainingSeconds,
                totalSeconds: session.secondsPerTurn,
                isRunning: widget.gameState.isTimerActive,
              ),
            ),
          ],
        ),
        body: SafeArea(
          child: Column(
            children: [
              // 1. Players Live Score Strip
              Container(
                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                decoration: const BoxDecoration(
                  color: AppColors.surface,
                  border: Border(
                    bottom: BorderSide(color: AppColors.border),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: session.players.map((p) {
                    final isActive = p.id == activePlayer?.id;
                    return Expanded(
                      child: PlayerAvatar(
                        player: p,
                        isActive: isActive,
                        size: 40,
                      ),
                    );
                  }).toList(),
                ),
              ),

              // 2. Main Arena (Pass Phone Phase OR Active Question Phase)
              Expanded(
                child: isPassPhase
                    ? _buildPassPhoneView(context, activePlayer!)
                    : _buildQuestionPlayView(context, activePlayer!, currentQuestion),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Screen shown between turns so the question is hidden while passing the phone
  Widget _buildPassPhoneView(BuildContext context, dynamic activePlayer) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 28.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Active Player Glowing Badge
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: activePlayer.color.withOpacity(0.15),
                border: Border.all(color: activePlayer.color, width: 3),
                boxShadow: [
                  BoxShadow(
                    color: activePlayer.color.withOpacity(0.35),
                    blurRadius: 20,
                    spreadRadius: 3,
                  ),
                ],
              ),
              alignment: Alignment.center,
              child: Text(
                activePlayer.avatarIcon,
                style: const TextStyle(fontSize: 48),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'دور ${activePlayer.name}',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w900,
                color: activePlayer.color,
              ),
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.border),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.phone_android_rounded, size: 20, color: AppColors.primary),
                  SizedBox(width: 8),
                  Text(
                    'مرر الهاتف للاعب الحالي',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 36),
            CustomButton(
              label: 'أنا جاهز، اكشف السؤال! 🚀',
              onPressed: () {
                widget.gameState.confirmReadyAndStartTurn();
              },
              icon: Icons.play_arrow_rounded,
              height: 56,
              fontSize: 18,
            ),
          ],
        ),
      ),
    );
  }

  /// Screen shown during active question
  Widget _buildQuestionPlayView(
    BuildContext context,
    dynamic activePlayer,
    dynamic currentQuestion,
  ) {
    if (currentQuestion == null) {
      return const Center(
        child: Text('جاري تحميل السؤال...', style: TextStyle(color: AppColors.textSecondary)),
      );
    }

    final isRevealed = widget.gameState.isAnswerRevealed;

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Active Player Mini Tag
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: activePlayer.color.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: activePlayer.color, width: 1.5),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(activePlayer.avatarIcon, style: const TextStyle(fontSize: 14)),
                    const SizedBox(width: 6),
                    Text(
                      'اللاعب: ${activePlayer.name}',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w800,
                        color: activePlayer.color,
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              // Category Tag
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.surfaceLight,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.border),
                ),
                child: Text(
                  currentQuestion.category,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primary,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Main Question Card
          Container(
            padding: const EdgeInsets.all(22),
            decoration: BoxDecoration(
              gradient: AppColors.cardGradient,
              borderRadius: BorderRadius.circular(22),
              border: Border.all(color: AppColors.border, width: 1.5),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.4),
                  blurRadius: 16,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Icon(Icons.sports_soccer_rounded, color: AppColors.primary, size: 20),
                    SizedBox(width: 8),
                    Text(
                      'تحدي "تلاتة في واحد"',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w800,
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                Text(
                  currentQuestion.question,
                  style: const TextStyle(
                    fontSize: 21,
                    fontWeight: FontWeight.w900,
                    color: AppColors.textPrimary,
                    height: 1.45,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // 3-in-1 Reveal Answer Card
          AnswerRevealCard(
            question: currentQuestion,
            isRevealed: isRevealed,
            onReveal: () {
              if (!isRevealed) {
                widget.gameState.revealAnswer();
              }
            },
          ),

          const SizedBox(height: 20),

          // Scoring Action Buttons (Correct / Incorrect)
          Row(
            children: [
              // Incorrect Button (0 pts)
              Expanded(
                child: CustomButton(
                  label: 'إجابة خاطئة (0)',
                  onPressed: () {
                    widget.gameState.recordAnswer(isCorrect: false);
                  },
                  variant: ButtonVariant.error,
                  icon: Icons.cancel_outlined,
                  height: 54,
                  fontSize: 15,
                ),
              ),
              const SizedBox(width: 14),
              // Correct Button (+1 pt)
              Expanded(
                child: CustomButton(
                  label: 'إجابة صحيحة (+1)',
                  onPressed: () {
                    widget.gameState.recordAnswer(isCorrect: true);
                  },
                  variant: ButtonVariant.success,
                  icon: Icons.check_circle_outline_rounded,
                  height: 54,
                  fontSize: 15,
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
