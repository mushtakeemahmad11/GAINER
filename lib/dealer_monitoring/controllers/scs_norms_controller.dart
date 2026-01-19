import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../gainer/apis_functionality/api_service.dart';
import '../../gainer/controllers/check_internet/no_internet_screen.dart';
import '../../gainer/controllers/home_screen_controller.dart';
import '../../gainer/screens/check_internet/check_internet_connectivity.dart';
import '../../gainer/shared_preferences/shared_preferences_get_data.dart';
import '../core/services/api_services.dart';

class ScsNormsController extends GetxController {
  ApiServices api = ApiServices();
  TextEditingController searchController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final LocationController _locationController = Get.put(LocationController());
  RxBool isLoading = false.obs;
  RxnString error = RxnString(null);
  // RxnString normsError = RxnString(null);
  // RxList<Map> partDetails = <Map>[].obs;
  RxMap<String, dynamic> partDetails = <String, dynamic>{}.obs;
  var stock = 0.0.obs;
  var max = 0.0.obs;
  // RxList<Map<String, dynamic>> locationsList = <Map<String, dynamic>>[].obs;
  RxList locationsList = [].obs;
  // RxInt plannedLevelValue = 0.obs;
  // RxInt locationStock = 0.obs;

  reset() {
    partDetails.clear();
    partSuggestions.clear();
    max.value = 0.0;
    stock.value = 0.0;
    error.value = null;
    locationsList.clear();
  }

  RxBool partSearchLoading = false.obs;
  var partSuggestions = <String>[].obs;
  // Function to handle part number selection
  void selectPartNumber(String partNumber) {
    searchController.text = partNumber;
    partSuggestions.clear();
  }

  // API Call to fetch matching part numbers
  Future<void> fetchPartSuggestions(String query) async {
    if (query.length < 5) {
      partSuggestions.clear();
      return;
    } else if (query.isNotEmpty) {
      String brandId = await getStringData('brandID') ?? 0;
      partSearchLoading.value = true;
      final response =
          await ApiService().searchPart(query, brandId); // API call function
      partSearchLoading.value = false;
      if (response['success']) {
        partSuggestions.value = response['data'];
      } else {
        partSuggestions.clear();
      }
    }
  }

  Future<void> onSearch() async {
    if (isLoading.value) return;
    if (formKey.currentState!.validate()) {
      // print('Searching: ${searchController.text}');

      String partNumber = searchController.text;
      var stockDetails = _locationController.stockDetails;
      String brandId = stockDetails['BrandID'].toString();
      String dealerId = stockDetails['DealerID'].toString();
      String locationId = stockDetails['LocationID'].toString();
      int tCode = await getIntData("tCode");
      // print("DealerId: $dealerId, BrandId: $brandId, LocationId: $locationId");
      bool checkInt = await checkInternet();
      if (!checkInt) {
        error.value = "no Internet connection ";
        return internetNotAvl();
      }
      // final response = await api.getPartDetails(
      //   brandId: brandId,
      //   dealerId: dealerId,
      //   locationId: locationId,
      //   partNumber: partNumber,
      // );

      reset();
      isLoading.value = true;
      final normsResponse = await api.getNorms(
        dealerId: dealerId,
        partNumber: partNumber,
        brandId: brandId,
        locationId: locationId,
        userId: tCode.toString(),
      );
      isLoading.value = false;
      // if (response['success']) {
      // //   print("Response of PartDetails success: ${response['data']}");
      //   partDetails.value = List<Map>.from(response['data']);
      // } else {
      // //   print("Response of failure $response");
      //   error.value = response['message'];
      // }

      if (normsResponse['success']) {
        // print("Response of Norms success: ${normsResponse['data']}");
        // final data = normsResponse['data'];
        // max.value = data['Norms'][0]['Maxvalue'];
        // stock.value = data['Norms'][0]['Qty'];
        // partDetails.value = List<Map>.from(data['Details']);
        final data = normsResponse['data'];
        partDetails.value = data['Details'][0];
        // if (data['Norms'].isNotEmpty) {
        //   max.value = data['Norms']
        //       .map((item) => item['Maxvalue'])
        //       .fold(0, (sum, qty) => sum + (qty ?? 0));
        // }
        // if (data['Stock'].isNotEmpty) {
        //   stock.value = data['Stock']
        //       .map((item) => item['Qty'])
        //       .fold(0, (sum, qty) => sum + (qty ?? 0));
        // }
        if (data['Norms'].isNotEmpty) {
          max.value = (data['Norms'] as List)
              .map((item) => (item['Maxvalue'] as num).toDouble())
              .fold(0.0, (sum, qty) => sum + qty);
        }else{
          max.value = 0;
        }
        if (data['Stock'].isNotEmpty) {
          stock.value = (data['Stock'] as List)
              .map((item) => (item['Qty'] as num).toDouble())
              .fold(0.0, (sum, qty) => sum + qty);
        } else {
          stock.value = 0.0;
        }
        locationsList.value = (data['Group'] != null &&
                data['Group'] is List &&
                data['Group'].isNotEmpty)
            ? data['Group']
            : [];
      } else {
        // print("Response of failure $normsResponse");
        error.value = normsResponse['message'];
      }
    }
  }

  // /// Get max value by location ID
  // int getPlannedLevelByLocationId(String locationId) {
  //   return normsDetails.firstWhere(
  //     (item) => item['locationid'] == locationId,
  //     orElse: () => {'Max': 0},
  //   )['Max'] as int;
  // }

  // /// Get Stock (qty) by location ID
  // int getStockByLocationId(String locationId) {
  //   return normsDetails.firstWhere(
  //     (item) => item['locationid'] == locationId,
  //     orElse: () => {'Stock': 0},
  //   )['Stock'] as int;
  // }

  /// Get total sum of max values
  double getPlannedGroupTotal() {
    return locationsList.fold(
      0.0,
      // (sum, item) => sum + (item['Max'] as int),
      (sum, item) =>
          sum + ((item['Max'] != null) ? item['Max'] as num : 0).toDouble(),
    );
  }

  // /// Get total sum of max values
  // int getGroupStock() {
  //   return normsDetails.fold(
  //     0,
  //     // (sum, item) => sum + (item['Stock'] as int),
  //     (sum, item) => sum + ((item['Max'] != null) ? item['Max'] as int : 0),
  //   );
  // }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }
}
