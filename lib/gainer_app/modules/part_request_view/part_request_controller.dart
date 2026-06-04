import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:gainer/gainer_app/core/constants/gainer_image.dart';
import 'package:gainer/gainer_app/core/widgets/gainer_bottom_sheet.dart';
import 'package:gainer/gainer_app/core/widgets/gainer_dialog.dart';
import 'package:get/get.dart';
import '../../core/Services/auth_service.dart';
import '../../core/services/gainer_api_service.dart';
import 'model/part_request_model.dart';
import 'model/part_request_part_model.dart';
import 'widgets/tat_disc/tat_disc_sheet.dart';

class PartRequestController extends GetxController {
  /// ORIGINAL / FILTERED LIST
  RxList<PartRequestModel> partRequestList = <PartRequestModel>[].obs;
  RxList<PartRequestModel> filteredList = <PartRequestModel>[].obs;
  RxList<PartRequestPartModel> partGroups = <PartRequestPartModel>[].obs;

  ///SORT TYPE(TAT,DISC)
  RxBool isSortDisc = true.obs;

  /// LOADING STATE
  RxBool isLoading = false.obs;

  RxBool isFromDealer = false.obs;
  RxBool isFromDealerDirect = false.obs;

  /// ERROR / RESPONSE MESSAGES
  RxnString errorMsg = RxnString(null);
  RxnString partNo = RxnString(null);

  /// SEARCH CONTROLLER
  SearchController searchController = SearchController();
  SearchController partSearchController = SearchController();

  ///search filed text
  final RxString searchText = ''.obs;
  final RxString partSearchText = ''.obs;

  ///BDL from local storage
  String brandId = '';
  String dealerId = '';
  String locationId = '';

  @override
  void onInit() {
    super.onInit();
    initWorkPartReq();
  }

  void initWorkPartReq() {
    isFromDealerDirect.value = false;
    final Map<String, dynamic> args =
        (Get.arguments as Map<String, dynamic>?) ?? {};
    partNo.value = args['part'] ?? '';
    isFromDealer.value = args['isDealer'] ?? false;
    partSearchController.text = partNo.value ?? '';
    partSearchText.value = partNo.value ?? '';
    showAvailability(partNo.value!);
  }

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
      filteredList.assignAll(partRequestList);
    } else {
      filteredList.assignAll(
        partRequestList.where((item) {
          return (item.sellerDealer).toLowerCase().contains(query) ||
              (item.sellerLocation).toLowerCase().contains(query);
        }).toList(),
      );
    }
    regroup();
  }

  /// CLEAR SEARCH BAR
  void clearSearchBar() {
    searchController.clear();
    searchText.value = '';
    filteredList.assignAll(partRequestList);
    regroup();
    // filteredList.assignAll(orderReceivedList);
  }

  String getCurrentQuery(String text) {
    final parts = text.split(',');
    return parts.last.trim();
  }

  String cleanSearchText(String text) {
    return text
        .split(',')
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .join(',');
  }

  Timer? _debounce;
  Future<void> onSearchChanged(String text) async {
    errorMsg.value = null;
    if (_debounce?.isActive ?? false) _debounce!.cancel();

    _debounce = Timer(const Duration(milliseconds: 400), () async {
      if (text.isEmpty) {
        partSuggestions.clear();
        return;
      }

      final query = getCurrentQuery(text);

      if (query == partSearchText.value) return;

      partSearchText.value = query;

      await fetchPartSuggestions(query);
    });
  }
  // Future<void> onSearchChanged(String text) async {
  //   errorMsg.value = null;
  //
  //   if (text.isEmpty) return;
  //
  //   // prevent duplicate API calls
  //   if (text == partSearchText.value) return;
  //
  //   partSearchText.value = text;
  //
  //   await fetchPartSuggestions(text);
  // }

  // void onPartSearch() {
  //   showAvailability(partSearchText.value);
  // }

  void onPartSearch() {
    errorMsg.value = null;
    partSuggestions.clear();

    final rawText = partSearchController.text.trim();
    if (rawText.isEmpty) return;

    final cleanedQuery = cleanSearchText(rawText);

    showAvailability(cleanedQuery);
  }

  RxBool partSearchLoading = false.obs;
  var partSuggestions = <String>[].obs;
  // Function to handle part number selection
  // void selectPartNumber(String partNumber) {
  //   partSearchController.text = partNumber;
  //   partSuggestions.clear();
  // }

  void selectPartNumber(String selectedPart) {
    final currentText = partSearchController.text;

    final parts = currentText.split(',');

    // Remove the last incomplete part
    parts.removeLast();

    String newText;

    if (parts.isEmpty) {
      newText = '$selectedPart, ';
    } else {
      newText = '${parts.join(',').trim()}, $selectedPart, ';
    }

    partSearchController.value = TextEditingValue(
      text: newText,
      selection: TextSelection.collapsed(offset: newText.length),
    );

    partSuggestions.clear();
  }

  // API Call to fetch matching part numbers
  Future<void> fetchPartSuggestions(String query) async {
    if (query.length < 5) {
      partSuggestions.clear();
      return;
    } else if (query.isNotEmpty) {
      partSearchLoading.value = true;
      final response = await GainerApiService().searchPart(query);
      partSearchLoading.value = false;
      if (response['success']) {
        partSuggestions.value = response['data'];
      } else {
        partSuggestions.clear();
      }
    }
  }

  Future<void> showAvailability(String searchingPart) async {
    if (searchingPart.isEmpty) return;

    partSuggestions.clear();
    // partSuggestions.clear();
    // FocusScope.of(context).unfocus(); // Hide keyboard

    final bdl = await AuthService.getBDLId();
    final tCode = await AuthService.getTCode();
    brandId = bdl['brandId'].toString();
    dealerId = bdl['dealerId'].toString();
    locationId = bdl['locationId'].toString();
    // String? orderFor = selectedValue1.value ?? '';
    //
    // String lspCode = '1';
    // String tat = '';
    // String clusterCode =
    //     _selectedValue3 != null ? clusterData[_selectedValue3].toString() : '';
    //
    // List<String> partNumber =
    //     tableData.map((item) => item['Part No.'] as String).toList();
    // List<String> stockCategory = [
    //   if (isSelected[0]) 'N',
    //   if (isSelected[1]) 'S',
    //   if (isSelected[2]) 'M',
    // ];
    // String withinGroup = isMyGroup ? '' : '';
    // if (orderFor.isEmpty) {
    //   GainerBottomSheet.showSnackBar('Please select order for');
    //   return;
    // }

    // if (partNumber.isEmpty) {
    //   GainerBottomSheet.showSnackBar('Please add some part in the table');
    // }
    // if (searchingPart == null) {
    //   return GainerBottomSheet.showSnackBar('Please enter part for search');
    // }
    isLoading.value = true;
    final response = await GainerApiService().showPartAvailability(brandId,
        dealerId, locationId, '', '1', '', '', searchingPart, '', '', tCode);
    isLoading.value = false;
    if (response['success']) {
      partNo.value = searchingPart;
      List<dynamic> jsonList = jsonDecode(response['data']);
      // use of model data
      partRequestList.value =
          jsonList.map((json) => PartRequestModel.fromJson(json)).toList();
      filteredList.assignAll(partRequestList);
      regroup();
    } else {
      partNo.value = null;
      errorMsg.value = response['message'];
    }
  }

  /// GROUP BY PART NUMBER
  List<PartRequestPartModel> groupByPart(
    List<PartRequestModel> list,
  ) {
    final Map<String, List<PartRequestModel>> grouped = {};

    // Group items
    for (final item in list) {
      (grouped[item.partNumber] ??= []).add(item);
    }

    // Build result
    return grouped.entries.map((entry) {
      final items = entry.value;

      // Sort by discount (DESC, TAT)
      if (isSortDisc.value) {
        // High discount first
        items.sort((a, b) => b.discount.compareTo(a.discount));
      } else {
        // Low TAT first
        items.sort((a, b) => a.tat.compareTo(b.tat));
      }
      // items.sort((a, b) => (b.discount).compareTo(a.discount));

      final first = items.first;

      return PartRequestPartModel(
        partNumber: entry.key,
        partDesc: first.description,
        mrp: first.mrp.toInt(),
        items: items,
      );
    }).toList();
  }

  ///Group Data Part Wise
  void regroup() {
    partGroups.value = groupByPart(filteredList);
  }

  bool get hasAnyQty => filteredList.any((e) => e.hasQty);

  /// 🔥 Submit only items with qty entered
  // SellerLocationList
  List<Map<String, dynamic>> sellerLocationList = [];
  void submitRequest() {
    sellerLocationList = [];
    List<Map<String, dynamic>> orderData = [];
    // final submitList = partRequestList
    //     .where((o) => o.hasQty)
    //     .map((o) => {
    //           "partNumber": o.partNumber,
    //           "qty": o.requestedQty,
    //           "remarks": o.remarkCtl.text.trim(),
    //         })
    //     .toList();

    orderData = partRequestList.where((order) => order.hasQty).map((o) {
      //data for send in notification
      sellerLocationList.add({
        'loc': o.sellerLocation,
        'locId': o.sellerLocationID.toString(),
        'price': o.price,
        'qty': o.requestedQty,
        'parts': o.partNumber,
      });
      return {
        "partNumber": o.partNumber.toString(),
        "ClusterCode": o.clusterCode.toString(),
        "sellerDealerId": o.sellerDealerID.toString(),
        "sellerLocationId": o.sellerLocationID.toString(),
        "sellerStockQty": o.sellerStock.toString(),
        "sellerFreeStocky": o.freeStock.toString(),
        "discount": o.discount.toString(),
        "tat": o.tat.toString(),
        "sellerVerified": o.dealerVerified.toString(),
        "scsVerified": o.scsVerified.toString(),
        "orderQty": o.requestedQty,
        "remarks": o.remarkCtl.text.trim(),
        "price": o.price.toString(),
        "mrp": o.mrp.toString(),
        "rate": o.rate.toString(),
        "stockCat": o.stockCat.toString(),
      };
    }).toList();

    if (orderData.isEmpty) {
      GainerBottomSheet.showSnackBar(
          'Please enter a quantity for at least one part.');
      return;
    }

    /// 🚀 API CALL
    apiSubmit(orderData);
  }

  Future<void> apiSubmit(List<Map<String, dynamic>> payload) async {
    // print("payload: $payload");
    // return;
    String tCode = await AuthService.getTCode();

    // var userID = await getIntData('tCode');
    // String? orderFor = _partRequestController.selectedValue1.value ?? '';
    // String lspCode = '';

    String tableVal = payload
        .map((item) => item.values.map((value) => value.toString()).join("|"))
        .join(",");

    if (tableVal.isEmpty) {
      GainerBottomSheet.showSnackBar('Please fill qty in Request Qty');
      return;
    }
    // bool checkInt = await checkInternet();
    // if (!checkInt) {
    //   Get.toNamed(Routes.NOINTERNETVIEW);
    //   return;
    // }

    isLoading.value = true;
    var response = await GainerApiService().orderReqSubmit(
        brandId, dealerId, locationId, tCode, 'Vehicle', '', tableVal);
    isLoading.value = false;
    if (response['success']) {
      Get.back();
      GainerDialog.midPopUp(GainerImages.checkIcon, response['data']);

      // for (var loc in sellerLocationList) {
      //   String buyerLocation = await AuthService.getLocation();
      //   await PushNotification.notifyDealer(
      //     locationID: loc['locId'],
      //     title: 'ORDER ENQUIRY',
      //     body:
      //         'Enquiry Received at ${loc['loc']} for Parts: ${loc['parts']} worth Rs: ${loc['price'] * loc['qty']}/- from $buyerLocation. Pl check & accept order via Gainer APP',
      //     data: {'moduleRoute': Routes.ORDERRECEIVED, 'LocationId': loc['locId']},
      //   );
      // }
      // for (var i in payload) {
      //   String sellerLocationID = i['sellerLocationId'];
      //   String sellerLocation = 'locationnnnnn';z
      //   // String sellerLocation = i['sellerLocation'];
      //   // String partNum = i['partNumber'];
      //   // String dealerName = await AuthService.getDealer();
      //   String buyerLocation = await AuthService.getLocation();
      //   int worth = double.tryParse(i['price'])?.toInt() ?? 0;
      //   int qty = int.tryParse(i['orderQty']?.toString() ?? '0') ?? 0;
      //   await PushNotification.notifyDealer(
      //     locationID: sellerLocationID,
      //     title: 'ORDER ENQUIRY',
      //     body:
      //         'Enquiry Received at $sellerLocation for Parts worth Rs: ${worth * qty}/- from Buyer – $buyerLocation. Pl check & accept order via Gainer APP',
      //     data: {'moduleRoute': Routes.ORDERRECEIVED},
      //   );
      //   // await SendNotification.notifyDealerUsers(
      //   //     sellerLocationID,
      //   //     "Order Request (RECEIVED)",
      //   //     "Part: $partNum\n"
      //   //         "Buyer: $dealerName, $locationName\n"
      //   //         "Pl check & CONFIRM order",
      //   //     {"app": "gainer", "Screen": "orderReceived"});
      // }
    } else {
      GainerBottomSheet.showSnackBar(response['message']);
    }
  }

  /// TAT Discount Sheet
  void toggleSort() {
    isSortDisc.toggle();
    regroup();
    Get.back();
  }

  Future<bool?> openTatDiscSheet(BuildContext context) {
    return Get.bottomSheet<bool>(
      SafeArea(
        child: Container(
          // height: MediaQuery.of(context).size.height * .75,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: TatDiscSheet(),
        ),
      ),
      isScrollControlled: true,
    );
  }

  @override
  void onClose() {
    for (final o in partRequestList) {
      o.dispose();
    }
    searchController.dispose();
    partSearchController.dispose();
    super.onClose();
  }
}
