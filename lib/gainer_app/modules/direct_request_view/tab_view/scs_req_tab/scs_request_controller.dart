import 'dart:async';
import 'package:flutter/material.dart';
import 'package:gainer/gainer_app/core/Services/auth_service.dart';
import 'package:gainer/gainer_app/core/Services/gainer_api_service.dart';
import 'package:gainer/gainer_app/core/constants/gainer_image.dart';
import 'package:gainer/gainer_app/core/widgets/gainer_bottom_sheet.dart';
import 'package:gainer/gainer_app/core/widgets/gainer_dialog.dart';
import 'package:gainer/gainer_app/modules/direct_request_view/models/order_type_list_model.dart';
import 'package:get/get.dart';
import '../../../../core/utils/gainer_text_filed_validator.dart';

class ScsRequestController extends GetxController {
  /// Controllers
  final partNoCtrl = TextEditingController();
  final partDescCtrl = TextEditingController();
  final partMRPCtrl = TextEditingController();
  final partRateCtrl = TextEditingController();
  final partQtyCtrl = TextEditingController();
  final remarkCtrl = TextEditingController();

  /// Dropdown selections
  final selectedOrderType = RxnString();

  /// State
  final isLoading = false.obs;
  final isError = false.obs;
  final isGettingPartDetails = false.obs;
  final isSubmitEnabled = false.obs;
  RxBool partSearchLoading = false.obs;
  RxBool isReadOnlyField = true.obs;

  /// Data lists
  final orderTypeList = <OrderTypeListModel>[].obs;
  var partSuggestions = <String>[].obs;

  @override
  void onInit() {
    super.onInit();
    initWork();

    partNoCtrl.addListener(validateFields);
    partDescCtrl.addListener(validateFields);
    partMRPCtrl.addListener(validateFields);
    partRateCtrl.addListener(validateFields);
    partQtyCtrl.addListener(validateFields);
  }

  void initWork() async {
    isError(false);
    isLoading(true);
    await getOrderType();
    isLoading(false);
  }

  // ============ Part Remove ============ //
  // ///Remove Part In List
  // void removePart(int index) {
  //   parts.removeAt(index);
  // }

  // ================= API ================= //

  Future<void> getOrderType() async {
    final res = await GainerApiService().getSuggestedOrderType();

    if (res['success']) {
      orderTypeList.assignAll(
        (res['data'] as List)
            .map((e) => OrderTypeListModel.fromJson(e))
            .toList(),
      );
    } else {
      isError(true);
      GainerBottomSheet.showSnackBar(res['message']);
    }
  }

  // ================= DROPDOWN HANDLERS ================= //
  void onOrderTypeChanged(String? order) {
    if (order == null) return;

    selectedOrderType.value = order;
    validateFields();
  }

  // ================= VALIDATION ================= //

  void validateFields() {
    isSubmitEnabled.value = partNoCtrl.text.trim().isNotEmpty &&
        partDescCtrl.text.trim().isNotEmpty &&
        partMRPCtrl.text.trim().isNotEmpty &&
        partRateCtrl.text.trim().isNotEmpty &&
        partQtyCtrl.text.trim().isNotEmpty &&
        // selectedDealer.value != null &&
        // selectedLocation.value != null &&
        selectedOrderType.value != null;
  }

  // ================= REMARKS ================= //

  Future<void> onRemarksChanges(String value) async {
    final filtered = await GainerTextFiledValidator.remarksValidation(value);

    if (value != filtered) {
      remarkCtrl.value = TextEditingValue(
        text: filtered,
        selection: TextSelection.collapsed(offset: filtered.length),
      );
    }
  }

  // ================= PART ACTION ================= //

  Future<void> getPartDetails() async {
    try {
      partSuggestions.clear();
      isReadOnlyField(true);
      isGettingPartDetails(true);
      final brandId = await AuthService.getBrandId();
      final locationId = await AuthService.getLocationId();
      final tCode = await AuthService.getTCode();

      final partNo = partNoCtrl.text.trim();

      final res = await GainerApiService().getPartDetails(
        brandId,
        partNo,
        locationId,
        tCode,
      );

      if (!res['success']) {
        GainerBottomSheet.showSnackBar(
            "${res['message']}\nEnter part details manually ");
        isReadOnlyField(false);
        partDescCtrl.clear();
        partMRPCtrl.clear();
        partRateCtrl.clear();
        return;
      }

      final data = res['data'][0];
      partDescCtrl.text = data['partdesc'];
      partMRPCtrl.text = data['MRP'].toInt().toString();
      partRateCtrl.text = data['landedcost'].toInt().toString();

      // _resetForm();
    } catch (e) {
      GainerBottomSheet.showSnackBar("Something went wrong");
    } finally {
      isGettingPartDetails(false);
    }
  }

  Future<void> submitScsRequest() async {
    try {
      isLoading(true);

      validateFields();
      if (!isSubmitEnabled.value) {
        GainerBottomSheet.showSnackBar('All field mandatory');
        return;
      }

      final buyerLocationId = await AuthService.getLocationId();
      final tCode = await AuthService.getTCode();
      final orderForId = orderTypeList
          .firstWhere((o) => o.orderFor == selectedOrderType.value)
          .orderForId;

      final payload = [
        {
          "buyerLocationId": buyerLocationId,
          "buyerId": tCode,
          "PartNumber": partNoCtrl.text.trim(),
          "PartDesc": partDescCtrl.text.trim(),
          "Mrp": partMRPCtrl.text.trim(),
          "Rate": partRateCtrl.text.trim(),
          "Qty": partQtyCtrl.text.trim(),
          "OrderFor": orderForId.toString(),
          "Remark": remarkCtrl.text.trim(),
        }
      ];

      final response = await GainerApiService().submitScsRequest(payload);

      if (response['success']) {
        GainerDialog.midPopUp(GainerImages.checkIcon, response['data']);
        _resetForm();
      } else {
        GainerBottomSheet.showSnackBar(
          response['message'] ?? 'Failed to submit request',
        );
      }
    } catch (e) {
      GainerBottomSheet.showSnackBar('Something went wrong');
    } finally {
      isLoading(false);
    }
  }

  Timer? _partSuggestionDebounce;
  Timer? _partDetailsDebounce;
  void onPartFieldChanged(String text) {
    if (_partSuggestionDebounce?.isActive ?? false) {
      _partSuggestionDebounce!.cancel();
    }

    _partSuggestionDebounce =
        Timer(const Duration(milliseconds: 400), () async {
      if (text.isEmpty) {
        partSuggestions.clear();
        return;
      }

      await fetchPartSuggestions(text);
    });

    if (_partDetailsDebounce?.isActive ?? false) _partDetailsDebounce!.cancel();

    _partSuggestionDebounce =
        Timer(const Duration(milliseconds: 2500), () async {
      if (text.isEmpty) {
        partSuggestions.clear();
        return;
      }

      await getPartDetails();
    });

    validateFields();
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

  // Function to handle part number selection
  void selectPartNumber(String partNumber) {
    partNoCtrl.text = partNumber;
    partSuggestions.clear();
  }

  void _resetForm() {
    partNoCtrl.clear();
    partDescCtrl.clear();
    partMRPCtrl.clear();
    partRateCtrl.clear();
    partQtyCtrl.clear();
    remarkCtrl.clear();
    selectedOrderType.value = null;
    isSubmitEnabled.value = false;
    isReadOnlyField.value = true;
  }

  @override
  void dispose() {
    partNoCtrl.dispose();
    partDescCtrl.dispose();
    partMRPCtrl.dispose();
    partRateCtrl.dispose();
    partQtyCtrl.dispose();
    remarkCtrl.dispose();
    super.dispose();
  }
}
