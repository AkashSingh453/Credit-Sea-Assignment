import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../theme/app_colors.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_text_field.dart';
import '../../widgets/step_indicator.dart';
import 'profile_setup_controller.dart';

class EmailVerificationView extends GetView<ProfileSetupController> {
  const EmailVerificationView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            const StepIndicator(currentStep: 1),
            const Divider(height: 1, color: AppColors.border),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Back + Title
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () => Get.back(),
                          child: const Icon(Icons.arrow_back,
                              color: AppColors.textPrimary),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          'Personal Email ID',
                          style: GoogleFonts.inter(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // Illustration
                    Center(
                      child: Container(
                        width: 180,
                        height: 140,
                        decoration: BoxDecoration(
                          color: AppColors.surfaceLight,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.email_outlined,
                              size: 56,
                              color: AppColors.primaryBlue,
                            ),
                            const SizedBox(height: 8),
                            Icon(
                              Icons.mark_email_read_outlined,
                              size: 32,
                              color: AppColors.brandGreen,
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 28),

                    // Email field
                    CustomTextField(
                      label: 'Email ID*',
                      hint: 'Enter your email ID',
                      controller: controller.emailController,
                      keyboardType: TextInputType.emailAddress,
                    ),
                    const SizedBox(height: 16),

                    // Error
                    Obx(
                      () => controller.errorMessage.value.isNotEmpty
                          ? Padding(
                              padding: const EdgeInsets.only(bottom: 12),
                              child: Text(
                                controller.errorMessage.value,
                                style: GoogleFonts.inter(
                                  fontSize: 12,
                                  color: AppColors.error,
                                ),
                              ),
                            )
                          : const SizedBox.shrink(),
                    ),

                    const SizedBox(height: 24),

                    // Verify button
                    Obx(
                      () => CustomButton(
                        text: 'Verify',
                        isLoading: controller.isLoading.value,
                        onPressed: controller.saveEmail,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
