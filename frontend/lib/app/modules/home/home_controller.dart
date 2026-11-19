import 'package:get/get.dart';
import '../../data/services/api_service.dart';
import '../../data/services/storage_service.dart';
import '../../routes/app_routes.dart';

class HomeController extends GetxController {
  final RxBool isLoading = false.obs;
  final RxInt currentNavIndex = 0.obs;

  // User data
  final RxString userName = ''.obs;
  final RxString userPhone = ''.obs;
  final RxInt creditScore = 650.obs;
  final RxBool isProfileComplete = false.obs;

  // Loan stats
  final RxInt totalLoans = 0.obs;
  final RxInt activeLoans = 0.obs;
  final RxDouble totalApprovedAmount = 0.0.obs;
  final RxMap<String, dynamic> statusBreakdown = <String, dynamic>{}.obs;

  // Recent loans list
  final RxList<Map<String, dynamic>> recentLoans =
      <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadDashboard();
  }

  Future<void> loadDashboard() async {
    isLoading.value = true;

    try {
      // Load profile
      final profileResponse = await ApiService.getProfile();
      if (profileResponse['success'] == true) {
        final user = profileResponse['data'];
        userName.value = user['name'] ?? '';
        userPhone.value = user['phone'] ?? '';
        creditScore.value = user['creditScore'] ?? 650;
        isProfileComplete.value = user['isProfileComplete'] ?? false;
        StorageService.userData = user;
      }

      // Load loan stats
      final statsResponse = await ApiService.getLoanStats();
      if (statsResponse['success'] == true) {
        final data = statsResponse['data'];
        totalLoans.value = data['totalLoans'] ?? 0;
        activeLoans.value = data['activeLoans'] ?? 0;
        totalApprovedAmount.value =
            (data['totalApprovedAmount'] ?? 0).toDouble();
        if (data['statusBreakdown'] != null) {
          statusBreakdown.value =
              Map<String, dynamic>.from(data['statusBreakdown']);
        }
      }

      // Load recent loans
      final loansResponse = await ApiService.getLoans(page: 1, limit: 5);
      if (loansResponse['success'] == true) {
        final loans = loansResponse['data']['loans'] as List;
        recentLoans.value =
            loans.map((l) => Map<String, dynamic>.from(l)).toList();
      }
    } catch (e) {
      // Silent fail — will show empty state
    } finally {
      isLoading.value = false;
    }
  }

  void navigateToLoanCalculator() {
    Get.toNamed(AppRoutes.loanCalculator);
  }

  void navigateToProfile() {
    Get.toNamed(AppRoutes.profile);
  }

  void navigateToLoanStatus(String loanId) {
    Get.toNamed(AppRoutes.loanStatus, arguments: {'loanId': loanId});
  }

  void logout() {
    StorageService.clearAll();
    Get.offAllNamed(AppRoutes.login);
  }

  String getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good Morning';
    if (hour < 17) return 'Good Afternoon';
    return 'Good Evening';
  }
}
