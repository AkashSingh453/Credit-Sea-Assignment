import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../data/services/api_service.dart';
import '../../data/services/storage_service.dart';
import '../../routes/app_routes.dart';

class ProfileSetupController extends GetxController {
  // Personal Details
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final dobController = TextEditingController();
  final emailController = TextEditingController();
  final panController = TextEditingController();
  final addressController = TextEditingController();
  final incomeController = TextEditingController();

  final RxString selectedGender = ''.obs;
  final RxString selectedMaritalStatus = ''.obs;
  final RxString selectedEmploymentType = ''.obs;
  final Rx<DateTime?> selectedDate = Rx<DateTime?>(null);

  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;

  // Form keys
  final personalDetailsFormKey = GlobalKey<FormState>();
  final emailFormKey = GlobalKey<FormState>();
  final panFormKey = GlobalKey<FormState>();

  final genderOptions = ['Male', 'Female', 'Other'];
  final maritalStatusOptions = ['Single', 'Married', 'Divorced', 'Widowed'];
  final employmentOptions = [
    'Salaried',
    'Self-Employed',
    'Business',
    'Student',
    'Other'
  ];

  @override
  void onClose() {
    firstNameController.dispose();
    lastNameController.dispose();
    dobController.dispose();
    emailController.dispose();
    panController.dispose();
    addressController.dispose();
    incomeController.dispose();
    super.onClose();
  }

  // Pick date
  Future<void> pickDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime(2000, 1, 1),
      firstDate: DateTime(1950),
      lastDate: DateTime.now().subtract(const Duration(days: 365 * 18)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF1565C0),
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Color(0xFF1A1A2E),
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      selectedDate.value = picked;
      dobController.text = DateFormat('dd - MM - yyyy').format(picked);
    }
  }

  // Save personal details & navigate to email
  Future<void> savePersonalDetails() async {
    if (!personalDetailsFormKey.currentState!.validate()) return;

    if (selectedGender.value.isEmpty) {
      errorMessage.value = 'Please select your gender';
      return;
    }
    if (selectedDate.value == null) {
      errorMessage.value = 'Please select your date of birth';
      return;
    }

    errorMessage.value = '';
    isLoading.value = true;

    try {
      final name =
          '${firstNameController.text.trim()} ${lastNameController.text.trim()}';

      final response = await ApiService.updateProfile({
        'name': name,
        'gender': selectedGender.value,
        'dateOfBirth': selectedDate.value!.toIso8601String(),
      });

      if (response['success'] == true) {
        Get.toNamed(AppRoutes.emailVerification);
      } else {
        errorMessage.value = response['message'] ?? 'Failed to save details';
      }
    } catch (e) {
      errorMessage.value = 'Connection error. Please try again.';
    } finally {
      isLoading.value = false;
    }
  }

  // Save email & navigate to PAN
  Future<void> saveEmail() async {
    final email = emailController.text.trim();
    if (email.isEmpty || !GetUtils.isEmail(email)) {
      errorMessage.value = 'Please enter a valid email address';
      return;
    }

    errorMessage.value = '';
    isLoading.value = true;

    try {
      final response = await ApiService.updateProfile({'email': email});

      if (response['success'] == true) {
        Get.toNamed(AppRoutes.panVerification);
      } else {
        errorMessage.value = response['message'] ?? 'Failed to save email';
      }
    } catch (e) {
      errorMessage.value = 'Connection error. Please try again.';
    } finally {
      isLoading.value = false;
    }
  }

  // Save PAN & employment info, complete profile
  Future<void> savePanAndComplete() async {
    final pan = panController.text.trim().toUpperCase();
    if (pan.isEmpty || !RegExp(r'^[A-Z]{5}[0-9]{4}[A-Z]{1}$').hasMatch(pan)) {
      errorMessage.value = 'Please enter a valid PAN number (e.g., ABCDE1234F)';
      return;
    }

    if (selectedEmploymentType.value.isEmpty) {
      errorMessage.value = 'Please select your employment type';
      return;
    }

    final income = double.tryParse(incomeController.text.trim()) ?? 0;
    if (income < 5000) {
      errorMessage.value = 'Please enter your monthly income (min ₹5,000)';
      return;
    }

    errorMessage.value = '';
    isLoading.value = true;

    try {
      final response = await ApiService.updateProfile({
        'panNumber': pan,
        'employmentType': selectedEmploymentType.value,
        'monthlyIncome': income,
        'address': addressController.text.trim(),
      });

      if (response['success'] == true) {
        StorageService.userData = response['data'] != null
            ? Map<String, dynamic>.from(response['data'])
            : null;

        Get.snackbar(
          'Profile Complete!',
          'Your profile has been set up successfully.',
          backgroundColor: Colors.green.shade600,
          colorText: Colors.white,
          snackPosition: SnackPosition.TOP,
        );

        Get.offAllNamed(AppRoutes.home);
      } else {
        errorMessage.value =
            response['message'] ?? 'Failed to complete profile';
      }
    } catch (e) {
      errorMessage.value = 'Connection error. Please try again.';
    } finally {
      isLoading.value = false;
    }
  }
}
