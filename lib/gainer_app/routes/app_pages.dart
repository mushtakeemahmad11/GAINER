import 'package:gainer/dealer_monitoring/screens/dm_splash_screen.dart';
import 'package:gainer/gainer_app/modules/gainer_main/gainer_main_binding.dart';
import 'package:gainer/gainer_app/modules/gainer_main/gainer_main_view.dart';
import 'package:gainer/gainer_app/modules/gainer_splash/gainer_splash_view.dart';
import 'package:gainer/gainer_app/modules/internet_connectivity/no_internet_binding.dart';
import 'package:gainer/gainer_app/modules/internet_connectivity/no_internet_view.dart';
import 'package:get/get.dart';
import '../modules/gainer_splash/gainer_splash_binding.dart';
import '../modules/home/home_binding.dart';
import '../modules/home/home_view.dart';
import '../modules/login/login_binding.dart';
import '../modules/login/login_view.dart';
import '../modules/splash/splash_binding.dart';
import '../modules/splash/splash_view.dart';
import 'app_routes.dart';

class AppPages {
  // static const INITIAL = Routes.LOGIN;
  // static final INITIAL = AuthService.isLoggedIn() ? Routes.HOME : Routes.LOGIN;
  // final INITIAL = await AuthService.isLoggedIn() ? Routes.HOME : Routes.LOGIN;
  static final routes = [
    GetPage(
      name: Routes.SPLASH,
      page: () => const SplashView(),
      binding: SplashBinding(),
    ),
    GetPage(
      name: Routes.LOGIN,
      page: () => const LoginView(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: Routes.HOME,
      page: () => const HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: Routes.DMSPLASH,
      page: () => const DMSplashScreen(),
      transition: Transition.rightToLeft,
      // binding: HomeBinding(),
    ),
    GetPage(
      name: Routes.GAINERSPLASH,
      // page: () => const SplashScreen(),
      page: () => const GainerSplashView(),
      transition: Transition.rightToLeft,
      binding: GainerSplashBinding(),
    ),
    GetPage(
      name: Routes.NOINTERNETVIEW,
      page: () => const NoInternetView(),
      binding: NoInternetBinding(),
    ),
    GetPage(
      name: Routes.GAINERMAINVIEW,
      page: () => const GainerMainView(),
      binding: GainerMainBinding(),
      transition: Transition.rightToLeft,
    ),
  ];
}
