import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../gainer/controllers/home_screen_controller.dart';
import '../../gainer/shared_preferences/shared_preferences_get_data.dart';
import '../../gainer/shared_preferences/shared_preferences_set_data.dart';
import '../core/services/api_services.dart';
import '../core/utils/dm_images.dart';
import '../core/utils/transform_value_ind.dart';
import '../widgets/access_denied_snackbar.dart';

class DMMainController extends GetxController {
  ApiServices api = ApiServices();
  final LocationController _locationController = Get.put(LocationController());
  RxnString selectedLocation = RxnString(null);
  //Dates
  RxnString stockDate = RxnString("--/--/----");
  RxnString jobLineDate = RxnString("--/--/----");
  RxnString jobCardDate = RxnString("--/--/----");

  RxnString fName = RxnString("FirstName");
  RxnString lName = RxnString("LastName");
  RxnString photo = RxnString(null);

  var currentScreen = 0.obs;
  void openScreen(int index) => currentScreen.value = index;
  // void goHome() => currentScreen.value = 0;

  final List<Map<String, dynamic>> menuItems = [
    // {'img': ConstantImages.binLocation, 'icon': Icons.location_on, 'label': 'Bin Location\nCheck'},
    {
      'img': DMImages.partStockCheck,
      'icon': Icons.inventory,
      'label': 'Part Stock\nCheck',
      // 'screen': PartStockCheckScreen(),
    },
    {
      'img': DMImages.gLogo,
      'icon': Icons.inventory_2,
      'label': 'Gainer Stock\nCheck',
      // 'screen': GainerStockCheck(),
    },
    {
      'img': DMImages.substitutionCheck,
      'icon': Icons.info,
      'label': 'Substitution\nCheck',
      // 'screen': SubstitutionCheckScreen(),
    },
    {
      'img': DMImages.ppniList,
      'icon': Icons.list_alt,
      'label': 'PPNI List\nView',
      // 'screen' : SubstitutionCheckScreen(),
    },
    {
      'img': DMImages.vehicleSearch,
      'icon': Icons.directions_car,
      'label': 'Vehicle\nSearch',
      // 'screen': VehicleSearchScreen(),
    },
    {
      'img': DMImages.saleTrend,
      'icon': Icons.show_chart,
      'label': 'Sale Trend\nView',
      // 'screen': SaleTrendScreen(),
    },
    {
      'img': DMImages.orderInfo,
      'icon': Icons.assignment,
      'label': 'Order\nInformation',
      // 'screen': OrderInfoScreen(),
    },
    {
      'img': DMImages.scsNorms,
      'icon': Icons.warehouse,
      'label': 'SCS Norms\nView',
      // 'screen': ScsNormsScreen(),
    },
    // {
    //   'img': ConstantImages.gainerListening,
    //   'icon': Icons.analytics,
    //   'label': 'My Gainer\nListing'
    //   'screen' : GainerListingScreen(),
    // },
  ];

  ///init work of Dm_main Screen
  initWork() async {
    String? selectedLocation = _locationController.selectedLocation.value;

    // Null check
    if (selectedLocation == null || selectedLocation.isEmpty) {
      if (_locationController.locationIdMap.isEmpty) {
        // No locations available
        Get.rawSnackbar(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          messageText: Center(
            child: Text("No location available. Please try again later",
                style: TextStyle(color: Colors.white)),
          ),
        );
        return; // stop execution
      } else {
        // fallback to first element
        selectedLocation =
            _locationController.locationIdMap.keys.elementAt(0).toString();
      }
    }

    final locationId =
        _locationController.locationIdMap[selectedLocation].toString();

    if (locationId.isEmpty) {
      Get.rawSnackbar(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        messageText: Center(
          child: Text("Invalid location. Please select a valid location",
              style: TextStyle(color: Colors.white)),
        ),
      );
      return;
    }
    _locationController.updateStockDetails(int.parse(locationId));
    int tCode = await getIntData("tCode");
    final response = await api.getUserRole(userId: tCode);
    if (response['success']) {
      final role = response['role'].toLowerCase() ?? "NotDefine";
      setStringData("userRole", role);
    }

    final dealerId = await getStringData("dealerID") ?? 0;
    final responseDate =
        await api.getStockDate(dealerId: dealerId, locationId: locationId);
    if (responseDate['success']) {
      final data = responseDate['data'];

      ///fin stock date
      stockDate.value =
          TransformValue().formatToReadableDate(data[0][0]['StockDate']);
      jobLineDate.value =
          TransformValue().formatToReadableDate(data[1][0]['JoblineCloseDate']);
      jobCardDate.value =
          TransformValue().formatToReadableDate(data[2][0]['JobCardCloseDate']);
    }

    fName.value = await getStringData('firstName');
    lName.value = await getStringData('lastName');
    photo.value = await getStringData('photo');
  }

  Future<void> goto(String label, int index) async {
    final String userRole = await getStringData("userRole");

    // ---------------- PPNI ----------------
    if (label.startsWith("PPNI List")) {
      switch (userRole) {
        case 'general manager':
        case 'ceo':
          openScreen(10);
          return;

        case 'spare parts manager':
          openScreen(11);
          return;

        case 'workshop advisor':
          openScreen(12);
          return;

        default:
          DealerSnackbar.showAccessDenied(
              'You are not authorized to access PPNI');
          return;
      }
    }

    // ---------------- SALES EXECUTIVE RULE ----------------
    if (userRole == 'sales executive') {
      if (label.startsWith("Part Stock") || label.startsWith("Substitution")) {
        openScreen(index + 1);
      } else {
        DealerSnackbar.showAccessDenied(
            'Sales Executive can access only Part Stock and Substitution');
      }
      return;
    }

    // ---------------- ADVISOR RULE ----------------
    if (userRole == 'workshop advisor') {
      if (label.startsWith("Gainer Stock")) {
        DealerSnackbar.showAccessDenied(
            'Advisor cannot access Gainer Stock Check');
        return;
      }
    }

    // ---------------- DEFAULT ACCESS ----------------
    openScreen(index + 1);
  }

// Future<void> goto(String label, int index) async {
  //   final String userRole = await getStringData("userRole");
  //
  //   void showAccessDenied(String message) {
  //     if (Get.isSnackbarOpen) Get.closeAllSnackbars();
  //     Get.snackbar(
  //       'Access Denied',
  //       message,
  //       backgroundColor: DMAppColors.primaryShade,
  //       colorText: Colors.black,
  //     );
  //   }
  //
  //   // ----------- PPNI LIST -----------
  //   if (label.startsWith("PPNI List")) {
  //     switch (userRole) {
  //       case 'General Manager':
  //       case 'CEO':
  //         openScreen(10);
  //         return;
  //
  //       case 'Spare Parts Manager':
  //         openScreen(11);
  //         return;
  //
  //       case 'Workshop Advisor':
  //         openScreen(12);
  //         return;
  //
  //       default:
  //         showAccessDenied('You are not authorized to access PPNI');
  //         return;
  //     }
  //   }
  //
  //   // ----------- STOCK CHECKS -----------
  //   if (label.startsWith("Part Stock") ||
  //       label.startsWith("Gainer Stock") ||
  //       label.startsWith("Substitution")) {
  //     if (userRole == 'Sales Executive') {
  //       openScreen(index + 1);
  //     } else {
  //       showAccessDenied('You are not authorized to access this');
  //     }
  //     return;
  //   }
  //
  //   // ----------- DEFAULT -----------
  //   openScreen(index + 1);
  // }

// Future<void> goto(String label, int index) async {
  //   String userRole = await getStringData("userRole");
  //   if (label.startsWith("PPNI List")) {
  //     // print("Label: $label, userRole::: $userRole");
  //     if (userRole == 'General Manager' || userRole == 'CEO') {
  //       openScreen(10); // GeneralManagerScreen index
  //     } else if (userRole == 'Spare Parts Manager') {
  //       openScreen(11); // WorkshopManagerScreen index
  //     } else if (userRole == "Workshop Advisor") {
  //       openScreen(12); // WorkshopAdvisorScreen index
  //     } else {
  //       Get.snackbar('Access Denied', 'You are not authorized to access PPNI',
  //           backgroundColor: DMAppColors.accent, colorText: Colors.black);
  //     }
  //   }
  //   if (label.startsWith("part stock check") ||
  //       label.startsWith("gainer stock check") ||
  //       label.startsWith("substitution check")) {
  //     if (userRole == 'Sales Executive') {
  //     } else {
  //       Get.snackbar('Access Denied', 'You are not authorized to access this',
  //           backgroundColor: DMAppColors.accent, colorText: Colors.black);
  //     }
  //   } else {
  //     openScreen(index + 1);
  //   }
  // }
}
