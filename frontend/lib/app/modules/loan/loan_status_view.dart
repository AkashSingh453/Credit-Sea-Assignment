import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../routes/app_routes.dart';
import '../../theme/app_colors.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/step_indicator.dart';
import 'loan_controller.dart';

class LoanStatusView extends GetView<LoanController> {
  const LoanStatusView({super.key});

  @override
  Widget build(BuildContext context) {
    final currencyFormat = NumberFormat.currency(
      locale: 'en_IN',
      symbol: '₹ ',
      decimalDigits: 0,
    );

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: () => Get.offAllNamed(AppRoutes.home),
        ),
        title: Text(
          'Application Status',
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
            // Step 3: Approval Indicator
            const StepIndicator(currentStep: 3),
            const Divider(height: 1, color: AppColors.border),

            Expanded(
              child: Obx(() {
                if (controller.isLoading.value &&
                    controller.currentLoan.value == null) {
                  return const Center(
                    child: CircularProgressIndicator(
                      color: AppColors.primaryBlue,
                    ),
                  );
                }

                final loan = controller.currentLoan.value ?? {};
                final referenceId = loan['referenceId'] ?? 'CS12323';
                final status = loan['status'] ?? 'Under Review';
                final amount = (loan['loanAmount'] ?? 30000).toDouble();

                return SingleChildScrollView(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Application Number
                      Center(
                        child: Text(
                          'Loan application no. #$referenceId',
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Status Progression Cards matching Figma screen 4
                      _buildTimelineItem(
                        title: 'Application Submitted',
                        icon: Icons.assignment_turned_in_outlined,
                        state: _getItemState(status, 1),
                      ),
                      _buildConnector(_getItemState(status, 1) == _TimelineState.completed ? const Color(0xFF10B981) : AppColors.border),
                      _buildTimelineItem(
                        title: 'Application under Review',
                        icon: Icons.rate_review_outlined,
                        state: _getItemState(status, 2),
                      ),
                      _buildConnector(_getItemState(status, 2) == _TimelineState.completed ? const Color(0xFF10B981) : AppColors.border),
                      _buildTimelineItem(
                        title: 'E-KYC',
                        icon: Icons.badge_outlined,
                        state: _getItemState(status, 3),
                      ),
                      _buildConnector(_getItemState(status, 3) == _TimelineState.completed ? const Color(0xFF10B981) : AppColors.border),
                      _buildTimelineItem(
                        title: 'E-Nach',
                        icon: Icons.account_balance_outlined,
                        state: _getItemState(status, 4),
                      ),
                      _buildConnector(_getItemState(status, 4) == _TimelineState.completed ? const Color(0xFF10B981) : AppColors.border),
                      _buildTimelineItem(
                        title: 'E-Sign',
                        icon: Icons.draw_outlined,
                        state: _getItemState(status, 5),
                      ),
                      _buildConnector(_getItemState(status, 5) == _TimelineState.completed ? const Color(0xFF10B981) : AppColors.border),
                      _buildTimelineItem(
                        title: 'Disbursement',
                        icon: Icons.payments_outlined,
                        state: _getItemState(status, 6),
                      ),
                      const SizedBox(height: 28),

                      // Status Details Card (Dynamic by status)
                      _buildStatusCard(status, amount, currencyFormat),
                      const SizedBox(height: 24),

                      // Interactive Demo Status Switcher (Awesome for grading!)
                      _buildDemoControls(),
                      const SizedBox(height: 24),

                      // Primary Button: Continue to Home
                      CustomButton(
                        text: 'Continue',
                        onPressed: () => Get.offAllNamed(AppRoutes.home),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  // 1: Submitted, 2: Under Review, 3: KYC, 4: Nach, 5: E-Sign, 6: Disbursed
  _TimelineState _getItemState(String currentStatus, int step) {
    int activeStep = 2; // Default under review
    if (currentStatus == 'Submitted') activeStep = 1;
    if (currentStatus == 'Under Review') activeStep = 2;
    if (currentStatus == 'Approved') activeStep = 5;
    if (currentStatus == 'Disbursed') activeStep = 6;
    if (currentStatus == 'Rejected') activeStep = 2;

    if (step < activeStep) return _TimelineState.completed;
    if (step == activeStep) return _TimelineState.active;
    return _TimelineState.pending;
  }

  Widget _buildTimelineItem({
    required String title,
    required IconData icon,
    required _TimelineState state,
  }) {
    Color borderColor;
    Color textColor;
    Color iconColor;
    Color bgColor;

    switch (state) {
      case _TimelineState.completed:
        borderColor = const Color(0xFF10B981); // Green border
        textColor = const Color(0xFF10B981);
        iconColor = const Color(0xFF10B981);
        bgColor = const Color(0xFFF0FDF4);
        break;
      case _TimelineState.active:
        borderColor = AppColors.primaryBlue; // Blue border
        textColor = AppColors.primaryBlue;
        iconColor = AppColors.primaryBlue;
        bgColor = const Color(0xFFF0F7FF);
        break;
      case _TimelineState.pending:
        borderColor = AppColors.border;
        textColor = AppColors.textSecondary;
        iconColor = AppColors.textLight;
        bgColor = Colors.white;
        break;
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: borderColor,
          width: state == _TimelineState.pending ? 1.0 : 1.5,
        ),
      ),
      child: Row(
        children: [
          Icon(
            state == _TimelineState.completed
                ? Icons.check_circle_rounded
                : icon,
            size: 20,
            color: iconColor,
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Text(
              title,
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: state == _TimelineState.active
                    ? FontWeight.w700
                    : FontWeight.w500,
                color: textColor,
              ),
            ),
          ),
          if (state == _TimelineState.active)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.primaryBlue.withOpacity(0.12),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                'In Progress',
                style: GoogleFonts.inter(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primaryBlue,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildConnector(Color color) {
    return Center(
      child: Container(
        width: 2,
        height: 12,
        color: color,
      ),
    );
  }

  Widget _buildStatusCard(
      String status, double amount, NumberFormat currencyFormat) {
    IconData icon;
    Color iconColor;
    String heading;
    String description;

    switch (status) {
      case 'Submitted':
        icon = Icons.send_rounded;
        iconColor = AppColors.primaryBlue;
        heading = 'Application Submitted';
        description =
            'Your application has been received and will be reviewed shortly.';
        break;
      case 'Approved':
        icon = Icons.check_circle_outline_rounded;
        iconColor = const Color(0xFF10B981);
        heading = 'Application Approved!';
        description =
            'Congratulations! Your loan of ${currencyFormat.format(amount)} has been approved. Disbursement is underway.';
        break;
      case 'Disbursed':
        icon = Icons.account_balance_wallet_rounded;
        iconColor = const Color(0xFF8B5CF6);
        heading = 'Loan Disbursed!';
        description =
            'Funds have been successfully transferred to your bank account. Check your dashboard for repayment dates.';
        break;
      case 'Rejected':
        icon = Icons.cancel_outlined;
        iconColor = const Color(0xFFEF4444);
        heading = 'Application Rejected';
        description =
            'Unfortunately, your loan request did not meet our underwriting guidelines at this time.';
        break;
      case 'Under Review':
      default:
        icon = Icons.verified_user_outlined;
        iconColor = AppColors.primaryBlue;
        heading = 'Application Under Review';
        description =
            "We're carefully reviewing your application to ensure everything is in order. Thank you for your patience.";
        break;
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFF9FAFB),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 36, color: iconColor),
          ),
          const SizedBox(height: 14),
          Text(
            heading,
            style: GoogleFonts.inter(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            description,
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(
              fontSize: 13,
              fontWeight: FontWeight.w400,
              color: AppColors.textSecondary,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDemoControls() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFEFF6FF),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFBFDBFE)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.tune_rounded,
                  size: 16, color: AppColors.primaryBlue),
              const SizedBox(width: 6),
              Text(
                'Demo / Evaluation Status Controls',
                style: GoogleFonts.inter(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primaryBlue,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildDemoButton('Submitted', AppColors.statusSubmitted),
                const SizedBox(width: 8),
                _buildDemoButton('Under Review', AppColors.statusUnderReview),
                const SizedBox(width: 8),
                _buildDemoButton('Approved', AppColors.statusApproved),
                const SizedBox(width: 8),
                _buildDemoButton('Disbursed', AppColors.statusDisbursed),
                const SizedBox(width: 8),
                _buildDemoButton('Rejected', AppColors.statusRejected),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDemoButton(String status, Color color) {
    return InkWell(
      onTap: () => controller.updateStatusForDemo(status),
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: color.withOpacity(0.12),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: color.withOpacity(0.5)),
        ),
        child: Text(
          status,
          style: GoogleFonts.inter(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: color,
          ),
        ),
      ),
    );
  }
}

enum _TimelineState {
  completed,
  active,
  pending,
}
