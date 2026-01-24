import 'package:gainer/dealer_monitoring/screens/dm_splash_screen.dart';
import 'package:gainer/gainer_app/modules/action_as_buyer/order_placed_view/order_placed_binding.dart';
import 'package:gainer/gainer_app/modules/gainer_splash/gainer_splash_view.dart';
import 'package:gainer/gainer_app/modules/internet_connectivity/no_internet_binding.dart';
import 'package:gainer/gainer_app/modules/internet_connectivity/no_internet_view.dart';
import 'package:get/get.dart';
import '../modules/action_as_buyer/order_placed_view/order_placed_view.dart';
import '../modules/action_as_buyer/update_po_view/update_po_binding.dart';
import '../modules/action_as_buyer/update_po_view/update_po_view.dart';
import '../modules/gainer_splash/gainer_splash_binding.dart';
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

class AppPages {
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

    // GetPage(
    //   name: Routes.HOME,
    //   page: () => HomeView(),
    //   binding: HomeBinding(),
    // ),

    ///Buyer
    GetPage(
      name: Routes.ORDERPLACED,
      page: () => OrderPlacedView(),
      binding: OrderPlacedBinding(),
    ),

    GetPage(
      name: Routes.UPDATEPO,
      page: () => UpdatePoView(),
      binding: UpdatePoBinding(),
    ),


    ///Seller

//Temp screen
    GetPage(name: Routes.ORDERS, page: () => const OrdersScreen()),
    GetPage(name: Routes.INVENTORY, page: () => const InventoryScreen()),
    GetPage(name: Routes.PROFILE, page: () => const ProfileScreen()),
  ];
}
