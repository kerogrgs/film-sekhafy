import 'package:flutter/material.dart';
import '../core/constants/app_colors.dart';
import '../models/question.dart';

/// Card that reveals the 3 verified answers for "تلاتة في واحد" challenge
class AnswerRevealCard extends StatelessWidget {
  final Question question;
  final bool isRevealed;
  final VoidCallback onReveal;

  const AnswerRevealCard({
    super.key,
    required this.question,
    required this.isRevealed,
    required this.onReveal,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 350),
      curve: Curves.easeInOut,
      margin: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: isRevealed ? AppColors.surfaceElevated : AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isRevealed ? AppColors.primary : AppColors.border,
          width: isRevealed ? 2 : 1,
        ),
        boxShadow: isRevealed
            ? [
                BoxShadow(
                  color: AppColors.primary.withOpacity(0.15),
                  blurRadius: 16,
                  offset: const Offset(0, 4),
                )
              ]
            : null,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header / Toggle
          InkWell(
            onTap: onReveal,
            borderRadius: BorderRadius.circular(20),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: isRevealed
                          ? AppColors.primary.withOpacity(0.2)
                          : AppColors.surfaceLight,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      isRevealed ? Icons.visibility : Icons.visibility_off,
                      color: isRevealed ? AppColors.primary : AppColors.textSecondary,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      isRevealed ? 'الإجابات النموذجية الثلاثة:' : 'اضغط لإظهار الإجابة (3 إجابات)',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                        color: isRevealed ? AppColors.primary : AppColors.textPrimary,
                      ),
                    ),
                  ),
                  Icon(
                    isRevealed ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                    color: isRevealed ? AppColors.primary : AppColors.textSecondary,
                  ),
                ],
              ),
            ),
          ),

          // Revealed content
          if (isRevealed) ...[
            const Divider(color: AppColors.border, height: 1),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ...List.generate(question.answers.length, (index) {
                    final ans = question.answers[index];
                    return Container(
                      margin: const EdgeInsets.only(bottom: 10),
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 26,
                            height: 26,
                            decoration: const BoxDecoration(
                              color: AppColors.primary,
                              shape: BoxShape.circle,
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              '${index + 1}',
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w900,
                                color: AppColors.textDark,
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              ans,
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                                color: AppColors.textPrimary,
                              ),
                            ),
                          ),
                          const Icon(
                            Icons.check_circle_outline,
                            size: 20,
                            color: AppColors.success,
                          ),
                        ],
                      ),
                    );
                  }),
                  if (question.hint.isNotEmpty) ...[
                    const SizedBox(height: 6),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.08),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: AppColors.primary.withOpacity(0.3),
                        ),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(
                            Icons.lightbulb_outline,
                            size: 18,
                            color: AppColors.primary,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'معلومة إضافية: ${question.hint}',
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: AppColors.primaryLight,
                                height: 1.4,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}
