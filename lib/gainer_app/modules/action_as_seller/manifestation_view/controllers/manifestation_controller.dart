import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../../core/Services/auth_service.dart';
import '../../../../core/services/gainer_api_service.dart';
import '../../../../core/widgets/gainer_bottom_sheet.dart';
import '../../../../routes/app_routes.dart';
import '../models/manifestation_check_box_order_model.dart';
import '../models/manifestation_model.dart';
import '../models/manifestation_part_model.dart';
import '../models/manifestation_seller_model.dart';
import '../widgets/sort_filter/m_filter_sheet.dart';
import '../widgets/sort_filter/m_sort_sheet.dart';

/// GROUP TYPE ENUM
enum MGroupType { part, seller }

class ManifestationController extends GetxController {
  /// ORIGINAL / FILTERED LIST
  RxList<ManifestationModel> manifestationList = <ManifestationModel>[].obs;
  RxList<ManifestationModel> filteredList = <ManifestationModel>[].obs;

  /// CURRENT GROUP TYPE
  Rx<MGroupType> groupType = MGroupType.part.obs;

  /// GROUPED DATA LISTS
  RxList<ManifestationPartModel> partGroups = <ManifestationPartModel>[].obs;
  RxList<ManifestationSellerModel> sellerGroups =
      <ManifestationSellerModel>[].obs;

  /// LOADING STATE
  RxBool isLoading = false.obs;

  /// ERROR / RESPONSE MESSAGES
  RxnString errorMsg = RxnString(null);
  // RxnString odrDltResMsg = RxnString(null);

  /// SEARCH CONTROLLER
  SearchController searchController = SearchController();

  /// Map to track the switch state for each partNumber
  final RxMap<String, bool> checkBoxStates = <String, bool>{}.obs;

  /// SEARCH
  RxString search = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchMDetails();
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
      filteredList.assignAll(manifestationList);
    } else {
      filteredList.assignAll(
        manifestationList.where((item) {
          return (item.partNumber ?? '').toLowerCase().contains(query) ||
              (item.buyerDealer ?? '').toLowerCase().contains(query);
        }).toList(),
      );
    }

    regroup();
  }

  /// CLEAR SEARCH BAR
  void clearSearchBar() {
    searchController.clear();
    filteredList.assignAll(manifestationList);
    searchText.value = '';
    regroup();
  }

  /// CHANGE GROUP TYPE
  void updateGrouping(MGroupType type) {
    groupType.value = type;
    regroup();
  }

  /// GROUP BY PART NUMBER
  List<ManifestationPartModel> groupByPart(List<ManifestationModel> list) {
    final Map<String, List<ManifestationModel>> map = {};

    for (var item in list) {
      final key = item.partNumber;

      map.putIfAbsent(key!, () => []);
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

      final validDates = items
          .where((e) =>
              e.sellerResponseDate != null && e.sellerResponseDate!.isNotEmpty)
          .map((e) {
        // final cleanedDate =
        //     e.sellerResponseDate ?? ''.replaceAll(RegExp(r'\s+'), ' ').trim();
        final cleanedDate =
            e.sellerResponseDate!.replaceAll(RegExp(r'\s+'), ' ').trim();

        return formatter.parse(cleanedDate);
      }).toList();

      final DateTime minDate = validDates.isNotEmpty
          ? validDates.reduce((a, b) => a.isBefore(b) ? a : b)
          : DateTime.now();

      final String formattedMinDate = DateFormat('MMM d yyyy').format(minDate);

      //total item inside
      final int totalItem = e.value.length;

      return ManifestationPartModel(
        partNumber: e.key,
        partDesc: items.first.partDesc ?? '',
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
  List<ManifestationSellerModel> groupBySeller(List<ManifestationModel> list) {
    // Map to group items using a unique key
    // key format: dealerName_location
    final Map<String, List<ManifestationModel>> map = {};

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
            e.sellerResponseDate!.replaceAll(RegExp(r'\s+'), ' ').trim();
        return formatter.parse(cleanedDate);
      }).reduce((a, b) => a.isBefore(b) ? a : b);

      final String formattedMinimumDate =
          DateFormat('MMM d yyyy').format(highestDate);

      //total item inside
      final int totalItem = e.value.length;
      return ManifestationSellerModel(
        sellerName: items.first.buyerDealer ?? '', //after group dealer
        location: items.first.buyerLocation ?? '', //after group location
        totalItem: totalItem, // Sum of all item inside the seller
        items: items,
        minimumDate: formattedMinimumDate,
      );
    }).toList();
  }

  /// REGROUP DATA BASED ON TYPE
  void regroup() {
    if (groupType.value == MGroupType.part) {
      partGroups.value = groupByPart(filteredList);
    } else {
      sellerGroups.value = groupBySeller(filteredList);
    }
  }

  /// ---------------- FETCH API ----------------
  Future<void> fetchMDetails() async {
    final locationId = await AuthService.getLocationId();
    final tCode = await AuthService.getTCode();

    errorMsg.value = null;
    checkBoxStates.clear();
    isLoading.value = true;

    final response =
        await GainerApiService().getSellerStages(locationId, 'RESPONSECONFIRM',tCode);
    isLoading.value = false;
    if (response['success']) {
      List<dynamic> jsonList = jsonDecode(response['data']);

      manifestationList.assignAll(
        jsonList.map((e) => ManifestationModel.fromJson(e)),
      );

      filteredList.assignAll(manifestationList);
      regroup();
    } else {
      errorMsg.value = response['message'];

      manifestationList.clear();
      filteredList.clear();
      partGroups.clear();
      sellerGroups.clear();
    }
  }

  final RxList<CheckBoxOrderModel> orders = <CheckBoxOrderModel>[].obs;

  List<ManifestationModel> get selectedOrders {
    return filteredList
        .where((o) => checkBoxStates[o.bigId.toString()] == true)
        .toList();
  }

  String? activeLocationId;
  String? activeLocationName;

  void toggleCheckBox({
    required String orderId,
    required String locationId,
    required String locationName,
  }) {
    final bool isSelected = checkBoxStates[orderId] ?? false;
    // 🟢 TURN ON
    if (!isSelected) {
      if (activeLocationId == null || activeLocationId == locationId) {
        checkBoxStates[orderId] = true;
        activeLocationId = locationId;
        activeLocationName = locationName;
      } else {
        GainerBottomSheet.showSnackBar(
          // "You may select orders only for the same location.\n"
          "Only same location orders can be selected.\n"
          "Already selected: $activeLocationName",
        );
        // GainerBottomSheet.showSnackBar(
        //   "You can select orders from only one location.\n"
        //   "Already selected: $activeLocationName",
        // );
      }
      return;
    }

    // TURN OFF
    checkBoxStates[orderId] = false;

    // If nothing is selected → reset location lock
    if (!checkBoxStates.values.any((v) => v)) {
      activeLocationId = null;
      activeLocationName = null;
    }
  }

  ///GOTO MANIFESTATION CREATE SCREEN
  final RxList<Map<String, dynamic>> orderData = <Map<String, dynamic>>[].obs;
  // var manifestationBigIds = [].obs;
  // RxnString manifestationBuyerLocationID = RxnString(null);
  // RxnBool manifestationIsWeFast = RxnBool(null);
  final RxList<int> manifestationBigIds = <int>[].obs;
  final RxnString manifestationBuyerLocationID = RxnString();
  final RxBool manifestationIsWeFast = false.obs;
  void proceedToManifestation(BuildContext context) {
    if (selectedOrders.isEmpty) {
      GainerBottomSheet.showSnackBar("Please accept at least one PO");
      return;
    }

    // orderData.value = [];
    manifestationBigIds.value = [];
    orderData.value = selectedOrders.map((order) {
      // final order = entry.value;
      // final qty = acceptedQty[entry.key] ?? 0;

      // sellerLocationID = order.sellerLocationId.toString();
      // sellerDealerName = order.dealerName;
      manifestationBuyerLocationID.value = order.buyerLocationId.toString();
      String? sellerClusters = order.sellerClusters.toString();
      String? buyerClusters = order.buyerClusters.toString();
      manifestationIsWeFast.value =
          _checkIsWeFast(sellerClusters, buyerClusters);
      manifestationBigIds.add(order.bigId ?? 0);
      return {
        "PartNo": order.partNumber,
        "Desc": order.partDesc,
        "PoNum": order.poNumber,
        "Buyer": '${order.buyerDealer}\n${order.buyerLocation}',
        "Qty": order.poQty.toString(),
        "Value": order.price! * order.poQty!,
      };
    }).toList();
    // final poTableVal = getTableValue();
    Get.toNamed(Routes.MANIFESTATIONSUMMARY, arguments: {
      "orderData": orderData,
    });
  }

  // check is we fast or not
  bool _checkIsWeFast(String sellerClusters, String buyerClusters) {
    // Convert strings to sets of values
    Set<String> set1 = sellerClusters.split(',').toSet();
    Set<String> set2 = buyerClusters.split(',').toSet();

    // Find intersection (common values)
    Set<String> commonValues = set1.intersection(set2);
    return commonValues.isNotEmpty ? true : false;
  }

  ///CALCULATE FREIGHT COST SCREEN FUNCTIONALITY
  /*//══════════════════════════════════════════════════════════════════════//
  // FORM KEYS
  //══════════════════════════════════════════════════════════════════════//
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final GlobalKey<FormState> submitFormKey = GlobalKey<FormState>();

  //══════════════════════════════════════════════════════════════════════//
  // LOADING STATES
  //══════════════════════════════════════════════════════════════════════//
  RxBool isLoadingFC = false.obs;
  RxBool isLoadingCFCSubmit = false.obs;

  //══════════════════════════════════════════════════════════════════════//
  // COUNTS
  //══════════════════════════════════════════════════════════════════════//
  RxInt invoiceCount = 0.obs;
  RxInt boxCount = 0.obs;

  //══════════════════════════════════════════════════════════════════════//
  // TEXT CONTROLLERS
  //══════════════════════════════════════════════════════════════════════//
  TextEditingController invoiceCountController = TextEditingController();
  TextEditingController boxCountController = TextEditingController();
  TextEditingController distanceController = TextEditingController();
  TextEditingController remarksController = TextEditingController();
  // for when select own arrangement for courier
  TextEditingController lrController = TextEditingController();
  TextEditingController transportNameController = TextEditingController();
  TextEditingController contactPersonNameController = TextEditingController();
  TextEditingController contactPersonPhoneController = TextEditingController();
  TextEditingController contactPersonEmailController = TextEditingController();

  // Invoice
  final invoiceNoControllers = <TextEditingController>[].obs;
  final invoiceValueControllers = <TextEditingController>[].obs;
  final invoiceUploaded = <bool>[].obs;
  final uploadedInvoiceNames = <String?>[].obs;

  // Box Dimensions
  final weightControllers = <TextEditingController>[].obs;
  final lengthControllers = <TextEditingController>[].obs;
  final widthControllers = <TextEditingController>[].obs;
  final heightControllers = <TextEditingController>[].obs;

  //for hit Submit manifestation API and Calculate Freight Cost
  String? itemBox;

  //══════════════════════════════════════════════════════════════════════//
  // DATA
  //══════════════════════════════════════════════════════════════════════//
  RxList<CalFCModel> calculateFCList = <CalFCModel>[].obs;

  RxList<Courier> couriers = <Courier>[].obs;
  Rx<Courier?> selectedCourier = Rx<Courier?>(null);

  // Own Arrangement
  RxBool isOwnSelected = false.obs;

  //══════════════════════════════════════════════════════════════════════//
  // UPDATE COUNTS
  //══════════════════════════════════════════════════════════════════════//
  void updateCount({
    required String value,
    required TextEditingController controller,
    required int maxLimit,
    required int type, // 1 = invoice, 2 = box ,3 = distance
  }) {
    int count = 0;

    if (value.isEmpty) {
      count = 0;
    }

    /// ❌ Leading zero not allowed
    if (value.isNotEmpty && value.startsWith('0')) {
      controller.text = value.replaceFirst('0', '');
      controller.selection =
          TextSelection.collapsed(offset: controller.text.length);
      count = int.tryParse(controller.text) ?? 0;
    }

    /// ✅ Numeric validation
    if (value.isNumericOnly) {
      final entered = int.parse(value);

      if (entered > maxLimit) {
        controller.text = maxLimit.toString();
        controller.selection =
            TextSelection.collapsed(offset: controller.text.length);

        count = maxLimit;
        GainerBottomSheet.showSnackBar("Input can't be greater than $maxLimit");
      } else {
        count = entered;
      }
    } else {
      /// ❌ Remove non-numeric characters
      if (controller.text.isNotEmpty) {
        controller.text =
            controller.text.substring(0, controller.text.length - 1);
        controller.selection =
            TextSelection.collapsed(offset: controller.text.length);
      }
      count = int.tryParse(controller.text) ?? 0;
    }

    /// 🔄 Update based on type
    if (type == 1 && invoiceCount.value != count) {
      invoiceCount.value = count;

      invoiceNoControllers
          .assignAll(List.generate(count, (_) => TextEditingController()));
      invoiceValueControllers
          .assignAll(List.generate(count, (_) => TextEditingController()));
      invoiceUploaded.assignAll(List.generate(count, (_) => false));
      uploadedInvoiceNames.assignAll(List.generate(count, (_) => null));
    }

    if (type == 2 && boxCount.value != count) {
      boxCount.value = count;

      weightControllers
          .assignAll(List.generate(count, (_) => TextEditingController()));
      lengthControllers
          .assignAll(List.generate(count, (_) => TextEditingController()));
      widthControllers
          .assignAll(List.generate(count, (_) => TextEditingController()));
      heightControllers
          .assignAll(List.generate(count, (_) => TextEditingController()));
    }
  }

  //══════════════════════════════════════════════════════════════════════//
  // PICK & UPLOAD INVOICE PDF
  //══════════════════════════════════════════════════════════════════════//
  Future<void> pickInvoicePdf(int index) async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (result == null || result.files.single.path == null) return;

    final File pdf = File(result.files.single.path!);

    final response = await ApiService().manifestationInvoicePdfUpload(
      pdfFile: pdf,
      bigID: manifestationBigIds.first.toString(),
      seqNo: '${index + 1}',
    );

    if (response['success']) {
      invoiceUploaded[index] = true;
      uploadedInvoiceNames[index] = response['data'][0]['FileName'];
    } else {
      GainerBottomSheet.showSnackBar(response['message']);
    }
  }

  //══════════════════════════════════════════════════════════════════════//
  // CALCULATE FREIGHT
  //══════════════════════════════════════════════════════════════════════//
  Future<void> calculateFreight() async {
    if (!formKey.currentState!.validate()) return;

    // isOwnSelected.value = false;
    isLoadingFC.value = true;

    double invoiceAmount = 0;
    for (final c in invoiceValueControllers) {
      invoiceAmount += double.tryParse(c.text) ?? 0;
    }

    final List<String> boxEntries = [];
    for (int i = 0; i < boxCount.value; i++) {
      boxEntries.add(
          '${weightControllers[i].text}|${lengthControllers[i].text}|${widthControllers[i].text}|${heightControllers[i].text}');
    }
    itemBox = boxEntries.join(',');

    final bdl = await AuthService.getBDLId();
    selectedCourier.value = null;
    // brandId = bdl['brandId'];
    // dealerId = bdl['dealerId'];
    // locationId = bdl['locationId'];

    final response = await ApiService().calculateFreightCost(
      buyerLocationID: manifestationBuyerLocationID.value ?? '',
      brandID: bdl['brandId'] ?? '',
      sellerDealerID: bdl['dealerId'] ?? '',
      sellerLocationID: bdl['locationId'] ?? '',
      invoiceAmount: invoiceAmount.toString(),
      distance: distanceController.text,
      itemsArr: itemBox ?? '',
      noOfBoxes: boxCount.value.toString(),
      isWeFastUse: manifestationIsWeFast.value == true ? "Y" : "N",
    );

    isLoadingFC.value = false;

    print("Response: ${response['data']}");
    if (response['success']) {
      calculateFCList.assignAll(
        (response['data'] as List).map((e) => CalFCModel.fromJson(e)).toList(),
      );

      couriers.assignAll(
        calculateFCList
            .map((e) => Courier(
                  name: e.companyName ?? '',
                  code: e.companyCode.toString(),
                ))
            .toList(),
      );

      couriers.add(Courier(name: 'Own Arrangement', code: ''));
    } else {
      GainerBottomSheet.showSnackBar(response['message']);
    }
  }

  //══════════════════════════════════════════════════════════════════════//
  // COURIER SELECTION
  //══════════════════════════════════════════════════════════════════════//
  void selectCourier(Courier courier) {
    selectedCourier.value = courier;
    isOwnSelected.value = courier.code.isEmpty;
  }

  //══════════════════════════════════════════════════════════════════════//
  // Table
  //══════════════════════════════════════════════════════════════════════//
  final List<List<String>> tableData = [];
  table1DataSet(CalFCModel item) {
    tableData.clear();
    int boxNo = 0;
    if (boxCountController.text.isNotEmpty) {
      boxNo = int.parse(boxCountController.text);
    }
    double volumetricWeight = item.volumetricWt ?? 0;
    double weight = item.weight ?? 0;
    double maxValW = volumetricWeight > weight ? volumetricWeight : weight;
    double actualWeight = 0,
        totalVolume = 0,
        totalHeight = 0,
        totalWidth = 0,
        totalLength = 0;

    // Format helper
    String formatDouble(double val) => val.toStringAsFixed(2);
    tableData
        .add(["Category", ...List.generate(boxNo, (i) => '${i + 1}'), "Total"]);

    // Weight-related rows
    List<String> maxRow = ["Maximum of Actual\n & Volumetric Weight(in Kg)"];
    List<String> volumetricRow = ["Volumetric Weight(in KG)"];
    List<String> actualRow = ["Actual Weight(in KG)"];

    for (var i = 0; i < boxNo; i++) {
      String weightText = weightControllers[i].text;
      double weightVal = double.tryParse(weightText) ?? 0;
      actualWeight += weightVal;

      maxRow.add(""); // Placeholder for box-specific max value
      volumetricRow.add(""); // Placeholder for box-specific volumetric weight
      actualRow.add(formatDouble(weightVal));
    }

    maxRow.add(formatDouble(maxValW));
    volumetricRow.add(formatDouble(volumetricWeight));
    actualRow.add(formatDouble(actualWeight));

    tableData.add(maxRow);
    tableData.add(volumetricRow);
    tableData.add(actualRow);

    // Volume row
    List<String> volumeRow = ["Volume (in cubic ft)"];
    for (var i = 0; i < boxNo; i++) {
      double h = double.tryParse(heightControllers[i].text) ?? 0;
      double w = double.tryParse(widthControllers[i].text) ?? 0;
      double l = double.tryParse(lengthControllers[i].text) ?? 0;

      double volume = double.parse(((h * w * l) / 1728).toStringAsFixed(2));
      totalVolume += volume;
      volumeRow.add(formatDouble(volume));
    }
    volumeRow.add(formatDouble(totalVolume));
    tableData.add(volumeRow);

    // Dimensions (Height, Width, Length)
    List<String> buildDimensionRow(
        String label,
        List<TextEditingController> controllers,
        double Function() totalSetter) {
      double total = 0;
      List<String> row = [label];
      for (var i = 0; i < boxNo; i++) {
        double val = double.tryParse(controllers[i].text) ?? 0;
        total += val;
        row.add(formatDouble(val));
      }
      row.add(formatDouble(total));
      return row;
    }

    tableData.add(buildDimensionRow(
        "Height (in inches)", heightControllers, () => totalHeight));
    tableData.add(buildDimensionRow(
        "Width (in inches)", widthControllers, () => totalWidth));
    tableData.add(buildDimensionRow(
        "Length (in inches)", lengthControllers, () => totalLength));
    // tableData.add(["Box", ...List.generate(boxNo, (i) => '${i + 1}'), ""]);

    if (boxNo <= 0) tableData.clear();
  }

  //══════════════════════════════════════════════════════════════════════//
  // FINAL SUBMIT
  //══════════════════════════════════════════════════════════════════════//
  Future<void> submitManifestation() async {
    if (selectedCourier.value == null) {
      GainerBottomSheet.showSnackBar('Please select a courier');
      return;
    }
    if (!submitFormKey.currentState!.validate()) return;

    if (invoiceUploaded.any((e) => e == false)) {
      GainerBottomSheet.showSnackBar('Upload all invoices');
      return;
    }

    final itemInvoice = List.generate(
      invoiceCount.value,
      (i) =>
          '${invoiceNoControllers[i].text}|${invoiceValueControllers[i].text}|${uploadedInvoiceNames[i]}',
    ).join(',');

    //company data according to selected dropdown
    CalFCModel? selectedCompany;
    bool isSelectedCostHighest = false;
    // check if Own Arrangement is not selected then selected company data store
    if (isOwnSelected.value == false) {
      selectedCompany = calculateFCList.firstWhere(
        (company) =>
            company.companyCode == int.parse(selectedCourier.value!.code),
        orElse: () => CalFCModel(), // empty default instance
      );

      // Now check if selectedCompany's cost is highest among all
      isSelectedCostHighest = calculateFCList.any(
        (company) =>
            company.companyCode != selectedCompany?.companyCode &&
            (selectedCompany?.estCost ?? 0) > (company.estCost ?? 0),
      );

      //clear all onw arrangement controller
      clearOwnArrangementCtrl();
    }

    final userId = await AuthService.getTCode();
    Future<void> confirmAndManifest() async {
      isLoadingCFCSubmit.value = true;
      final response = await ApiService().manifestation(
        bigIDs: manifestationBigIds.join(','),
        companyCode: selectedCourier.value?.code ?? "3",
        remarks: remarksController.text,
        noofInvoioce: invoiceCount.value.toString(),
        itemInvoice: itemInvoice,
        noofBoxes: boxCount.value.toString(),
        itemBox: itemBox.toString(),
        estFreightCost: selectedCompany?.estCost.toString() ?? "0",
        chargeableWeight:
            selectedCompany?.minChargeableWeight.toString() ?? "0",
        volumetricWt: selectedCompany?.volumetricWt.toString() ?? "0",
        odaChargePickup: selectedCompany?.odaChargePickup.toString() ?? "0",
        odaChargeDelivery: selectedCompany?.odaChargeDelivery.toString() ?? "0",
        handlingCharges: selectedCompany?.handlingCharges.toString() ?? "0",
        tat: selectedCompany?.tat.toString() ?? "",
        buyerZone: selectedCompany?.buyerZone ?? "",
        sellerZone: selectedCompany?.sellerZone ?? "",
        lrNumber: lrController.text.trim(),
        transporterName: transportNameController.text.trim(),
        contactPerson: contactPersonNameController.text.trim(),
        phone: contactPersonPhoneController.text.trim(),
        emailID: contactPersonEmailController.text.trim(),
        itemCN: "",
        noofCN: "",
        loginUserID: userId,
      );
      isLoadingCFCSubmit.value = false;
      if (response['success']) {
        Get.back();
        Get.back();
      } else {
        GainerBottomSheet.showSnackBar(response['message']);
      }
    }

    void confirmDialog(String message, VoidCallback onYes) {
      GainerDialog.dialogForYesNo(
        text: message,
        imgPath: GainerImages.decisionMaking,
        yesFunction: () {
          Get.back();
          onYes();
        },
        noFunction: Get.back,
      );
    }

    //check dropdown courier if not selected own arrangement
    if (selectedCompany != null) {
      confirmDialog(
        "Are you sure Dimensions is correct\nVol. Weight(KG): ${selectedCompany.volumetricWt}\nFreight Cost: ${selectedCompany.totalCost}",
        () {
          if (isSelectedCostHighest) {
            confirmDialog(
              "LSP chosen has higher estimated cost\nDo you want to proceed?",
              () {
                confirmDialog(
                  "Are you sure? You want to Manifest",
                  confirmAndManifest,
                );
              },
            );
          } else {
            confirmDialog(
              "Are you sure? You want to Manifest",
              confirmAndManifest,
            );
          }
        },
      );
    } else {
      confirmDialog(
        "Are you sure? You want to Manifest",
        confirmAndManifest,
      );
    }
  }

  //══════════════════════════════════════════════════════════════════════//
  // CLEANUP
  //══════════════════════════════════════════════════════════════════════//
  @override
  void onClose() {
    for (var c in [
      ...invoiceNoControllers,
      ...invoiceValueControllers,
      ...weightControllers,
      ...lengthControllers,
      ...widthControllers,
      ...heightControllers,
    ]) {
      c.dispose();
    }
    super.onClose();
  }

  //when not select own arrangement
  void clearOwnArrangementCtrl() {
    lrController.dispose();
    transportNameController.clear();
    contactPersonNameController.clear();
    contactPersonPhoneController.clear();
    contactPersonEmailController.clear();
  }*/

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
    dealers
        .assignAll(manifestationList.map((e) => e.buyerDealer ?? '').toSet());
  }

  ///Rebuild location name in filter (according to dealer)
  void rebuildLocations() {
    final filtered = manifestationList.where((o) {
      return tempDealers.isEmpty || tempDealers.contains(o.buyerDealer);
    });

    locations.assignAll(filtered.map((e) => e.buyerLocation ?? '').toSet());
  }

  ///Rebuild location name in filter (according to dealer & location)
  void rebuildParts() {
    final filtered = manifestationList.where((o) {
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
      partNdDesc[o.partNumber ?? ''] = o.partDesc ?? '';
    }
  }

  ///WHEN CLICK ON APPLY AFTER FILTER
  void applyFilters() {
    appliedDealers.assignAll(tempDealers);
    appliedLocations.assignAll(tempLocations);
    appliedPartNos.assignAll(tempPartNos);
    selectedOrderType.value = tempSelectedOrderType.value;

    filteredList.value = manifestationList.where((order) {
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
    filteredList.assignAll(manifestationList);
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
          child: MSortSheet(),
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
          child: MFilterSheet(),
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
