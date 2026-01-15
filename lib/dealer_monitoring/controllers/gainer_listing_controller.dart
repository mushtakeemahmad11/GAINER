import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../gainer/apis_functionality/api_service.dart';
import '../../gainer/controllers/check_internet/no_internet_screen.dart';
import '../../gainer/screens/check_internet/check_internet_connectivity.dart';
import '../../gainer/shared_preferences/shared_preferences_get_data.dart';
import '../core/services/api_services.dart';

class GainerListingController extends GetxController {
  ApiServices api = ApiServices();
  TextEditingController searchController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  // final LocationController _locationController = Get.put(LocationController())
  final RxList gainerListingData = [].obs;
  RxBool isLoading = false.obs;
  RxnString error = RxnString(null);

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
      final response = await ApiService().searchPart(query, brandId); // API call function
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
      String locationId = await getStringData("selectedLocationID");
      String dealerId = await getStringData("dealerID");
      // print(
      //     "DealerId: $dealerId, LocationId: $locationId, PartNumber: $partNumber");
      bool checkInt = await checkInternet();
      if (!checkInt) {
        error.value = "no Internet connection ";
        return internetNotAvl();
      }
      partSuggestions.clear();
      error.value = null;
      isLoading.value = true;
      final response = await api.getGainerListing(
          dealerId: dealerId, locationId: locationId, partNumber: partNumber);
      isLoading.value = false;
      if (response['success']) {
        final data = response['data'];
        // print(response['data']);
        gainerListingData.value = data;
      } else {
        gainerListingData.clear();
        error.value = response['message'];
      }
    }
  }
}
