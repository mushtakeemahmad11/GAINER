import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gainer/dealer_monitoring/core/services/dm_api_services.dart';
import 'package:gainer/gainer_app/core/widgets/gainer_bottom_sheet.dart';
import 'package:gainer/gainer_app/modules/main_view/models/location_data_model.dart';
import 'package:get/get.dart';
import '../gainer_app/core/Services/auth_service.dart';
import '../gainer_app/core/services/fcm_service/firebase_db_creation.dart';
import '../gainer_app/core/services/fcm_service/firebase_notification_service.dart';
import '../gainer_app/core/services/gainer_api_service.dart';
import '../gainer_app/modules/internet_connectivity/no_internet_controller.dart';
import '../gainer_app/modules/login/model/user_model.dart';
import '../gainer_app/routes/app_routes.dart';

class AppSwitcherController extends GetxController with WidgetsBindingObserver {
  RxString userName = ''.obs;

  /// for notified app update
  RxString oldVersion = '2.0.1'.obs;
  RxString newVersion = ''.obs;
  RxBool isAppUpdated = true.obs;

  RxBool isLoading = true.obs;

  RxnString errMsg = RxnString(null);
  Rx<String?> selectedLocation = Rx<String?>(null);
  Rx<String?> selectedLocationId = Rx<String?>(null);

  RxList<LocationDataModel> locationDataList = <LocationDataModel>[].obs;
  // Observable Map that holds the location data(location:locationID)
  var locationIdMap = <String, String>{}.obs;
  final RxString stockData = ''.obs;

  @override
  void onInit() {
    super.onInit();
    appSwitcherInitWork();
  }

  Future<void> appSwitcherInitWork() async {
    isLoading.value = true;
    await _checkSession();
    try {
      await Future.wait([
        _checkAppAccess(),
        _fetchVersionFromFirestore(),
        getLocation(),
        _notificationPermission(),
      ]);
    } catch (e, s) {
      debugPrintStack(stackTrace: s);
    }
    isLoading.value = false;
  }

  Rxn<LocationDataModel> selectedStock = Rxn<LocationDataModel>();
  void updateStockDetails(String selectedLocationID) {
    final foundStock = locationDataList
        .firstWhere((e) => e.locationId.toString() == selectedLocationID);
    selectedStock.value = foundStock;
    stockData.value = foundStock.stockDate ?? '';
  }

  void onModuleTap(String moduleName) {
    if (!Get.find<NoInternetController>().isConnected.value) {
      Get.toNamed(Routes.NOINTERNETVIEW);
      return;
    }

    switch (moduleName.toLowerCase()) {
      case 'gainer':
        Get.toNamed(Routes.GAINERSPLASH);
        break;
      case 'sims':
        Get.toNamed(Routes.DMSPLASH);
        break;
    }
  }

  void appAccessSnackBar() {
    GainerBottomSheet.showSnackBar("You are not authorised to access this");
  }

  Future<void> _checkSession() async {
    final session = await AuthService.checkSessionExpired();
    if (session) await AuthService.logout('SessionExpired');
  }

  LocationDataModel? getStock() => selectedStock.value;
  Future<void> getLocation() async {
    try {
      UserModel? user = await AuthService.getUser();

      if (user == null) {
        errMsg.value =
            'Something went wrong while fetching user details.\nPlease login again';
        return;
      }

      userName.value = "${user.firstName} ${user.lastName}";
      int userTCode = user.userTCode;

      // Fetch locations
      await getLocationUsingTCode(userTCode.toString());

      // 🔒 SAFETY CHECK (MOST IMPORTANT)
      if (locationDataList.isEmpty) {
        errMsg.value = 'No location found please restart again';
        return;
      }

      await getUSerRole();
      final List<String> locationsIds =
          locationDataList.map((item) => item.locationId.toString()).toList();
      await FirebaseDbCreation.storeUserDetails(
        role: userRole.value,
        dealerId: locationIdMap.values.first,
        locationIds: locationsIds,
        appVersion: oldVersion.value,
      );
    } catch (e, stack) {
      // 🔒 GLOBAL SAFETY (App Store & Play Store friendly)
      errMsg.value = 'Unexpected error occurred. Please try again.';
      debugPrintStack(stackTrace: stack);
    }
  }

  RxString userRole = ''.obs;
  Future<void> getUSerRole() async {
    String tCode = await AuthService.getTCode();
    final response = await DMApiServices().getUserRole(userId: tCode);
    if (response['success']) {
      final role = response['role'].toLowerCase() ?? "NotDefine";
      userRole.value = role;
      await AuthService.saveUserRole(role);
    }
  }

  Future<void> getLocationUsingTCode(String tCode) async {
    try {
      final response = await GainerApiService().getLocation(tCode);
      locationDataList.clear();
      if (response['success']) {
        final data = jsonDecode(response['data']) as List;
        final locationsData =
            data.map((e) => LocationDataModel.fromJson(e)).toList();
        locationDataList.assignAll(locationsData);

        ///LocationsId and locations fro dropdown
        locationIdMap.value = {
          for (var item in locationDataList)
            item.location: item.locationId.toString()
        };
        selectedLocation.value = locationIdMap.keys.first;
        //update stock details by default 0 index
        updateStockDetails(locationIdMap.values.first);

        await AuthService.saveBDLId(
          locationsData.first.brandId.toString(),
          locationsData.first.dealerId.toString(),
          locationsData.first.locationId.toString(),
        );

        await AuthService.saveBDL(
          locationsData.first.brand.toString(),
          locationsData.first.dealer.toString(),
          locationsData.first.location.toString(),
        );
      } else {
        errMsg.value = response['message'];
      }
    } catch (e) {
      errMsg.value = 'Error fetching locations';
    }
  }

  Future<void> _fetchVersionFromFirestore() async {
    bool versionFB = await FirebaseDbCreation.versionCheckFB();
    if (versionFB) {
      try {
        final doc = await FirebaseFirestore.instance
            .collection('update')
            .doc('tel-e-scope')
            .get();

        if (doc.exists) {
          newVersion.value = doc['versionName'];
          isAppUpdated.value = oldVersion.value == newVersion.value;
        }
      } catch (e) {
        debugPrint('Version fetch error: $e');
      }
    } else {
      final response = await GainerApiService().fetchAppVersion();
      if (response['success']) {
        final data = response['data'];
        newVersion.value = data['Version'];
        isAppUpdated.value = oldVersion.value == newVersion.value;
      }
    }
  }

  final RxMap<String, dynamic> appAccess = <String, dynamic>{}.obs;
  Future<void> _checkAppAccess() async {
    final tCode = await AuthService.getTCode();
    final response = await GainerApiService().getAppAccess(tCode);
    if (response['success']) {
      final data = response['data'];
      appAccess.assignAll(data);
    }
  }

  Future<void> _notificationPermission() async {
    NotificationServiceNEW.requestPermission();
  }

  void logout() {
    AuthService.logout('UserLogoutAppSwitcher');
  }
}
