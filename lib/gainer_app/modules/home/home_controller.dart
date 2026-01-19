import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:gainer/gainer/model/user_model.dart';
import 'package:gainer/gainer_app/modules/internet_connectivity/no_internet_controller.dart';
import 'package:get/get.dart';
import '../../../gainer/apis_functionality/api_service.dart';
import '../../../gainer/apis_functionality/firebase_db_creation.dart';
import '../../core/Services/auth_service.dart';
import '../../routes/app_routes.dart';

class HomeController extends GetxController {
  var userName = ''.obs;
  var notificationCount = 3.obs;
  var isLoading = false.obs;
  // Rx<String?> errorMsg = Rx<String?>(null);
  RxnString errMsg = RxnString(null);

  // Data list with full structure for store all location which got according to tCode
  RxList<Map<String, dynamic>> locationList = <Map<String, dynamic>>[].obs;
  // RxnString? selectedLocation which user select and by default zero index;
  Rx<String?> selectedLocation = Rx<String?>(null);
  Rx<String?> selectedLocationId = Rx<String?>(null);

  // Observable Map that holds the location data(location:locationID)
  var locationIdMap = <String, String>{}.obs;

  //Observable Map that holds the locationId and StockVal data(locationID:StockVal)
  var stockValMap = <String, String>{}.obs;

  // for notified app update
  RxString oldVersion = '1.0.1'.obs;
  RxString newVersion = ''.obs;
  RxBool isAppUpdated = true.obs;

  @override
  void onInit() {
    super.onInit();
    _checkSession();
    _fetchVersionFromFirestore();
    _subscribeTopic();
  }

  ///Check version from firebase and match with current version is same or not
  Future<void> _fetchVersionFromFirestore() async {
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
      // debugPrint('Version fetch error: $e');
    }
  }

  ///Check session is time(4h) is user login before 4h or not
  Future<void> _checkSession() async {
    final bool isLoggedIn = await AuthService.isLoggedIn();
    bool isExpired = await AuthService.checkSessionExpired();
    if (!isLoggedIn || isExpired) {
      await AuthService.logout(isExpired ? 'SessionExpired' : 'UserLogout');
    } else {
      _getLocation();
    }
  }

  ///GET USER LOCATION USING tCode AND STORE DEVICE TOKEN IN FIREBASE
  Future<void> _getLocation() async {
    UserModel? user = await AuthService.getUser();
    if (user != null) {
      userName.value = "${user.firstName} ${user.lastName}";
      int userTCode = user.userTCode;
      await _getLocationUsingTCode(userTCode.toString());
      String? userId = await AuthService.getUserId();
      // Get the DealerID (assuming all have the same one)
      final dealerId = locationList.first['DealerID'];
      // Get all locations
      final List<String> locationsId = locationList
          .map<String>((item) => item['LocationID'].toString())
          .toList();
      FirebaseDB firebaseDB = FirebaseDB();
      await firebaseDB.storeDeviceToken(
        userId: userId ?? "NotFount",
        userCode: userTCode.toString(),
        dealerId: dealerId.toString(),
        locationIds: locationsId,
      );
    } else {
      errMsg.value =
          'something wend wrong to find user details\nPlease login again';
    }
  }

  ///GET LOCATION AND --
  Future<void> _getLocationUsingTCode(String tCode) async {
    try {
      final response = await ApiService().getLocation(tCode);
      if (response['success']) {
        final locationData = response['data'];
        var data = jsonDecode(locationData);
        locationList.clear(); // Clear the list before adding new data

        for (var item in data) {
          locationList.add({
            "BrandID": item['BrandID'] ?? '',
            "DealerID": item['DealerID'] ?? '',
            "LocationID": item['LocationID'] ?? '',
            "Brand": item['Brand'] ?? '',
            "Dealer": item['Dealer'] ?? '',
            "Location": item['Location'] ?? '',
            "StockDate": item['StockDate'] ?? '',
            "StockVal": item['StockVal'] ?? '',
          });
        }

        locationIdMap.value = {
          for (var item in data)
            item['Location'] as String: item['LocationID'].toString()
        };

        // locationID and StockVal in key value
        stockValMap.value = {
          for (var item in data)
            item['LocationID'].toString(): item['StockVal'].toString()
        };

        if (locationList.isNotEmpty) {
          // selectedLocation.value = locationList[0]['Location']; // Set the default selected location
          selectedLocation.value = locationIdMap.keys
              .elementAt(0)
              .toString(); // Set the default selected location
        }
      } else {
        errMsg.value = response['message'];
      }
    } catch (e) {
      errMsg.value = 'Error fetching locations';
    }
  }

  Future<void> gotoScreen(String name) async {
    if (!Get.find<NoInternetController>().isConnected.value) {
      Get.toNamed(Routes.NOINTERNETVIEW);
      return;
    }
    switch (name.toLowerCase()) {
      case 'gainer':
        Get.toNamed(Routes.GAINERSPLASH);
        break;
      case 'sims':
        Get.toNamed(Routes.DMSPLASH);
        break;
    }
  }

  void _subscribeTopic() {
    FirebaseMessaging messaging = FirebaseMessaging.instance;
    messaging.subscribeToTopic("all");
    // print("subscribe topic All");
  }

  // /// Handles navigation logic based on user login status.
  // Future<void> _checkLogin() async {
  //   final bool isLoggedIn = await AuthService.isLoggedIn();
  //   if (!isLoggedIn) {
  //     Get.offAllNamed(Routes.LOGIN);
  //   } else {
  //     _getLocation();
  //   }
  // }
}
