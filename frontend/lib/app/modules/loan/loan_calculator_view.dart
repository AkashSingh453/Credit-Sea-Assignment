import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../theme/app_colors.dart';
import '../../widgets/credit_sea_logo.dart';
import '../../widgets/custom_button.dart';
import 'loan_controller.dart';

class LoanCalculatorView extends GetView<LoanController> {
  const LoanCalculatorView({super.key});

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
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: () => Get.back(),
        ),
        title: const CreditSeaLogo(
          size: 28,
          textColor: AppColors.primaryBlue,
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Screen Title
              Text(
                'Apply for loan',
                style: GoogleFonts.inter(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                "We've calculated your loan eligibility. Select your preferred loan amount and tenure.",
                style: GoogleFonts.inter(
                  fontSize: 13,
                  fontWeight: FontWeight.w400,
                  color: AppColors.textSecondary,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 18),

              // Info chips with dashed border
              Row(
                children: [
                  Expanded(
                    child: _buildDashedChip(
                      label: 'Interest Per Day 1%',
                      icon: Icons.percent_rounded,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildDashedChip(
                      label: 'Processing Fee 10%',
                      icon: Icons.receipt_long_outlined,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Purpose of Loan Dropdown
              Text(
                'Purpose of Loan*',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 8),
              Obx(
                () => Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.border, width: 1.2),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: controller.selectedPurpose.value,
                      isExpanded: true,
                      icon: const Icon(Icons.keyboard_arrow_down_rounded,
                          color: AppColors.textSecondary),
                      items: controller.loanPurposes.map((purpose) {
                        return DropdownMenuItem<String>(
                          value: purpose,
                          child: Text(
                            purpose,
                            style: GoogleFonts.inter(
                              fontSize: 14,
                              color: AppColors.textPrimary,
                            ),
                          ),
                        );
                      }).toList(),
                      onChanged: (val) {
                        if (val != null) controller.updatePurpose(val);
                      },
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 28),

              // Principal Amount Slider Section
              Obx(() {
                final amount = controller.principalAmount.value;
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Principal Amount',
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 14, vertical: 6),
                          decoration: BoxDecoration(
                            color: AppColors.surfaceLight,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                                color: AppColors.primaryBlue.withOpacity(0.3)),
                          ),
                          child: Text(
                            currencyFormat.format(amount),
                            style: GoogleFonts.inter(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: AppColors.primaryBlue,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SliderTheme(
                      data: SliderTheme.of(context).copyWith(
                        activeTrackColor: AppColors.primaryBlue,
                        inactiveTrackColor: const Color(0xFFD9E2EC),
                        thumbColor: AppColors.primaryBlue,
                        overlayColor: AppColors.primaryBlue.withOpacity(0.15),
                        trackHeight: 6,
                        thumbShape: const RoundSliderThumbShape(
                            enabledThumbRadius: 10),
                      ),
                      child: Slider(
                        value: amount,
                        min: 5000,
                        max: 100000,
                        divisions: 19,
                        onChanged: (v) => controller.updatePrincipal(v),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('₹ 5,000',
                              style: GoogleFonts.inter(
                                  fontSize: 11, color: AppColors.textLight)),
                          Text('₹ 1,00,000',
                              style: GoogleFonts.inter(
                                  fontSize: 11, color: AppColors.textLight)),
                        ],
                      ),
                    ),
                  ],
                );
              }),
              const SizedBox(height: 24),

              // Tenure Slider Section
              Obx(() {
                final days = controller.tenureDays.value;
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Tenure',
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 14, vertical: 6),
                          decoration: BoxDecoration(
                            color: AppColors.surfaceLight,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                                color: AppColors.primaryBlue.withOpacity(0.3)),
                          ),
                          child: Text(
                            '$days Days',
                            style: GoogleFonts.inter(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: AppColors.primaryBlue,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SliderTheme(
                      data: SliderTheme.of(context).copyWith(
                        activeTrackColor: AppColors.primaryBlue,
                        inactiveTrackColor: const Color(0xFFD9E2EC),
                        thumbColor: AppColors.primaryBlue,
                        overlayColor: AppColors.primaryBlue.withOpacity(0.15),
                        trackHeight: 6,
                        thumbShape: const RoundSliderThumbShape(
                            enabledThumbRadius: 10),
                      ),
                      child: Slider(
                        value: days.toDouble(),
                        min: 20,
                        max: 90,
                        divisions: 14,
                        onChanged: (v) => controller.updateTenure(v.round()),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('20 Days',
                              style: GoogleFonts.inter(
                                  fontSize: 11, color: AppColors.textLight)),
                          Text('90 Days',
                              style: GoogleFonts.inter(
                                  fontSize: 11, color: AppColors.textLight)),
                        ],
                      ),
                    ),
                  ],
                );
              }),
              const SizedBox(height: 28),

              // Summary Card (Figma Light Blue Card)
              Obx(() {
                final principal = controller.principalAmount.value;
                final payable = controller.totalPayable.value;

                return Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF0F7FF),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: const Color(0xFFBAE3FF),
                      width: 1.2,
                    ),
                  ),
                  child: Column(
                    children: [
                      _buildSummaryRow(
                        label: 'Principle Amount',
                        value: currencyFormat.format(principal),
                        valueColor: AppColors.primaryBlue,
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 10),
                        child: Divider(
                            height: 1, color: Color(0xFFD3E7FA)),
                      ),
                      _buildSummaryRow(
                        label: 'Interest',
                        value: '1%',
                        valueColor: AppColors.textPrimary,
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 10),
                        child: Divider(
                            height: 1, color: Color(0xFFD3E7FA)),
                      ),
                      _buildSummaryRow(
                        label: 'Total Payable',
                        value: currencyFormat.format(payable),
                        valueColor: AppColors.primaryBlue,
                        isBold: true,
                        fontSize: 16,
                      ),
                    ],
                  ),
                );
              }),
              const SizedBox(height: 16),

              // Note
              Center(
                child: Text(
                  'Thank you for choosing CreditSea. Please accept to proceed with the loan details.',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.inter(
                    fontSize: 11,
                    fontWeight: FontWeight.w400,
                    color: AppColors.textSecondary,
                    height: 1.4,
                  ),
                ),
              ),
              const SizedBox(height: 28),

              // Action Buttons
              CustomButton(
                text: 'Apply',
                onPressed: controller.proceedToOffer,
              ),
              const SizedBox(height: 12),
              CustomButton(
                text: 'Cancel',
                isOutlined: true,
                onPressed: () => Get.back(),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDashedChip({required String label, required IconData icon}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFFFAFBFC),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: const Color(0xFF7CB5EC),
          width: 1.2,
          style: BorderStyle.solid,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 16, color: AppColors.primaryBlue),
          const SizedBox(width: 6),
          Flexible(
            child: Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 11.5,
                fontWeight: FontWeight.w600,
                color: AppColors.primaryBlue,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryRow({
    required String label,
    required String value,
    required Color valueColor,
    bool isBold = false,
    double fontSize = 14,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: AppColors.textSecondary,
          ),
        ),
        Text(
          value,
          style: GoogleFonts.inter(
            fontSize: fontSize,
            fontWeight: isBold ? FontWeight.w700 : FontWeight.w600,
            color: valueColor,
          ),
        ),
      ],
    );
  }
}
