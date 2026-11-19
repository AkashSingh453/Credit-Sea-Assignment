import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../theme/app_colors.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_text_field.dart';
import 'profile_controller.dart';

class ProfileView extends GetView<ProfileController> {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    final currencyFormat = NumberFormat.currency(
      locale: 'en_IN',
      symbol: '₹ ',
      decimalDigits: 0,
    );

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primaryDark,
        elevation: 0,
        title: Text(
          'My Profile',
          style: GoogleFonts.inter(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        actions: [
          Obx(
            () => IconButton(
              icon: Icon(
                controller.isEditing.value
                    ? Icons.close_rounded
                    : Icons.edit_note_rounded,
                color: Colors.white,
              ),
              onPressed: controller.toggleEdit,
            ),
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(color: AppColors.primaryBlue),
          );
        }

        return RefreshIndicator(
          onRefresh: controller.loadProfile,
          color: AppColors.primaryBlue,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              children: [
                _buildHeader(),
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      _buildCreditScoreCard(),
                      const SizedBox(height: 16),
                      if (controller.isEditing.value)
                        _buildEditForm(currencyFormat)
                      else
                        _buildProfileDetails(currencyFormat),
                      const SizedBox(height: 16),
                      _buildBankDetails(),
                      const SizedBox(height: 16),
                      _buildSupportSection(),
                      const SizedBox(height: 24),
                      CustomButton(
                        text: 'Log Out',
                        backgroundColor: const Color(0xFFEF4444),
                        icon: Icons.logout_rounded,
                        onPressed: controller.logout,
                      ),
                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 24),
      decoration: const BoxDecoration(
        gradient: AppColors.headerGradient,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(24),
          bottomRight: Radius.circular(24),
        ),
      ),
      child: Column(
        children: [
          CircleAvatar(
            radius: 40,
            backgroundColor: Colors.white.withOpacity(0.15),
            child: Text(
              controller.name.value.isNotEmpty
                  ? controller.name.value[0].toUpperCase()
                  : 'U',
              style: GoogleFonts.inter(
                fontSize: 32,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            controller.name.value.isNotEmpty
                ? controller.name.value
                : 'CreditSea Customer',
            style: GoogleFonts.inter(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '+91 ${controller.phone.value}',
            style: GoogleFonts.inter(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: Colors.white70,
            ),
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: controller.isProfileComplete.value
                  ? const Color(0xFF10B981).withOpacity(0.2)
                  : const Color(0xFFF59E0B).withOpacity(0.2),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: controller.isProfileComplete.value
                    ? const Color(0xFF10B981)
                    : const Color(0xFFF59E0B),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  controller.isProfileComplete.value
                      ? Icons.verified_rounded
                      : Icons.pending_actions_rounded,
                  size: 14,
                  color: controller.isProfileComplete.value
                      ? const Color(0xFF10B981)
                      : const Color(0xFFF59E0B),
                ),
                const SizedBox(width: 6),
                Text(
                  controller.isProfileComplete.value
                      ? 'KYC Verified'
                      : 'Profile Incomplete',
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: controller.isProfileComplete.value
                        ? const Color(0xFF10B981)
                        : const Color(0xFFF59E0B),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCreditScoreCard() {
    final score = controller.creditScore.value;
    final progress = (score - 300) / (900 - 300);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Credit Health Score',
                style: GoogleFonts.inter(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFF10B981).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  score >= 750 ? 'Excellent' : 'Good',
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF10B981),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '$score',
                style: GoogleFonts.inter(
                  fontSize: 32,
                  fontWeight: FontWeight.w800,
                  color: AppColors.primaryBlue,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 6, left: 4),
                child: Text(
                  '/ 900',
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: LinearProgressIndicator(
              value: progress.clamp(0.0, 1.0),
              minHeight: 8,
              backgroundColor: const Color(0xFFE5E7EB),
              valueColor: const AlwaysStoppedAnimation<Color>(
                AppColors.primaryBlue,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Poor (300)',
                  style: GoogleFonts.inter(
                      fontSize: 11, color: AppColors.textLight)),
              Text('Excellent (900)',
                  style: GoogleFonts.inter(
                      fontSize: 11, color: AppColors.textLight)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildProfileDetails(NumberFormat currencyFormat) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Personal & KYC Information',
            style: GoogleFonts.inter(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 16),
          _buildInfoRow('Full Name', controller.name.value),
          _buildInfoRow('Email Address', controller.email.value),
          _buildInfoRow('PAN Card', controller.panNumber.value),
          _buildInfoRow('Employment', controller.employmentType.value),
          _buildInfoRow(
            'Monthly Income',
            currencyFormat.format(controller.monthlyIncome.value),
          ),
          _buildInfoRow('Address', controller.address.value, isLast: true),
        ],
      ),
    );
  }

  Widget _buildEditForm(NumberFormat currencyFormat) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Edit Profile Details',
            style: GoogleFonts.inter(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 16),
          CustomTextField(
            label: 'Full Name',
            controller: controller.nameController,
          ),
          const SizedBox(height: 12),
          CustomTextField(
            label: 'Email Address',
            controller: controller.emailController,
            keyboardType: TextInputType.emailAddress,
          ),
          const SizedBox(height: 12),
          CustomTextField(
            label: 'PAN Number',
            controller: controller.panController,
          ),
          const SizedBox(height: 12),
          CustomTextField(
            label: 'Monthly Income (₹)',
            controller: controller.incomeController,
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 12),
          CustomTextField(
            label: 'Address',
            controller: controller.addressController,
            maxLines: 2,
          ),
          const SizedBox(height: 20),
          CustomButton(
            text: 'Save Changes',
            isLoading: controller.isSaving.value,
            onPressed: controller.saveProfile,
          ),
        ],
      ),
    );
  }

  Widget _buildBankDetails() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.account_balance_rounded,
                  color: AppColors.primaryBlue, size: 20),
              const SizedBox(width: 8),
              Text(
                'Disbursement Bank Account',
                style: GoogleFonts.inter(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildInfoRow(
            'Bank Name',
            controller.bankName.value.isNotEmpty
                ? controller.bankName.value
                : 'HDFC Bank (Default)',
          ),
          _buildInfoRow(
            'Account Number',
            controller.bankAccountNumber.value.isNotEmpty
                ? controller.bankAccountNumber.value
                : '••••••••8492',
          ),
          _buildInfoRow(
            'IFSC Code',
            controller.ifscCode.value.isNotEmpty
                ? controller.ifscCode.value
                : 'HDFC0001234',
            isLast: true,
          ),
        ],
      ),
    );
  }

  Widget _buildSupportSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildSettingsItem(
            icon: Icons.support_agent_rounded,
            title: '24x7 Customer Care',
            subtitle: 'Get help with your loan application',
            onTap: () {
              Get.snackbar(
                'Customer Support',
                'Reach our 24x7 helpdesk at support@creditsea.com or 1800-CREDIT-SEA',
                snackPosition: SnackPosition.BOTTOM,
                backgroundColor: AppColors.primaryDark,
                colorText: Colors.white,
                duration: const Duration(seconds: 4),
              );
            },
          ),
          const Divider(height: 16, color: AppColors.border),
          _buildSettingsItem(
            icon: Icons.privacy_tip_outlined,
            title: 'Privacy Policy',
            subtitle: 'How we safeguard your financial data',
            onTap: () {
              Get.snackbar(
                'Privacy Policy',
                'Your data is 256-bit encrypted and RBI compliant.',
                snackPosition: SnackPosition.BOTTOM,
              );
            },
          ),
          const Divider(height: 16, color: AppColors.border),
          _buildSettingsItem(
            icon: Icons.description_outlined,
            title: 'Terms & Conditions',
            subtitle: 'Loan agreements and user policies',
            onTap: () {
              Get.snackbar(
                'Terms & Conditions',
                'All loans are governed by RBI NBFC fair practices code.',
                snackPosition: SnackPosition.BOTTOM,
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, {bool isLast = false}) {
    return Padding(
      padding: EdgeInsets.only(bottom: isLast ? 0 : 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 13,
              color: AppColors.textSecondary,
            ),
          ),
          Text(
            value.isNotEmpty ? value : 'Not provided',
            style: GoogleFonts.inter(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: value.isNotEmpty
                  ? AppColors.textPrimary
                  : AppColors.textLight,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.primaryBlue.withOpacity(0.08),
                borderRadius: BorderRadius.circular(8),
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
                  Text(
                    subtitle,
                    style: GoogleFonts.inter(
                      fontSize: 11,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right_rounded,
                color: AppColors.textLight, size: 20),
          ],
        ),
      ),
    );
  }
}
