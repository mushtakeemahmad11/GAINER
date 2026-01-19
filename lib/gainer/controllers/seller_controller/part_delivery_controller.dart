import 'dart:convert';
import 'package:get/get.dart';
import '../../apis_functionality/api_service.dart';
import '../../model/seller_model/part_delivery_model.dart';

class PartDeliveryController extends GetxController {
  RxBool isLoading = false.obs;

  //for store error msg which comes when api hit
  RxnString errorMsg = RxnString(null);
  RxnString reminderErrorMsg = RxnString(null);

  // // for store response meg which comes after tap delete icon

  // The list of seller data
  var partDeliveryList = <PartDeliveryModel>[].obs;


  // API Call to fetch Part Delivery
  Future<void> partDeliveryAsSeller(String locationID, String stage) async {
    errorMsg.value = null;
    final response = await ApiService().getSellerStages(locationID, stage);
    if (response['success']) {
      List<dynamic> jsonList = jsonDecode(response['data']);

      // use of model data
      partDeliveryList.value =
          jsonList.map((json) => PartDeliveryModel.fromJson(json)).toList();
    } else {
      errorMsg.value = response['message'];
      partDeliveryList.clear();
    }
  }

}
