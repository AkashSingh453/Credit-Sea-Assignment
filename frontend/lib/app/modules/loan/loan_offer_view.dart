import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../theme/app_colors.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/step_indicator.dart';
import 'loan_controller.dart';

class LoanOfferView extends GetView<LoanController> {
  const LoanOfferView({super.key});

  @override
  Widget build(BuildContext context) {
    final currencyFormat = NumberFormat.currency(
      locale: 'en_IN',
      symbol: 'Rs. ',
      decimalDigits: 0,
    );

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: () => Get.back(),
        ),
        title: Text(
          'Our Offerings',
          style: GoogleFonts.inter(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Step 2 Active Indicator
            const StepIndicator(currentStep: 2),
            const Divider(height: 1, color: AppColors.border),

            Expanded(
              child: SingleChildScrollView(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                child: Column(
                  children: [
                    const SizedBox(height: 12),

                    // Section Heading
                    Text(
                      'Our Offerings',
                      style: GoogleFonts.inter(
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 32),

                    // Gold Coin Illustration
                    _buildGoldCoinIllustration(),
                    const SizedBox(height: 36),

                    // Congratulatory Rich Text matching Figma exactly
                    Obx(() {
                      final amount =
                          currencyFormat.format(controller.principalAmount.value);
                      final payable =
                          currencyFormat.format(controller.totalPayable.value);
                      final days = controller.tenureDays.value;

                      return Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        child: RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                            style: GoogleFonts.inter(
                              fontSize: 15,
                              fontWeight: FontWeight.w400,
                              color: AppColors.textSecondary,
                              height: 1.6,
                            ),
                            children: [
                              TextSpan(
                                text: 'Congratulations! ',
                                style: GoogleFonts.inter(
                                  color: const Color(0xFF10B981),
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const TextSpan(text: 'We can offer you '),
                              TextSpan(
                                text: '$amount ',
                                style: GoogleFonts.inter(
                                  color: AppColors.textPrimary,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const TextSpan(text: 'Amount Within '),
                              TextSpan(
                                text: '30 minutes ',
                                style: GoogleFonts.inter(
                                  color: AppColors.textPrimary,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              TextSpan(text: 'for $days days, with a payable amount of '),
                              TextSpan(
                                text: '$payable. ',
                                style: GoogleFonts.inter(
                                  color: AppColors.textPrimary,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const TextSpan(
                                text:
                                    'Just with few more steps. Proceed further to',
                              ),
                            ],
                          ),
                        ),
                      );
                    }),
                    const SizedBox(height: 24),

                    // Benefit badges
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.surfaceLight,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: Column(
                        children: [
                          _buildOfferDetail(
                            icon: Icons.bolt_rounded,
                            title: 'Instant Disbursal',
                            subtitle: 'Transfer directly to your verified bank account',
                          ),
                          const Divider(height: 18, color: AppColors.border),
                          _buildOfferDetail(
                            icon: Icons.lock_outline_rounded,
                            title: '100% Paperless & Secure',
                            subtitle: 'End-to-end encrypted RBI compliant processing',
                          ),
                          const Divider(height: 18, color: AppColors.border),
                          _buildOfferDetail(
                            icon: Icons.event_repeat_rounded,
                            title: 'Flexible Repayment',
                            subtitle: 'No pre-closure or hidden foreclosure penalties',
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 36),

                    // Primary Button: Accept Offer
                    Obx(
                      () => CustomButton(
                        text: 'Accept Offer',
                        isLoading: controller.isSubmitting.value,
                        onPressed: controller.submitLoanApplication,
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Secondary Button: Extend Offer
                    CustomButton(
                      text: 'Extend Offer',
                      isOutlined: true,
                      onPressed: () {
                        Get.snackbar(
                          'Offer Options',
                          'You can customize your loan amount and tenure directly in the calculator.',
                          snackPosition: SnackPosition.BOTTOM,
                          duration: const Duration(seconds: 3),
                        );
                        Get.back();
                      },
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGoldCoinIllustration() {
    return Container(
      width: 140,
      height: 140,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: const RadialGradient(
          center: Alignment(-0.2, -0.2),
          radius: 0.8,
          colors: [
            Color(0xFFFFEE58),
            Color(0xFFFFCA28),
            Color(0xFFFFA000),
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFFFB300).withOpacity(0.35),
            blurRadius: 24,
            spreadRadius: 4,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Center(
        child: Container(
          width: 116,
          height: 116,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: const Color(0xFFFFE082),
              width: 3.5,
            ),
          ),
          child: const Center(
            child: Text(
              '₹',
              style: TextStyle(
                fontSize: 64,
                fontWeight: FontWeight.w900,
                color: Color(0xFF6D4C41),
                height: 1.0,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildOfferDetail({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppColors.primaryBlue.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: AppColors.primaryBlue, size: 20),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: GoogleFonts.inter(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: GoogleFonts.inter(
                  fontSize: 11,
                  fontWeight: FontWeight.w400,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
