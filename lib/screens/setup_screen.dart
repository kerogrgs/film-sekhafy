import 'dart:math';
import 'package:flutter/material.dart';
import '../core/constants/app_colors.dart';
import '../state/game_state.dart';
import '../widgets/custom_button.dart';
import 'gameplay_screen.dart';

/// Setup Screen for configuring 2-4 local players and game rounds
class SetupScreen extends StatefulWidget {
  const SetupScreen({super.key});

  @override
  State<SetupScreen> createState() => _SetupScreenState();
}

class _SetupScreenState extends State<SetupScreen> {
  int _playerCount = 2;
  int _roundsCount = 5;
  int _turnSeconds = 30;

  final List<TextEditingController> _nameControllers = [];
  final List<String> _suggestedNames = [
    'الحريف',
    'الساحر',
    'الأسطورة',
    'الكابتن',
    'الهداف',
    'المعلم',
    'العمدة',
    'البرنس',
  ];

  @override
  void initState() {
    super.initState();
    _initializeControllers();
  }

  void _initializeControllers() {
    _nameControllers.clear();
    for (int i = 0; i < 4; i++) {
      _nameControllers.add(
        TextEditingController(text: 'اللاعب ${i + 1}'),
      );
    }
  }

  @override
  void dispose() {
    for (var controller in _nameControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void _randomizeName(int index) {
    final random = Random();
    final name = _suggestedNames[random.nextInt(_suggestedNames.length)];
    _nameControllers[index].text = '$name ${index + 1}';
  }

  void _startGame(BuildContext context) async {
    final List<String> finalNames = [];
    for (int i = 0; i < _playerCount; i++) {
      final text = _nameControllers[i].text.trim();
      finalNames.add(text.isEmpty ? 'لاعب ${i + 1}' : text);
    }

    final gameState = GameState();
    await gameState.startNewGame(
      playerNames: finalNames,
      rounds: _roundsCount,
      turnSeconds: _turnSeconds,
    );

    if (mounted) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => GameplayScreen(gameState: gameState),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('إعداد اللعبة'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_forward_ios_rounded, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // 1. Number of Players
              _buildSectionCard(
                title: 'عدد اللاعبين',
                icon: Icons.group_outlined,
                child: Row(
                  children: [2, 3, 4].map((count) {
                    final isSelected = _playerCount == count;
                    return Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4.0),
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              _playerCount = count;
                            });
                          },
                          borderRadius: BorderRadius.circular(12),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? AppColors.primary
                                  : AppColors.surfaceLight,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: isSelected
                                    ? AppColors.primary
                                    : AppColors.border,
                                width: isSelected ? 2 : 1,
                              ),
                              boxShadow: isSelected ? AppColors.primaryGlow : null,
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              '$count لاعبين',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w800,
                                color: isSelected
                                    ? AppColors.textDark
                                    : AppColors.textPrimary,
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),

              const SizedBox(height: 16),

              // 2. Player Names Inputs
              _buildSectionCard(
                title: 'أسماء اللاعبين',
                icon: Icons.badge_outlined,
                child: Column(
                  children: List.generate(_playerCount, (index) {
                    final color = AppColors.playerColors[index % AppColors.playerColors.length];
                    final avatar = GameState.defaultAvatars[index % GameState.defaultAvatars.length];

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12.0),
                      child: Row(
                        children: [
                          Container(
                            width: 38,
                            height: 38,
                            decoration: BoxDecoration(
                              color: color.withOpacity(0.2),
                              shape: BoxShape.circle,
                              border: Border.all(color: color, width: 2),
                            ),
                            alignment: Alignment.center,
                            child: Text(avatar, style: const TextStyle(fontSize: 18)),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: TextField(
                              controller: _nameControllers[index],
                              style: const TextStyle(
                                color: AppColors.textPrimary,
                                fontWeight: FontWeight.w700,
                              ),
                              decoration: InputDecoration(
                                hintText: 'اسم اللاعب ${index + 1}',
                                prefixIcon: Icon(
                                  Icons.person_outline,
                                  color: color,
                                  size: 20,
                                ),
                                suffixIcon: IconButton(
                                  icon: const Icon(
                                    Icons.casino_outlined,
                                    size: 20,
                                    color: AppColors.textSecondary,
                                  ),
                                  tooltip: 'لقب عشوائي',
                                  onPressed: () => _randomizeName(index),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
                ),
              ),

              const SizedBox(height: 16),

              // 3. Rounds Count
              _buildSectionCard(
                title: 'عدد الجولات',
                icon: Icons.repeat_rounded,
                child: Row(
                  children: [3, 5, 7, 10].map((rounds) {
                    final isSelected = _roundsCount == rounds;
                    return Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4.0),
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              _roundsCount = rounds;
                            });
                          },
                          borderRadius: BorderRadius.circular(12),
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? AppColors.primary
                                  : AppColors.surfaceLight,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: isSelected
                                    ? AppColors.primary
                                    : AppColors.border,
                              ),
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              '$rounds جولات',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w800,
                                color: isSelected
                                    ? AppColors.textDark
                                    : AppColors.textPrimary,
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),

              const SizedBox(height: 16),

              // 4. Timer Option
              _buildSectionCard(
                title: 'وقت الإجابة لكل لاعب',
                icon: Icons.timer_outlined,
                child: Row(
                  children: [
                    {'label': '30 ث', 'seconds': 30},
                    {'label': '45 ث', 'seconds': 45},
                    {'label': '60 ث', 'seconds': 60},
                    {'label': 'بدون وقت', 'seconds': 0},
                  ].map((item) {
                    final isSelected = _turnSeconds == item['seconds'];
                    return Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4.0),
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              _turnSeconds = item['seconds'] as int;
                            });
                          },
                          borderRadius: BorderRadius.circular(12),
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? AppColors.secondary
                                  : AppColors.surfaceLight,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: isSelected
                                    ? AppColors.secondary
                                    : AppColors.border,
                              ),
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              item['label'] as String,
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w800,
                                color: isSelected
                                    ? AppColors.textDark
                                    : AppColors.textPrimary,
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),

              const SizedBox(height: 28),

              // Start Game Action
              CustomButton(
                label: 'انطلق في التحدي! ⚽',
                onPressed: () => _startGame(context),
                icon: Icons.sports_soccer_rounded,
                height: 56,
                fontSize: 18,
              ),
              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionCard({
    required String title,
    required IconData icon,
    required Widget child,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 20, color: AppColors.primary),
              const SizedBox(width: 8),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          child,
        ],
      ),
    );
  }
}
