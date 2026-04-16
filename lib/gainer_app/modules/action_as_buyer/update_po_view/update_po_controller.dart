import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:gainer/gainer_app/modules/action_as_buyer/update_po_view/models/update_po_part_model.dart';
import 'package:gainer/gainer_app/modules/action_as_buyer/update_po_view/widgets/sort_filter/po_filter_sheet.dart';
import 'package:gainer/gainer_app/modules/action_as_buyer/update_po_view/widgets/sort_filter/po_sort_sheet.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../core/Services/auth_service.dart';
import '../../../core/constants/gainer_image.dart';
import '../../../core/services/gainer_api_service.dart';
import '../../../core/utils/url_launch_utils.dart';
import '../../../core/widgets/gainer_bottom_sheet.dart';
import '../../../core/widgets/gainer_dialog.dart';
import '../../../routes/app_routes.dart';
import 'models/update_po_model.dart';
import 'models/update_po_seller_model.dart';

/// GROUP TYPE ENUM
enum POGroupType { part, seller }

class UpdatePoController extends GetxController {
  /// ORIGINAL / FILTERED LIST
  RxList<UpdatePoModel> updatePoList = <UpdatePoModel>[].obs;
  RxList<UpdatePoModel> filteredList = <UpdatePoModel>[].obs;

  /// CURRENT GROUP TYPE
  Rx<POGroupType> groupType = POGroupType.part.obs;

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

  /// FOR UPDATE PO ORDER SUMMARY SCREEN
  final formKey = GlobalKey<FormState>();
  final TextEditingController poNumberController = TextEditingController();
  final TextEditingController poRemarksController = TextEditingController();

  /// SEARCH
  RxString search = ''.obs;

  final RxString _locationId = ''.obs;
  final RxString _tCode = ''.obs;

  String get locationId => _locationId.value;
  String get tCode => _tCode.value;

  @override
  void onInit() {
    super.onInit();
    _initWork();
  }

  Future<void> _initWork() async {
    await _getLocationIdTCode();
    await _fetchPoDetails();
  }

  Future<void> _getLocationIdTCode() async {
    _locationId.value = await AuthService.getLocationId();
    _tCode.value = await AuthService.getTCode();
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
    searchText.value = '';
    regroup();
  }

  /// CHANGE GROUP TYPE
  void updateGrouping(POGroupType type) {
    groupType.value = type;
    regroup();
  }

  /// GROUP BY PART NUMBER
  List<UpdatePoPartModel> groupByPart(List<UpdatePoModel> list) {
    final Map<String, List<UpdatePoModel>> map = {};

    for (var item in list) {
      final key = item.partNumber;

      map.putIfAbsent(key, () => []);
      map[key]!.add(item);
    }

    return map.entries.map((e) {
      final items = e.value;

      // 🔹 Safe totals
      final totalMrp = items.fold<int>(0, (sum, i) => sum + (i.mrp).toInt());

      final totalPrice =
          items.fold<int>(0, (sum, i) => sum + (i.price).toInt());

      // 🔹 Date handling (safe)
      final DateFormat formatter = DateFormat('MMM d yyyy hh:mma');

      // total quantity
      // final totalQty = items.fold<int>(
      //   0,
      //   (sum, i) => sum + (i.qty),
      // );

      final validDates = items.where((e) => e.requestDate.isNotEmpty).map((e) {
        final cleanedDate =
            e.requestDate.replaceAll(RegExp(r'\s+'), ' ').trim();
        return formatter.parse(cleanedDate);
      }).toList();

      final DateTime highestDate = validDates.isNotEmpty
          ? validDates.reduce((a, b) => a.isAfter(b) ? a : b)
          : DateTime.now();

      final String formattedHighestDate =
          DateFormat('MMM d yyyy').format(highestDate);

      return UpdatePoPartModel(
        partNumber: e.key,
        partDesc: items.first.partDesc,
        highestDate: formattedHighestDate,
        totalMrp: totalMrp,
        totalPrice: totalPrice,
        items: items,
      );
    }).toList();
  }

  /// Groups PO items by seller (dealerName + sellerLocation)
// and calculates total MRP & total Price for each seller
  List<UpdatePoSellerModel> groupBySeller(List<UpdatePoModel> list) {
    // Map to group items using a unique key
    // key format: dealerName_location
    final Map<String, List<UpdatePoModel>> map = {};

    // Loop through each PO item
    for (var item in list) {
      // Create a unique key for grouping
      final key = '${item.dealerName}_${item.sellerLocation}';

      // If key doesn't exist, initialize empty list
      map.putIfAbsent(key, () => []);

      // Add item to the respective group
      map[key]!.add(item);
    }

    // Convert grouped map into a list of UpdatePoSellerModel
    return map.entries.map((e) {
      final items = e.value;

      final totalMrp = items.fold<int>(0, (sum, i) => sum + i.mrp.toInt());

      final totalPrice = items.fold<int>(0, (sum, i) => sum + i.price.toInt());

      // 🔹 Date handling
      final DateFormat formatter = DateFormat('MMM d yyyy hh:mma');

      final DateTime highestDate = items.map((e) {
        final cleanedDate =
            e.requestDate.replaceAll(RegExp(r'\s+'), ' ').trim();
        return formatter.parse(cleanedDate);
      }).reduce((a, b) => a.isAfter(b) ? a : b);

      final String formattedHighestDate =
          DateFormat('MMM d yyyy').format(highestDate);

      return UpdatePoSellerModel(
        sellerName: items.first.dealerName, //after group dealer
        location: items.first.sellerLocation, //after group location
        totalMrp: totalMrp, // Sum of MRP
        totalPrice: totalPrice, // Sum of Price
        items: items,
        highestDate: formattedHighestDate, // Latest date of request date
      );
    }).toList();
  }

  /// REGROUP DATA BASED ON TYPE
  void regroup() {
    if (groupType.value == POGroupType.part) {
      partGroups.value = groupByPart(filteredList);
    } else {
      sellerGroups.value = groupBySeller(filteredList);
    }
  }

  /// ---------------- FETCH API ----------------
  Future<void> _fetchPoDetails() async {
    // final locationId = await AuthService.getLocationId();
    // final tCode = await AuthService.getTCode();

    errorMsg.value = null;
    isLoading.value = true;

    final response = await GainerApiService()
        .getBuyerStages(locationId, 'REQUESTACCEPTED', tCode);

    isLoading.value = false;

    if (response['success']) {
      List<dynamic> jsonList = jsonDecode(response['data']);

      updatePoList.assignAll(
        jsonList.map((e) => UpdatePoModel.fromJson(e)),
      );

      filteredList.assignAll(updatePoList);
      // loadFromOrders(filteredList);
      // loadOrdersInFilters(updatePoList);
      regroup();
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

  /// Download image from image screen
  Future<void> downloadImage(String imgString, BuildContext context) async {
    final imageUrl =
        'https://scope.sparecare.in/UAP_SC/images/PartImage/$imgString';
    String imgName = imgString.replaceAll(".jpg", "replace");
    final response = await UrlLaunchUtils.downloadImage(
      imageUrl,
      "GainerApp",
      imgName,
    );
    if (response['success']) {
      GainerBottomSheet.showSnackBar(
        response['path'],
      );
    } else {
      GainerBottomSheet.showSnackBar(
        response['error'],
      );
    }
  }

  /// GOTO IMAGE SCREEN
  void gotoPartImageScreen(UpdatePoModel order) {
    //for remove green accept
    final key = order.bigId.toString();
    removeAcceptedOrder(key);

    final images =
        order.partImage?.split("##").where((e) => e.isNotEmpty).toList();

    if (images == null || images.isEmpty) {
      GainerDialog.midPopUp(
        GainerImages.noImage,
        'There is no image of this part',
      );
      return;
    }

    Get.toNamed(
      Routes.UPDATEPOIMAGEVIEW,
      arguments: {"images": images},
    );
  }

  //---
  ///ON TAP ACCEPT
  void onAccept(UpdatePoModel order, TextEditingController accCtrl,
      BuildContext context) {
    String qtyController = accCtrl.text;
    if (qtyController.isEmpty || qtyController == '0') {
      GainerBottomSheet.showSnackBar("Please fill Qty greater than 0");
    } else {
      // PoAcceptView.onClickThumbUp(order, size);
      // _onClickThumbUp(order);
    }
  }

  ///FROM ORDERS
  String sellerLocationID = '';
  // String sellerDealerName = '';

  /// Stores accepted orders by unique id (bigId / orderId)
  final RxMap<String, UpdatePoModel> acceptedOrders =
      <String, UpdatePoModel>{}.obs;

  /// Quantity per order
  final RxMap<String, int> acceptedQty = <String, int>{}.obs;

  /// Toggle accept state
  void toggleAccept(UpdatePoModel order, int qty) {
    final key = order.bigId.toString();

    if (acceptedOrders.containsKey(key)) {
      removeAcceptedOrder(key);
    } else {
      acceptedOrders[key] = order; // accept
      acceptedQty[key] = qty;
    }
  }

  void removeAcceptedOrder(String key) {
    if (acceptedOrders.containsKey(key)) {
      acceptedOrders.remove(key); // un-accept
      acceptedQty.remove(key); //removeQty from list
    }
  }

  // void toggleAccept(UpdatePoModel order) {
  //   final key = order.bigId.toString();
  //   if (acceptedOrders.containsKey(key)) {
  //     acceptedOrders.remove(key); // un-accept
  //   } else {
  //     acceptedOrders[key] = order; // accept
  //   }
  // }

  /// Check if order is accepted
  bool isAccepted(UpdatePoModel order) {
    return acceptedOrders.containsKey(order.bigId.toString());
  }

  Object getTableValue() {
    final poTableVal = acceptedOrders.entries.map((entry) {
      final order = entry.value;
      final qty = acceptedQty[entry.key] ?? 0;

      return {
        "bigID": order.bigId.toString(),
        "remarks": poRemarksController.text,
        "poQty": qty.toString(),
        "price": order.price.toString(),
        "freeStock": order.sellerFreeStock.toString(),
      };
    }).toList();
    return poTableVal;

    // return poTableVal
    //     .map((item) => item.values.map((e) => e.toString()).join("|"))
    //     .join(",");
  }

  /// Final submit
  void createPoScreen(BuildContext context) {
    if (acceptedOrders.isEmpty) {
      GainerBottomSheet.showSnackBar("Please accept at least one PO");
      return;
    }

    // final acceptedList = acceptedOrders.values.toList();
    List<Map<String, dynamic>> orderData = acceptedOrders.entries.map((entry) {
      final order = entry.value;
      final qty = acceptedQty[entry.key] ?? 0;

      sellerLocationID = order.sellerLocationId.toString();
      // sellerDealerName = order.dealerName;
      return {
        "PartNo": order.partNumber,
        "Desc": order.partDesc,
        "Seller": '${order.dealerName}\n${order.sellerLocation}',
        "Qty": qty.toString(),
        "Value": order.price * qty,
      };
    }).toList();

    final poTableVal = getTableValue();
    Get.toNamed(Routes.UPDATEPOORDERSUMMARY, arguments: {
      "poTableVal": poTableVal,
      "orderData": orderData,
      "sellerLocationID": sellerLocationID,
      // "sellerDealerName": sellerDealerName,
    });
  }

  // List<Map<String, dynamic>> poTableVal = [];
  RxBool isSubmitting = false.obs;
  Future<void> onSubmitPo(
      String raisePoNumber,
      String raisePoRemarks,
      List<Map<String, dynamic>> tableVal,
      String sellerLocationId,
      double totalPrice,
      // String sellerDealerName,
      int totalQty,
      BuildContext context) async {
    // String userId = await AuthService.getTCode();

    final bdl = await AuthService.getBDLId();
    String brandId = bdl['brandId'].toString();
    String dealerId = bdl['dealerId'].toString();
    String locationId = bdl['locationId'].toString();
    // String dealer = await AuthService.getDealer();
    // String location = await AuthService.getLocation();

    // Update remarks
    for (var item in tableVal) {
      item["remarks"] = raisePoRemarks;
    }

    // bool checkInt = await checkInternet();
    // if (!checkInt) {
    //   Get.toNamed(Routes.NOINTERNETVIEW);
    //   return;
    // }

    // print(
    //   tableVal
    //       .map((item) => item.values.map((value) => value.toString()).join("|"))
    //       .join(","),
    // );
    // return;
    isSubmitting.value = true;
    final response = await GainerApiService().poRaise(
      poNumber: raisePoNumber,
      // userID: userId.toString(),
      userID: tCode,
      brandID: brandId,
      dealerID: dealerId,
      locationID: locationId,
      tableValue: tableVal
          .map((item) => item.values.map((value) => value.toString()).join("|"))
          .join(","),
    );
    isSubmitting.value = false;

    if (response['success']) {
      Get.back();
      _fetchPoDetails();
      acceptedOrders.clear();
      GainerDialog.midPopUp(GainerImages.checkIcon, response['data']);
      // await PushNotification.notifyDealer(
      //   locationID: sellerLocationID,
      //   title: 'Purchase Order (CONFIRMED)',
      //   body:
      //       'Enquiry raised from $location worth $totalPrice Please do Invoice & manifest details on Gainer.',
      //   data: {'moduleRoute': Routes.MANIFESTATIONVIEW},
      // );
    } else {
      GainerBottomSheet.showSnackBar(response['message']);
    }
  }

  ///ON CHANGED ACCEPT QTY FILED
  void onChangedAcctQty(String val, TextEditingController accCtl,
      UpdatePoModel order, BuildContext context) {
    //This remove the accept green color or order from table
    final key = order.bigId.toString();
    removeAcceptedOrder(key);

    // Return early if the input is empty
    if (val.isEmpty) return;

    // Cache the available stock and the controller for easier access
    final int availableStock = order.sellerFreeStock.toInt();
    final int dispatchQty = order.dispatchQty.toInt();
    final controller = accCtl;

    // Prevent the first character from being '0'
    if (val.isNotEmpty && val.startsWith("0")) {
      controller.text = controller.text.replaceFirst('0', '');
    }

    if (val.isNumericOnly) {
      final int enteredQty = int.parse(val);

      // Case 1: entered greater than request qty
      if (enteredQty > dispatchQty) {
        controller.text = dispatchQty.toString();
        GainerBottomSheet.showSnackBar(
          "PO Qty can't be greater than Request Qty $dispatchQty",
        );
        return;
      }

      // Case 2: entered greater than available stock
      if (enteredQty > availableStock) {
        controller.text = availableStock.toString();
        GainerBottomSheet.showSnackBar(
          "PO Qty can't be greater than Free Stock $availableStock",
        );
        return;
      }

      // Case 3: valid input (less than or equal to both)
      // do nothing – user is decreasing manually
    } else {
      // Remove non-numeric input
      if (controller.text.isNotEmpty) {
        controller.text =
            controller.text.substring(0, controller.text.length - 1);
      }
    }
  }

  ///ORDER REJECT SCREEN
  RxBool isRejectLoading = false.obs;

  RxBool isDemandExpired = false.obs;
  RxBool isArrangedFromOtherSource = false.obs;
  RxBool isPoReleasedToOEM = false.obs;
  RxBool isQualityIssues = false.obs;
  RxBool isWithoutPacking = false.obs;
  RxBool isLeadTimeHigh = false.obs;
  RxBool isFreeStockNotAvl = false.obs;
  RxBool isDelayResponse = false.obs;
  RxBool isInsufficientFund = false.obs;
  RxBool isTransportArrangementNotOk = false.obs;
  TextEditingController rejectRemarksCtrl = TextEditingController();

  // List of toggle button labels and their corresponding controller values
  final List<Map<String, dynamic>> toggleButtons = [
    {'text': 'Demand Expired/Customer Refused', 'state': 'isDemandExpired'},
    {
      'text': 'Arranged From Other Source',
      'state': 'isArrangedFromOtherSource'
    },
    {'text': 'PO Released To OEM', 'state': 'isPoReleasedToOEM'},
    {'text': 'Quality Issues at Supplier', 'state': 'isQualityIssues'},
    {'text': 'Without Packing', 'state': 'isWithoutPacking'},
    {'text': 'Lead Time High', 'state': 'isLeadTimeHigh'},
    {'text': 'Free Stock Not Available', 'state': 'isFreeStockNotAvl'},
    {'text': 'Delay Response From Seller', 'state': 'isDelayResponse'},
    {'text': 'Insufficient Fund', 'state': 'isInsufficientFund'},
    {
      'text': 'Transport Arrangement not ok',
      'state': 'isTransportArrangementNotOk'
    },
  ];

  // Method to update states dynamically
  void updateSelection(String selectedState) {
    isDemandExpired.value = selectedState == 'isDemandExpired';
    isArrangedFromOtherSource.value =
        selectedState == 'isArrangedFromOtherSource';
    isPoReleasedToOEM.value = selectedState == 'isPoReleasedToOEM';
    isQualityIssues.value = selectedState == 'isQualityIssues';
    isWithoutPacking.value = selectedState == 'isWithoutPacking';
    isLeadTimeHigh.value = selectedState == 'isLeadTimeHigh';
    isFreeStockNotAvl.value = selectedState == 'isFreeStockNotAvl';
    isDelayResponse.value = selectedState == 'isDelayResponse';
    isInsufficientFund.value = selectedState == 'isInsufficientFund';
    isTransportArrangementNotOk.value =
        selectedState == 'isTransportArrangementNotOk';
  }

  // Getter for accessing the value dynamically
  bool getState(String state) {
    switch (state) {
      case 'isDemandExpired':
        return isDemandExpired.value;
      case 'isArrangedFromOtherSource':
        return isArrangedFromOtherSource.value;
      case 'isPoReleasedToOEM':
        return isPoReleasedToOEM.value;
      case 'isQualityIssues':
        return isQualityIssues.value;
      case 'isWithoutPacking':
        return isWithoutPacking.value;
      case 'isLeadTimeHigh':
        return isLeadTimeHigh.value;
      case 'isFreeStockNotAvl':
        return isFreeStockNotAvl.value;
      case 'isDelayResponse':
        return isDelayResponse.value;
      case 'isInsufficientFund':
        return isInsufficientFund.value;
      case 'isTransportArrangementNotOk':
        return isTransportArrangementNotOk.value;

      default:
        return false;
    }
  }

  // Method to get the selected issue
  String? getSelectedIssue() {
    if (isDemandExpired.value) return 'Demand Expired/Customer Refused';
    if (isArrangedFromOtherSource.value) return 'Arranged From Other Source';
    if (isPoReleasedToOEM.value) return 'PO Released To OEM';
    if (isQualityIssues.value) return 'Quality Issues at Supplier';
    if (isWithoutPacking.value) return 'Without Packing';
    if (isLeadTimeHigh.value) return 'Lead Time High';
    if (isFreeStockNotAvl.value) return 'Free Stock Not Available';
    if (isDelayResponse.value) return 'Delay Response From Seller';
    if (isInsufficientFund.value) return 'Insufficient Fund';
    if (isTransportArrangementNotOk.value) {
      return 'Transport Arrangement not ok';
    }
    return null;
  }

  void toggleSelection(String selectedState) {
    updateSelection(selectedState);
  }

  void onRejectSubmitBtn(BuildContext context, UpdatePoModel order) {
    String? selectedIssue = getSelectedIssue();
    String remarks = rejectRemarksCtrl.text;
    if (selectedIssue == null) {
      GainerBottomSheet.showSnackBar('Please select one issue');
      return;
    }
    GainerDialog.dialogForYesNo(
      text: 'Are you sure to reject Purchased Order',
      imgPath: GainerImages.decisionMaking,
      yesFunction: () async {
        Get.back();
        isRejectLoading.value = true;
        // if (await checkInternet()) {
        final response = await GainerApiService().poReject(
          freeStock: order.sellerFreeStock.toString(),
          rejectReason: selectedIssue,
          remarks: remarks,
          bigID: order.bigId.toString(),
          locationId: locationId,
          tCode: tCode,
        );
        isRejectLoading.value = false;
        if (response['success']) {
          Get.back();
          _fetchPoDetails();
          GainerDialog.midPopUp(GainerImages.rejectIcon, response['data']);

          // String location = await AuthService.getLocation();
          // String dealer = await AuthService.getDealer();
          // await PushNotification.notifyDealer(
          //   locationID: order.sellerLocationId.toString(),
          //   title: 'Purchase Order (REJECTED)',
          //   body:
          //       'Enquiry raised from $location for ${order.partNumber}. for $selectedIssue Please check & update on Gainer.',
          //   data: {'moduleRoute': Routes.ORDERRECEIVED},
          // );
        } else {
          GainerBottomSheet.showSnackBar(response['message']);
        }
        // } else {
        //   Get.toNamed(Routes.NOINTERNETVIEW);
        // }
      },
      noFunction: () {
        Get.back();
      },
    );
  }

  ///FURTHER REMARKS FUNCTIONALITY
  RxBool isFRLoading = false.obs;
  Future<void> onSubmitFurtherDetails(String bigId, String furtherRemarks,
      String sellerLocationID, String partNumber, BuildContext context) async {
    String remarks = furtherRemarks;

    // bool checkInt = await checkInternet();
    // if (checkInt) {
    //   if (await checkInternet()) {
    // final locationId = await AuthService.getLocationId();
    // final tCode = await AuthService.getTCode();
    isFRLoading.value = true;
    final response = await GainerApiService().poFurtherDetails(
      remarks: remarks,
      bigID: bigId,
      locationId: locationId,
      tCode: tCode,
    );
    isFRLoading.value = false;
    if (response['success']) {
      Get.back();
      _fetchPoDetails();
      GainerDialog.midPopUp(GainerImages.checkIcon, response['data']);
      // final location = await AuthService.getLocation();
      // final dealer = await AuthService.getDealer();
      // await PushNotification.notifyDealer(
      //   locationID: sellerLocationID,
      //   title: 'Purchase Order (Further Remarks)',
      //   body:
      //       'Enquiry raised from $location for $partNumber $remarks PO Return for Further remarks, by $dealer $location. PO Return for Further remarks, please Check & update on Gainer.',
      //   data: {'moduleRoute': Routes.ORDERRECEIVED},
      // );

    } else {
      Get.back();
      GainerBottomSheet.showSnackBar(response['message']);
    }
    // } else {
    //   Get.toNamed(Routes.NOINTERNETVIEW);
    // }
    // }
  }

  ///FILTER FUNCTIONALITY
  /// QUICK FILTER
  RxString selectedOrderType = 'All'.obs;

  /// APPLIED FILTERS (affect list)
  RxSet<String> appliedDealers = <String>{}.obs;
  RxSet<String> appliedLocations = <String>{}.obs;
  RxSet<String> appliedPartNos = <String>{}.obs;

  /// TEMP FILTERS (UI only)
  RxSet<String> tempDealers = <String>{}.obs;
  RxSet<String> tempLocations = <String>{}.obs;
  RxSet<String> tempPartNos = <String>{}.obs;
  RxString tempSelectedOrderType = 'All'.obs;

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
    tempSelectedOrderType.value = selectedOrderType.value;

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
    dealers.assignAll(updatePoList.map((e) => e.dealerName).toSet());
  }

  ///Rebuild location name in filter (according to dealer)
  void rebuildLocations() {
    final filtered = updatePoList.where((o) {
      return tempDealers.isEmpty || tempDealers.contains(o.dealerName);
    });

    locations.assignAll(filtered.map((e) => e.sellerLocation).toSet());
  }

  ///Rebuild location name in filter (according to dealer & location)
  void rebuildParts() {
    final filtered = updatePoList.where((o) {
      if (tempDealers.isNotEmpty && !tempDealers.contains(o.dealerName)) {
        return false;
      }

      if (tempLocations.isNotEmpty &&
          !tempLocations.contains(o.sellerLocation)) {
        return false;
      }

      return true;
    });

    partNdDesc.clear();
    for (final o in filtered) {
      partNdDesc[o.partNumber] = o.partDesc;
    }
  }

  ///WHEN CLICK ON APPLY AFTER FILTER
  void applyFilters() {
    appliedDealers.assignAll(tempDealers);
    appliedLocations.assignAll(tempLocations);
    appliedPartNos.assignAll(tempPartNos);
    selectedOrderType.value = tempSelectedOrderType.value;

    filteredList.value = updatePoList.where((order) {
      if (selectedOrderType.value != 'All' &&
          order.orderFor != selectedOrderType.value) {
        return false;
      }

      if (appliedDealers.isNotEmpty &&
          !appliedDealers.contains(order.dealerName)) {
        return false;
      }

      if (appliedLocations.isNotEmpty &&
          !appliedLocations.contains(order.sellerLocation)) {
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
        appliedPartNos.isNotEmpty ||
        selectedOrderType.value != 'All') {
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
    tempSelectedOrderType.value = 'All';
    // isFilterApplied.value = false;
  }

  ///Clear all filter on tap of clear
  void clearAllFilter() {
    selectedOrderType.value = 'All';
    appliedDealers.clear();
    appliedLocations.clear();
    appliedPartNos.clear();
    filteredList.assignAll(updatePoList);
    isFilterApplied.value = false;
  }

/* ///FILTER FUNCTIONALITY
  /// Quick Filter
  RxString selectedOrderType = 'All'.obs;

  /// Multi-select filters
  RxSet<String> selectedDealers = <String>{}.obs;
  RxSet<String> selectedLocations = <String>{}.obs;
  RxSet<String> selectedPartNos = <String>{}.obs;
  RxSet<String> tempDealers = <String>{}.obs;
  RxSet<String> tempLocations = <String>{}.obs;
  RxSet<String> tempPartNos = <String>{}.obs;

  void openFilter() {
    // copy APPLIED → TEMP
    tempDealers = selectedDealers;
    tempLocations = selectedLocations;
    tempPartNos = selectedPartNos;
  }

  void toggleTemp(RxSet<String> set, String value) {
    set.contains(value) ? set.remove(value) : set.add(value);
  }

  void cancelFilter() {
    tempDealers.clear();
    tempLocations.clear();
    tempPartNos.clear();
  }

  ///check is there any filter applied
  final RxBool isFilterApplied = false.obs;

  /// Clear all filters
  void clearAllFilter() {
    selectedOrderType.value = 'All';
    selectedDealers.clear();
    selectedLocations.clear();
    selectedPartNos.clear();

    isFilterApplied.value = false;
    loadOrdersInFilters(updatePoList);
  }

  bool isSelected(Set<String> set, String value) {
    return set.contains(value);
  }

  void toggle(Set<String> set, String value) {
    set.contains(value) ? set.remove(value) : set.add(value);
  }
  // bool isFiltered() {
  //   return selectedDealers.isNotEmpty ||
  //       selectedLocations.isNotEmpty ||
  //       selectedPartNos.isNotEmpty ||
  //       selectedOrderType.value != 'All';
  // }
  //
  // bool get hasActiveFilters {
  //   return selectedDealers.isNotEmpty ||
  //       selectedLocations.isNotEmpty ||
  //       selectedPartNos.isNotEmpty ||
  //       selectedOrderType.value != 'All';
  // }
  //
  // int get activeFilterCount {
  //   return selectedDealers.length +
  //       selectedLocations.length +
  //       selectedPartNos.length +
  //       (selectedOrderType.value != 'All' ? 1 : 0);
  // }

  /// Available filter options (from API)
  final dealers = <String>{}.obs;
  final locations = <String>{}.obs;
  final partNos = <String>{}.obs;
  final RxMap<String, String> partNdDesc = <String, String>{}.obs;
  final RxMap<String, String> tempPartNdDesc = <String, String>{}.obs;

  /// LOAD FROM API RESPONSE
  void loadOrdersInFilters(List<UpdatePoModel> orders) {
    /// Initial filter options (no selection)
    _rebuildDealers();
    _rebuildLocations();
    _rebuildParts();
  }

  ///Toggle dealers and rebuild Dealer -> location, part
  void toggleDealer(String dealer) {
    selectedDealers.contains(dealer)
        ? selectedDealers.remove(dealer)
        : selectedDealers.add(dealer);

    /// Clear dependent selections
    selectedLocations.clear();
    selectedPartNos.clear();

    /// Rebuild options
    _rebuildLocations();
    _rebuildParts();
  }

  ///Toggle Location and rebuild Location -> part
  void toggleLocation(String location) {
    selectedLocations.contains(location)
        ? selectedLocations.remove(location)
        : selectedLocations.add(location);

    /// Clear dependent selection
    selectedPartNos.clear();

    /// Rebuild parts
    _rebuildParts();
  }

  ///Toggle Part
  void togglePart(String partNo) {
    selectedPartNos.contains(partNo)
        ? selectedPartNos.remove(partNo)
        : selectedPartNos.add(partNo);
  }

  void _rebuildDealers() {
    dealers.assignAll(updatePoList.map((e) => e.dealerName).toSet());
  }

  void _rebuildLocations() {
    final filtered = updatePoList.where((o) {
      if (selectedDealers.isNotEmpty &&
          !selectedDealers.contains(o.dealerName)) {
        return false;
      }
      return true;
    });

    locations.assignAll(
      filtered.map((e) => e.sellerLocation).toSet(),
    );
  }

  void _rebuildParts() {
    final filtered = updatePoList.where((o) {
      if (selectedDealers.isNotEmpty &&
          !selectedDealers.contains(o.dealerName)) {
        return false;
      }

      if (selectedLocations.isNotEmpty &&
          !selectedLocations.contains(o.sellerLocation)) {
        return false;
      }

      return true;
    });

    partNdDesc.clear();
    for (final o in filtered) {
      partNdDesc[o.partNumber] = o.partDesc;
    }
  }

  void applyFilters() {
    filteredList.value = updatePoList.where((order) {
      /// Quick filter
      if (selectedOrderType.value != 'All' &&
          order.orderFor != selectedOrderType.value) {
        return false;
      }

      if (selectedDealers.isNotEmpty &&
          !selectedDealers.contains(order.dealerName)) {
        return false;
      }

      if (selectedLocations.isNotEmpty &&
          !selectedLocations.contains(order.sellerLocation)) {
        return false;
      }

      if (selectedPartNos.isNotEmpty &&
          !selectedPartNos.contains(order.partNumber)) {
        return false;
      }

      return true;
    }).toList();

    if (selectedDealers.isNotEmpty ||
        selectedLocations.isNotEmpty ||
        selectedPartNos.isNotEmpty ||
        selectedOrderType.value != 'All') {
      isFilterApplied.value = true;
    }

    regroup();
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
          child: FilterBottomSheet(),
        ),
      ),
      isScrollControlled: true,
    );
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) {
        return SafeArea(
          child: FilterBottomSheet(),
        );
      },
    );
  }

  Future<void> onFilterTap(BuildContext context) async {
    final applied = await openFilterSheet(context);
    if (applied == true) {
      applyFilters();
      update();
    }
  }*/

  Future<bool?> openSortSheet(BuildContext context) {
    return Get.bottomSheet<bool>(
      SafeArea(
        child: Container(
          // height: MediaQuery.of(context).size.height * .75,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: POSortSheet(),
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
          child: POFilterSheet(),
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
}
