import 'package:flutter/material.dart';
import 'package:gainer/gainer_app/core/utils/check_internet.dart';
import 'package:get/get.dart';
import '../../gainer_app/core/Services/auth_service.dart';
import '../core/services/api_services.dart';
import '../widgets/no_internet_dialog.dart';

class SubstitutionCheckController extends GetxController {
  ApiServices api = ApiServices();
  TextEditingController searchController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  // final LocationController _locationController = Get.put(LocationController());
  RxBool isLoading = false.obs;
  RxnString error = RxnString(null);
  RxString finalStatus = ''.obs;

  // RxMap<String, dynamic> responseList = <String, dynamic>{}.obs;
  RxList<Map> responseList = <Map>[].obs;
  // RxInt reservedForVehicle = 0.obs;
  // RxInt groupStock = 0.obs;
  // RxList groupStockList = [].obs;
  // List<Map<String, dynamic>> locationsList = <Map<String, dynamic>>[].obs;

  // RxString partNumberForGainer = "00".obs;

  // API Call to fetch matching part numbers
  Future<void> fetchPartSuggestions(String query) async {
    if (query.length < 5) {
      partSuggestions.clear();
      return;
    } else if (query.isNotEmpty) {
      // String brandId = await getStringData('brandID') ?? 0;
      partSearchLoading.value = true;
      final response = await api.searchPart(query); // API call function
      partSearchLoading.value = false;
      if (response['success']) {
        partSuggestions.value = response['data'];
      } else {
        partSuggestions.clear();
      }
    }
  }

  RxBool partSearchLoading = false.obs;
  var partSuggestions = <String>[].obs;
  // Function to handle part number selection
  void selectPartNumber(String partNumber) {
    searchController.text = partNumber;
    partSuggestions.clear();
  }

  Future<void> onSearch() async {
    if (isLoading.value) return;
    if (formKey.currentState!.validate()) {
      // print('Searching: ${searchController.text}');

      String partNumber = searchController.text;
      // var stockDetails = _locationController.stockDetails;
      // String brandId = stockDetails['BrandID'].toString();
      // String dealerId = stockDetails['DealerID'].toString();
      // String locationId = stockDetails['LocationID'].toString();
      // int tCode = await getIntData("tCode");
      final bdl = await AuthService.getBDLId();
      String brandId = bdl['brandId'] ?? '';
      String dealerId = bdl['dealerId'] ?? '';
      String locationId = bdl['locationId'] ?? '';
      String tCode = await AuthService.getTCode();
      // print(
      //     "BrandId: $brandId, dealerId: $dealerId, locationId: $locationId PartNumber: $partNumber");
      bool checkInt = await CheckInternet.checkInternet();
      if (!checkInt) {
        error.value = "no Internet connection ";
        return NoInternetDialog.show();
      }
      partSuggestions.clear();
      error.value = null;
      isLoading.value = true;
      final response = await api.getSubstitution(
        brandId: brandId,
        dealerId: dealerId,
        locationId: locationId,
        partNumber: partNumber,
        userId: tCode.toString(),
      );
      isLoading.value = false;
      if (response['success']) {
        final data = response['data'];
        // print(response['data']);
        responseList.value = RxList<Map<dynamic, dynamic>>.from(data);

        if (responseList.any((p) => p['PartStatus'] == 'Stockable')) {
          finalStatus.value = 'Stockable';
        } else if (responseList.any((p) => p['PartStatus'] == 'Non-Moving')) {
          finalStatus.value = 'Non-Moving';
        } else {
          finalStatus.value = 'Non-Stockable';
          // finalStatus.value = '';
        }
      } else {
        responseList.clear();
        error.value = response['message'];
      }
    }
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }
}
