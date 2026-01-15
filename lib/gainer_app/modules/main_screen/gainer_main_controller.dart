import 'package:flutter/material.dart';
import 'package:gainer/gainer_app/modules/navbar/home_view/home_view.dart';
import 'package:get/get.dart';
import '../../../testing/example_screen.dart';
import 'nav_model.dart';

class GainerMainController extends GetxController {
  var selectedLocation = 'Location'.obs;
  SearchController searchController = SearchController();

  final RxInt currentIndex = 0.obs;

  final List<NavItem> navItems = [
    NavItem(
      label: "Home",
      icon: Icons.home,
      page: HomeView(),
      // page: const GainerMainView(),
    ),
    NavItem(
      label: "Orders",
      icon: Icons.shopping_cart,
      page: const OrdersScreen(),
    ),
    NavItem(
      label: "Inventory",
      icon: Icons.inventory,
      page: const InventoryScreen(),
    ),
    NavItem(
      label: "Profile",
      icon: Icons.person,
      page: const ProfileScreen(),
    ),
  ];

  List<Widget> get pages => navItems.map((e) => e.page).toList();

  List<BottomNavigationBarItem> get items =>
      navItems
          .map(
            (e) => BottomNavigationBarItem(
          icon: Icon(e.icon),
          label: e.label,
        ),
      )
          .toList();

  void changeTab(int index) {
    currentIndex.value = index;
  }

  //
  // // final RxList<NavItem> navItems = <NavItem>[
  // //   NavItem(
  // //     label: "Home",
  // //     icon: Icons.app_switcher_view,
  // //     route: Routes.GAINERMAINVIEW,
  // //   ),
  // //   NavItem(
  // //     label: "Orders",
  // //     icon: Icons.shopping_cart,
  // //     route: Routes.ORDERS,
  // //   ),
  // //   NavItem(
  // //     label: "Inventory",
  // //     icon: Icons.inventory,
  // //     route: Routes.INVENTORY,
  // //   ),
  // //   NavItem(
  // //     label: "Profile",
  // //     icon: Icons.person,
  // //     route: Routes.PROFILE,
  // //   ),
  // // ].obs;
  //
  //
  // final buyerActions = [
  //   ActionItem(
  //     icon: Icons.shopping_cart,
  //     title: "Order Placed",
  //     subtitle: "6 orders | ₹10.13L",
  //     status: "Pending since Jan 10, 2025",
  //     iconColor: Colors.blue,
  //     actionKey: 'orderPlaced',
  //   ),
  //   ActionItem(
  //     icon: Icons.update,
  //     title: "Update PO Details",
  //     subtitle: "3 orders | ₹3.22L",
  //     status: "Pending since Jan 10, 2025",
  //     iconColor: Colors.blue,
  //     actionKey: 'updatePo',
  //   ),
  //   ActionItem(
  //     icon: Icons.inventory,
  //     title: "Part Receipt",
  //     subtitle: "8 orders | ₹13.45L",
  //     status: "Pending since Jan 10, 2025",
  //     iconColor: Colors.blue,
  //     actionKey: 'partReceipt',
  //   ),
  // ];
  //
  // final sellerActions = [
  //   ActionItem(
  //     icon: Icons.shopping_cart,
  //     title: "Order Received",
  //     subtitle: "6 orders | ₹10.13L",
  //     status: "Pending since Jan 10, 2025",
  //     iconColor: Colors.green,
  //     actionKey: 'orderReceived',
  //   ),
  //   ActionItem(
  //     icon: Icons.update,
  //     title: "Manifestation",
  //     subtitle: "3 orders | ₹3.22L",
  //     status: "Pending since Jan 10, 2025",
  //     iconColor: Colors.green,
  //     actionKey: 'Manifestation',
  //   ),
  //   ActionItem(
  //     icon: Icons.inventory,
  //     title: "Dispatched Details",
  //     subtitle: "8 orders | ₹13.45L",
  //     status: "Pending since Jan 10, 2025",
  //     iconColor: Colors.green,
  //     actionKey: 'DispatchedDetails',
  //   ),
  // ];
  //
  // void onActionTap(String actionKey) {
  //   switch (actionKey) {
  //     case 'orderPlaced':
  //       Get.toNamed('/buyer/orders');
  //       break;
  //
  //     case 'updatePo':
  //       Get.toNamed('/buyer/update-po');
  //       break;
  //
  //     case 'partReceipt':
  //       Get.toNamed('/buyer/part-receipt');
  //       break;
  //
  //     case 'orderReceived':
  //       Get.toNamed('/seller/orders');
  //       break;
  //
  //     case 'manifestation':
  //       Get.toNamed('/seller/manifestation');
  //       break;
  //
  //     case 'dispatchDetails':
  //       Get.toNamed('/seller/dispatch');
  //       break;
  //
  //     default:
  //       break;
  //   }
  // }
  //
  // void onSearchPressed() {
  //   final query = searchController.text.trim();
  //   if (query.isEmpty) return;
  //
  //   log("Search: $query");
  //   // API call / filter logic here
  // }
  //
  // void onSearchChanged(String value) {
  //   // debounce / live search
  //   log("Typing: $value");
  // }
  //
  // @override
  // void onClose() {
  //   searchController.dispose();
  //   super.onClose();
  // }
}
