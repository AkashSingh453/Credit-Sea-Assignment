import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../theme/app_colors.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_text_field.dart';
import '../../widgets/step_indicator.dart';
import 'profile_setup_controller.dart';

class PersonalDetailsView extends GetView<ProfileSetupController> {
  const PersonalDetailsView({super.key});

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
                child: Form(
                  key: controller.personalDetailsFormKey,
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
                            'Personal Details',
                            style: GoogleFonts.inter(
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 28),

                      // First Name & Last Name
                      Row(
                        children: [
                          Expanded(
                            child: CustomTextField(
                              label: 'First Name*',
                              hint: 'Your first name',
                              controller: controller.firstNameController,
                              validator: (v) => v == null || v.isEmpty
                                  ? 'Required'
                                  : null,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: CustomTextField(
                              label: 'Last Name*',
                              hint: 'Your last name',
                              controller: controller.lastNameController,
                              validator: (v) => v == null || v.isEmpty
                                  ? 'Required'
                                  : null,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),

                      // Gender Dropdown
                      Text(
                        'Gender*',
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Obx(
                        () => DropdownButtonFormField<String>(
                          value: controller.selectedGender.value.isEmpty
                              ? null
                              : controller.selectedGender.value,
                          decoration: InputDecoration(
                            hintText: 'Select your gender',
                            hintStyle: GoogleFonts.inter(
                              fontSize: 14,
                              color: AppColors.textLight,
                            ),
                          ),
                          items: controller.genderOptions
                              .map((g) => DropdownMenuItem(
                                    value: g,
                                    child: Text(g),
                                  ))
                              .toList(),
                          onChanged: (v) =>
                              controller.selectedGender.value = v ?? '',
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Date of Birth
                      CustomTextField(
                        label: 'Date of Birth*',
                        hint: 'DD - MM - YYYY',
                        controller: controller.dobController,
                        readOnly: true,
                        onTap: () => controller.pickDate(context),
                        suffix: const Icon(Icons.calendar_today_outlined,
                            size: 20, color: AppColors.textSecondary),
                      ),
                      const SizedBox(height: 20),

                      // Marital Status
                      Text(
                        'Your Marital Status *',
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
                              controller.selectedMaritalStatus.value.isEmpty
                                  ? null
                                  : controller.selectedMaritalStatus.value,
                          decoration: InputDecoration(
                            hintText: 'Select',
                            hintStyle: GoogleFonts.inter(
                              fontSize: 14,
                              color: AppColors.textLight,
                            ),
                          ),
                          items: controller.maritalStatusOptions
                              .map((s) => DropdownMenuItem(
                                    value: s,
                                    child: Text(s),
                                  ))
                              .toList(),
                          onChanged: (v) =>
                              controller.selectedMaritalStatus.value =
                                  v ?? '',
                        ),
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

                      // Continue button
                      Obx(
                        () => CustomButton(
                          text: 'Continue',
                          isLoading: controller.isLoading.value,
                          onPressed: controller.savePersonalDetails,
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
