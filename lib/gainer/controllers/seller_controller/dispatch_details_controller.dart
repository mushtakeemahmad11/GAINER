import 'dart:convert';
import 'package:get/get.dart';

import '../../apis_functionality/api_service.dart';
import '../../model/seller_model/dispatch_details_controller.dart';

class DispatchDetailsController extends GetxController {
  RxBool isLoading = false.obs;

  RxnBool isNullSelectedImagesPerOrder1 = RxnBool(false);

  // for loading image uploading time
  var uploadingMap = <String,bool>{}.obs;


  //for store error msg which comes when api hit
  RxnString errorMsg = RxnString(null);

  // // for store response meg which comes after tap delete icon

  // The list of seller data
  var dispatchDetailsList = <DispatchDetailsModel>[].obs;

  // API Call to fetch Order placed
  Future<void> dispatchDetailsAsSeller(String brandID, String dealerID, String sellerLocationID) async {
    errorMsg.value = null;
    final response = await ApiService().dispatchDetailsStage(brandID, dealerID,sellerLocationID);
    if (response['success']) {
      List<dynamic> jsonList = jsonDecode(response['data']);

      // use of model data
      dispatchDetailsList.value =
          jsonList.map((json) => DispatchDetailsModel.fromJson(json)).toList();
    } else {
      errorMsg.value = response['message'];
      dispatchDetailsList.clear();
    }
  }


  // for calculate Freight
  var poTableVal = <Map<String, dynamic>>[].obs;
  var orderData = <Map<String, dynamic>>[].obs;

  // Method to add data to poTableVal
  void addPoTableValue(Map<String, dynamic> value) {
    poTableVal.add(value);
  }

  // Method to add data to orderData
  void addOrderData(Map<String, dynamic> value) {
    orderData.add(value);
  }

  // Method to remove data from poTableVal
  void removePoTableValue(int index) {
    if (index >= 0 && index < poTableVal.length) {
      poTableVal.removeAt(index);
    }
  }

  // Method to remove data from orderData
  void removeOrderData(int index) {
    if (index >= 0 && index < orderData.length) {
      orderData.removeAt(index);
    }
  }

  // Method to update poTableVal entry
  void updatePoTableValue(int index, Map<String, dynamic> updatedValue) {
    if (index >= 0 && index < poTableVal.length) {
      poTableVal[index] = updatedValue;
    }
  }

  // Method to update orderData entry
  void updateOrderData(int index, Map<String, dynamic> updatedValue) {
    if (index >= 0 && index < orderData.length) {
      orderData[index] = updatedValue;
    }
  }

  // Method to clear all data
  void clearAll() {
    poTableVal.clear();
    orderData.clear();
  }

}
