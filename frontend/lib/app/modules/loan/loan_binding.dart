import 'package:get/get.dart';
import 'loan_controller.dart';

class LoanBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LoanController>(() => LoanController());
  }
}
