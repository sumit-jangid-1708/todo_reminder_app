import 'package:get/get.dart';
import '../view_models/controller/auth_controller.dart';

class InitialBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(()=>AuthController());
  }
}