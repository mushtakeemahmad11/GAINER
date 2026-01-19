import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:gainer/gainer_app/core/services/auth_service.dart';
import 'package:gainer/gainer_app/modules/app_switcher_view/app_switcher_controller.dart';
import 'package:gainer/gainer_app/modules/internet_connectivity/no_internet_controller.dart';
import 'package:gainer/gainer_app/modules/navbar/home_view/models/stage_model.dart';
import 'package:get/get.dart';
import '../../../../gainer/apis_functionality/api_service.dart';
import '../../../../gainer/controllers/notification_controller.dart';
import '../../../routes/app_routes.dart';
import '../../main_screen/models/action_item_model.dart';
import 'models/stage_action_config.dart';

class HomeController extends GetxController {
  AppSwitcherController appSwitcherController =
      Get.find<AppSwitcherController>();

  @override
  void onInit() {
    _initWork();
    super.onInit();
  }

  ///After location changed from dropdown
  void onChangeLocation(String location) {
    final locationId = appSwitcherController.locationIdMap[location];
    selectedLocationId.value = locationId;
    getBuyerDetails(locationId!);
    appSwitcherController.updateStockDetails(locationId);
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

  final buyerActionsDummyData = [
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

  // final sellerActions1 = [
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

  Rx<String?> selectedLocation = Rx<String?>(null);
  Rx<String?> selectedLocationId = Rx<String?>(null);

  _initWork() {
    final stockDetails = appSwitcherController.getStock();
    String? locationId = stockDetails?.locationId.toString() ?? '';
    getBuyerDetails(locationId);
  }

  Future<void> onChangedLocation() async {}

  final RxString funBalance = ''.obs;
  final RxList<StageModel> stageList = <StageModel>[].obs;

  final RxList<ActionItem> buyerActions = <ActionItem>[].obs;
  final RxList<ActionItem> sellerActions = <ActionItem>[].obs;
  static const Map<String, String> buyerStageMap = {
    'OrderPlaced': 'Order Placed',
    'PoUpdation': 'Update Po Details',
    'PartsReceipt': 'Part Receipt',
  };

  static const Map<String, String> sellerStageMap = {
    'OrderDue': 'Order Received',
    'Manifestation': 'Manifestation',
    'DispatchDetail': 'Dispatched Details',
  };

  List<ActionItem> _buildActions(
    List<StageModel> stages, {
    required bool isBuyer,
  }) {
    final allowedStages = isBuyer ? buyerStageMap : sellerStageMap;
    return stages
        .where((stage) => allowedStages.keys.contains(stage.stage))
        .map((stage) {
      final config = stageConfigMap[stage.stage];
      final stageName = allowedStages[stage.stage] ?? '';
      // final partCount = stage.partsCount > 0
      //     ? '${stage.partsCount} orders | ₹ ${stage.val}L'
      //     : '-';
      return ActionItem(
        icon: config?.icon ?? Icons.info,
        // title: stage.stage,
        title: stageName,
        // subtitle: partCount,
        subtitle: '${stage.partsCount} orders | ₹${stage.val}L',
        status: 'Pending since Jan 10, 2025',
        iconColor: isBuyer ? Colors.blue : Colors.green,
        // ? (config?.buyerColor ?? Colors.blue)
        // : (config?.sellerColor ?? Colors.green),
        actionKey: stage.stage,
      );
    }).toList();
  }

  void setStageData(List<StageModel> stages) {
    stageList.assignAll(stages);

    buyerActions.value = _buildActions(
      stageList,
      isBuyer: true,
    );

    sellerActions.value = _buildActions(
      stageList,
      isBuyer: false,
    );

    //   buyerActions.assignAll(_buildActions(stages, isBuyer: true));
    //   sellerActions.assignAll(_buildActions(stages, isBuyer: false));
  }

  RxBool isStageDataLoad = false.obs;
  // final RxList<StageModel> stageList = <StageModel>[].obs;

  final NotificationController _notificationController =
      Get.find<NotificationController>();
  Future<void> getBuyerDetails(String locationId) async {
    // fetchVersionFromFirestore(); //check for update
    // for notification fetch
    // final stockDetails = appSwitcherController.getStock();
    // String? locationId = stockDetails?.locationId.toString() ?? '';

    if (!Get.find<NoInternetController>().isConnected.value) {
      Get.toNamed(Routes.NOINTERNETVIEW);
      return;
    }
    isStageDataLoad.value = true;
    final response = await ApiService().getBuyerValues(locationId);
    isStageDataLoad.value = false;
    if (response['success']) {
      final List data = jsonDecode(response['data']);
      final stages = data.map((e) => StageModel.fromJson(e)).toList();

      setStageData(stages);
      funBalance.value = stageList.first.walletBalance.toInt().toString();
      await AuthService.saveLocationId(locationId);
      print("Location ID: $locationId");
      print("Fund avl for order ${funBalance.value}");
      print("Stock Date ${appSwitcherController.stockData.value}");
      // print("data from stageList.value: ${stageList[0].}");
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

    await _notificationController.fetchNotifications(locationId);
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
