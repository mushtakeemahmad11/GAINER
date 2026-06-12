import 'package:flutter/material.dart';
import 'package:gainer/gainer_app/core/Services/auth_service.dart';
import 'package:gainer/gainer_app/core/widgets/gainer_bottom_sheet.dart';
import 'package:get/get.dart';
import '../../app_switcher_view/app_switcher_controller.dart';
import '../../gainer_app/modules/login/model/user_model.dart';
import '../core/services/dm_api_services.dart';
import '../core/utils/dm_images.dart';
import '../core/utils/transform_value_ind.dart';
import '../widgets/access_denied_snackbar.dart';

class DMMainController extends GetxController {
  DMApiServices api = DMApiServices();
  final controller = Get.find<AppSwitcherController>();
  RxnString selectedLocation = RxnString(null);
  //Dates
  RxnString stockDate = RxnString("--/--/----");
  RxnString jobLineDate = RxnString("--/--/----");
  RxnString jobCardDate = RxnString("--/--/----");

  RxString name = 'User Name'.obs;
  RxString userRole = 'User Role'.obs;
  RxnString profileImage = RxnString(null);
  RxnString pickedProfileImg = RxnString(null);

  var currentScreen = 0.obs;
  void openScreen(int index) => currentScreen.value = index;
  // void goHome() => currentScreen.value = 0;

  final List<Map<String, dynamic>> menuItems = [
    {
      'img': DMImages.partStockCheck,
      'icon': Icons.inventory,
      'label': 'Part Stock\nCheck',
    },
    {
      'img': DMImages.gLogo,
      'icon': Icons.inventory_2,
      'label': 'Gainer Stock\nCheck',
    },
    {
      'img': DMImages.substitutionCheck,
      'icon': Icons.info,
      'label': 'Substitution\nCheck',
    },
    {
      'img': DMImages.ppniList,
      'icon': Icons.list_alt,
      'label': 'PPNI List\nView',
    },
    {
      'img': DMImages.vehicleSearch,
      'icon': Icons.directions_car,
      'label': 'Vehicle\nSearch',
    },
    {
      'img': DMImages.saleTrend,
      'icon': Icons.show_chart,
      'label': 'Sale Trend\nView',
    },
    {
      'img': DMImages.orderInfo,
      'icon': Icons.assignment,
      'label': 'Order\nInformation',
    },
    {
      'img': DMImages.scsNorms,
      'icon': Icons.warehouse,
      'label': 'SCS Norms\nView',
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
    String? selectedLocation = controller.selectedLocation.value;

    // Null check
    if (selectedLocation == null || selectedLocation.isEmpty) {
      if (controller.locationIdMap.isEmpty) {
        // No locations available
        GainerBottomSheet.showSnackBar(
            'No location available. Please try again later');

        return; // stop execution
      } else {
        // fallback to first element
        selectedLocation =
            controller.locationIdMap.keys.elementAt(0).toString();
      }
    }

    final locationId = controller.locationIdMap[selectedLocation].toString();
    if (locationId.isEmpty) {
      GainerBottomSheet.showSnackBar(
          'Invalid location. Please select a valid location');

      return;
    }
    controller.updateStockDetails(locationId);
    await AuthService.saveLocationId(locationId);
    await AuthService.saveLocation(selectedLocation);
    final dealerId = await AuthService.getDealerId();
    final responseDate =
        await api.getStockDate(dealerId: dealerId, locationId: locationId);
    if (responseDate['success']) {
      final data = responseDate['data'];

      ///fin stock date
      final normalizedData = [
        _safeList(data, 0, 'StockDate'),
        _safeList(data, 1, 'JoblineCloseDate'),
        _safeList(data, 2, 'JobCardCloseDate'),
      ];

      stockDate.value = TransformValue()
          .formatToReadableDate(normalizedData[0][0]['StockDate']);

      jobLineDate.value = TransformValue()
          .formatToReadableDate(normalizedData[1][0]['JoblineCloseDate']);

      jobCardDate.value = TransformValue()
          .formatToReadableDate(normalizedData[2][0]['JobCardCloseDate']);
    }

    getUserDetails();
  }

  List<Map<String, dynamic>> _safeList(
    List<dynamic>? data,
    int index,
    String key,
  ) {
    return [
      {
        key: (data != null &&
                data.length > index &&
                data[index] is List &&
                data[index]?.isNotEmpty == true)
            ? data[index][0][key]
            : null
      }
    ];
  }

  Future<void> getUserDetails() async {
    UserModel? user = await AuthService.getUser();
    userRole.value = await AuthService.getUserRole();

    if (user != null) {
      name.value = "${user.firstName} ${user.lastName}";

      // email.value = user.email;

      final img = user.photo;
      profileImage.value = img;
    }
    pickedProfileImg.value = await AuthService.getProfile();
  }

  Future<void> goto(String label, int index) async {
    final String userRole = await AuthService.getUserRole();

    if (userRole.isEmpty) {
      DealerSnackbar.showAccessDenied(
          'User Role not found\nPlease Restart Application');
      return;
    }

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
}
