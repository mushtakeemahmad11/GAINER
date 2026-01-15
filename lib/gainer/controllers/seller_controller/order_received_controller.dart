import 'dart:convert';
import 'package:get/get.dart';

import '../../apis_functionality/api_service.dart';
import '../../model/seller_model/order_received_model.dart';


class OrderReceivedController extends GetxController {
  RxBool isLoading = false.obs;

  //for store error msg which comes when api hit
  RxnString errorMsg = RxnString(null);

  // // for store response meg which comes after tap delete icon

  // The list of seller data
  var orderReceivedList = <OrderReceivedModel>[].obs;

  // void removeOrder(OrderReceivedModel order) {
  //   orderReceivedList.remove(order);
  // }

  // API Call to fetch Order placed
  Future<void> orderReceivedAsSeller(String locationID, String stage) async {
    errorMsg.value = null;
    final response = await ApiService().getSellerStages(locationID, stage);

    if (response['success']) {
      List<dynamic> jsonList = jsonDecode(response['data']);

      // use of model data
      orderReceivedList.value =
          jsonList.map((json) => OrderReceivedModel.fromJson(json)).toList();

    } else {
      errorMsg.value = response['message'];
      orderReceivedList.clear();
    }
  }
}

class RejectOrderController extends GetxController {
  RxBool isLoading = false.obs;

  RxBool isPhysicallyNotFound = false.obs;
  RxBool isPartDamaged = false.obs;
  RxBool isReservedForVehicle = false.obs;
  RxBool isNeedForStock = false.obs;
  RxBool isHighLogisticsCost = false.obs;
  RxBool isFragilePart = false.obs;
  RxBool isNonMovingPart = false.obs;
  RxBool isPartNotInStock = false.obs;
  RxBool isCurrentStockIsLess = false.obs;

  // List of toggle button labels and their corresponding controller values
  final List<Map<String, dynamic>> toggleButtons = [
    {'text': 'Physically Not Found', 'state': 'isPhysicallyNotFound'},
    {'text': 'Part Damaged', 'state': 'isPartDamaged'},
    {'text': 'Reserved For Vehicle', 'state': 'isReservedForVehicle'},
    {'text': 'Need For Stock', 'state': 'isNeedForStock'},
    {'text': 'High Logistics Cost', 'state': 'isHighLogisticsCost'},
    {'text': 'Fragile Part', 'state': 'isFragilePart'},
    {'text': 'Non Moving Part', 'state': 'isNonMovingPart'},
    {'text': 'Part Not In Stock', 'state': 'isPartNotInStock'},
    {'text': 'Current Stock Is Less', 'state': 'isCurrentStockIsLess'},
  ];

  // Method to update states dynamically
  void updateSelection(String selectedState) {
    isPhysicallyNotFound.value = selectedState == 'isPhysicallyNotFound';
    isPartDamaged.value = selectedState == 'isPartDamaged';
    isReservedForVehicle.value = selectedState == 'isReservedForVehicle';
    isNeedForStock.value = selectedState == 'isNeedForStock';
    isHighLogisticsCost.value = selectedState == 'isHighLogisticsCost';
    isFragilePart.value = selectedState == 'isFragilePart';
    isNonMovingPart.value = selectedState == 'isNonMovingPart';
    isPartNotInStock.value = selectedState == 'isPartNotInStock';
    isCurrentStockIsLess.value = selectedState == 'isCurrentStockIsLess';
  }

  // Getter for accessing the value dynamically
  bool getState(String state) {
    switch (state) {
      case 'isPhysicallyNotFound':
        return isPhysicallyNotFound.value;
      case 'isPartDamaged':
        return isPartDamaged.value;
      case 'isReservedForVehicle':
        return isReservedForVehicle.value;
      case 'isNeedForStock':
        return isNeedForStock.value;
      case 'isHighLogisticsCost':
        return isHighLogisticsCost.value;
      case 'isFragilePart':
        return isFragilePart.value;
      case 'isNonMovingPart':
        return isNonMovingPart.value;
      case 'isPartNotInStock':
        return isPartNotInStock.value;
      case 'isCurrentStockIsLess':
        return isCurrentStockIsLess.value;

      default:
        return false;
    }
  }

  // Method to get the selected issue
  String? getSelectedIssue() {
    if (isPhysicallyNotFound.value) return 'Physically Not Found';
    if (isPartDamaged.value) return 'Part Damaged';
    if (isReservedForVehicle.value) return 'Reserved for Vehicle';
    if (isNeedForStock.value) return 'Need for Stock';
    if (isHighLogisticsCost.value) return 'High Logistics Cost';
    if (isFragilePart.value) return 'Fragile Part';
    if (isNonMovingPart.value) return 'Non-Moving Part';
    if (isPartNotInStock.value) return 'Part Not in Stock';
    if (isCurrentStockIsLess.value) return 'Current Stock is Less';
    return null;
  }
}

class AcceptOrderController extends GetxController {
  RxBool isLoading = false.obs;
}
