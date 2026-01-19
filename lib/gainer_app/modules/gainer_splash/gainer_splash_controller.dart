import 'package:get/get.dart';
import '../../core/Services/auth_service.dart';
import '../../routes/app_routes.dart';

class GainerSplashController extends GetxController {
  @override
  void onReady() {
    super.onReady();
    print("on Ready screen");
    _checkLogin();
  }

  Future<void> _checkLogin() async {
    print("islogging in gainer splash: ");
    await Future.delayed(const Duration(seconds: 2));
    final isLoggedIn = await AuthService.isLoggedIn();

    print("islogging in gainer splash: $isLoggedIn");
    if (isLoggedIn) {
      // Get.OffNamed(Routes.GAINERMAINVIEW);
      Get.offNamed(Routes.GAINERMAINVIEW);
    } else {
      Get.offAllNamed(Routes.LOGIN);
    }
  }
}
