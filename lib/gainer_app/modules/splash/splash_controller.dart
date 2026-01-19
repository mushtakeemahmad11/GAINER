import 'package:get/get.dart';
import '../../core/Services/auth_service.dart';

class AuthController extends GetxController {
  @override
  void onReady() {
    super.onReady();
    checkLogin();
  }

  Future<void> checkLogin() async {
    // final isLoggedIn = await AuthService.isLoggedIn();
    await Future.delayed(const Duration(seconds: 3)); // branding delay
    final isLoggedIn = await AuthService.isLoggedIn();

    if (isLoggedIn) {
      Get.offAllNamed('/home');
    } else {
      Get.offAllNamed('/login');
    }
  }
}
