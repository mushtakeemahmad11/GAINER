import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import '../../../core/Services/auth_service.dart';
import '../../../core/constants/gainer_image.dart';
import '../../../core/services/gainer_api_service.dart';
import '../../../core/widgets/gainer_bottom_sheet.dart';
import '../../../core/widgets/gainer_dialog.dart';
import 'models/order_received_model.dart';
import 'models/order_received_part_model.dart';
import 'models/order_received_seller_model.dart';
import 'widgets/sort_filter/or_filter_sheet.dart';
import 'widgets/sort_filter/or_sort_sheet.dart';

/// GROUP TYPE ENUM
enum ORGroupType { part, seller }

class OrderReceivedController extends GetxController {
  /// ORIGINAL / FILTERED LIST
  RxList<OrderReceivedModel> orderReceivedList = <OrderReceivedModel>[].obs;
  RxList<OrderReceivedModel> filteredList = <OrderReceivedModel>[].obs;

  /// CURRENT GROUP TYPE
  Rx<ORGroupType> groupType = ORGroupType.part.obs;

  /// GROUPED DATA LISTS
  RxList<OrderReceivedPartModel> partGroups = <OrderReceivedPartModel>[].obs;
  RxList<OrderReceivedSellerModel> sellerGroups =
      <OrderReceivedSellerModel>[].obs;

  /// LOADING STATE
  RxBool isLoading = false.obs;

  /// ERROR / RESPONSE MESSAGES
  RxnString errorMsg = RxnString(null);
  // RxnString odrDltResMsg = RxnString(null);

  /// SEARCH CONTROLLER
  SearchController searchController = SearchController();

  // /// FOR UPDATE PO ORDER SUMMARY SCREEN
  // final formKey = GlobalKey<FormState>();
  // final TextEditingController poNumberController = TextEditingController();
  // final TextEditingController poRemarksController = TextEditingController();

  // /// SEARCH
  // RxString search = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchORDetails();
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
      filteredList.assignAll(orderReceivedList);
    } else {
      filteredList.assignAll(
        orderReceivedList.where((item) {
          return (item.partNumber).toLowerCase().contains(query) ||
              (item.buyerDealer).toLowerCase().contains(query);
        }).toList(),
      );
    }

    regroup();
  }

  /// CLEAR SEARCH BAR
  void clearSearchBar() {
    searchController.clear();
    filteredList.assignAll(orderReceivedList);
    searchText.value = '';
    regroup();
  }

  /// CHANGE GROUP TYPE
  void updateGrouping(ORGroupType type) {
    groupType.value = type;
    regroup();
  }

  /// GROUP BY PART NUMBER
  List<OrderReceivedPartModel> groupByPart(List<OrderReceivedModel> list) {
    final Map<String, List<OrderReceivedModel>> map = {};

    for (var item in list) {
      final key = item.partNumber;

      map.putIfAbsent(key, () => []);
      map[key]!.add(item);
    }

    return map.entries.map((e) {
      final items = e.value;

      // 🔹 Safe totals
      // final totalMrp = items.fold<int>(0, (sum, i) => sum + (i.mrp).toInt());
      //
      // final totalPrice =
      //     items.fold<int>(0, (sum, i) => sum + (i.price).toInt());

      // total quantity
      // final totalQty = items.fold<int>(
      //   0,
      //   (sum, i) => sum + (i.qty),
      // );

      // 🔹 Date handling (safe)
      final DateFormat formatter = DateFormat('MMM d yyyy hh:mma');

      final validDates = items.where((e) => e.requestDate.isNotEmpty).map((e) {
        final cleanedDate =
            e.requestDate.replaceAll(RegExp(r'\s+'), ' ').trim();
        return formatter.parse(cleanedDate);
      }).toList();

      final DateTime minDate = validDates.isNotEmpty
          ? validDates.reduce((a, b) => a.isBefore(b) ? a : b)
          : DateTime.now();

      final String formattedMinDate = DateFormat('MMM d yyyy').format(minDate);

      //total item inside
      final int totalItem = e.value.length;

      return OrderReceivedPartModel(
        partNumber: e.key,
        partDesc: items.first.partDesc,
        minimumDate: formattedMinDate,
        totalItem: totalItem,
        // totalMrp: totalMrp,
        // totalPrice: totalPrice,
        items: items,
      );
    }).toList();
  }

  /// Groups PO items by seller (dealerName + sellerLocation)
// and calculates total MRP & total Price for each seller
  List<OrderReceivedSellerModel> groupBySeller(List<OrderReceivedModel> list) {
    // Map to group items using a unique key
    // key format: dealerName_location
    final Map<String, List<OrderReceivedModel>> map = {};

    // Loop through each OR item
    for (var item in list) {
      // Create a unique key for grouping
      final key = '${item.buyerDealer}_${item.buyerLocation}';

      // If key doesn't exist, initialize empty list
      map.putIfAbsent(key, () => []);

      // Add item to the respective group
      map[key]!.add(item);
    }

    // Convert grouped map into a list of UpdatePoSellerModel
    return map.entries.map((e) {
      final items = e.value;

      // final totalMrp = items.fold<int>(0, (sum, i) => sum + i.mrp.toInt());
      //
      // final totalPrice = items.fold<int>(0, (sum, i) => sum + i.price.toInt());

      // 🔹 Date handling
      final DateFormat formatter = DateFormat('MMM d yyyy hh:mma');

      final DateTime highestDate = items.map((e) {
        final cleanedDate =
            e.requestDate.replaceAll(RegExp(r'\s+'), ' ').trim();
        return formatter.parse(cleanedDate);
      }).reduce((a, b) => a.isBefore(b) ? a : b);

      final String formattedMinimumDate =
          DateFormat('MMM d yyyy').format(highestDate);

      //total item inside
      final int totalItem = e.value.length;
      return OrderReceivedSellerModel(
        sellerName: items.first.buyerDealer, //after group dealer
        location: items.first.buyerLocation, //after group location
        totalItem: totalItem, // Sum of all item inside the seller
        items: items,
        minimumDate: formattedMinimumDate,
      );
    }).toList();
  }

  /// REGROUP DATA BASED ON TYPE
  void regroup() {
    if (groupType.value == ORGroupType.part) {
      partGroups.value = groupByPart(filteredList);
    } else {
      sellerGroups.value = groupBySeller(filteredList);
    }
  }

  /// ---------------- FETCH API ----------------
  Future<void> fetchORDetails() async {
    final locationId = await AuthService.getLocationId();
    final tcode = await AuthService.getTCode();

    // orderReceivedList.clear();
    errorMsg.value = null;
    isLoading.value = true;

    final response = await GainerApiService()
        .getSellerStages(locationId, 'REQUESTSENT', tcode);
    isLoading.value = false;
    if (response['success']) {
      List<dynamic> jsonList = jsonDecode(response['data']);

      orderReceivedList.assignAll(
        jsonList.map((e) => OrderReceivedModel.fromJson(e)),
      );

      filteredList.assignAll(orderReceivedList);

      regroup();
    } else {
      errorMsg.value = response['message'];

      orderReceivedList.clear();
      filteredList.clear();
      partGroups.clear();
      sellerGroups.clear();
    }
  }

  ///FROM ORDERS
  String sellerLocationID = '';

  /// Quantity per order
  final RxMap<String, int> acceptedQty = <String, int>{}.obs;

  ///<------BUTTON FUNCTIONALITY------>///
  ///Action Button
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

  final RxMap<String, List<File>> selectedImages = <String, List<File>>{}.obs;
  RxBool isShowImage = false.obs;
  void toggleImage() {
    isShowImage(!isShowImage.value);
  }

  Future<void> pickImages({
    required String bigId,
    required ImageSource source,
    int maxImages = 3,
  }) async {
    Get.back();

    final ImagePicker picker = ImagePicker();

    selectedImages.putIfAbsent(bigId, () => []);

    final List<File> existingImages = selectedImages[bigId]!;

    final int remaining = maxImages - existingImages.length;

    if (remaining <= 0) {
      GainerBottomSheet.showSnackBar(
        'Maximum limit of image upload is $maxImages',
      );
      return;
    }

    List<XFile> pickedFiles = [];

    /// 📷 Camera → always single image
    if (source == ImageSource.camera) {
      final XFile? file = await picker.pickImage(
        source: ImageSource.camera,
      );
      if (file != null) {
        pickedFiles.add(file);
      }
    }

    /// 🖼️ Gallery → handle remaining count safely
    if (source == ImageSource.gallery) {
      if (remaining == 1) {
        // ✅ MUST use pickImage when only 1 slot left
        final XFile? file = await picker.pickImage(
          source: ImageSource.gallery,
        );
        if (file != null) {
          pickedFiles.add(file);
        }
      } else {
        pickedFiles = await picker.pickMultiImage(
          limit: remaining,
        );
      }
    }

    if (pickedFiles.isEmpty) return;

    /// ✅ Add only non-duplicate images
    for (final XFile xfile in pickedFiles) {
      final String path = xfile.path;

      final bool alreadyExists =
          existingImages.any((file) => file.path == path);

      if (alreadyExists) {
        GainerBottomSheet.showSnackBar(
          'This image is already selected',
        );
        continue;
      }

      existingImages.add(File(path));
    }

    selectedImages.refresh(); // 🔄 GetX UI update
  }

  void uploadImage(OrderReceivedModel order, BuildContext context) {
    int currentCount = selectedImages[order.bigId.toString()]?.length ?? 0;
    if (currentCount >= 3) {
      GainerBottomSheet.showSnackBar('Maximum limit of image upload is 3');
      return;
    }
    GainerBottomSheet.show(
      context: context,
      onPressedCamera: () => pickImages(
        bigId: order.bigId.toString(),
        source: ImageSource.camera,
      ),
      onPressedGallery: () => pickImages(
        bigId: order.bigId.toString(),
        source: ImageSource.gallery,
      ),
    );
  }

  void removeImageTest(String bigId, int index) {
    final images = selectedImages[bigId];

    if (images == null) return;

    images.removeAt(index);

    if (images.isEmpty) {
      selectedImages.remove(bigId);
    }

    selectedImages.refresh();
  }

  ///Accept Order Button
  static const int maxImages = 3;
  void onTapAccept(
    TextEditingController remCtl,
    OrderReceivedModel order,
    TextEditingController reqCtrl,
    BuildContext context,
  ) {
    final List<File> imageFiles =
        List<File>.from(selectedImages[order.bigId.toString()] ?? []);
    final String remarks = remCtl.text.trim();
    final String reqQtyText = reqCtrl.text.trim();
    final int reqQty = int.tryParse(reqQtyText) ?? 0;

    if (reqQty <= 0) {
      GainerBottomSheet.showSnackBar("Please enter Qty greater than 0");
      return;
    }
    onTapBtn('Are you sure to accept this order?', () async {
      // final String dealer = await AuthService.getDealer();
      // final String location = await AuthService.getLocation();
      final String locationId = await AuthService.getLocationId();
      final String userID = await AuthService.getTCode();

      try {
        isLoading.value = true;

        final response = await GainerApiService().orderDueAcceptV2(
          bigID: order.bigId.toString(),
          remarks: remarks,
          confirmQty: reqQty.toString(),
          freeStock: order.sellerFreeStock.toString(),
          transporterType: "SCOPE",
          loginUserID: userID.toString(),
          imageFiles: imageFiles,
          locationId: locationId,
        );

        if (response['success'] != true) {
          GainerBottomSheet.showSnackBar(response['message'].toString());
          return;
        }

        // remarksControllers.clear();
        await fetchORDetails();
        GainerDialog.midPopUp(
            GainerImages.agreement, response['data'].toString());

        /// Send notification to buyer
        // await PushNotification.notifyDealer(
        //   locationID: order.buyerLocationId.toString(),
        //   title: 'ORDER CONFIRMATION',
        //   body:
        //       'Enquiry raised from $location for ${order.partNumber} ($reqQty Qty) is ACCEPTED by $dealer $location. Please raise Final PO in ${order.buyerLocation} & update on Gainer.',
        //   data: {'moduleRoute': Routes.UPDATEPO},
        // );

        // FocusScope.of(context).unfocus();
        // await _orderReceivedController.orderReceivedAsSeller(
        //     locationID, 'REQUESTSENT');

        // _initWork();
      } catch (e) {
        GainerBottomSheet.showSnackBar(
            "Something went wrong. Please try again.");
      } finally {
        isLoading.value = false;
      }
    });
  }

  ///ORDER REJECT SCREEN
  RxBool isRejectLoading = false.obs;

  // List of toggle button labels and their corresponding controller values
  final List<Map<String, dynamic>> toggleButtons = [
    {'text': 'Physically Not Found', 'state': 'isPhysicallyNotFound'},
    {'text': 'Part Damaged', 'state': 'isPartDamaged'},
    {'text': 'Reserved For Vehicle', 'state': 'isReservedForVehicle'},
    {'text': 'Need For Stock', 'state': 'isNeedForStock'},
    {'text': 'High Logistics Cost', 'state': 'isHighLogisticsCost'},
    {'text': 'Fragile Part', 'state': 'isFragilePart'},
    {'text': 'Non Moving Part', 'state': 'isNonMovingPart'},
    {'text': 'Part Not In Stock', 'state': 'isPartNotInStock'},
    {'text': 'Current Stock Is Less', 'state': 'isCurrentStockIsLess'},
  ];

  var selectedIssue = RxString('');

  bool isSelected(String reason) {
    return selectedIssue.value == reason;
  }

  // void resetSelection() {
  //   selectedIssue.value = '';
  // }

  void toggleIssue(String issue) {
    // Toggle selection
    if (selectedIssue.value == issue) {
      selectedIssue.value = ''; // Deselect if already selected
    } else {
      selectedIssue.value = issue;
    }
  }

  TextEditingController rejectRemarksCtrl = TextEditingController();

  void closedRejectOrder() {
    selectedIssue.value = '';
    rejectRemarksCtrl.clear();
  }
  // void toggleSelection(String selectedState) {
  //   updateSelection(selectedState);
  // }

  onRejectSubmitBtn(BuildContext context, OrderReceivedModel order) {
    String issue = selectedIssue.value;
    if (issue.isEmpty) {
      GainerBottomSheet.showSnackBar('Please select one issue');
      return;
    }
    onTapBtn('Are you sure to reject Order Received', () async {
      String remarks = rejectRemarksCtrl.text.trim();
      String tCode = await AuthService.getTCode();
      String sellerLocationId = await AuthService.getLocationId();
      // String sellerLocation = await AuthService.getLocation();
      // String dealer = await AuthService.getDealer();
      isRejectLoading.value = true;
      final response = await GainerApiService().orderDueReject(
        remarks: remarks,
        rejectReason: issue,
        bigID: order.bigId.toString(),
        freeStock: order.sellerFreeStock.toString(),
        partNumber: order.partNumber,
        stockCatType: order.stockCatType,
        sellerLocationID: sellerLocationId,
        loginUserID: tCode,
      );
      isRejectLoading.value = false;
      if (response['success'] == true) {
        Get.back();
        await fetchORDetails();
        GainerDialog.midPopUp(GainerImages.checkIcon, '${response['data']}');
        // ORDER REQUEST (REJECTED)
        // Enquiry raised from Location for PartNumber (3 Qty) is REJECTED by Dealer_Location. Pl check part on Gainer & place enquiry to another Co-Dealer.

        // await PushNotification.notifyDealer(
        //   locationID: order.buyerLocationId.toString(),
        //   title: 'ORDER REQUEST (REJECTED)',
        //   body:
        //       'Enquiry raised from $sellerLocation for ${order.partNumber} (${order.qty} Qty) is REJECTED by $dealer/$sellerLocation. Please check part on Gainer & place enquiry to another Co-Dealer',
        //   data: {'moduleRoute': Routes.PARTREQUESTVIEW},
        // );
      } else {
        GainerBottomSheet.showSnackBar('${response['message']}');
      }
    });
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
    dealers.assignAll(orderReceivedList.map((e) => e.buyerDealer).toSet());
  }

  ///Rebuild location name in filter (according to dealer)
  void rebuildLocations() {
    final filtered = orderReceivedList.where((o) {
      return tempDealers.isEmpty || tempDealers.contains(o.buyerDealer);
    });

    locations.assignAll(filtered.map((e) => e.buyerLocation).toSet());
  }

  ///Rebuild location name in filter (according to dealer & location)
  void rebuildParts() {
    final filtered = orderReceivedList.where((o) {
      if (tempDealers.isNotEmpty && !tempDealers.contains(o.buyerDealer)) {
        return false;
      }

      if (tempLocations.isNotEmpty &&
          !tempLocations.contains(o.buyerLocation)) {
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

    filteredList.value = orderReceivedList.where((order) {
      if (selectedOrderType.value != 'All' &&
          order.orderFor != selectedOrderType.value) {
        return false;
      }

      if (appliedDealers.isNotEmpty &&
          !appliedDealers.contains(order.buyerDealer)) {
        return false;
      }

      if (appliedLocations.isNotEmpty &&
          !appliedLocations.contains(order.buyerLocation)) {
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
  }

  ///Clear all filter on tap of clear
  void clearAllFilter() {
    selectedOrderType.value = 'All';
    appliedDealers.clear();
    appliedLocations.clear();
    appliedPartNos.clear();
    filteredList.assignAll(orderReceivedList);
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
          child: ORSortSheet(),
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
          child: ORFilterSheet(),
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
