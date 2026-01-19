import 'package:gainer/dealer_monitoring/screens/dm_splash_screen.dart';
import 'package:gainer/gainer_app/modules/gainer_splash/gainer_splash_view.dart';
import 'package:gainer/gainer_app/modules/internet_connectivity/no_internet_binding.dart';
import 'package:gainer/gainer_app/modules/internet_connectivity/no_internet_view.dart';
import 'package:get/get.dart';
import '../modules/gainer_splash/gainer_splash_binding.dart';
import '../modules/home/home_binding.dart';
import '../modules/home/home_view.dart';
import '../modules/login/login_binding.dart';
import '../modules/login/login_view.dart';
import 'package:gainer/gainer_app/modules/app_switcher_view/app_switcher_binding.dart';
import 'package:gainer/gainer_app/modules/app_switcher_view/app_switcher_view.dart';
import '../../testing/example_screen.dart';
import '../modules/main_screen/gainer_main_binding.dart';
import '../modules/main_screen/gainer_main_view.dart';
import '../modules/splash/splash_binding.dart';
import '../modules/splash/splash_view.dart';
import 'app_routes.dart';

// class AppPages {
//   // static const INITIAL = Routes.LOGIN;
// <<<<<<< HEAD
//   // static final INITIAL = AuthService.isLoggedIn() ? Routes.HOME : Routes.LOGIN;
//   // final INITIAL = await AuthService.isLoggedIn() ? Routes.HOME : Routes.LOGIN;
// =======
//   // static final INITIAL = AuthService.isLoggedIn() ? '/app_switcher_view' : '/login';
// >>>>>>> b056c7f8578cae3e3d804243b9e1ce0638d31fbf
//   static final routes = [
//     GetPage(
//       name: Routes.SPLASH,
//       page: () => const SplashView(),
//       binding: SplashBinding(),
//     ),
//     GetPage(
//       name: Routes.LOGIN,
//       page: () => const LoginView(),
//       binding: LoginBinding(),
//     ),
//     GetPage(
// <<<<<<< HEAD
//       name: Routes.HOME,
//       page: () => const HomeView(),
//       binding: HomeBinding(),
//     ),
//     GetPage(
//       name: Routes.DMSPLASH,
//       page: () => const DMSplashScreen(),
//       transition: Transition.rightToLeft,
//       // binding: HomeBinding(),
//     ),
//     GetPage(
//       name: Routes.GAINERSPLASH,
//       // page: () => const SplashScreen(),
//       page: () => const GainerSplashView(),
//       transition: Transition.rightToLeft,
//       binding: GainerSplashBinding(),
//     ),
//     GetPage(
//       name: Routes.NOINTERNETVIEW,
//       page: () => const NoInternetView(),
//       binding: NoInternetBinding(),
//     ),
// =======
//       name: Routes.APPSWITCHER,
//       page: () => const AppSwitcherView(),
//       binding: AppSwitcherBinding(),
//     ),
//
//     ///Gainer Bottom Navigator
// >>>>>>> b056c7f8578cae3e3d804243b9e1ce0638d31fbf
//     GetPage(
//       name: Routes.GAINERMAINVIEW,
//       page: () => const GainerMainView(),
//       binding: GainerMainBinding(),
// <<<<<<< HEAD
//       transition: Transition.rightToLeft,
//     ),
// =======
//     ),
//     GetPage(
//       name: Routes.HOME,
//       page: () => HomeView(),
//       binding: HomeBinding(),
//     ),
//
//     //Temp screen
//     GetPage(name: Routes.ORDERS, page: () => const OrdersScreen()),
//     GetPage(name: Routes.INVENTORY, page: () => const InventoryScreen()),
//     GetPage(name: Routes.PROFILE, page: () => const ProfileScreen()),
// >>>>>>> b056c7f8578cae3e3d804243b9e1ce0638d31fbf
//   ];
// }

class AppPages {
// static const INITIAL = Routes.LOGIN;
// static final INITIAL = AuthService.isLoggedIn() ? Routes.HOME : Routes.LOGIN;
// final INITIAL = await AuthService.isLoggedIn() ? Routes.HOME : Routes.LOGIN;

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
      name: Routes.DMSPLASH,
      page: () => const DMSplashScreen(),
      transition: Transition.rightToLeft,
// binding: HomeBinding(),
    ),
    GetPage(
      name: Routes.GAINERSPLASH,
      page: () => const GainerSplashView(),
      binding: GainerSplashBinding(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: Routes.NOINTERNETVIEW,
      page: () => const NoInternetView(),
      binding: NoInternetBinding(),
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
      transition: Transition.rightToLeft,
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
