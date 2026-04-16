import 'package:gainer/gainer_app/modules/gainer_splash/gainer_splash_controller.dart';
import 'package:get/get.dart';

// class GainerSplashBinding extends Bindings {
//   @override
//   void dependencies() {
//     // Get.put(GainerSplashController());
//     Get.lazyPut<GainerSplashController>(() => GainerSplashController());
//   }
// }
class GainerSplashBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<GainerSplashController>(GainerSplashController());
  }
}
