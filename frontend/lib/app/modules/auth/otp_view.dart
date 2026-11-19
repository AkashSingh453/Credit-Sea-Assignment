import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import '../../theme/app_colors.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/credit_sea_logo.dart';
import 'auth_controller.dart';

class OtpView extends GetView<AuthController> {
  const OtpView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Blue header with carousel (shorter)
          _buildHeader(context),
          // OTP form
          Expanded(child: _buildOtpForm(context)),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      width: double.infinity,
      height: MediaQuery.of(context).size.height * 0.38,
      decoration: const BoxDecoration(
        gradient: AppColors.headerGradient,
      ),
      child: SafeArea(
        bottom: false,
        child: Column(
          children: [
            const SizedBox(height: 12),
            const CreditSeaLogo(size: 30),
            const SizedBox(height: 16),
            // Approval illustration
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                borderRadius: BorderRadius.circular(18),
              ),
              child: const Icon(
                Icons.verified_user_rounded,
                color: Colors.white,
                size: 44,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Instant Loan Approval',
              style: GoogleFonts.inter(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Users will receive approval within minutes',
              style: GoogleFonts.inter(
                fontSize: 12,
                color: Colors.white70,
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildOtpForm(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(28),
          topRight: Radius.circular(28),
        ),
      ),
      transform: Matrix4.translationValues(0, -24, 0),
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(24, 20, 24, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Back button
            IconButton(
              onPressed: () => Get.back(),
              icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
            ),
            const SizedBox(height: 16),

            Center(
              child: Text(
                'Enter OTP',
                style: GoogleFonts.inter(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
            ),
            const SizedBox(height: 8),

            Center(
              child: Obx(
                () => RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      color: AppColors.textSecondary,
                    ),
                    children: [
                      const TextSpan(text: 'Verify OTP, Sent on '),
                      TextSpan(
                        text: '+91 ${controller.phone.value}',
                        style: GoogleFonts.inter(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 32),

            // OTP Input fields
            PinCodeTextField(
              appContext: context,
              length: 4,
              controller: controller.otpController,
              animationType: AnimationType.scale,
              pinTheme: PinTheme(
                shape: PinCodeFieldShape.box,
                borderRadius: BorderRadius.circular(10),
                fieldHeight: 56,
                fieldWidth: 56,
                activeFillColor: Colors.white,
                inactiveFillColor: AppColors.surfaceLight,
                selectedFillColor: Colors.white,
                activeColor: AppColors.primaryBlue,
                inactiveColor: AppColors.border,
                selectedColor: AppColors.primaryBlue,
                borderWidth: 1.5,
              ),
              enableActiveFill: true,
              keyboardType: TextInputType.number,
              textStyle: GoogleFonts.inter(
                fontSize: 22,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
              onChanged: (value) {},
              onCompleted: (value) {
                controller.verifyOtp(value);
              },
            ),
            const SizedBox(height: 8),

            // Timer and resend
            Obx(
              () => Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '00:${controller.timerSeconds.value.toString().padLeft(2, '0')}',
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  if (controller.canResend.value)
                    GestureDetector(
                      onTap: controller.resendOtp,
                      child: Text(
                        'Resend Code',
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: AppColors.primaryBlue,
                        ),
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // Error
            Obx(
              () => controller.errorMessage.value.isNotEmpty
                  ? Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Center(
                        child: Text(
                          controller.errorMessage.value,
                          style: GoogleFonts.inter(
                            fontSize: 13,
                            color: AppColors.error,
                          ),
                        ),
                      ),
                    )
                  : const SizedBox.shrink(),
            ),

            // Verify button
            Obx(
              () => CustomButton(
                text: 'Verify',
                isLoading: controller.isLoading.value,
                onPressed: () {
                  // Manual verify if not auto-completed
                  if (controller.otpController.text.length == 4) {
                    controller.verifyOtp(controller.otpController.text);
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
