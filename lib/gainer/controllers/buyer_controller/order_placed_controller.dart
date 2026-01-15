import 'dart:convert';
import 'package:get/get.dart';

import '../../apis_functionality/api_service.dart';
import '../../model/buyer_model/order_placed_model.dart';

class OrderPlacedController extends GetxController{

  RxBool isLoading = false.obs;

  //for store error msg which comes when api hit
  RxnString errorMsg = RxnString(null);

  // for store response meg which comes after tap delete icon
  RxnString odrDltResMsg = RxnString(null);
  RxnString odrDltErrorMsg = RxnString(null);

  // The list of seller data
  var orderPlacedList = <OrderPlacedModel>[].obs;



  // API Call to fetch Order placed
  Future<void> orderPlacedAsBuyer(String locationID,String stage) async {

    errorMsg.value = null;
    final response = await ApiService().getBuyerStages(locationID,stage);

    if (response['success']) {

      List<dynamic> jsonList = jsonDecode(response['data']);

      // use of model data
      orderPlacedList.value = jsonList
          .map((json) => OrderPlacedModel.fromJson(json))
          .toList();
    } else {
      errorMsg.value = response['message'];
      orderPlacedList.clear();
    }
  }



  //Api for order place delete
  Future<void> orderPlacedDeleteAsBuyer(String bigID) async {

    isLoading.value = true;
    final response = await ApiService().orderPlacedDelete(bigID);
    isLoading.value = false;

    if (response['success']) {
      odrDltResMsg.value = response['data'];
    } else {
      odrDltErrorMsg.value = response['message'];
    }
  }
}