import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/Services/auth_service.dart';
import '../../../../core/constants/gainer_image.dart';
import '../../../../core/services/gainer_api_service.dart';
import '../../../../core/widgets/gainer_bottom_sheet.dart';
import '../../../../core/widgets/gainer_dialog.dart';
import 'manifestation_controller.dart';
import '../models/cal_f_c_model.dart';
import '../models/courier_model.dart';

class CalFCController extends GetxController {
  // final manifestController = Get.find<ManifestationController>();
  //══════════════════════════════════════════════════════════════════════//
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
  // Data from Manifestation screen
  //══════════════════════════════════════════════════════════════════════//

  final ManifestationController manifestController =
      Get.find<ManifestationController>();

  /// 🔹 Getters (Form manifestation screen)
  RxList<int> get manifestationBigIds => manifestController.manifestationBigIds;

  RxnString get manifestationBuyerLocationID =>
      manifestController.manifestationBuyerLocationID;

  RxBool get manifestationIsWeFast => manifestController.manifestationIsWeFast;
  // var manifestationBigIds = [].obs;
  // RxnString manifestationBuyerLocationID = RxnString(null);
  // RxnBool manifestationIsWeFast = RxnBool(null);
  // @override
  // void onInit() {
  //   manifestationBigIds = manifestController.manifestationBigIds;
  //   manifestationBuyerLocationID.value =
  //       manifestController.manifestationBuyerLocationID.value;
  //   manifestationIsWeFast.value = manifestController.manifestationIsWeFast.value;
  //   super.onInit();
  // }

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

    final locationId = await AuthService.getLocationId();
    final tcode = await AuthService.getTCode();
    final response = await GainerApiService().manifestationInvoicePdfUpload(
      pdfFile: pdf,
      bigID: manifestationBigIds.first.toString(),
      seqNo: '${index + 1}',
      locationId: locationId,
      tCode: tcode,
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
  double invoiceAmount = 0;
  Future<void> calculateFreight() async {
    if (!formKey.currentState!.validate()) return;

    // isOwnSelected.value = false;
    isLoadingFC.value = true;

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
    final tCode = await AuthService.getTCode();
    selectedCourier.value = null;
    // brandId = bdl['brandId'];
    // dealerId = bdl['dealerId'];
    // locationId = bdl['locationId'];

    final response = await GainerApiService().calculateFreightCost(
      buyerLocationID: manifestationBuyerLocationID.value ?? '',
      brandID: bdl['brandId'] ?? '',
      sellerDealerID: bdl['dealerId'] ?? '',
      sellerLocationID: bdl['locationId'] ?? '',
      invoiceAmount: invoiceAmount.toString(),
      distance: distanceController.text,
      itemsArr: itemBox ?? '',
      noOfBoxes: boxCount.value.toString(),
      isWeFastUse: manifestationIsWeFast.value == true ? "Y" : "N",
      userId: tCode,
    );

    isLoadingFC.value = false;

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
    final locationId = await AuthService.getLocationId();
    // final bdl = await AuthService.getBDL();
    Future<void> confirmAndManifest() async {
      isLoadingCFCSubmit.value = true;
      final response = await GainerApiService().manifestation(
          bigIDs: manifestationBigIds.join(','),
          companyCode:
              isOwnSelected.value ? "3" : selectedCourier.value?.code ?? "3",
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
          odaChargeDelivery:
              selectedCompany?.odaChargeDelivery.toString() ?? "0",
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
          locationId: locationId);
      isLoadingCFCSubmit.value = false;
      if (response['success']) {
        Get.back();
        Get.back();
        // List<ManifestationModel> orderList = manifestController.selectedOrders;
        await manifestController.fetchMDetails();
        GainerDialog.midPopUp(
            GainerImages.checkIcon, 'Order Manifested Successfully');
        // await PushNotification.notifyDealer(
        //   locationID: manifestationBuyerLocationID.value ?? '',
        //   title: 'MANIFEST STAGE',
        //   body:
        //       'Final Purchase Order received at ${orderList.first.buyerLocation} for parts worth Rs $invoiceAmount/- from Buyer: ${bdl['dealer']} ${bdl['location']}. Pl Invoice & update shipment details on priority',
        //   data: {'moduleRoute': Routes.PARTRECEIPT},
        // );
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
    lrController.clear();
    transportNameController.clear();
    contactPersonNameController.clear();
    contactPersonPhoneController.clear();
    contactPersonEmailController.clear();
  }
}
