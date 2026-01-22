import 'package:flutter/material.dart';
import 'package:gainer/gainer_app/core/Services/auth_service.dart';
import 'package:get/get.dart';
import 'dart:convert';
import '../../../../gainer/apis_functionality/api_service.dart';
import 'models/grouped_part_model.dart';
import 'models/grouped_seller_model.dart';
import 'models/order_placed_model.dart';

/// 🔹 GROUP TYPE (WRITE HERE)
enum GroupType { part, seller }

class OrderPlacedController extends GetxController {
  /// original flat list
  RxList<OrderPlacedModel> orderPlacedList = <OrderPlacedModel>[].obs;

  /// current grouping type
  Rx<GroupType> groupType = GroupType.part.obs;

  /// grouped lists
  RxList<GroupedPartModel> partGroups = <GroupedPartModel>[].obs;

  RxList<GroupedSellerModel> sellerGroups = <GroupedSellerModel>[].obs;

  ///loading data in stage
  RxBool isLoading = false.obs;

  //for store error msg which comes when api hit
  RxnString errorMsg = RxnString(null);

  // for store response meg which comes after tap delete icon
  RxnString odrDltResMsg = RxnString(null);
  RxnString odrDltErrorMsg = RxnString(null);

  @override
  void onInit() {
    super.onInit();
    orderPlacedAsBuyer();
  }

  SearchController searchController = SearchController();

  ///on search Part
  void onSearch(String text) {
    final String searchText = searchController.text;
    print("searchText: $text");
    // {
    //   String filteredValue =
    //       await ControllerUtils.partNumberValidation(val);
    //   // String filteredValue = val.replaceAll(RegExp(r'[^a-zA-Z0-9]'), '');
    //   searchByPartsController.text =
    //       filteredValue.toUpperCase().trim();
    //
    //   setState(() {
    //     if (filteredValue.isEmpty) {
    //       // If search text is empty, display all orders.
    //       _filteredOrderPlaced = List.from(_orderPlaced);
    //     } else {
    //       // Filter orders by part number (case-insensitive)
    //       _filteredOrderPlaced =
    //           _orderPlaced.where((order) {
    //             return order.partNumber!
    //                 .toLowerCase()
    //                 .contains(filteredValue.toLowerCase());
    //           }).toList();
    //     }
    //   });
    // }
  }

  void updateGrouping(GroupType type) {
    groupType.value = type;
    regroup();
  }

  void regroup() {
    if (groupType.value == GroupType.part) {
      partGroups.value = groupByPart(orderPlacedList);
    } else {
      sellerGroups.value = groupBySeller(orderPlacedList);
    }
  }

  /// Grouped data for UI
  final RxMap<String, List<OrderPlacedModel>> groupedData =
      <String, List<OrderPlacedModel>>{}.obs;

  /// API RESPONSE HANDLING
  void setOrdersFromApi(String responseData) {
    List<dynamic> jsonList = jsonDecode(responseData);

    orderPlacedList.value =
        jsonList.map((e) => OrderPlacedModel.fromJson(e)).toList();
    regroup();
  }

  List<GroupedPartModel> groupByPart(List<OrderPlacedModel> list) {
    final Map<String, List<OrderPlacedModel>> map = {};

    for (var item in list) {
      map.putIfAbsent(item.partNumber!, () => []);
      map[item.partNumber!]!.add(item);
    }

    return map.entries.map((e) {
      final items = e.value;
      final totalQty = items.fold<int>(0, (sum, i) => sum + (i.qty ?? 0));

      return GroupedPartModel(
        partNumber: e.key,
        partDesc: items.first.partDesc ?? '',
        totalQty: totalQty,
        items: items,
      );
    }).toList();
  }

  List<GroupedSellerModel> groupBySeller(List<OrderPlacedModel> list) {
    final Map<String, List<OrderPlacedModel>> map = {};

    for (var item in list) {
      final key = '${item.dealerName}_${item.sellerLocation}';
      map.putIfAbsent(key, () => []);
      map[key]!.add(item);
    }

    return map.entries.map((e) {
      final items = e.value;
      final totalQty = items.fold<int>(0, (sum, i) => sum + (i.qty ?? 0));

      return GroupedSellerModel(
        sellerName: items.first.dealerName ?? '',
        location: items.first.sellerLocation ?? '',
        totalQty: totalQty,
        items: items,
      );
    }).toList();
  }

  // API Call to fetch Order placed
  Future<void> orderPlacedAsBuyer() async {
    final locationId = await AuthService.getLocationId();
    errorMsg.value = null;
    isLoading.value = true;
    final response =
        await ApiService().getBuyerStages(locationId, 'REQUESTSENT');
    isLoading.value = false;

    if (response['success']) {
      final data = response['data'];
      setOrdersFromApi(data);
    } else {
      errorMsg.value = response['message'];
      orderPlacedList.clear();
    }
  }

  RxnString selectedBigId = RxnString(null);
  void deletePart(String bigId) async {
    odrDltResMsg.value = null;
    odrDltErrorMsg.value = null;
    selectedBigId.value = bigId;
    await orderPlacedDeleteAsBuyer(bigId);
    selectedBigId.value = null;
  }

  RxBool dltIsLoading = false.obs;
  //Api for order place delete
  Future<void> orderPlacedDeleteAsBuyer(String bigID) async {
    dltIsLoading.value = true;
    final response = await ApiService().orderPlacedDelete(bigID);
    dltIsLoading.value = false;

    if (response['success']) {
      odrDltResMsg.value = response['data'];
      regroup();
    } else {
      odrDltErrorMsg.value = response['message'];
    }
  }
}
