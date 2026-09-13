import 'package:flutter/material.dart';
import '../core/constants/app_colors.dart';
import 'custom_button.dart';

/// Modal dialog explaining the "تلاتة في واحد" (Three in One) game rules in Arabic
class RulesModal extends StatelessWidget {
  const RulesModal({super.key});

  static void show(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => const RulesModal(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      child: Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.menu_book, color: AppColors.primary, size: 24),
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Text(
                    'قواعد تحدي "تلاتة في واحد"',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close, color: AppColors.textSecondary),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Divider(color: AppColors.border, height: 1),
            const SizedBox(height: 16),
            _buildRuleItem(
              number: '١',
              title: 'تمرير الهاتف (Pass & Play)',
              description: 'اللعبة محلية، يمرر الهاتف لكل لاعب في دوره للإجابة.',
            ),
            _buildRuleItem(
              number: '٢',
              title: 'مطلوب ٣ إجابات',
              description: 'كل سؤال يطلب ذكر ٣ عناصر كروية (مثلاً ٣ لاعبين، ٣ أندية، ٣ هدافين).',
            ),
            _buildRuleItem(
              number: '٣',
              title: 'إظهار الإجابة واحتساب النقطة',
              description: 'بعد إجابة اللاعب، يتم الضغط على "إظهار الإجابة" للتحقق. إذا أجاب صح يضغط "إجابة صحيحة" (+١ نقطة).',
            ),
            _buildRuleItem(
              number: '٤',
              title: 'تحديد بطل الجلسة',
              description: 'في نهاية الجولات المحددة، يفوز اللاعب صاحب أكبر عدد من النقاط بكأس فيلم ثقافي!',
            ),
            const SizedBox(height: 20),
            CustomButton(
              label: 'فهمت، يلا نلعب!',
              onPressed: () => Navigator.pop(context),
              height: 48,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRuleItem({
    required String number,
    required String title,
    required String description,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 26,
            height: 26,
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.2),
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.primary, width: 1),
            ),
            alignment: Alignment.center,
            child: Text(
              number,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w900,
                color: AppColors.primary,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  description,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textSecondary,
                    height: 1.35,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
