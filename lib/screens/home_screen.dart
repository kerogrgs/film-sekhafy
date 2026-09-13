import 'package:flutter/material.dart';
import '../core/constants/app_colors.dart';
import '../widgets/custom_button.dart';
import '../widgets/rules_modal.dart';
import 'setup_screen.dart';

/// Main Home Screen for "فيلم ثقافي"
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight - 40,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Top Bar / Status
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: AppColors.surface,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: AppColors.border),
                          ),
                          child: const Row(
                            children: [
                              Icon(Icons.offline_pin, size: 16, color: AppColors.success),
                              SizedBox(width: 6),
                              Text(
                                'أوفلاين بالكامل',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          onPressed: () => RulesModal.show(context),
                          icon: const Icon(
                            Icons.help_outline_rounded,
                            color: AppColors.primary,
                            size: 26,
                          ),
                          tooltip: 'طريقة اللعب',
                        ),
                      ],
                    ),

                    // Center Hero Branding & Mode Card
                    Column(
                      children: [
                        const SizedBox(height: 20),
                        // Logo Badge
                        Container(
                          width: 84,
                          height: 84,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: AppColors.primaryGradient,
                            boxShadow: AppColors.primaryGlow,
                          ),
                          alignment: Alignment.center,
                          child: const Text('⚽', style: TextStyle(fontSize: 40)),
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'فيلم ثقافي',
                          style: TextStyle(
                            fontSize: 38,
                            fontWeight: FontWeight.w900,
                            color: AppColors.primary,
                            letterSpacing: -0.5,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 6),
                        const Text(
                          'تحدي معلومات كرة القدم مع أصحابك',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textSecondary,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 30),

                        // Mode Highlight Card (Three in One)
                        Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: AppColors.surface,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: AppColors.border, width: 1.5),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.3),
                                blurRadius: 12,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 10,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: AppColors.primary.withOpacity(0.15),
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(
                                        color: AppColors.primary.withOpacity(0.4),
                                      ),
                                    ),
                                    child: const Text(
                                      'الطور الرئيسي',
                                      style: TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.w800,
                                        color: AppColors.primary,
                                      ),
                                    ),
                                  ),
                                  const Spacer(),
                                  const Icon(
                                    Icons.people_alt_rounded,
                                    color: AppColors.secondary,
                                    size: 20,
                                  ),
                                  const SizedBox(width: 4),
                                  const Text(
                                    '٢ إلى ٤ لاعبين',
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w700,
                                      color: AppColors.secondary,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 14),
                              const Text(
                                'تحدي "تلاتة في واحد"',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w900,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                              const SizedBox(height: 6),
                              const Text(
                                'كل سؤال بيطلب منك ٣ عناصر كروية (أندية، لاعبين، أرقام قياسية). مرر الهاتف لصحابك واكتشف مين الحريف الحقيقي!',
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.textSecondary,
                                  height: 1.45,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    // Bottom Actions
                    Column(
                      children: [
                        const SizedBox(height: 30),
                        CustomButton(
                          label: 'ابدأ التحدي ⚡',
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => const SetupScreen(),
                              ),
                            );
                          },
                          icon: Icons.play_arrow_rounded,
                          fontSize: 18,
                          height: 56,
                        ),
                        const SizedBox(height: 12),
                        CustomButton(
                          label: 'كيف تلعب؟',
                          onPressed: () => RulesModal.show(context),
                          variant: ButtonVariant.secondary,
                          icon: Icons.info_outline,
                          height: 50,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
