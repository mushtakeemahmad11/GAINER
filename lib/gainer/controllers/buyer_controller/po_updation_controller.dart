import 'dart:convert';
import 'package:get/get.dart';

import '../../apis_functionality/api_service.dart';
import '../../model/buyer_model/po_updation_model.dart';

class PoUpdationController extends GetxController{

  RxBool isLoading = false.obs;
  RxBool orderSummaryIsLoading = false.obs;
  //for store error msg which comes when api hit
  RxnString errorMsg = RxnString(null);

  var switchStates = <String, bool>{}.obs; // Observable switch states

  // for store response meg which comes after tap delete icon
  RxnString odrDltResMsg = RxnString(null);

  // The list of seller data
  var poUpdationList = <PoUpdationModel>[].obs;

  void removeRejectedPo(int bigId) {
    poUpdationList.removeWhere((po) => po.bigId == bigId);
  }


  // API Call to fetch Order placed
  Future<void> poUpdationAsBuyer(String locationID,String stage) async {

    errorMsg.value = null;
    final response = await ApiService().getBuyerStages(locationID,stage);

    if (response['success']) {

      List<dynamic> jsonList = jsonDecode(response['data']);

      // use of model data
      poUpdationList.value = jsonList
          .map((json) => PoUpdationModel.fromJson(json))
          .toList();
    } else {
      errorMsg.value = response['message'];
      poUpdationList.clear();
    }
  }
}

class OrderSummaryController extends GetxController{
  RxBool isLoading = false.obs;
}