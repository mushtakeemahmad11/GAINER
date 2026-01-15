import 'package:get/get.dart';
import '../../core/Services/auth_service.dart';
import '../../routes/app_routes.dart';

class AuthController extends GetxController {
  @override
  void onReady() {
    super.onReady();
    checkLogin();
  }

  Future<void> checkLogin() async {
    // final isLoggedIn = await AuthService.isLoggedIn();
    await Future.delayed(const Duration(seconds: 2)); // branding delay
    final isLoggedIn = await AuthService.isLoggedIn();

    print("isLOgin in splash screen: $isLoggedIn");
    if (isLoggedIn) {
      // Get.offAllNamed('/app_switcher_view');
      Get.offAllNamed(Routes.APPSWITCHER);
    } else {
      // Get.offAllNamed('/login');
      Get.offAllNamed(Routes.LOGIN);
    }
  }
}
