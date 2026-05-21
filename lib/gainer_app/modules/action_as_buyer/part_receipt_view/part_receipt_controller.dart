import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gainer/gainer_app/core/constants/gainer_image.dart';
import 'package:gainer/gainer_app/core/widgets/gainer_bottom_sheet.dart';
import 'package:gainer/gainer_app/core/widgets/gainer_dialog.dart';
import 'package:gainer/gainer_app/modules/action_as_buyer/part_receipt_view/raised_concern_view.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import '../../../core/Services/auth_service.dart';
import '../../../core/services/gainer_api_service.dart';
import '../../../core/utils/url_launch_utils.dart';
import 'models/part_receipt_model.dart';
import 'models/part_receipt_part_model.dart';
import 'models/part_receipt_seller_model.dart';
import 'widget/sort_filter/pr_filter_sheet.dart';
import 'widget/sort_filter/pr_sort_sheet.dart';

/// GROUP TYPE ENUM
enum PRGroupType { part, seller }

class PartReceiptController extends GetxController {
  ///When something load
  RxBool isLoading = false.obs;
  RxnString errorMsg = RxnString(null);

  /// SEARCH CONTROLLER
  SearchController searchController = SearchController();

  /// ORIGINAL / FILTERED LIST
  RxList<PartReceiptModel> partReceiptList = <PartReceiptModel>[].obs;
  RxList<PartReceiptModel> filteredList = <PartReceiptModel>[].obs;

  /// CURRENT GROUP TYPE
  Rx<PRGroupType> groupType = PRGroupType.part.obs;

  /// GROUPED DATA LISTS
  RxList<PartReceiptPartModel> partGroups = <PartReceiptPartModel>[].obs;
  RxList<PartReceiptSellerModel> sellerGroups = <PartReceiptSellerModel>[].obs;

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
    await _getLocationIdTcode();
    await fetchPartReceiptDetails();
  }

  Future<void> _getLocationIdTcode() async {
    _locationId.value = await AuthService.getLocationId();
    _tCode.value = await AuthService.getTCode();
  }

  /// ---------------- FETCH API ----------------
  Future<void> fetchPartReceiptDetails() async {
    // final locationId = await AuthService.getLocationId();
    // final tCode = await AuthService.getTCode();

    errorMsg.value = null;
    isLoading.value = true;
    final response = await GainerApiService().getBuyerStages(
      locationId,
      'DISPATCHED',
      tCode,
    );

    isLoading.value = false;

    if (response['success']) {
      List<dynamic> jsonList = jsonDecode(response['data']);

      partReceiptList.assignAll(
        jsonList.map((e) => PartReceiptModel.fromJson(e)),
      );

      clearSearchBar();
      // filteredList.assignAll(partReceiptList);
      // regroup();
    } else {
      errorMsg.value = response['message'];

      partReceiptList.clear();
      filteredList.clear();
      partGroups.clear();
      sellerGroups.clear();
    }
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
      filteredList.assignAll(partReceiptList);
    } else {
      filteredList.assignAll(
        partReceiptList.where((item) {
          return (item.partnumber).toLowerCase().contains(query) ||
              (item.dealerName).toLowerCase().contains(query);
        }).toList(),
      );
    }

    regroup();
  }

  /// CLEAR SEARCH BAR
  void clearSearchBar() {
    searchController.clear();
    searchText.value = '';
    filteredList.assignAll(partReceiptList);
    regroup();
  }

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

  //On Tap Happy To received
  Future<void> onTapReceived(String bigId) async {
    isLoading.value = true;
    final response = await GainerApiService().pendingToBeReceivedV2(
      remarks: '',
      actionType: 'RECEIVED',
      bigID: bigId,
      imageFiles: [],
      locationId: locationId,
      tCode: tCode,
    );
    isLoading.value = false;
    if (response['success'] == true) {
      GainerDialog.midPopUp(GainerImages.checkIcon, '${response['data']}');
      fetchPartReceiptDetails();
    } else {
      GainerBottomSheet.showSnackBar('${response['message']}');
    }
  }

  Future<void> onTapTrackOrder(String lrNo, int companyCode,
      String bufferAction, BuildContext context) async {
    if (companyCode == 1) {
      bufferAction == "Invalid"
          ? await UrlLaunchUtils.openUrl(
              'https://www.shiprocket.in/shipment-tracking/')
          : await UrlLaunchUtils.openUrl(
              'https://www.delhivery.com/track/lr/$lrNo');
    } else if (companyCode == 2) {
      bufferAction == "Invalid"
          ? await UrlLaunchUtils.openUrl(
              'https://www.shiprocket.in/shipment-tracking/')
          : await UrlLaunchUtils.openUrl(
              'https://www.delhivery.com/track/package/$lrNo');
    } else if (companyCode == 4) {
      await UrlLaunchUtils.openUrl(lrNo);
    } else if (companyCode == 5) {
      _copyToClipboard(lrNo);
      await UrlLaunchUtils.openUrl('https://www.bluedart.com/web/guest/home');
    } else {
      GainerBottomSheet.showSnackBar('This LR number can not be track');
    }
  }

  void _copyToClipboard(String lrNo) async {
    // Copy the text to the clipboard
    await Clipboard.setData(ClipboardData(text: lrNo));
  }

  ///Raised Concern Screen
  void onTapRaisedConcern(int bigId) {
    Get.to(() => RaisedConcernView(bigId: bigId));
  }

  final List<String> issueOptions = [
    'Damage',
    'Functional Issue',
    'Wrong Part',
    'Part Received Late',
    'Others'
  ];

  RxBool isLoadingIssue = false.obs;

  var selectedIssue = RxString('');

  RxBool isDamage = false.obs;
  RxBool isFunctionalIssue = false.obs;
  RxBool isWrongPart = false.obs;
  RxBool isPartReceivedLate = false.obs;
  RxBool isOthers = false.obs;
  TextEditingController remarksCtrl = TextEditingController();
  RxList<String?> selectedImageNames = RxList<String?>([null, null, null]);
  static const int maxImages = 3;

  RxList<File?> selectedImages =
      RxList<File?>(List.generate(maxImages, (_) => null));
  Future<void> pickImage(
      int index, ImageSource source, BuildContext context) async {
    Get.back();

    final ImagePicker picker = ImagePicker();
    final XFile? picked = await picker.pickImage(source: source);

    if (picked == null) return;

    final String pickedPath = picked.path;
    final name = basename(picked.path);
    // int emptyIndex = selectedImages.indexWhere((e) => e == null);
    // if (emptyIndex != -1) {
    //   selectedImages[emptyIndex] = File(pickedPath);
    // }

    // Check if image already exists
    final bool alreadySelected = selectedImageNames.any(
      (img) => img != null && img == name,
    );

    if (alreadySelected) {
      GainerBottomSheet.showSnackBar('This image is already selected');
      return;
    }

    // Assign image to slot
    selectedImages[index] = File(pickedPath);
    selectedImageNames[index] = name;
  }

  void removeImage(int index) {
    selectedImages[index] = null;
  }

  void closedRaisedConcern() {
    selectedIssue.value = '';
    remarksCtrl.clear();
    selectedImages.assignAll([null, null, null]);
    selectedImageNames.assignAll([null, null, null]);
  }

  void takeImage(int index, BuildContext context) {
    GainerBottomSheet.show(
      context: context,
      onPressedCamera: () => pickImage(index, ImageSource.camera, context),
      onPressedGallery: () => pickImage(index, ImageSource.gallery, context),
    );
  }

  void toggleIssue(String issue) {
    // Toggle selection
    if (selectedIssue.value == issue) {
      selectedIssue.value = ''; // Deselect if already selected
    } else {
      selectedIssue.value = issue;
    }
  }

  ///onSubmit button for hit API to raised concern
  void onSubmitConcern(int bigId, BuildContext context) {
    List<File> selectedImages = [];
    String remarks = remarksCtrl.text.trim();
    onTapBtn('Are you sure to to receive order\nwith your concern', () async {
      //for store image in key value{"img1:"image_path"}
      Map<String, String> imageMap = {};
      isLoadingIssue.value = true;
      for (int i = 0; i < selectedImages.length; i++) {
        imageMap["img${i + 1}"] = selectedImages[i].path;
      }
      final response = await GainerApiService().pendingToBeReceivedV2(
        remarks: remarks,
        actionType: selectedIssue.toString(),
        bigID: bigId.toString(),
        imageFiles: selectedImages,
        locationId: locationId,
        tCode: tCode,
      );
      isLoadingIssue.value = false;
      if (response['success'] == true) {
        selectedIssue.value = '';
        Get.back();
        GainerDialog.midPopUp(GainerImages.checkIcon, '${response['data']}');
        fetchPartReceiptDetails();
      } else {
        GainerBottomSheet.showSnackBar('${response['message']}');
      }
    });
  }

  ///====GROUPING=====///
  /// CHANGE GROUP TYPE
  void updateGrouping(PRGroupType type) {
    groupType.value = type;
    regroup();
  }

  /// GROUP BY PART NUMBER
  List<PartReceiptPartModel> groupByPart(List<PartReceiptModel> list) {
    final Map<String, List<PartReceiptModel>> map = {};

    for (var item in list) {
      final key = item.partnumber;

      map.putIfAbsent(key, () => []);
      map[key]!.add(item);
    }

    return map.entries.map((e) {
      final items = e.value;
      //sum of Po Qty
      final poQty = items.fold<int>(0, (sum, i) => sum + (i.poQty).toInt());

      /*// // 🔹 Safe totals
      // final totalMrp = items.fold<int>(0, (sum, i) => sum + (i.mrp).toInt());
      //
      // final totalPrice =
      //     items.fold<int>(0, (sum, i) => sum + (i.price).toInt());

      // 🔹 Date handling (safe)
      final DateFormat formatter = DateFormat('MMM d yyyy hh:mma');

      // total quantity
      // final totalQty = items.fold<int>(
      //   0,
      //   (sum, i) => sum + (i.qty),
      // );


      // final validDates = items.where((e) => e.requestdate.isNotEmpty).map((e) {
      //   final cleanedDate =
      //       e.requestdate.replaceAll(RegExp(r'\s+'), ' ').trim();
      //   return formatter.parse(cleanedDate);
      // }).toList();
      //
      // final DateTime highestDate = validDates.isNotEmpty
      //     ? validDates.reduce((a, b) => a.isAfter(b) ? a : b)
      //     : DateTime.now();

      // final String formattedHighestDate =
      //     DateFormat('MMM d yyyy').format(highestDate);*/

      return PartReceiptPartModel(
        partNumber: e.key,
        partDesc: items.first.partdesc,
        poQty: poQty,
        items: items,
      );
    }).toList();
  }

  /// Groups PO items by seller (dealerName + sellerLocation)
// and calculates total MRP & total Price for each seller
  List<PartReceiptSellerModel> groupBySeller(List<PartReceiptModel> list) {
    // Map to group items using a unique key
    // key format: dealerName_location
    final Map<String, List<PartReceiptModel>> map = {};

    // Loop through each PO item
    for (var item in list) {
      // Create a unique key for grouping
      final key = '${item.dealerName}_${item.sellerlocation}';

      // If key doesn't exist, initialize empty list
      map.putIfAbsent(key, () => []);

      // Add item to the respective group
      map[key]!.add(item);
    }

    // Convert grouped map into a list of PartReceiptSellerModel
    return map.entries.map((e) {
      final items = e.value;
      //count of PoQty
      final poQty = items.fold<int>(0, (sum, i) => sum + i.poQty.toInt());

      /*// final totalMrp = items.fold<int>(0, (sum, i) => sum + i.mrp.toInt());
      //
      // final totalPrice = items.fold<int>(0, (sum, i) => sum + i.price.toInt());


      // 🔹 Date handling
      // final DateFormat formatter = DateFormat('MMM d yyyy hh:mma');

      // final DateTime highestDate = items.map((e) {
      //   final cleanedDate =
      //       e.requestdate.replaceAll(RegExp(r'\s+'), ' ').trim();
      //   return formatter.parse(cleanedDate);
      // }).reduce((a, b) => a.isAfter(b) ? a : b);

      // final String formattedHighestDate =
      //     DateFormat('MMM d yyyy').format(highestDate);*/

      return PartReceiptSellerModel(
        sellerName: items.first.dealerName, //after group dealer
        location: items.first.sellerlocation, //after group location
        poQty: poQty,
        items: items,
      );
    }).toList();
  }

  /// REGROUP DATA BASED ON TYPE
  void regroup() {
    if (groupType.value == PRGroupType.part) {
      partGroups.value = groupByPart(filteredList);
    } else {
      sellerGroups.value = groupBySeller(filteredList);
    }
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
    dealers.assignAll(partReceiptList.map((e) => e.dealerName).toSet());
  }

  ///Rebuild location name in filter (according to dealer)
  void rebuildLocations() {
    final filtered = partReceiptList.where((o) {
      return tempDealers.isEmpty || tempDealers.contains(o.dealerName);
    });

    locations.assignAll(filtered.map((e) => e.sellerlocation).toSet());
  }

  ///Rebuild location name in filter (according to dealer & location)
  void rebuildParts() {
    final filtered = partReceiptList.where((o) {
      if (tempDealers.isNotEmpty && !tempDealers.contains(o.dealerName)) {
        return false;
      }

      if (tempLocations.isNotEmpty &&
          !tempLocations.contains(o.sellerlocation)) {
        return false;
      }

      return true;
    });

    partNdDesc.clear();
    for (final o in filtered) {
      partNdDesc[o.partnumber] = o.partdesc;
    }
  }

  ///WHEN CLICK ON APPLY AFTER FILTER
  void applyFilters() {
    appliedDealers.assignAll(tempDealers);
    appliedLocations.assignAll(tempLocations);
    appliedPartNos.assignAll(tempPartNos);
    selectedOrderType.value = tempSelectedOrderType.value;

    filteredList.value = partReceiptList.where((order) {
      if (selectedOrderType.value != 'All' &&
          order.orderfor != selectedOrderType.value) {
        return false;
      }

      if (appliedDealers.isNotEmpty &&
          !appliedDealers.contains(order.dealerName)) {
        return false;
      }

      if (appliedLocations.isNotEmpty &&
          !appliedLocations.contains(order.sellerlocation)) {
        return false;
      }

      if (appliedPartNos.isNotEmpty &&
          !appliedPartNos.contains(order.partnumber)) {
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
  // void clearAllFilter() {
  //   selectedOrderType.value = 'All';
  //   appliedDealers.clear();
  //   appliedLocations.clear();
  //   appliedPartNos.clear();
  //   filteredList.assignAll(updatePoList);
  //   isFilterApplied.value = false;
  // }

  Future<bool?> openSortSheet(BuildContext context) {
    return Get.bottomSheet<bool>(
      SafeArea(
        child: Container(
          // height: MediaQuery.of(context).size.height * .75,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: PRSortSheet(),
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
          child: PRFilterSheet(),
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

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }
}
