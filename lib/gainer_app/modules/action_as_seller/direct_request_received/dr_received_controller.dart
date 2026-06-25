import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/Services/auth_service.dart';
import '../../../core/Services/gainer_api_service.dart';
import '../../../core/constants/gainer_image.dart';
import '../../../core/services/fcm_service/firebase_db_creation.dart';
import '../../../core/services/fcm_service/send_notification_service.dart';
import '../../../core/widgets/gainer_bottom_sheet.dart';
import '../../../core/widgets/gainer_dialog.dart';
import '../../../routes/app_routes.dart';
import 'models/dr_received_model.dart';
import 'models/dr_received_part_model.dart';
import 'models/dr_received_seller_model.dart';
import 'models/stock_quality_list_model.dart';
import 'widgets/sort_filter/dr_received_filter_sheet.dart';
import 'widgets/sort_filter/dr_received_sort_sheet.dart';

enum DrReceivedGroupType { part, seller }

class DrReceivedController extends GetxController {
  // final formKey = GlobalKey<FormState>();

  /// ORIGINAL / FILTERED LIST
  RxList<DrReceivedModel> drReceivedOrderList = <DrReceivedModel>[].obs;
  RxList<DrReceivedModel> filteredList = <DrReceivedModel>[].obs;

  /// CURRENT GROUP TYPE
  // Rx<DrReceivedGroupType> groupType = DrReceivedGroupType.part.obs;
  Rx<DrReceivedGroupType> groupType = DrReceivedGroupType.part.obs;

  /// GROUPED DATA LISTS
  RxList<DrReceivedPartModel> partGroups = <DrReceivedPartModel>[].obs;
  RxList<DrReceivedSellerModel> sellerGroups = <DrReceivedSellerModel>[].obs;
  RxList<StockQualityListModel> stockQualityList =
      <StockQualityListModel>[].obs;

  /// LOADING STATE
  RxBool isLoading = false.obs;

  /// ERROR / RESPONSE MESSAGES
  RxnString errorMsg = RxnString(null);
  RxnString selectedStockQuality = RxnString();
  RxnInt selectedStockQualityId = RxnInt();

  /// SEARCH CONTROLLER
  SearchController searchController = SearchController();

  @override
  void onInit() {
    super.onInit();
    getDrReceivedOrders();
    getStockCat();
  }

  Future<void> getDrReceivedOrders() async {
    final locationId = await AuthService.getLocationId();
    final tCode = await AuthService.getTCode();
    isLoading(true);
    final response =
        await GainerApiService().getDrReceivedOrder(locationId, tCode);
    isLoading(false);

    if (response['success']) {
      final data = response['data'];
      List<dynamic> jsonList = jsonDecode(data);
      drReceivedOrderList
          .assignAll(jsonList.map((e) => DrReceivedModel.fromJson(e)));
      filteredList.assignAll(drReceivedOrderList);
      regroup();
    } else {
      errorMsg.value = response['message'];
    }
  }

  Future<void> getStockCat() async {
    final res = await GainerApiService().getStockCat();

    if (res['success']) {
      stockQualityList.assignAll(
        (res['data'] as List)
            .map((e) => StockQualityListModel.fromJson(e))
            .toList(),
      );
    } else {
      GainerBottomSheet.showSnackBar(res['message']);
    }
  }

  // void onStockQualityChanged(String? quality) {
  //   if (quality == null) return;
  //   selectedStockQuality.value = quality;
  //
  //   final stockQualityId = stockQualityList
  //       .firstWhere((stock) => stock.stockQuality == selectedStockQuality.value)
  //       .stockQualityId;
  //   selectedStockQualityId.value = stockQualityId;
  // }

  void onStockQualityChanged(DrReceivedModel order, String? val) {
    if (val == null) return;
    selectedStockQuality.value = val;

    final stockQualityId = stockQualityList
        .firstWhere((stock) => stock.stockQuality == selectedStockQuality.value)
        .stockQualityId;

    order.selectedStockQuality.value = stockQualityId;
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
      filteredList.assignAll(drReceivedOrderList);
    } else {
      filteredList.assignAll(
        drReceivedOrderList.where((item) {
          return (item.partNumber ?? '').toLowerCase().contains(query) ||
              (item.buyingLocation ?? '').toLowerCase().contains(query);
        }).toList(),
      );
    }

    regroup();
  }

  void clearSearchBar() {
    searchController.clear();
    filteredList.assignAll(drReceivedOrderList);
    searchText.value = '';
    regroup();
  }

  void onTapBtn(
    String title,
    Future<void> Function() onYes,
  ) {
    GainerDialog.dialogForYesNo(
      text: title,
      imgPath: GainerImages.decisionMaking,
      yesFunction: () async {
        Get.back();
        onYes();
      },
      noFunction: Get.back,
    );
  }

  Future<void> acceptRequest(DrReceivedModel part) async {
    // AcceptDRSeller - RejectDRSeller

    final discount = part.discountCtl.text.trim();
    final stock = part.stockCtl.text.trim();
    final stockType = part.selectedStockQuality.value;
    if (discount.isEmpty || stock.isEmpty || stockType == null) {
      GainerBottomSheet.showSnackBar('All field are mandatory');
      return;
    }

    final tCode = await AuthService.getTCode();
    final locationId = await AuthService.getLocationId();

    onTapBtn('Are you sure to accept this order?', () async {
      isLoading(true);
      final response = await GainerApiService().acceptDrReceived(
        id: part.id.toString(),
        discount: part.discountCtl.text.trim(),
        sellerStockQty: part.stockCtl.text.trim(),
        stockQuality: part.selectedStockQuality.value.toString(),
        tCode: tCode,
        locationId: locationId,
      );
      isLoading(false);
      if (response['success']) {
        GainerDialog.midPopUp(GainerImages.checkIcon, response['data']);
        await getDrReceivedOrders();
        await sendNotification(part, 'accept');
      } else {
        GainerBottomSheet.showSnackBar(response['message']);
      }
    });
  }

  Future<void> rejectRequest(DrReceivedModel part) async {
    // AcceptDRSeller - RejectDRSeller

    onTapBtn('Are you sure to reject order received', () async {
      final tCode = await AuthService.getTCode();

      final response = await GainerApiService().rejectDRReceived(
        id: part.id.toString(),
        tCode: tCode,
      );
      if (response['success']) {
        GainerDialog.midPopUp(GainerImages.checkIcon, response['data']);
        await getDrReceivedOrders();
        sendNotification(part, 'reject');
      } else {
        GainerBottomSheet.showSnackBar(response['message']);
      }
    });
  }

  /// CHANGE GROUP TYPE
  void updateGrouping(DrReceivedGroupType type) {
    groupType.value = type;
    regroup();
  }

  /// GROUP BY PART NUMBER
  List<DrReceivedPartModel> groupByPart(List<DrReceivedModel> list) {
    final Map<String, List<DrReceivedModel>> map = {};

    for (var item in list) {
      final key = item.partNumber ?? '';

      map.putIfAbsent(key, () => []);
      map[key]!.add(item);
    }

    return map.entries.map((e) {
      final items = e.value;
      //total item inside
      final int totalItem = e.value.length;

      return DrReceivedPartModel(
        partNumber: e.key,
        partDesc: items.first.description ?? "",
        totalItem: totalItem,
        items: items,
      );
    }).toList();
  }

  /// Groups PO items by seller (dealerName + sellerLocation)
// and calculates total MRP & total Price for each seller
  List<DrReceivedSellerModel> groupBySeller(List<DrReceivedModel> list) {
    // Map to group items using a unique key
    // key format: dealerName_location
    final Map<String, List<DrReceivedModel>> map = {};

    // Loop through each OR item
    for (var item in list) {
      // Create a unique key for grouping
      final key = '${item.buyingDealer}_${item.buyingLocation}';

      // If key doesn't exist, initialize empty list
      map.putIfAbsent(key, () => []);

      // Add item to the respective group
      map[key]!.add(item);
    }

    // Convert grouped map into a list of UpdatePoSellerModel
    return map.entries.map((e) {
      final items = e.value;
      // final totalQty = items.fold<int>(
      //   0,
      //   (sum, i) => sum + (i.qty?.toInt() ?? 0),
      // );
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
      final int totalItem = e.value.length;
      return DrReceivedSellerModel(
        sellerName: items.first.buyingDealer ?? '', //after group dealer
        location: items.first.buyingLocation ?? '', //after group location
        // totalItem: totalItem, // Sum of all item inside the seller
        totalItems: totalItem,
        items: items,
      );
    }).toList();
  }

  /// REGROUP DATA BASED ON TYPE
  void regroup() {
    if (groupType.value == DrReceivedGroupType.part) {
      partGroups.value = groupByPart(filteredList);
    } else {
      sellerGroups.value = groupBySeller(filteredList);
    }
  }

  // ///Sort Sheet
  // Future<bool?> openSortSheet(BuildContext context) {
  //   return Get.bottomSheet<bool>(
  //     SafeArea(
  //       child: Container(
  //         decoration: const BoxDecoration(
  //           color: Colors.white,
  //           borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
  //         ),
  //         child: DrReceivedSortSheet(),
  //       ),
  //     ),
  //     isScrollControlled: true,
  //   );
  // }

  ///FILTER FUNCTIONALITY
  /// QUICK FILTER
  // RxString selectedOrderType = 'All'.obs;

  /// APPLIED FILTERS (affect list)
  RxSet<String> appliedDealers = <String>{}.obs;
  RxSet<String> appliedLocations = <String>{}.obs;
  RxSet<String> appliedPartNos = <String>{}.obs;

  /// TEMP FILTERS (UI only)
  RxSet<String> tempDealers = <String>{}.obs;
  RxSet<String> tempLocations = <String>{}.obs;
  RxSet<String> tempPartNos = <String>{}.obs;
  // RxString tempSelectedOrderType = 'All'.obs;

  /// FOR SHOWING IN SCREEN (UI only)
  final dealers = <String>{}.obs;
  final locations = <String>{}.obs;
  final RxMap<String, String> partNdDesc = <String, String>{}.obs;
  final RxMap<String, String> tempPartNdDesc = <String, String>{}.obs;

  ///check is there any filter applied
  final RxBool isFilterApplied = false.obs;

  ///LAST APPLIED FILTER SHOW
  void openFilter() {
    tempDealers.assignAll(appliedDealers);
    tempLocations.assignAll(appliedLocations);
    tempPartNos.assignAll(appliedPartNos);
    // tempSelectedOrderType.value = selectedOrderType.value;

    rebuildDealers();
    rebuildLocations();
    rebuildParts();
  }

  void toggle(RxSet<String> set, String value) {
    set.contains(value) ? set.remove(value) : set.add(value);
  }

  ///Toggle DEALER and rebuild Dealer -> location, part
  void toggleDealer(String dealer) {
    toggle(tempDealers, dealer);

    tempLocations.clear();
    tempPartNos.clear();

    rebuildLocations();
    rebuildParts();

    ///here is problem
  }

  ///Toggle Location and rebuild Location -> part
  void toggleLocation(String location) {
    toggle(tempLocations, location);

    tempPartNos.clear();
    rebuildParts();
  }

  ///Toggle Part
  void togglePart(String partNo) {
    toggle(tempPartNos, partNo);
  }

  ///Rebuild dealer name in filter (assign all)
  void rebuildDealers() {
    dealers.assignAll(
        drReceivedOrderList.map((e) => e.buyingDealer ?? '').toSet());
  }

  ///Rebuild location name in filter (according to dealer)
  void rebuildLocations() {
    final filtered = drReceivedOrderList.where((o) {
      return tempDealers.isEmpty || tempDealers.contains(o.buyingDealer);
    });

    locations.assignAll(filtered.map((e) => e.buyingLocation ?? '').toSet());
  }

  ///Rebuild location name in filter (according to dealer & location)
  void rebuildParts() {
    final filtered = drReceivedOrderList.where((o) {
      if (tempDealers.isNotEmpty && !tempDealers.contains(o.buyingDealer)) {
        return false;
      }

      if (tempLocations.isNotEmpty &&
          !tempLocations.contains(o.buyingLocation)) {
        return false;
      }

      return true;
    });

    partNdDesc.clear();
    for (final o in filtered) {
      partNdDesc[o.partNumber ?? ''] = o.description ?? '';
    }
  }

  ///WHEN CLICK ON APPLY AFTER FILTER
  void applyFilters() {
    appliedDealers.assignAll(tempDealers);
    appliedLocations.assignAll(tempLocations);
    appliedPartNos.assignAll(tempPartNos);
    // selectedOrderType.value = tempSelectedOrderType.value;

    filteredList.value = drReceivedOrderList.where((order) {
      // if (selectedOrderType.value != 'All' &&
      //     order.orderFor != selectedOrderType.value) {
      //   return false;
      // }

      if (appliedDealers.isNotEmpty &&
          !appliedDealers.contains(order.buyingDealer)) {
        return false;
      }

      if (appliedLocations.isNotEmpty &&
          !appliedLocations.contains(order.buyingLocation)) {
        return false;
      }

      if (appliedPartNos.isNotEmpty &&
          !appliedPartNos.contains(order.partNumber)) {
        return false;
      }

      return true;
    }).toList();

    ///Check is there any filter applied
    if (appliedDealers.isNotEmpty ||
            appliedLocations.isNotEmpty ||
            appliedPartNos.isNotEmpty
        // || selectedOrderType.value != 'All'
        ) {
      isFilterApplied.value = true;
    } else {
      isFilterApplied.value = false;
    }
    regroup();
  }

  ///Clear temp selected item
  void cancelFilter() {
    tempDealers.clear();
    tempLocations.clear();
    tempPartNos.clear();
    // tempSelectedOrderType.value = 'All';
  }

  ///Clear all filter on tap of clear
  void clearAllFilter() {
    // selectedOrderType.value = 'All';
    appliedDealers.clear();
    appliedLocations.clear();
    appliedPartNos.clear();
    filteredList.assignAll(drReceivedOrderList);
    isFilterApplied.value = false;
  }

  Future<bool?> openSortSheet(BuildContext context) {
    return Get.bottomSheet<bool>(
      SafeArea(
        child: Container(
          // height: MediaQuery.of(context).size.height * .75,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: DrReceivedSortSheet(),
        ),
      ),
      isScrollControlled: true,
    );
  }

  Future<bool?> openFilterSheet(BuildContext context) {
    return Get.bottomSheet<bool>(
      SafeArea(
        child: Container(
          height: MediaQuery.of(context).size.height * .75,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: DrReceivedFilterSheet(),
        ),
      ),
      isScrollControlled: true,
    );
  }

  Future<void> onFilterTap(BuildContext context) async {
    openFilter();
    final applied = await openFilterSheet(context);
    if (applied == true) {
      applyFilters();
      update();
    }
  }

  Future<void> sendNotification(DrReceivedModel part, String action) async {
    bool needN = await FirebaseDbCreation.needNotificationSend();
    if (!needN) return;
    String dealerName = await AuthService.getDealer();
    String locationName = await AuthService.getLocation();
    if (action == 'accept') {
      await PushNotification.notifyDealer(
        locationID: part.buyingLocationId ?? '',
        title: 'ORDER CONFIRMATION',
        body:
            'Enquiry raised from ${part.buyingLocation} for ${part.partNumber} (${part.qty?.toInt()} Qty) is ACCEPTED by $dealerName $locationName. Please raise Final PO in ${part.buyingLocation} & update on Gainer.',
        data: {'moduleRoute': Routes.UPDATEPO},
      );
    } else {
      await PushNotification.notifyDealer(
        locationID: part.buyingLocationId ?? '',
        title: 'ORDER REQUEST (REJECTED)',
        body:
            'Enquiry raised from ${part.buyingLocation} for ${part.partNumber} (${part.qty?.toInt()} Qty) is REJECTED by $dealerName/$locationName. Please check part on Gainer & place enquiry to another Co-Dealer',
        data: {'moduleRoute': Routes.PARTREQUESTVIEW},
      );
    }
  }
}
