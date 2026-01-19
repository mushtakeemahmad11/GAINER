import 'dart:convert';
import 'package:get/get.dart';
import '../../apis_functionality/api_service.dart';
import '../../model/buyer_model/part_receipt_model.dart';

class PartReceiptController extends GetxController{
  RxBool isLoading = false.obs;
  RxBool isLoadingIssue = false.obs;

  var selectedIssue = RxString('');

  RxBool isDamage = false.obs;
  RxBool isFunctionalIssue = false.obs;
  RxBool isWrongPart = false.obs;
  RxBool isPartReceivedLate = false.obs;
  RxBool isOthers = false.obs;
  RxnString errorMsg = RxnString(null);
  // The list of seller data
  var partReceiptList = <PartReceiptModel>[].obs;

  // API Call to fetch part Receipt
  Future<void> partReceiptAsBuyer(String locationID,String stage) async {

    errorMsg.value = null;
    final response = await ApiService().getBuyerStages(locationID,stage);
    if (response['success']) {

      List<dynamic> jsonList = jsonDecode(response['data']);

      // use of model data
      partReceiptList.value = jsonList
          .map((json) => PartReceiptModel.fromJson(json))
          .toList();

    } else {
      errorMsg.value = response['message'];
      partReceiptList.clear();
    }
  }
}