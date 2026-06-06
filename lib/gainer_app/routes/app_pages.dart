import 'package:gainer/dealer_monitoring/screens/dm_splash_screen.dart';
import 'package:gainer/gainer_app/modules/action_as_buyer/direct_request_sent/dr_sent_binding.dart';
import 'package:gainer/gainer_app/modules/action_as_buyer/direct_request_sent/dr_sent_view.dart';
import 'package:gainer/gainer_app/modules/action_as_buyer/order_placed_view/order_placed_binding.dart';
import 'package:gainer/gainer_app/modules/action_as_buyer/update_po_view/screens/update_po_image_view.dart';
import 'package:gainer/gainer_app/modules/action_as_buyer/update_po_view/screens/update_po_order_summary.dart';
import 'package:gainer/gainer_app/modules/action_as_seller/dispatched_details_view/dispatched_details_binding.dart';
import 'package:gainer/gainer_app/modules/action_as_seller/dispatched_details_view/dispatched_details_view.dart';
import 'package:gainer/gainer_app/modules/action_as_seller/manifestation_view/bindings/cal_f_c_binding.dart';
import 'package:gainer/gainer_app/modules/action_as_seller/manifestation_view/screens/manifestation_view.dart';
import 'package:gainer/gainer_app/modules/direct_request_view/direct_request_tab_bar.dart';
import 'package:gainer/gainer_app/modules/gainer_splash/gainer_splash_view.dart';
import 'package:gainer/gainer_app/modules/internet_connectivity/no_internet_binding.dart';
import 'package:gainer/gainer_app/modules/internet_connectivity/no_internet_view.dart';
import 'package:get/get.dart';
import '../../app_switcher_view/app_switcher_binding.dart';
import '../../app_switcher_view/app_switcher_view.dart';
import '../modules/action_as_buyer/order_placed_view/order_placed_view.dart';
import '../modules/action_as_buyer/part_receipt_view/part_receipt_binding.dart';
import '../modules/action_as_buyer/part_receipt_view/part_receipt_view.dart';
import '../modules/action_as_buyer/update_po_view/update_po_binding.dart';
import '../modules/action_as_buyer/update_po_view/screens/update_po_view.dart';
import '../modules/action_as_seller/direct_request_received/dr_received_binding.dart';
import '../modules/action_as_seller/direct_request_received/dr_received_view.dart';
import '../modules/action_as_seller/manifestation_view/bindings/manifestation_binding.dart';
import '../modules/action_as_seller/manifestation_view/screens/cal_f_c_view.dart';
import '../modules/action_as_seller/manifestation_view/screens/manifestation_summary_view.dart';
import '../modules/action_as_seller/order_received_view/order_received_binding.dart';
import '../modules/action_as_seller/order_received_view/screens/order_received_view.dart';
import '../modules/bottom_navbar/help_view/help_binding.dart';
import '../modules/bottom_navbar/home_view/home_binding.dart';
import '../modules/direct_request_view/tab_view/direct_req_tab/direct_request_binding.dart';
import '../modules/direct_request_view/tab_view/scs_req_tab/scs_request_binding.dart';
import '../modules/gainer_splash/gainer_splash_binding.dart';
import '../modules/login/login_binding.dart';
import '../modules/login/login_view.dart';
import '../modules/main_view/gainer_main_binding.dart';
import '../modules/main_view/gainer_main_view.dart';
import '../modules/notification_view/notification_view.dart';
import '../modules/part_request_view/part_request_binding.dart';
import '../modules/part_request_view/part_request_view.dart';
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
      // binding: AppSwitcherBinding(),
      bindings: [AppSwitcherBinding(), HomeBinding()],
    ),

    ///Gainer
    GetPage(
      name: Routes.GAINERMAINVIEW,
      page: () => const GainerMainView(),
      bindings: [GainerMainBinding(), HelpBinding()],
      transition: Transition.rightToLeft,
    ),

    ///Buyer
    GetPage(
      name: Routes.DIRECTREQSENT,
      page: () => DrSentView(),
      binding: DrSentBinding(),
    ),

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

    GetPage(
      name: Routes.UPDATEPOIMAGEVIEW,
      page: () => UpdatePoImageView(),
    ),

    GetPage(
      name: Routes.UPDATEPOORDERSUMMARY,
      page: () => UpdatePoOrderSummary(),
      transition: Transition.rightToLeft,
    ),

    GetPage(
      name: Routes.PARTRECEIPT,
      page: () => PartReceiptView(),
      binding: PartReceiptBinding(),
    ),

    ///Seller
    GetPage(
      name: Routes.DIRECTREQRECEIVED,
      page: () => DrReceivedView(),
      binding: DrReceivedBinding(),
    ),
    GetPage(
      name: Routes.ORDERRECEIVED,
      page: () => OrderReceivedView(),
      binding: OrderReceivedBinding(),
    ),

    GetPage(
      name: Routes.MANIFESTATIONVIEW,
      page: () => ManifestationView(),
      binding: ManifestationBinding(),
    ),

    GetPage(
      name: Routes.MANIFESTATIONSUMMARY,
      page: () => ManifestationSummaryView(),
      transition: Transition.rightToLeft,
    ),

    GetPage(
      name: Routes.DISPATCHEDDETAILSVIEW,
      page: () => DDView(),
      binding: DDBinding(),
    ),

    GetPage(
      name: Routes.MANIFESTATIONFCVIEW,
      page: () => CalFCView(),
      binding: CalFCBinding(),
      transition: Transition.rightToLeft,
    ),

    GetPage(
      name: Routes.PARTREQUESTVIEW,
      page: () => PartRequestView(),
      binding: PartRequestBinding(),
    ),

    GetPage(
      name: Routes.DIRECTREQ,
      page: () => DirectRequestTabBar(),
      bindings: [DirectRequestBinding(), ScsRequestBinding()],
    ),

    GetPage(
      name: Routes.NOTIFICATIONVIEW,
      page: () => NotificationView(),
    ),
  ];
}
