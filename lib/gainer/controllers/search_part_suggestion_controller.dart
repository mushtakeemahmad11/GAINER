import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../apis_functionality/api_service.dart';
class PartSearchController extends GetxController {
  final TextEditingController partNumberController = TextEditingController();
  var partSuggestions = <String>[].obs; // List to store part number suggestions
  RxBool isLoading = false.obs; // Timer for debouncing API calls

  // Function to call API when the user types
  void onPartNumberChanged(String query, String brandId) async {
    // Simulate an API call or logic
    if (query.length < 5) {
      partSuggestions.clear();
      return;
    }
    if (query.isNotEmpty) {
      await fetchPartSuggestions(query, brandId);
    } else {
      partSuggestions.clear();
    }
  }

  // API Call to fetch matching part numbers
  Future<void> fetchPartSuggestions(String query, String brandId) async {
    isLoading.value = true;
    final response = await ApiService().searchPart(query, brandId); // API call function
    if (response['success']) {
      partSuggestions.value = response['data'];
    } else {
      partSuggestions.clear();
    }
    isLoading.value = false;
  }

  // Function to handle part number selection
  void selectPartNumber(String partNumber) {
    partNumberController.text = partNumber;
    partSuggestions.clear();
  }
}
