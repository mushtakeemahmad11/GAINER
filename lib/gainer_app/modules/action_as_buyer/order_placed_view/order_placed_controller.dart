import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gainer/gainer_app/core/Services/auth_service.dart';
import '../../../core/constants/gainer_image.dart';
import '../../../core/services/gainer_api_service.dart';
import '../../../core/widgets/gainer_bottom_sheet.dart';
import '../../../core/widgets/gainer_dialog.dart';
import 'models/grouped_part_model.dart';
import 'models/grouped_seller_model.dart';
import 'models/order_placed_model.dart';
import 'widgets/sort_filter/or_sort_sheet.dart';

/// GROUP TYPE ENUM
enum OPGroupType { part, seller }

/// ORDER PLACED CONTROLLER
class OrderPlacedController extends GetxController {
  /// ORIGINAL / FILTERED LIST
  RxList<OrderPlacedModel> orderPlacedList = <OrderPlacedModel>[].obs;
  RxList<OrderPlacedModel> filteredList = <OrderPlacedModel>[].obs;

  /// CURRENT GROUP TYPE
  Rx<OPGroupType> groupType = OPGroupType.part.obs;

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

  ///search filed text
  final RxString searchText = ''.obs;

  /// SEARCH HANDLING
  void onSearch(String text) {
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
    searchText.value = '';
    regroup();
  }

  /// CHANGE GROUP TYPE
  void updateGrouping(OPGroupType type) {
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
    if (groupType.value == OPGroupType.part) {
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
    final tCode = await AuthService.getTCode();

    errorMsg.value = null;
    isLoading.value = true;
    final response = await GainerApiService()
        .getBuyerStages(locationId, 'REQUESTSENT', tCode);

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

  void deletePart(String? part, String bigId, BuildContext context) async {
    GainerDialog.dialogForYesNo(
      text: 'Are you sure do you want to remove it ?\nPart Number: $part',
      imgPath: GainerImages.decisionMaking,
      yesFunction: () async {
        Get.back();
        odrDltResMsg.value = null;
        odrDltErrorMsg.value = null;
        selectedBigId.value = bigId;
        await orderPlacedDeleteAsBuyer(bigId);
        selectedBigId.value = null;

        if (odrDltResMsg.value != null) {
          GainerDialog.midPopUp(GainerImages.deleteIcon,
              odrDltResMsg.value ?? "Part Request Deleted");
        } else {
          GainerBottomSheet.showSnackBar(
            odrDltErrorMsg.value ?? "There is a problem......!",
          );
        }
      },
      noFunction: Get.back,
    );
  }

  RxBool dltIsLoading = false.obs;

  /// API CALL — DELETE ORDER
  Future<void> orderPlacedDeleteAsBuyer(String bigID) async {
    final locationId = await AuthService.getLocationId();
    final tCode = await AuthService.getTCode();
    dltIsLoading.value = true;
    final response =
        await GainerApiService().orderPlacedDelete(bigID, locationId, tCode);
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
          child: OPSortSheet(),
        ),
      ),
      isScrollControlled: true,
    );
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }
}
