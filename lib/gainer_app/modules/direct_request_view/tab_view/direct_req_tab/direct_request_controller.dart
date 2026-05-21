import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:gainer/gainer_app/core/Services/auth_service.dart';
import 'package:gainer/gainer_app/core/Services/gainer_api_service.dart';
import 'package:gainer/gainer_app/core/constants/gainer_image.dart';
import 'package:gainer/gainer_app/core/widgets/gainer_bottom_sheet.dart';
import 'package:gainer/gainer_app/core/widgets/gainer_dialog.dart';
import 'package:gainer/gainer_app/modules/direct_request_view/models/dealer_list_model.dart';
import 'package:gainer/gainer_app/modules/direct_request_view/models/location_list_model.dart';
import 'package:gainer/gainer_app/modules/direct_request_view/models/order_type_list_model.dart';
import 'package:get/get.dart';
import '../../../../core/utils/gainer_text_filed_validator.dart';
import '../../models/part_model.dart';

class DirectRequestController extends GetxController {
  /// Controllers
  final partNoCtrl = TextEditingController();
  final qtyCtrl = TextEditingController();
  final remarkCtrl = TextEditingController();

  /// Dropdown selections
  final selectedDealer = RxnString();
  final selectedLocation = RxnString();
  final selectedOrderType = RxnString();

  /// State
  final isLoading = false.obs;
  final isError = false.obs;
  final isPartAdding = false.obs;
  final isAddEnabled = false.obs;
  RxBool partSearchLoading = false.obs;

  /// Data lists
  final dealerList = <DealerListModel>[].obs;
  final locationList = <LocationListModel>[].obs;
  final orderTypeList = <OrderTypeListModel>[].obs;
  final parts = <PartModel>[].obs;
  var partSuggestions = <String>[].obs;

  // final formKey = GlobalKey<FormState>();

  @override
  void onInit() {
    super.onInit();
    initWork();

    /// 🔥 Auto validation (no need to call manually everywhere)
    partNoCtrl.addListener(validateFields);
    qtyCtrl.addListener(validateFields);
  }

  void initWork() async {
    isError(false);
    isLoading(true);
    await Future.wait([
      getDealer(),
      getOrderType(),
    ]);
    isLoading(false);
  }

  // ============ Part Remove ============ //
  ///Remove Part In List
  void removePart(int index) {
    parts.removeAt(index);
  }

  // ================= API ================= //

  Future<void> getDealer() async {
    final brandId = await AuthService.getBrandId();
    final res = await GainerApiService().getSuggestedDealer(brandId);

    if (res['success']) {
      dealerList.assignAll(
        (res['data'] as List).map((e) => DealerListModel.fromJson(e)).toList(),
      );
    } else {
      isError(true);
      GainerBottomSheet.showSnackBar(res['message']);
    }
  }

  Future<void> getLocation(int dealerId) async {
    final res = await GainerApiService().getSuggestedLocation(dealerId);

    if (res['success']) {
      locationList.assignAll(
        (res['data'] as List)
            .map((e) => LocationListModel.fromJson(e))
            .toList(),
      );
    } else {
      GainerBottomSheet.showSnackBar(res['message']);
    }
  }

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

  Future<void> onDealerChanged(String? dealer) async {
    if (dealer == null) return;

    selectedDealer.value = dealer;

    /// Reset dependent fields
    selectedLocation.value = null;
    locationList.clear();

    final dealerId = dealerList.firstWhere((d) => d.dealer == dealer).dealerId;

    await getLocation(dealerId);

    validateFields();
  }

  void onLocationChanged(String? location) {
    if (location == null) return;

    selectedLocation.value = location;
    validateFields();
  }

  void onOrderTypeChanged(String? order) {
    if (order == null) return;

    selectedOrderType.value = order;
    validateFields();
  }

  // ================= VALIDATION ================= //

  void validateFields() {
    isAddEnabled.value = partNoCtrl.text.trim().isNotEmpty &&
        qtyCtrl.text.trim().isNotEmpty &&
        selectedDealer.value != null &&
        selectedLocation.value != null &&
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

  Future<void> onTapAddPart() async {
    try {
      isPartAdding(true);
      final brandId = await AuthService.getBrandId();
      final locationId = await AuthService.getLocationId();
      final tCode = await AuthService.getTCode();

      final partNo = partNoCtrl.text.trim();
      final location = selectedLocation.value;
      final orderType = selectedOrderType.value;

      final isDuplicate = parts.any(
        (p) =>
            p.partNo == partNo &&
            p.location == location &&
            p.orderFor == orderType,
      );
      if (isDuplicate) {
        GainerBottomSheet.showSnackBar(
          'Part $partNo is already added for location $location',
        );
        return;
      }

      final res = await GainerApiService().getPartDetails(
        brandId,
        partNo,
        locationId,
        tCode,
      );

      if (!res['success']) {
        GainerBottomSheet.showSnackBar(res['message']);
        return;
      }

      final data = res['data'][0];

      final dealerId = dealerList
          .firstWhere((d) => d.dealer == selectedDealer.value)
          .dealerId;
      final selectedLocationId = locationList
          .firstWhere((l) => l.location == selectedLocation.value)
          .locationId;
      final orderForId = orderTypeList
          .firstWhere((o) => o.orderFor == selectedOrderType.value)
          .orderForId;

      parts.add(
        PartModel(
          partNo: partNo,
          desc: data["partdesc"],
          mrp: data["MRP"].toString(),
          rate: data["landedcost"].toString(),
          qty: qtyCtrl.text.trim(),
          dealer: selectedDealer.value!,
          location: selectedLocation.value!,
          orderFor: selectedOrderType.value!,
          dealerId: dealerId,
          locationId: selectedLocationId,
          orderForId: orderForId,
          remarks: remarkCtrl.text,
        ),
      );
      _resetForm();
    } catch (e) {
      GainerBottomSheet.showSnackBar("Something went wrong");
    } finally {
      isPartAdding(false);
    }
  }

  Future<void> submitDirectRequest() async {
    if (parts.isEmpty) {
      GainerBottomSheet.showSnackBar('Please add at least one part');
      return;
    }

    try {
      isLoading(true);

      final buyerLocationId = await AuthService.getLocationId();
      final tCode = await AuthService.getTCode();

      final payload = parts
          .map((p) => {
                ...p.toJson(),
                "buyerLocationId": buyerLocationId,
                "buyerId": tCode,
              })
          .toList();

      final response = await GainerApiService().submitDirectRequest(payload);

      if (response['success']) {
        // GainerBottomSheet.showSnackBar(response['data']);
        GainerDialog.midPopUp(GainerImages.checkIcon, response['data']);
        parts.clear();
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

  Timer? _debounce;
  void onPartFieldChanged(String text) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();

    _debounce = Timer(const Duration(milliseconds: 400), () async {
      if (text.isEmpty) {
        partSuggestions.clear();
        return;
      }

      await fetchPartSuggestions(text);
    });
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
    qtyCtrl.clear();
    remarkCtrl.clear();
    selectedDealer.value = null;
    selectedLocation.value = null;
    selectedOrderType.value = null;
    locationList.clear();
    isAddEnabled(false);
  }

  @override
  void dispose() {
    partNoCtrl.dispose();
    qtyCtrl.dispose();
    remarkCtrl.dispose();

    super.dispose();
  }
}
