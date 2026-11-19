import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../theme/app_colors.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_text_field.dart';
import '../../widgets/step_indicator.dart';
import 'profile_setup_controller.dart';

class PanVerificationView extends GetView<ProfileSetupController> {
  const PanVerificationView({super.key});

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
                          'Verify PAN Number',
                          style: GoogleFonts.inter(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // PAN card illustration
                    Center(
                      child: Container(
                        width: 180,
                        height: 120,
                        decoration: BoxDecoration(
                          color: AppColors.primaryBlue.withOpacity(0.08),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Icon(
                              Icons.credit_card_rounded,
                              size: 72,
                              color: AppColors.primaryBlue.withOpacity(0.3),
                            ),
                            Icon(
                              Icons.verified_rounded,
                              size: 36,
                              color: AppColors.primaryBlue,
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 28),

                    // PAN Number
                    CustomTextField(
                      label: 'Enter Your PAN Number*',
                      hint: 'e.g., ABCDF1234F',
                      controller: controller.panController,
                      keyboardType: TextInputType.text,
                    ),
                    const SizedBox(height: 20),

                    // Employment Type
                    Text(
                      'Employment Type*',
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Obx(
                      () => DropdownButtonFormField<String>(
                        value:
                            controller.selectedEmploymentType.value.isEmpty
                                ? null
                                : controller.selectedEmploymentType.value,
                        decoration: InputDecoration(
                          hintText: 'Select employment type',
                          hintStyle: GoogleFonts.inter(
                            fontSize: 14,
                            color: AppColors.textLight,
                          ),
                        ),
                        items: controller.employmentOptions
                            .map((e) => DropdownMenuItem(
                                  value: e,
                                  child: Text(e),
                                ))
                            .toList(),
                        onChanged: (v) =>
                            controller.selectedEmploymentType.value =
                                v ?? '',
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Monthly Income
                    CustomTextField(
                      label: 'Monthly Income*',
                      hint: 'e.g., 50000',
                      controller: controller.incomeController,
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: 20),

                    // Address
                    CustomTextField(
                      label: 'Address',
                      hint: 'Enter your address',
                      controller: controller.addressController,
                      maxLines: 2,
                    ),
                    const SizedBox(height: 12),

                    // Error
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

                    const SizedBox(height: 24),

                    // Complete Profile button
                    Obx(
                      () => CustomButton(
                        text: 'Complete Profile',
                        isLoading: controller.isLoading.value,
                        onPressed: controller.savePanAndComplete,
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
