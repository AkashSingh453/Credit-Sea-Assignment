import 'package:get/get.dart';
import '../../../app/routes/app_routes.dart';
import '../../data/services/storage_service.dart';

class SplashController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    _navigateAfterDelay();
  }

  @override
  void onReady() {
    super.onReady();
  }

  Future<void> _navigateAfterDelay() async {
    await Future.delayed(const Duration(seconds: 2));

    if (StorageService.isLoggedIn && StorageService.token != null) {
      Get.offAllNamed(AppRoutes.home);
    } else {
      Get.offAllNamed(AppRoutes.login);
    }
  }
}
