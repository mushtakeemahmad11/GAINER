import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:gainer/gainer_app/modules/app_switcher_view/app_switcher_controller.dart';
import 'package:gainer/gainer_app/modules/app_switcher_view/app_switcher_controller.dart';
import 'package:get/get.dart';

import '../../../../gainer/apis_functionality/api_service.dart';
import '../../../../gainer/controllers/notification_controller.dart';
import '../../main_screen/models/action_item_model.dart';

class HomeController extends GetxController {
  AppSwitcherController appSwitcherController =
      Get.find<AppSwitcherController>();


  onChangeLocation(locationId){

  }
  ///FIND LOCATION WORK
  // API data list
  // final RxList<String> locations = <String>[].obs;

  // Selected value (nullable)
  // final RxnString selectedLocation = RxnString();

  // Loading state
  // final RxBool isLoading = false.obs;

  // @override
  // void onInit() {
  //   super.onInit();
  //   fetchLocations();
  // }
  //
  // // Future<void> fetchLocations() async {
  // //   try {
  // //     isLoading.value = true;
  // //
  // //     // 🔹 Simulate API delay
  // //     await Future.delayed(const Duration(seconds: 1));
  // //
  // //     // 🔹 API response
  // //     final response = ['Delhi', 'Mumbai', 'Pune', 'Chennai'];
  // //
  // //     locations.assignAll(response);
  // //   } finally {
  // //     isLoading.value = false;
  // //   }
  // // }
  // //
  // // void clearLocation() {
  // //   selectedLocation.value = null;
  // // }

  ///-------------------------
  // final AppSwitcherController _c = Get.find();
  //
  // List<LocationDataModel> get filteredData {
  //   final locationId = _c.selectedLocationId.value;
  //
  //   if (locationId == null) return [];
  //
  //   return _c.stockList
  //       .where((e) => e.locationId == locationId)
  //       .toList();
  // }
  //
  // double get totalStockValue {
  //   return filteredData.fold(
  //     0,
  //         (sum, item) => sum + item.stockVal,
  //   );
  // }

  SearchController searchController = SearchController();

  final RxInt currentIndex = 0.obs;

  // final List<NavItem> navItems = [
  //   NavItem(
  //     label: "Home",
  //     icon: Icons.home,
  //     page: const HomeScreen(),
  //     // page: const GainerMainView(),
  //   ),
  //   NavItem(
  //     label: "Orders",
  //     icon: Icons.shopping_cart,
  //     page: const OrdersScreen(),
  //   ),
  //   NavItem(
  //     label: "Inventory",
  //     icon: Icons.inventory,
  //     page: const InventoryScreen(),
  //   ),
  //   NavItem(
  //     label: "Profile",
  //     icon: Icons.person,
  //     page: const ProfileScreen(),
  //   ),
  // ];
  //
  // List<Widget> get pages => navItems.map((e) => e.page).toList();
  //
  // List<BottomNavigationBarItem> get items =>
  //     navItems
  //         .map(
  //           (e) => BottomNavigationBarItem(
  //         icon: Icon(e.icon),
  //         label: e.label,
  //       ),
  //     )
  //         .toList();
  //
  // void changeTab(int index) {
  //   currentIndex.value = index;
  // }

  // final RxList<NavItem> navItems = <NavItem>[
  //   NavItem(
  //     label: "Home",
  //     icon: Icons.app_switcher_view,
  //     route: Routes.GAINERMAINVIEW,
  //   ),
  //   NavItem(
  //     label: "Orders",
  //     icon: Icons.shopping_cart,
  //     route: Routes.ORDERS,
  //   ),
  //   NavItem(
  //     label: "Inventory",
  //     icon: Icons.inventory,
  //     route: Routes.INVENTORY,
  //   ),
  //   NavItem(
  //     label: "Profile",
  //     icon: Icons.person,
  //     route: Routes.PROFILE,
  //   ),
  // ].obs;

  final buyerActions = [
    ActionItem(
      icon: Icons.shopping_cart,
      title: "Order Placed",
      subtitle: "6 orders | ₹10.13L",
      status: "Pending since Jan 10, 2025",
      iconColor: Colors.blue,
      actionKey: 'orderPlaced',
    ),
    ActionItem(
      icon: Icons.update,
      title: "Update PO Details",
      subtitle: "3 orders | ₹3.22L",
      status: "Pending since Jan 10, 2025",
      iconColor: Colors.blue,
      actionKey: 'updatePo',
    ),
    ActionItem(
      icon: Icons.inventory,
      title: "Part Receipt",
      subtitle: "8 orders | ₹13.45L",
      status: "Pending since Jan 10, 2025",
      iconColor: Colors.blue,
      actionKey: 'partReceipt',
    ),
  ];

  final sellerActions = [
    ActionItem(
      icon: Icons.shopping_cart,
      title: "Order Received",
      subtitle: "6 orders | ₹10.13L",
      status: "Pending since Jan 10, 2025",
      iconColor: Colors.green,
      actionKey: 'orderReceived',
    ),
    ActionItem(
      icon: Icons.update,
      title: "Manifestation",
      subtitle: "3 orders | ₹3.22L",
      status: "Pending since Jan 10, 2025",
      iconColor: Colors.green,
      actionKey: 'Manifestation',
    ),
    ActionItem(
      icon: Icons.inventory,
      title: "Dispatched Details",
      subtitle: "8 orders | ₹13.45L",
      status: "Pending since Jan 10, 2025",
      iconColor: Colors.green,
      actionKey: 'DispatchedDetails',
    ),
  ];

  void onActionTap(String actionKey) {
    log('Tap on: $actionKey');
    return;
    switch (actionKey) {
      case 'orderPlaced':
        Get.toNamed('/buyer/orders');
        break;

      case 'updatePo':
        Get.toNamed('/buyer/update-po');
        break;

      case 'partReceipt':
        Get.toNamed('/buyer/part-receipt');
        break;

      case 'orderReceived':
        Get.toNamed('/seller/orders');
        break;

      case 'manifestation':
        Get.toNamed('/seller/manifestation');
        break;

      case 'dispatchDetails':
        Get.toNamed('/seller/dispatch');
        break;

      default:
        break;
    }
  }

  void onSearchPressed() {
    final query = searchController.text.trim();
    if (query.isEmpty) return;

    log("Search: $query");
    // API call / filter logic here
  }

  void onSearchChanged(String value) {
    // debounce / live search
    log("Typing: $value");
  }

  @override
  void onInit() {
    getBuyerDetails();
    super.onInit();
  }

  final NotificationController _notificationController =
      Get.find<NotificationController>();
  Future<void> getBuyerDetails() async {
    // fetchVersionFromFirestore(); //check for update
    // for notification fetch
    final stockDetails = appSwitcherController.getStock();
    String? locationId = stockDetails?.locationId.toString() ?? '';
    await _notificationController.fetchNotifications(locationId);
    // print(
    //     "location: $locationId, Notification Length: ${_notificationController.notifications.length}");

    // locationController.errorMsg.value = null;
    // locationController.isLoading.value = true;
    final response = await ApiService().getBuyerValues(locationId);
    // locationController.isLoading.value = false;

    if (response['success']) {
      var data = jsonDecode(response['data'].toString());
      print("data from getbuyerValue: ${response['data']}");
      // locationController.users.clear();
      // for (Map<String, dynamic> index in data) {
      //   locationController.users.add(StageData.fromJson(index));
      // }
      // locationController.usersMap.assignAll({
      //   for (var user in locationController.users) user.stage: user,
      // });
      // locationController.usersMap = {for (var user in locationController.users) user.stage: user};

      // var stockVal = locationController.stockDetails['StockVal'];
      // locationController.listedStockShow.value =
      //     getFormattedStockValue(stockVal);

      // setState(() {});
    } else {}
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }
  // var selectedLocation = 'Location'.obs;
  // SearchController searchController = SearchController();
  //
  // final RxInt currentIndex = 0.obs;
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
