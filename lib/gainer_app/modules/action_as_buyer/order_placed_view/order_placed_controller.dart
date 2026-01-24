import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gainer/gainer_app/core/Services/auth_service.dart';
import '../../../../gainer/apis_functionality/api_service.dart';
import 'models/grouped_part_model.dart';
import 'models/grouped_seller_model.dart';
import 'models/order_placed_model.dart';

/// GROUP TYPE ENUM
enum GroupType { part, seller }

/// ORDER PLACED CONTROLLER
class OrderPlacedController extends GetxController {
  /// ORIGINAL / FILTERED LIST
  RxList<OrderPlacedModel> orderPlacedList = <OrderPlacedModel>[].obs;
  RxList<OrderPlacedModel> filteredList = <OrderPlacedModel>[].obs;

  /// CURRENT GROUP TYPE
  Rx<GroupType> groupType = GroupType.part.obs;

  /// GROUPED DATA LISTS
  RxList<GroupedPartModel> partGroups = <GroupedPartModel>[].obs;
  RxList<GroupedSellerModel> sellerGroups = <GroupedSellerModel>[].obs;

  /// LOADING STATE
  RxBool isLoading = false.obs;

  /// ERROR / RESPONSE MESSAGES
  RxnString errorMsg = RxnString(null);
  RxnString odrDltResMsg = RxnString(null);
  RxnString odrDltErrorMsg = RxnString(null);

  /// SEARCH CONTROLLER
  SearchController searchController = SearchController();

  /// CONTROLLER INIT
  @override
  void onInit() {
    super.onInit();
    orderPlacedAsBuyer();
  }

  /// SEARCH HANDLING
  void onSearch(String text) {
    final query = text.trim().toLowerCase();

    if (query.isEmpty) {
      filteredList.assignAll(orderPlacedList);
    } else {
      filteredList.assignAll(
        orderPlacedList.where((item) {
          return (item.partNumber ?? '').toLowerCase().contains(query) ||
              (item.dealerName ?? '').toLowerCase().contains(query);
        }).toList(),
      );
    }

    regroup();
  }

  /// CLEAR SEARCH BAR
  void clearSearchBar() {
    searchController.clear();
    filteredList.assignAll(orderPlacedList);
    regroup();
  }

  /// CHANGE GROUP TYPE
  void updateGrouping(GroupType type) {
    groupType.value = type;
    regroup();
  }

  /// GROUP BY PART NUMBER
  List<GroupedPartModel> groupByPart(List<OrderPlacedModel> list) {
    final Map<String, List<OrderPlacedModel>> map = {};

    for (var item in list) {
      map.putIfAbsent(item.partNumber!, () => []);
      map[item.partNumber!]!.add(item);
    }

    return map.entries.map((e) {
      final items = e.value;
      final totalQty = items.fold<int>(
        0,
            (sum, i) => sum + (i.qty ?? 0),
      );

      return GroupedPartModel(
        partNumber: e.key,
        partDesc: items.first.partDesc ?? '',
        totalQty: totalQty,
        items: items,
      );
    }).toList();
  }

  /// GROUP BY SELLER + LOCATION
  List<GroupedSellerModel> groupBySeller(List<OrderPlacedModel> list) {
    final Map<String, List<OrderPlacedModel>> map = {};

    for (var item in list) {
      final key = '${item.dealerName}_${item.sellerLocation}';

      map.putIfAbsent(key, () => []);
      map[key]!.add(item);
    }

    return map.entries.map((e) {
      final items = e.value;
      final totalQty = items.fold<int>(
        0,
            (sum, i) => sum + (i.qty ?? 0),
      );

      return GroupedSellerModel(
        sellerName: items.first.dealerName ?? '',
        location: items.first.sellerLocation ?? '',
        totalQty: totalQty,
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

  /// GROUPED DATA MAP (OPTIONAL)
  final RxMap<String, List<OrderPlacedModel>> groupedData =
      <String, List<OrderPlacedModel>>{}.obs;

  /// API RESPONSE HANDLING
  void setOrdersFromApi(String responseData) {
    List<dynamic> jsonList = jsonDecode(responseData);

    orderPlacedList.assignAll(
      jsonList.map((e) => OrderPlacedModel.fromJson(e)),
    );

    filteredList.assignAll(orderPlacedList);

    regroup();
  }



  /// API CALL — FETCH ORDERS
  Future<void> orderPlacedAsBuyer() async {
    final locationId = await AuthService.getLocationId();

    errorMsg.value = null;
    isLoading.value = true;

    final response =
        await ApiService().getBuyerStages(locationId, 'REQUESTSENT');

    isLoading.value = false;

    if (response['success']) {
      setOrdersFromApi(response['data']);
    } else {
      errorMsg.value = response['message'];

      orderPlacedList.clear();
      filteredList.clear();
      partGroups.clear();
      sellerGroups.clear();
    }
  }

  /// DELETE HANDLING
  RxnString selectedBigId = RxnString(null);

  void deletePart(String bigId) async {
    odrDltResMsg.value = null;
    odrDltErrorMsg.value = null;

    selectedBigId.value = bigId;

    await orderPlacedDeleteAsBuyer(bigId);

    selectedBigId.value = null;
  }

  RxBool dltIsLoading = false.obs;

  /// API CALL — DELETE ORDER
  Future<void> orderPlacedDeleteAsBuyer(String bigID) async {
    dltIsLoading.value = true;

    final response = await ApiService().orderPlacedDelete(bigID);

    dltIsLoading.value = false;

    if (response['success']) {
      odrDltResMsg.value = response['data'];

      orderPlacedList.removeWhere(
        (e) => e.bigId.toString() == bigID,
      );

      filteredList.assignAll(orderPlacedList);

      regroup();
    } else {
      odrDltErrorMsg.value = response['message'];
    }
  }
}

// import 'package:flutter/material.dart';
// import 'package:gainer/gainer_app/core/Services/auth_service.dart';
// import 'package:get/get.dart';
// import 'dart:convert';
// import '../../../../gainer/apis_functionality/api_service.dart';
// import 'models/grouped_part_model.dart';
// import 'models/update_po_part_model.dart';
// import 'models/order_placed_model.dart';
//
// /// 🔹 GROUP TYPE (WRITE HERE)
// enum GroupType { part, seller }
//
// class OrderPlacedController extends GetxController {
//   /// original flat list
//   RxList<OrderPlacedModel> orderPlacedList = <OrderPlacedModel>[].obs;
//   RxList<OrderPlacedModel> filteredList = <OrderPlacedModel>[].obs;
//
//   /// current grouping type
//   Rx<GroupType> groupType = GroupType.part.obs;
//
//   /// grouped lists
//   RxList<GroupedPartModel> partGroups = <GroupedPartModel>[].obs;
//
//   RxList<GroupedSellerModel> sellerGroups = <GroupedSellerModel>[].obs;
//
//   ///loading data in stage
//   RxBool isLoading = false.obs;
//
//   //for store error msg which comes when api hit
//   RxnString errorMsg = RxnString(null);
//
//   // for store response meg which comes after tap delete icon
//   RxnString odrDltResMsg = RxnString(null);
//   RxnString odrDltErrorMsg = RxnString(null);
//
//   @override
//   void onInit() {
//     super.onInit();
//     orderPlacedAsBuyer();
//   }
//
//   SearchController searchController = SearchController();
//
//   ///on search Part
//   void onSearch(String text) {
//     final query = text.trim().toLowerCase();
//
//     if (query.isEmpty) {
//       filteredList.assignAll(orderPlacedList);
//     } else {
//       filteredList.assignAll(
//         orderPlacedList.where((item) {
//           return (item.partNumber ?? '').toLowerCase().contains(query) ||
//               (item.dealerName ?? '').toLowerCase().contains(query);
//         }).toList(),
//       );
//     }
//
//     regroup();
//   }
//
//   void clearSearchBar() {
//     searchController.clear();
//     filteredList.assignAll(orderPlacedList);
//     regroup();
//   }
//
//   void updateGrouping(GroupType type) {
//     groupType.value = type;
//     regroup();
//   }
//
//   void regroup() {
//     if (groupType.value == GroupType.part) {
//       partGroups.value = groupByPart(filteredList);
//     } else {
//       sellerGroups.value = groupBySeller(filteredList);
//     }
//   }
//
//   /// Grouped data for UI
//   final RxMap<String, List<OrderPlacedModel>> groupedData =
//       <String, List<OrderPlacedModel>>{}.obs;
//
//   /// API RESPONSE HANDLING
//   void setOrdersFromApi(String responseData) {
//     print("setOrdersFromApi called");
//
//     List<dynamic> jsonList = jsonDecode(responseData);
//
//     print("JSON LENGTH: ${jsonList.length}");
//
//     orderPlacedList.assignAll(
//       jsonList.map((e) => OrderPlacedModel.fromJson(e)),
//     );
//
//     print("ORDER LIST LENGTH: ${orderPlacedList.length}");
//
//     filteredList.assignAll(orderPlacedList);
//
//     regroup();
//   }
//
//   // void setOrdersFromApi(String responseData) {
//   //   List<dynamic> jsonList = jsonDecode(responseData);
//   //
//   //   orderPlacedList.value =
//   //       jsonList.map((e) => OrderPlacedModel.fromJson(e)).toList();
//   //   filteredList.value = orderPlacedList;
//   //   regroup();
//   // }
//
//   List<GroupedPartModel> groupByPart(List<OrderPlacedModel> list) {
//     final Map<String, List<OrderPlacedModel>> map = {};
//
//     for (var item in list) {
//       map.putIfAbsent(item.partNumber!, () => []);
//       map[item.partNumber!]!.add(item);
//     }
//
//     return map.entries.map((e) {
//       final items = e.value;
//       final totalQty = items.fold<int>(0, (sum, i) => sum + (i.qty ?? 0));
//
//       return GroupedPartModel(
//         partNumber: e.key,
//         partDesc: items.first.partDesc ?? '',
//         totalQty: totalQty,
//         items: items,
//       );
//     }).toList();
//   }
//
//   List<GroupedSellerModel> groupBySeller(List<OrderPlacedModel> list) {
//     final Map<String, List<OrderPlacedModel>> map = {};
//
//     for (var item in list) {
//       final key = '${item.dealerName}_${item.sellerLocation}';
//       map.putIfAbsent(key, () => []);
//       map[key]!.add(item);
//     }
//
//     return map.entries.map((e) {
//       final items = e.value;
//       final totalQty = items.fold<int>(0, (sum, i) => sum + (i.qty ?? 0));
//
//       return GroupedSellerModel(
//         sellerName: items.first.dealerName ?? '',
//         location: items.first.sellerLocation ?? '',
//         totalQty: totalQty,
//         items: items,
//       );
//     }).toList();
//   }
//
//   // API Call to fetch Order placed
//   Future<void> orderPlacedAsBuyer() async {
//     final locationId = await AuthService.getLocationId();
//     errorMsg.value = null;
//     isLoading.value = true;
//     final response =
//         await ApiService().getBuyerStages(locationId, 'REQUESTSENT');
//     isLoading.value = false;
//
//     if (response['success']) {
//       setOrdersFromApi(response['data']);
//     } else {
//       errorMsg.value = response['message'];
//       orderPlacedList.clear();
//       filteredList.clear();
//       partGroups.clear();
//       sellerGroups.clear();
//     }
//   }
//
//   RxnString selectedBigId = RxnString(null);
//   void deletePart(String bigId) async {
//     odrDltResMsg.value = null;
//     odrDltErrorMsg.value = null;
//     selectedBigId.value = bigId;
//     await orderPlacedDeleteAsBuyer(bigId);
//     selectedBigId.value = null;
//   }
//
//   RxBool dltIsLoading = false.obs;
//   //Api for order place delete
//
//   Future<void> orderPlacedDeleteAsBuyer(String bigID) async {
//     dltIsLoading.value = true;
//     final response = await ApiService().orderPlacedDelete(bigID);
//     dltIsLoading.value = false;
//
//     if (response['success']) {
//       odrDltResMsg.value = response['data'];
//       orderPlacedList.removeWhere((e) => e.bigId.toString() == bigID);
//
//       filteredList.assignAll(orderPlacedList);
//
//       regroup();
//     } else {
//       odrDltErrorMsg.value = response['message'];
//     }
//   }
//
//   // Future<void> orderPlacedDeleteAsBuyer(String bigID) async {
//   //   dltIsLoading.value = true;
//   //   final response = await ApiService().orderPlacedDelete(bigID);
//   //   dltIsLoading.value = false;
//   //
//   //   if (response['success']) {
//   //     odrDltResMsg.value = response['data'];
//   //     regroup();
//   //   } else {
//   //     odrDltErrorMsg.value = response['message'];
//   //   }
//   // }
// }
