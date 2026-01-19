import 'dart:convert';
import 'package:get/get.dart';

import '../../apis_functionality/api_service.dart';
import '../../model/seller_model/manifestation.dart';


class ManifestationController extends GetxController {
  RxBool isLoading = false.obs;
  RxBool isLoadingFC = false.obs;
  RxBool isLoadingCFCSubmit = false.obs;

  //for calculate freight screen if own arrangement selected for courier
  RxBool isOwnSelected = false.obs;

  //for store error msg which comes when api hit
  RxnString errorMsg = RxnString(null);

  // // for store response meg which comes after tap delete icon

  // The list of seller data
  var manifestationList = <ManifestationModel>[].obs;

  RxnString manifestationBuyerLocationID = RxnString(null);
  RxnBool manifestationIsWeFast = RxnBool(null);

  // API Call to fetch Order placed
  Future<void> manifestationAsSeller(String locationID, String stage) async {
    errorMsg.value = null;
    final response = await ApiService().getSellerStages(locationID, stage);

    if (response['success']) {
      List<dynamic> jsonList = jsonDecode(response['data']);

      // use of model data
      manifestationList.value =
          jsonList.map((json) => ManifestationModel.fromJson(json)).toList();
    } else {
      errorMsg.value = response['message'];
      manifestationList.clear();
    }
  }


  // for calculate Freight
  var poTableVal = <Map<String, dynamic>>[].obs;
  var orderData = <Map<String, dynamic>>[].obs;
  var manifestationBigId = [].obs;
  // Clear all
  void manifestationBigIdClear() {
    manifestationBigId.clear();
  }


}

