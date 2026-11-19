import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../theme/app_colors.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/credit_sea_logo.dart';
import 'auth_controller.dart';

class LoginView extends GetView<AuthController> {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Top section — blue header with carousel
          _buildHeader(context),

          // Bottom section — login form
          Expanded(
            child: _buildLoginForm(context),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    return Container(
      width: double.infinity,
      height: screenHeight * 0.44,
      decoration: const BoxDecoration(
        gradient: AppColors.headerGradient,
      ),
      child: SafeArea(
        bottom: false,
        child: Column(
          children: [
            const SizedBox(height: 12),
            const CreditSeaLogo(size: 32),
            const SizedBox(height: 12),

            // Feature carousel
            Expanded(
              child: PageView(
                controller: controller.carouselController,
                onPageChanged: (i) => controller.currentCarouselPage.value = i,
                children: [
                  _buildFeatureSlide(
                    icon: Icons.account_balance_rounded,
                    icon2: Icons.currency_exchange_rounded,
                    icon3: Icons.laptop_mac_rounded,
                    icon4: Icons.phone_android_rounded,
                    title: 'Flexible Loan Options',
                    subtitle:
                        'Loan types to cater to different financial needs',
                  ),
                  _buildFeatureSlide(
                    icon: Icons.verified_rounded,
                    icon2: Icons.speed_rounded,
                    icon3: Icons.flash_on_rounded,
                    icon4: Icons.shield_rounded,
                    title: 'Instant Loan Approval',
                    subtitle:
                        'Users will receive approval within minutes',
                  ),
                  _buildFeatureSlide(
                    icon: Icons.headset_mic_rounded,
                    icon2: Icons.support_agent_rounded,
                    icon3: Icons.star_rounded,
                    icon4: Icons.chat_rounded,
                    title: '24x7 Customer Care',
                    subtitle: 'Dedicated customer support team',
                  ),
                ],
              ),
            ),

            // Dots indicator
            Obx(
              () => Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(3, (index) {
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    width:
                        controller.currentCarouselPage.value == index ? 24 : 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: controller.currentCarouselPage.value == index
                        ? Colors.white
                        : Colors.white38,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  );
                }),
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureSlide({
    required IconData icon,
    required IconData icon2,
    required IconData icon3,
    required IconData icon4,
    required String title,
    required String subtitle,
  }) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // 2x2 icon grid
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _featureIcon(icon),
            const SizedBox(width: 10),
            _featureIcon(icon2),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _featureIcon(icon3),
            const SizedBox(width: 10),
            _featureIcon(icon4),
          ],
        ),
        const SizedBox(height: 12),
        Text(
          title,
          style: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 2),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            subtitle,
            style: GoogleFonts.inter(
              fontSize: 12,
              color: Colors.white70,
            ),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _featureIcon(IconData icon) {
    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.12),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(icon, color: Colors.white, size: 22),
    );
  }

  Widget _buildLoginForm(BuildContext context) {
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
        padding: const EdgeInsets.fromLTRB(24, 32, 24, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Text(
                'Welcome to Credit Sea!',
                style: GoogleFonts.inter(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
            ),
            const SizedBox(height: 28),

            // Mobile Number label
            Text(
              'Mobile Number',
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 10),

            // Phone input with +91 prefix
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.border),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  // Country code
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                    decoration: const BoxDecoration(
                      border: Border(
                        right: BorderSide(color: AppColors.border),
                      ),
                    ),
                    child: Row(
                      children: [
                        Text('🇮🇳', style: const TextStyle(fontSize: 18)),
                        const SizedBox(width: 6),
                        Text(
                          '+91',
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Phone field
                  Expanded(
                    child: TextField(
                      controller: controller.phoneController,
                      keyboardType: TextInputType.phone,
                      maxLength: 10,
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        color: AppColors.textPrimary,
                      ),
                      decoration: InputDecoration(
                        hintText: 'Please enter your mobile no.',
                        counterText: '',
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 14,
                        ),
                        hintStyle: GoogleFonts.inter(
                          fontSize: 14,
                          color: AppColors.textLight,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Terms & conditions checkbox
            Obx(
              () => Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 24,
                    height: 24,
                    child: Checkbox(
                      value: controller.isAgreed.value,
                      onChanged: (v) => controller.isAgreed.value = v ?? false,
                      activeColor: AppColors.brandGreen,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: RichText(
                      text: TextSpan(
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          color: AppColors.textSecondary,
                        ),
                        children: [
                          const TextSpan(text: 'By continuing, you agree to our '),
                          TextSpan(
                            text: 'privacy policies',
                            style: GoogleFonts.inter(
                              fontSize: 12,
                              color: AppColors.primaryBlue,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                          const TextSpan(text: ' and '),
                          TextSpan(
                            text: 'Terms & Conditions.',
                            style: GoogleFonts.inter(
                              fontSize: 12,
                              color: AppColors.primaryBlue,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),

            // Error message
            Obx(
              () => controller.errorMessage.value.isNotEmpty
                  ? Padding(
                      padding: const EdgeInsets.only(bottom: 8),
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

            const SizedBox(height: 16),

            // Request OTP button
            Obx(
              () => CustomButton(
                text: 'Request OTP',
                isLoading: controller.isLoading.value,
                onPressed: controller.sendOtp,
              ),
            ),
            const SizedBox(height: 20),

            // Existing User link
            Center(
              child: TextButton(
                onPressed: () {
                  // Same flow for existing users
                },
                child: RichText(
                  text: TextSpan(
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      color: AppColors.textSecondary,
                    ),
                    children: [
                      const TextSpan(text: 'Existing User? '),
                      TextSpan(
                        text: 'Sign in',
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: AppColors.primaryBlue,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
