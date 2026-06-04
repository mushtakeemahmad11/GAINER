import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:gainer/gainer_app/core/Services/auth_service.dart';
import 'package:gainer/gainer_app/core/Services/gainer_api_service.dart';
import 'package:get/get.dart';
import 'models/dr_sent_model.dart';
import 'models/dr_sent_part_model.dart';
import 'models/dr_sent_seller_model.dart';
import 'widgets/sort_filter/dr_sent_sort_sheet.dart';

enum DrSentGroupType { part, seller }

class DrSentController extends GetxController {
  /// ORIGINAL / FILTERED LIST
  RxList<DrSentModel> drSentOrderList = <DrSentModel>[].obs;
  RxList<DrSentModel> filteredList = <DrSentModel>[].obs;

  /// CURRENT GROUP TYPE
  // Rx<DrSentGroupType> groupType = DrSentGroupType.part.obs;
  Rx<DrSentGroupType> groupType = DrSentGroupType.part.obs;

  /// GROUPED DATA LISTS
  RxList<DrSentPartModel> partGroups = <DrSentPartModel>[].obs;
  RxList<DrSentSellerModel> sellerGroups = <DrSentSellerModel>[].obs;

  /// LOADING STATE
  RxBool isLoading = false.obs;

  /// ERROR / RESPONSE MESSAGES
  RxnString errorMsg = RxnString(null);

  /// SEARCH CONTROLLER
  SearchController searchController = SearchController();

  @override
  void onInit() {
    super.onInit();
    getDrSentOrders();
  }

  Future<void> getDrSentOrders() async {
    final locationId = await AuthService.getLocationId();
    final tCode = await AuthService.getTCode();
    isLoading(true);
    final response = await GainerApiService().getDrSentOrder(locationId, tCode);
    isLoading(false);

    if (response['success']) {
      final data = response['data'];
      List<dynamic> jsonList = jsonDecode(data);
      drSentOrderList.assignAll(jsonList.map((e) => DrSentModel.fromJson(e)));
      filteredList.assignAll(drSentOrderList);
      regroup();
    } else {
      errorMsg.value = response['message'];
    }
  }

  ///search filed text
  final RxString searchText = ''.obs;
  void onChangedSearch(String text) {
    //Prevent leading space
    if (text.startsWith(' ')) {
      final cleaned = text.trimLeft();
      searchController.value = searchController.value.copyWith(
        text: cleaned,
        selection: TextSelection.collapsed(offset: cleaned.length),
      );
      return; //stop old value processing
    }

    //Normalize query
    final query = text.trim().toLowerCase();
    searchText.value = query;

    if (query.isEmpty) {
      filteredList.assignAll(drSentOrderList);
    } else {
      filteredList.assignAll(
        drSentOrderList.where((item) {
          return (item.partNumber ?? '').toLowerCase().contains(query) ||
              (item.location ?? '').toLowerCase().contains(query);
        }).toList(),
      );
    }

    regroup();
  }

  void clearSearchBar() {
    searchController.clear();
    filteredList.assignAll(drSentOrderList);
    searchText.value = '';
    regroup();
  }

  /// CHANGE GROUP TYPE
  void updateGrouping(DrSentGroupType type) {
    groupType.value = type;
    regroup();
  }

  /// GROUP BY PART NUMBER
  List<DrSentPartModel> groupByPart(List<DrSentModel> list) {
    final Map<String, List<DrSentModel>> map = {};

    for (var item in list) {
      final key = item.partNumber ?? '';

      map.putIfAbsent(key, () => []);
      map[key]!.add(item);
    }

    return map.entries.map((e) {
      final items = e.value;
      final totalQty = items.fold<int>(
        0,
        (sum, i) => sum + (i.qty?.toInt() ?? 0),
      );

      return DrSentPartModel(
        partNumber: e.key,
        partDesc: items.first.description ?? "",
        qty: totalQty,
        items: items,
      );
    }).toList();
  }

  /// Groups PO items by seller (dealerName + sellerLocation)
// and calculates total MRP & total Price for each seller
  List<DrSentSellerModel> groupBySeller(List<DrSentModel> list) {
    // Map to group items using a unique key
    // key format: dealerName_location
    final Map<String, List<DrSentModel>> map = {};

    // Loop through each OR item
    for (var item in list) {
      // Create a unique key for grouping
      final key = '${item.dealer}_${item.location}';

      // If key doesn't exist, initialize empty list
      map.putIfAbsent(key, () => []);

      // Add item to the respective group
      map[key]!.add(item);
    }

    // Convert grouped map into a list of UpdatePoSellerModel
    return map.entries.map((e) {
      final items = e.value;
      final totalQty = items.fold<int>(
        0,
        (sum, i) => sum + (i.qty?.toInt() ?? 0),
      );
      // 🔹 Date handling
      // final DateFormat formatter = DateFormat('MMM d yyyy hh:mma');
      //
      // final DateTime highestDate = items.map((e) {
      //   final cleanedDate =
      //       e.requestDate?.replaceAll(RegExp(r'\s+'), ' ').trim();
      //   return formatter.parse(cleanedDate ?? '');
      // }).reduce((a, b) => a.isBefore(b) ? a : b);
      //
      // final String formattedMinimumDate =
      //     DateFormat('MMM d yyyy').format(highestDate);

      //total item inside
      // final int totalItem = e.value.length;
      return DrSentSellerModel(
        sellerName: items.first.dealer ?? '', //after group dealer
        location: items.first.location ?? '', //after group location
        // totalItem: totalItem, // Sum of all item inside the seller
        qty: totalQty,
        items: items,
      );
    }).toList();
  }

  /// REGROUP DATA BASED ON TYPE
  void regroup() {
    if (groupType.value == DrSentGroupType.part) {
      partGroups.value = groupByPart(filteredList);
    } else {
      sellerGroups.value = groupBySeller(filteredList);
    }
  }



  ///Sort Sheet
  Future<bool?> openSortSheet(BuildContext context) {
    return Get.bottomSheet<bool>(
      SafeArea(
        child: Container(
          // height: MediaQuery.of(context).size.height * .75,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: DrSentSortSheet(),
        ),
      ),
      isScrollControlled: true,
    );
  }
}
