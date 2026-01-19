import 'dart:convert';
import 'package:get/get.dart';

import '../apis_functionality/api_service.dart';
import '../model/stage_model.dart';
import '../shared_preferences/shared_preferences_get_data.dart';
import '../shared_preferences/shared_preferences_set_data.dart';

class LocationController extends GetxController {
  // Data list with full structure for store all location which got according to tCode
  RxList<Map<String, dynamic>> locationList = <Map<String, dynamic>>[].obs;

  // RxnString? selectedLocation which user select and by default zero index;
  Rx<String?> selectedLocation = Rx<String?>(null);
  Rx<String?> selectedLocationId = Rx<String?>(null);

  //store error message when location not found using tCode
  Rx<String?> errorMsg = Rx<String?>(null);

// Observable Map that holds the location data(location:locationID)
  var locationIdMap = <String, String>{}.obs;

// Observable Map that holds the locationId and StockVal data(locationID:StockVal)
  var stockValMap = <String, String>{}.obs;

  //when location fetch api hit then show circular progress
  RxBool isLoading = false.obs;

  Future<void> getLocationUsingTCode() async {
    int userTCode = await getIntData('tCode') ?? 0;
    String tCode = userTCode.toString();
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
        errorMsg.value = response['message'];
      }
    } catch (e) {
      errorMsg.value = 'Error fetching locations';
    }
  }

  Map<String, dynamic>? getStockDetails(int selectedLocationID) {
    return locationList.firstWhere(
      (stock) => stock['LocationID'] == selectedLocationID,
      orElse: () => {},
    );
  }

  // Declare stockDetails as an observable map
  var stockDetails = <String, dynamic>{}.obs;

  // Method to update stock details based on selected LocationID
  void updateStockDetails(int selectedLocationID) {
    var foundStock = locationList.firstWhere(
      (stock) => stock['LocationID'] == selectedLocationID,
      orElse: () => {},
    );

    stockDetails.value = foundStock; // Updating observable map
    setStringData('selectedLocationID', foundStock['LocationID'].toString());
    setStringData("dealerID", foundStock['DealerID'].toString());
    setStringData("brandID", foundStock['BrandID'].toString());
  }

  var users = <StageData>[].obs; // Observable List
  var usersMap = <String, StageData>{}.obs; // Observable Map

  // void addUser(StageData user) {
  //   users.add(user);
  //   usersMap[user.id] = user; // assuming StageData has an `id` field
  // }

  void clearData() {
    users.clear();
    usersMap.clear();
  }

  RxString listedStockShow = "0".obs;
}
