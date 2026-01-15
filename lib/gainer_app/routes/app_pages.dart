import 'package:gainer/gainer_app/modules/app_switcher_view/app_switcher_binding.dart';
import 'package:gainer/gainer_app/modules/app_switcher_view/app_switcher_view.dart';
import 'package:get/get.dart';
import '../../testing/example_screen.dart';
import '../modules/login/login_binding.dart';
import '../modules/login/login_view.dart';
import '../modules/main_screen/gainer_main_binding.dart';
import '../modules/main_screen/gainer_main_view.dart';
import '../modules/navbar/home_view/home_binding.dart';
import '../modules/navbar/home_view/home_view.dart';
import '../modules/splash/splash_binding.dart';
import '../modules/splash/splash_view.dart';
import 'app_routes.dart';

class AppPages {
  // static const INITIAL = Routes.LOGIN;
  // static final INITIAL = AuthService.isLoggedIn() ? '/app_switcher_view' : '/login';
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
      name: Routes.APPSWITCHER,
      page: () => const AppSwitcherView(),
      binding: AppSwitcherBinding(),
    ),

    ///Gainer Bottom Navigator
    GetPage(
      name: Routes.GAINERMAINVIEW,
      page: () => const GainerMainView(),
      binding: GainerMainBinding(),
    ),
    GetPage(
      name: Routes.HOME,
      page: () => HomeView(),
      binding: HomeBinding(),
    ),

    //Temp screen
    GetPage(name: Routes.ORDERS, page: () => const OrdersScreen()),
    GetPage(name: Routes.INVENTORY, page: () => const InventoryScreen()),
    GetPage(name: Routes.PROFILE, page: () => const ProfileScreen()),
  ];
}
