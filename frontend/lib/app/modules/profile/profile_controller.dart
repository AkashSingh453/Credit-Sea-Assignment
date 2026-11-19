import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../data/services/api_service.dart';
import '../../data/services/storage_service.dart';
import '../../routes/app_routes.dart';

class ProfileController extends GetxController {
  final RxBool isLoading = false.obs;
  final RxBool isSaving = false.obs;
  final RxBool isEditing = false.obs;

  // Profile data
  final RxString name = ''.obs;
  final RxString phone = ''.obs;
  final RxString email = ''.obs;
  final RxString panNumber = ''.obs;
  final RxString employmentType = ''.obs;
  final RxDouble monthlyIncome = 0.0.obs;
  final RxString address = ''.obs;
  final RxString bankAccountNumber = ''.obs;
  final RxString ifscCode = ''.obs;
  final RxString bankName = ''.obs;
  final RxInt creditScore = 650.obs;
  final RxBool isProfileComplete = false.obs;
  final RxBool isKycVerified = false.obs;

  // Controllers for editing
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final panController = TextEditingController();
  final incomeController = TextEditingController();
  final addressController = TextEditingController();
  final bankAccountController = TextEditingController();
  final ifscController = TextEditingController();
  final bankNameController = TextEditingController();

  final employmentOptions = [
    'Salaried',
    'Self-Employed',
    'Business',
    'Student',
    'Other'
  ];

  @override
  void onInit() {
    super.onInit();
    loadProfile();
  }

  @override
  void onClose() {
    nameController.dispose();
    emailController.dispose();
    panController.dispose();
    incomeController.dispose();
    addressController.dispose();
    bankAccountController.dispose();
    ifscController.dispose();
    bankNameController.dispose();
    super.onClose();
  }

  Future<void> loadProfile() async {
    isLoading.value = true;
    try {
      final response = await ApiService.getProfile();
      if (response['success'] == true && response['data'] != null) {
        final data = response['data'];
        _populateFields(data);
        StorageService.userData = data;
      } else {
        // Fallback to locally stored user data
        final cached = StorageService.userData;
        if (cached != null) {
          _populateFields(cached);
        }
      }
    } catch (_) {
      final cached = StorageService.userData;
      if (cached != null) {
        _populateFields(cached);
      }
    } finally {
      isLoading.value = false;
    }
  }

  void _populateFields(Map<String, dynamic> data) {
    name.value = data['name'] ?? '';
    phone.value = data['phone'] ?? '';
    email.value = data['email'] ?? '';
    panNumber.value = data['panNumber'] ?? '';
    employmentType.value = data['employmentType'] ?? 'Salaried';
    monthlyIncome.value = (data['monthlyIncome'] ?? 0).toDouble();
    address.value = data['address'] ?? '';
    bankAccountNumber.value = data['bankAccountNumber'] ?? '';
    ifscCode.value = data['ifscCode'] ?? '';
    bankName.value = data['bankName'] ?? '';
    creditScore.value = data['creditScore'] ?? 650;
    isProfileComplete.value = data['isProfileComplete'] ?? false;
    isKycVerified.value = data['isKycVerified'] ?? false;

    // Set text controllers
    nameController.text = name.value;
    emailController.text = email.value;
    panController.text = panNumber.value;
    incomeController.text =
        monthlyIncome.value > 0 ? monthlyIncome.value.round().toString() : '';
    addressController.text = address.value;
    bankAccountController.text = bankAccountNumber.value;
    ifscController.text = ifscCode.value;
    bankNameController.text = bankName.value;
  }

  void toggleEdit() {
    isEditing.value = !isEditing.value;
  }

  Future<void> saveProfile() async {
    isSaving.value = true;
    try {
      final updateData = {
        'name': nameController.text.trim(),
        'email': emailController.text.trim(),
        'panNumber': panController.text.trim().toUpperCase(),
        'employmentType': employmentType.value,
        'monthlyIncome': double.tryParse(incomeController.text.trim()) ?? 0,
        'address': addressController.text.trim(),
        'bankAccountNumber': bankAccountController.text.trim(),
        'ifscCode': ifscController.text.trim().toUpperCase(),
        'bankName': bankNameController.text.trim(),
      };

      final response = await ApiService.updateProfile(updateData);
      if (response['success'] == true && response['data'] != null) {
        _populateFields(response['data']);
        isEditing.value = false;
        Get.snackbar(
          'Profile Updated',
          'Your profile has been successfully updated.',
          backgroundColor: const Color(0xFF10B981),
          colorText: Colors.white,
          snackPosition: SnackPosition.TOP,
        );
      } else {
        Get.snackbar(
          'Update Failed',
          response['message'] ?? 'Unable to update profile.',
          backgroundColor: const Color(0xFFEF4444),
          colorText: Colors.white,
          snackPosition: SnackPosition.TOP,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to connect to server.',
        backgroundColor: const Color(0xFFEF4444),
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
      );
    } finally {
      isSaving.value = false;
    }
  }

  void logout() {
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Log Out'),
        content: const Text('Are you sure you want to log out of CreditSea?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFEF4444),
              foregroundColor: Colors.white,
            ),
            onPressed: () {
              Get.back();
              StorageService.clearAll();
              Get.offAllNamed(AppRoutes.login);
            },
            child: const Text('Log Out'),
          ),
        ],
      ),
    );
  }
}
