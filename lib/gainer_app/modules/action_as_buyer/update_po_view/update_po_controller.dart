import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:gainer/gainer_app/modules/action_as_buyer/update_po_view/models/grouped_part_model.dart';
import 'package:get/get.dart';
import '../../../../gainer/apis_functionality/api_service.dart';
import '../../../core/Services/auth_service.dart';
import 'models/update_po_model.dart';
import 'models/update_po_part_model.dart';

/// GROUP TYPE ENUM
enum GroupType { part, seller }

class UpdatePoController extends GetxController {
  /// ORIGINAL / FILTERED LIST
  RxList<UpdatePoModel> updatePoList = <UpdatePoModel>[].obs;
  RxList<UpdatePoModel> filteredList = <UpdatePoModel>[].obs;

  /// CURRENT GROUP TYPE
  Rx<GroupType> groupType = GroupType.part.obs;

  /// GROUPED DATA LISTS
  RxList<UpdatePoPartModel> partGroups = <UpdatePoPartModel>[].obs;
  RxList<UpdatePoSellerModel> sellerGroups = <UpdatePoSellerModel>[].obs;

  /// LOADING STATE
  RxBool isLoading = false.obs;

  /// ERROR / RESPONSE MESSAGES
  RxnString errorMsg = RxnString(null);
  RxnString odrDltResMsg = RxnString(null);

  /// SEARCH CONTROLLER
  SearchController searchController = SearchController();

  /// SORT TYPE
  // Rx<SortType> sortType = SortType.part.obs;

  /// SEARCH
  RxString search = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchPoDetails();
  }

  /// SEARCH HANDLING
  void onSearch(String text) {
    final query = text.trim().toLowerCase();

    if (query.isEmpty) {
      filteredList.assignAll(updatePoList);
    } else {
      filteredList.assignAll(
        updatePoList.where((item) {
          return (item.partNumber).toLowerCase().contains(query) ||
              (item.dealerName).toLowerCase().contains(query);
        }).toList(),
      );
    }

    regroup();
  }

  /// CLEAR SEARCH BAR
  void clearSearchBar() {
    searchController.clear();
    filteredList.assignAll(updatePoList);
    regroup();
  }

  /// CHANGE GROUP TYPE
  void updateGrouping(GroupType type) {
    groupType.value = type;
    regroup();
  }

  /// GROUP BY PART NUMBER
  List<UpdatePoPartModel> groupByPart(List<UpdatePoModel> list) {
    final Map<String, List<UpdatePoModel>> map = {};

    for (var item in list) {
      map.putIfAbsent(item.partNumber, () => []);
      map[item.partNumber]!.add(item);
    }

    return map.entries.map((e) {
      final items = e.value;
      final totalQty = items.fold<int>(
        0,
        (sum, i) => sum + (i.qty),
      );

      return UpdatePoPartModel(
        partNumber: e.key,
        partDesc: items.first.partDesc,
        totalQty: totalQty,
        items: items,
      );
    }).toList();
  }

  /// GROUP BY SELLER + LOCATION
  List<UpdatePoSellerModel> groupBySeller(List<UpdatePoModel> list) {
    final Map<String, List<UpdatePoModel>> map = {};

    for (var item in list) {
      final key = '${item.dealerName}_${item.sellerLocation}';

      map.putIfAbsent(key, () => []);
      map[key]!.add(item);
    }

    return map.entries.map((e) {
      final items = e.value;
      // final totalQty = items.fold<int>(
      //   0,
      //   (sum, i) => sum + (i.qty),
      // );

      final totalMrp = items.fold<int>(0, (sum, i) => sum + (i.mrp).toInt());
      final totalPrice =
          items.fold<int>(0, (sum, i) => sum + (i.price).toInt());
      return UpdatePoSellerModel(
        sellerName: items.first.dealerName,
        location: items.first.sellerLocation,
        totalMrp: totalMrp,
        totalPrice: totalPrice,
        items: items,
      );
    }).toList();
  }

  /// REGROUP DATA BASED ON TYPE
  void regroup() {
    if (groupType.value == GroupType.part) {
      partGroups.value = groupByPart(filteredList);
    } else {
      sellerGroups.value = groupBySeller(filteredList);
    }
  }

  /// ---------------- FETCH API ----------------
  Future<void> fetchPoDetails() async {
    final locationId = await AuthService.getLocationId();

    errorMsg.value = null;
    isLoading.value = true;

    final response =
        await ApiService().getBuyerStages(locationId, 'REQUESTACCEPTED');

    isLoading.value = false;

    if (response['success']) {
      List<dynamic> jsonList = jsonDecode(response['data']);

      updatePoList.assignAll(
        jsonList.map((e) => UpdatePoModel.fromJson(e)),
      );

      filteredList.assignAll(updatePoList);
      regroup();
      print("Part: $filteredList");
    } else {
      errorMsg.value = response['message'];

      updatePoList.clear();
      filteredList.clear();
      partGroups.clear();
      sellerGroups.clear();
    }
  }

  /// ---------------- SEARCH ----------------
  // void onSearch(String value) {
  //   search.value = value.toLowerCase();
  //
  //   filteredList.assignAll(
  //     updatePoList.where((e) =>
  //         e.partNumber.toLowerCase().contains(search.value) ||
  //         e.dealerName.toLowerCase().contains(search.value)),
  //   );
  // }

  // /// ---------------- SORT ----------------
  // void changeSort(SortType type) {
  //   sortType.value = type;
  //
  //   if (type == SortType.part) {
  //     filteredList.sort((a, b) => a.partNumber.compareTo(b.partNumber));
  //   } else {
  //     filteredList.sort((a, b) => a.dealerName.compareTo(b.dealerName));
  //   }
  // }
}
