import 'dart:convert';
import 'package:gainer/gainer/model/user_model.dart';
import 'package:gainer/gainer_app/modules/main_screen/models/location_data_model.dart';
import 'package:get/get.dart';
import '../../../gainer/apis_functionality/api_service.dart';
import '../../../gainer/apis_functionality/firebase_db_creation.dart';
import '../../core/Services/auth_service.dart';

class AppSwitcherController extends GetxController {
  var userName = ''.obs;
  var notificationCount = 3.obs;
  var isLoading = false.obs;
  // Rx<String?> errorMsg = Rx<String?>(null);
  RxnString errMsg = RxnString(null);

  // Data list with full structure for store all location which got according to tCode
  // RxList<Map<String, dynamic>> locationList = <Map<String, dynamic>>[].obs;
  // RxnString? selectedLocation which user select and by default zero index;
  Rx<String?> selectedLocation = Rx<String?>(null);
  Rx<String?> selectedLocationId = Rx<String?>(null);

  RxList<LocationDataModel> locationDataList = <LocationDataModel>[].obs;
  // Observable Map that holds the location data(location:locationID)
  var locationIdMap = <String, String>{}.obs;
  final RxString stockData = ''.obs;
  Rxn<LocationDataModel> selectedStock = Rxn<LocationDataModel>();
  void updateStockDetails(String selectedLocationID) {
    final foundStock = locationDataList.firstWhere(
      (e) => e.locationId.toString() == selectedLocationID,
    );

    selectedStock.value = foundStock;
    stockData.value = foundStock.stockDate ?? '';

    // Example usage
    // setStringData('selectedLocationID', foundStock.locationId.toString());
    // setStringData('dealerID', foundStock.dealerId.toString());
    // setStringData('brandID', foundStock.brandId.toString());
  }

  LocationDataModel? getStock() => selectedStock.value;

  // //stock data according to location
  // var stockData = <String, String>{}.obs;

  // final RxList<LocationDataModel> stockList = <LocationDataModel>[].obs;

  // final Rxn<int> selectedLocationId = Rxn<int>();

  // for notified app update
  RxString oldVersion = '1.0.1'.obs;
  RxString newVersion = ''.obs;
  RxBool isAppUpdated = true.obs;

  @override
  void onInit() {
    super.onInit();
    _getLocation();
  }
  // void _init() {
  //   checkSession();
  //   // fetchVersionFromFirestore();
  //   // navigateOnLaunch();
  // }

  // Future<void> checkSession() async {
  //   final isLoggedIn = await AuthService.isLoggedIn();
  //
  //   if (isLoggedIn) return;
  //
  //   bool isExpired = await AuthService.checkSession();
  //   // if (isExpired) {
  //     // await ApiService().logoutContinue(
  //     //   empId: (await getIntData("tCode")).toString(),
  //     //   userId: (await getStringData('UserID')).toString(),
  //     //   deviceToken: (await getStringData("deviceToken")).toString(),
  //     //   logoutType: 'SessionExpired',
  //     // );
  //
  //     // await setBoolData('isLogin', false);
  //     // await removeData('tCode');
  //     // await removeData('userProfile');
  //
  //     // Get.offAll(() => const LoginScreen());
  //   // }
  // }

  Future<void> _getLocation() async {
    UserModel? user = await AuthService.getUser();
    if (user != null) {
      userName.value = "${user.firstName} ${user.lastName}";
      int userTCode = user.userTCode;
      await getLocationUsingTCode(userTCode.toString());
      String? userId = await AuthService.getUserId();
      // Get the DealerID (assuming all have the same one)
      final dealerId = locationDataList.first.dealerId;
      // Get all locations
      final List<String> locationsId = locationDataList
          .map<String>((item) => item.locationId.toString())
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

  Future<void> getLocationUsingTCode(String tCode) async {
    try {
      final response = await ApiService().getLocation(tCode);
      locationDataList.clear();
      if (response['success']) {
        final data1 = jsonDecode(response['data']) as List;
        print("getLocation: $data1");
        final locationsData =
            data1.map((e) => LocationDataModel.fromJson(e)).toList();
        locationDataList.assignAll(locationsData);

        for (var items in locationDataList) {
          print("${items.location}: ${items.stockDate}");
        }

        ///LocationsId and locations fro dropdown
        locationIdMap.value = {
          for (var item in locationDataList)
            item.location: item.locationId.toString()
        };

        selectedLocation.value = locationIdMap.keys.first;
        //update stock details by default 0 index
        updateStockDetails(locationIdMap.values.first);

        // // locationID and StockVal in key value
        // stockValMap.value = {
        //   for (var item in locationDataList)
        //     item.locationId.toString(): item.stockVal.toString()
        // };

        ///---------------------
        // final locationData = response['data'];
        // var data = jsonDecode(locationData);
        // locationList.clear(); // Clear the list before adding new data
        //
        // for (var item in data) {
        //   locationList.add({
        //     "BrandID": item['BrandID'] ?? '',
        //     "DealerID": item['DealerID'] ?? '',
        //     "LocationID": item['LocationID'] ?? '',
        //     "Brand": item['Brand'] ?? '',
        //     "Dealer": item['Dealer'] ?? '',
        //     "Location": item['Location'] ?? '',
        //     "StockDate": item['StockDate'] ?? '',
        //     "StockVal": item['StockVal'] ?? '',
        //   });
        // }
        //
        // // locationIdMap.value = {
        // //   for (var item in data)
        // //     item['Location'] as String: item['LocationID'].toString()
        // // };
        //
        // // locationID and StockVal in key value
        // // stockValMap.value = {
        // //   for (var item in data)
        // //     item['LocationID'].toString(): item['StockVal'].toString()
        // // };
        //
        // if (locationList.isNotEmpty) {
        //   // selectedLocation.value = locationList[0]['Location']; // Set the default selected location
        //   selectedLocation.value = locationIdMap.keys
        //       .elementAt(0)
        //       .toString(); // Set the default selected location
        // }
      } else {
        errMsg.value = response['message'];
      }
    } catch (e) {
      errMsg.value = 'Error fetching locations';
    }
  }

  // Future<void> loadStockData() async {
  //   final data = await repository.getStockList();
  //   stockList.assignAll(data);
  // }

  // /// Unique locations for dropdown
  // List<LocationDataModel> get uniqueLocations {
  //   final map = <int, LocationDataModel>{};
  //   for (var item in locationDataList) {
  //     map[item.locationId] = item;
  //   }
  //   return map.values.toList();
  // }

  // void loadDashboardData() async {
  //   isLoading.value = true;
  //   // Simulate API call
  //   await Future.delayed(const Duration(seconds: 2));
  //
  //   UserModel? user = await AuthService.getUser();
  //   userName.value = "${user!.firstName} ${user.lastName}";
  //   notificationCount.value = 5;
  //
  //   isLoading.value = false;
  // }
}
