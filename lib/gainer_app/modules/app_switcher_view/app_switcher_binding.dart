import 'package:get/get.dart';
import 'app_switcher_controller.dart';

class AppSwitcherBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<AppSwitcherController>(AppSwitcherController());
  }
}
