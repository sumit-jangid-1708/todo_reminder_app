import 'package:get/get.dart';
import '../view_models/controller/auth_controller.dart';
import '../view_models/controller/payable_controller.dart';
import '../view_models/controller/receivable_controller.dart';
import '../view_models/controller/transaction_controller.dart';

class InitialBinding extends Bindings {
  @override
  void dependencies() {
    // ✅ Global Controllers (Always needed)
    Get.put(AuthController());

    // ✅ Screen Controllers (Created when needed)
    Get.lazyPut(() => TransactionController());
    Get.lazyPut(() => ReceivableController());
    Get.lazyPut(() => PayableController());
  }
}