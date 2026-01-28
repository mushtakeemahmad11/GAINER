import 'package:get/get.dart';
import 'app_launcher_controller.dart';

class AppLauncherBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AppLauncherController>(
      () => AppLauncherController(),
    );
  }
}
