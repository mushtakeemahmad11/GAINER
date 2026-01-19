import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../apis_functionality/api_service.dart';
import '../model/show_part_availability_model.dart';


class PartRequestController extends GetxController {
  // Form controllers
  final TextEditingController tatController = TextEditingController();
  //when api call
  RxBool isLoading = false.obs;

  //to show error msg
  Rx<String?> errorMsg = Rx<String?>(null);

  // Rx variables for dropdown selections
  RxnString selectedValue1 = RxnString(null);

  // Rx variables from PartStock check screen
  RxnString partStockPartNum = RxnString(null);

  // Observable Map that holds the Kyu:Value CompanyName:CompanyCode
  var companyName = <String, String>{}.obs;

  // Observable Map that holds the Kyu:Value clusterName:clusterCode
  var clusterData = <String, String>{}.obs;

  // Observable list of maps
  var tableData = <Map<String, String>>[].obs;

  // Function to add a new entry
  void addEntry(Map<String, String> entry) {
    tableData.add(entry);
  }

  // Function to remove an entry
  void removeEntry(int index) {
    if (index < tableData.length) {
      tableData.removeAt(index);
    }
  }

  // Observable list
  RxList<String> clusterOption = <String>[].obs;

  // Optional: method to update the list
  void updateDropdownOptions(List<String> newOptions) {
    clusterOption.assignAll(newOptions);
  }

  ///show availability of part request functionality
  // The list of seller data
  var showAvailabilityList = <ShowPartAvailabilityModel>[].obs;

  Future<bool> showAvailability(
    String brandID,
    String dealerID,
    String locationID,
    String orderFor,
    String lspCode,
    String tat,
    String clusterCode,
    String partNumbers,
    String stockCategory,
    String withInGroup,
  ) async {
    isLoading.value = true;
    var response = await ApiService().showPartAvailability(
      brandID,
      dealerID,
      locationID,
      orderFor,
      lspCode,
      tat,
      clusterCode,
      partNumbers,
      stockCategory,
      withInGroup,
    );
    isLoading.value = false;
    if (response['success']) {
      List<dynamic> jsonList = jsonDecode(response['data']);
      // use of model data
      showAvailabilityList.value = jsonList
          .map((json) => ShowPartAvailabilityModel.fromJson(json))
          .toList();
      return true;
    } else {
      errorMsg.value = response['message'];
      return false;
    }
  }
}
