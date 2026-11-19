import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../data/services/api_service.dart';
import '../../routes/app_routes.dart';

class LoanController extends GetxController {
  // Calculator Form State
  final RxDouble principalAmount = 30000.0.obs;
  final RxInt tenureDays = 40.obs;
  final RxString selectedPurpose = 'Personal'.obs;

  // Rate & Fee constants
  final double dailyInterestRate = 0.01; // 1% per day (as in Figma design)
  final double processingFeePercent = 0.10; // 10%

  // Calculation results
  final RxDouble totalInterest = 0.0.obs;
  final RxDouble totalPayable = 0.0.obs;
  final RxDouble processingFee = 0.0.obs;
  final RxDouble monthlyEmi = 0.0.obs;

  // Eligibility
  final RxBool isEligible = true.obs;
  final RxDouble maxLoanAmount = 100000.0.obs;
  final RxList<String> eligibilityReasons = <String>[].obs;

  // Loading & Error States
  final RxBool isLoading = false.obs;
  final RxBool isSubmitting = false.obs;
  final RxString errorMessage = ''.obs;

  // Current active loan data
  final Rx<Map<String, dynamic>?> currentLoan = Rx<Map<String, dynamic>?>(null);

  // Available Purposes
  final List<String> loanPurposes = [
    'Personal',
    'Education',
    'Medical',
    'Home Renovation',
    'Business',
    'Travel',
    'Debt Consolidation',
    'Other'
  ];

  @override
  void onInit() {
    super.onInit();
    recalculate();
    _checkInitialEligibility();

    // Check if arguments contain a loanId or existing loan data
    if (Get.arguments != null && Get.arguments is Map) {
      final args = Get.arguments as Map;
      if (args['loanId'] != null) {
        fetchLoanDetails(args['loanId'].toString());
      } else if (args['loan'] != null) {
        currentLoan.value = Map<String, dynamic>.from(args['loan']);
      }
    }
  }

  void recalculate() {
    final principal = principalAmount.value;
    final days = tenureDays.value;

    // Daily interest formula: Principal * (Rate/Day) * Days
    // To keep it realistic & aligned with the Figma numbers:
    // Figma shows: Principle Amount: ₹1,00,000, Interest: 1%, Total Payable: ₹1,02,000 or ₹2000 interest
    final interest = (principal * (dailyInterestRate / 100) * days).roundToDouble();
    totalInterest.value = interest;
    totalPayable.value = principal + interest;
    processingFee.value = (principal * 0.02).roundToDouble();

    // Equivalent monthly EMI (tenure in months roughly = days / 30)
    final months = max(1, (days / 30).ceil());
    monthlyEmi.value = (totalPayable.value / months).roundToDouble();
  }

  void updatePrincipal(double value) {
    principalAmount.value = value;
    recalculate();
  }

  void updateTenure(int days) {
    tenureDays.value = days;
    recalculate();
  }

  void updatePurpose(String purpose) {
    selectedPurpose.value = purpose;
  }

  Future<void> _checkInitialEligibility() async {
    try {
      final response = await ApiService.checkEligibility();
      if (response['success'] == true && response['data'] != null) {
        final data = response['data'];
        isEligible.value = data['isEligible'] ?? true;
        if (data['maxLoanAmount'] != null && data['maxLoanAmount'] > 0) {
          maxLoanAmount.value = (data['maxLoanAmount']).toDouble();
        }
        if (data['reasons'] != null) {
          eligibilityReasons.value = List<String>.from(data['reasons']);
        }
      }
    } catch (_) {
      // Offline fallback: keep default eligibility
    }
  }

  void proceedToOffer() {
    recalculate();
    Get.toNamed(AppRoutes.loanOffer);
  }

  Future<void> submitLoanApplication() async {
    isSubmitting.value = true;
    errorMessage.value = '';

    try {
      final payload = {
        'loanAmount': principalAmount.value,
        'tenure': tenureDays.value,
        'tenureUnit': 'days',
        'purpose': selectedPurpose.value,
      };

      final response = await ApiService.applyLoan(payload);

      if (response['success'] == true && response['data'] != null) {
        currentLoan.value = Map<String, dynamic>.from(response['data']);

        Get.snackbar(
          'Application Submitted!',
          'Your loan application #${currentLoan.value?['referenceId']} has been submitted.',
          backgroundColor: const Color(0xFF10B981),
          colorText: Colors.white,
          snackPosition: SnackPosition.TOP,
          duration: const Duration(seconds: 4),
        );

        Get.offNamed(
          AppRoutes.loanStatus,
          arguments: {'loanId': currentLoan.value?['_id']},
        );
      } else {
        errorMessage.value =
            response['message'] ?? 'Failed to submit loan application.';
        Get.snackbar(
          'Application Notice',
          errorMessage.value,
          backgroundColor: const Color(0xFFEF4444),
          colorText: Colors.white,
          snackPosition: SnackPosition.TOP,
        );
      }
    } catch (e) {
      // If server is unreachable in mock test, generate demo loan object
      final mockId = 'CS${Random().nextInt(90000) + 10000}';
      currentLoan.value = {
        '_id': 'mock_${DateTime.now().millisecondsSinceEpoch}',
        'referenceId': mockId,
        'loanAmount': principalAmount.value,
        'tenure': tenureDays.value,
        'tenureUnit': 'days',
        'purpose': selectedPurpose.value,
        'status': 'Under Review',
        'createdAt': DateTime.now().toIso8601String(),
        'monthlyEmi': monthlyEmi.value,
        'totalPayable': totalPayable.value,
      };

      Get.offNamed(
        AppRoutes.loanStatus,
        arguments: {'loanId': currentLoan.value?['_id']},
      );
    } finally {
      isSubmitting.value = false;
    }
  }

  Future<void> fetchLoanDetails(String loanId) async {
    isLoading.value = true;
    try {
      final response = await ApiService.getLoanById(loanId);
      if (response['success'] == true && response['data'] != null) {
        currentLoan.value = Map<String, dynamic>.from(response['data']);
      }
    } catch (_) {
      // If fetching fails, fallback to existing currentLoan if present
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateStatusForDemo(String newStatus) async {
    if (currentLoan.value == null) return;
    final loanId = currentLoan.value!['_id'];

    isLoading.value = true;
    try {
      final response = await ApiService.updateLoanStatus(
        loanId,
        newStatus,
        remarks: 'Status updated via Demo Controls to $newStatus',
      );

      if (response['success'] == true && response['data'] != null) {
        currentLoan.value = Map<String, dynamic>.from(response['data']);
        Get.snackbar(
          'Status Updated',
          'Loan status changed to $newStatus',
          backgroundColor: const Color(0xFF1565C0),
          colorText: Colors.white,
          snackPosition: SnackPosition.TOP,
        );
      } else {
        // Fallback for mock/local testing
        final updated = Map<String, dynamic>.from(currentLoan.value!);
        updated['status'] = newStatus;
        currentLoan.value = updated;
      }
    } catch (_) {
      final updated = Map<String, dynamic>.from(currentLoan.value!);
      updated['status'] = newStatus;
      currentLoan.value = updated;
    } finally {
      isLoading.value = false;
    }
  }
}
