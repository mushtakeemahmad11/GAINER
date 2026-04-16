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
    await Future.delayed(const Duration(seconds: 1)); // branding delay
    final isLoggedIn = await AuthService.isLoggedIn();

    if (isLoggedIn) {
    // if (true) {
      // Get.offAllNamed('/app_switcher_view');
      print("You are isLoggedIn: $isLoggedIn");
      Get.offAllNamed(Routes.APPSWITCHER);
    } else {
      // Get.offAllNamed('/login');
      Get.offAllNamed(Routes.LOGIN);
    }
  }
}
