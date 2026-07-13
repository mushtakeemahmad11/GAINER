import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../../core/Services/auth_service.dart';
import '../../../core/constants/gainer_image.dart';
import '../../../core/services/gainer_api_service.dart';
import '../../../core/widgets/gainer_bottom_sheet.dart';
import '../../../core/widgets/gainer_dialog.dart';
import '../../../core/widgets/image_preview.dart';
import 'models/dd_model.dart';

class DDController extends GetxController {
  /// ORIGINAL / FILTERED LIST
  RxList<DDModel> ddList = <DDModel>[].obs;
  RxList<DDModel> filteredList = <DDModel>[].obs;

  /// LOADING STATE
  RxBool isLoading = false.obs;

  /// ERROR / RESPONSE MESSAGES
  RxnString errorMsg = RxnString(null);

  /// SEARCH CONTROLLER
  SearchController searchController = SearchController();

  /// get from local for HIT Api to Fetch and ubmit data
  String brandID = '';
  String dealerID = '';
  String locationID = '';
  String tCode = '';

  @override
  void onInit() {
    super.onInit();
    _initWork();
  }

  _initWork() async {
    final bdl = await AuthService.getBDLId();
    brandID = bdl['brandId'] ?? '';
    dealerID = bdl['dealerId'] ?? '';
    locationID = bdl['locationId'] ?? '';
    tCode = await AuthService.getTCode();

    await fetchDD();
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

    //Filter list
    if (query.isEmpty) {
      filteredList.assignAll(ddList);
    } else {
      filteredList.assignAll(
        ddList.where(
          (item) => item.buyerLocation.toLowerCase().contains(query),
        ),
      );
    }

    //Group AFTER filtering
    groupedData();
  }

  /// CLEAR SEARCH BAR
  void clearSearchBar() {
    searchController.clear();
    searchText.value = '';
    filteredList.assignAll(ddList);
    groupedData();
  }

  /// GROUP BY DISPATCH ORDER NUMBER NUMBER
  final RxList<Map<String, dynamic>> groupedList = <Map<String, dynamic>>[].obs;

  ///Group API Data according to Dispatch order number [{data: DDModel, count: int}]
  void groupedData() {
    groupedList.clear();
    final Map<String, List<DDModel>> groupedData = {};

    for (final item in filteredList) {
      groupedData.putIfAbsent(item.dispatchOrderNo, () => []).add(item);
    }

    final result = groupedData.entries.map((e) {
      return {
        'data': e.value.first,
        'count': e.value.length,
      };
    }).toList();

    groupedList.assignAll(result);
  }

  /// ---------------- FETCH API ----------------
  Future<void> fetchDD() async {
    // final bdl = await AuthService.getBDLId();
    // final brandID = bdl['brandId'] ?? '';
    // final dealerID = bdl['dealerId'] ?? '';
    // final locationID = bdl['locationId'] ?? '';

    errorMsg.value = null;
    isLoading.value = true;
    groupedList.clear();
    ddList.clear();

    final response = await GainerApiService()
        .dispatchDetailsStage(brandID, dealerID, locationID, tCode);
    isLoading.value = false;
    if (response['success']) {
      List<dynamic> jsonList = jsonDecode(response['data']);
      print(jsonList);
      ddList.assignAll(
        jsonList.map((e) => DDModel.fromJson(e)),
      );

      filteredList.assignAll(ddList);
      groupedData();
    } else {
      errorMsg.value = response['message'];
    }
  }

  // RxBool isLoading = false.obs;
  RxMap<String, bool> uploadingMap = <String, bool>{}.obs;

  final RxMap<String, List<List<Object?>>> boxImages =
      <String, List<List<Object?>>>{}.obs;

  final RxMap<String, List<List<Object?>>> signedImages =
      <String, List<List<Object?>>>{}.obs;

  void initImages(DDModel order, int rowCount) {
    boxImages.putIfAbsent(
      order.dispatchOrderNo,
      () => List.generate(
        rowCount,
        (_) => [order.withPkgSlipImg, order.img1, order.img2],
      ),
    );

    signedImages.putIfAbsent(
      order.dispatchOrderNo,
      () => [
        [order.signedCopyPkgSlipImg, order.otherDetailImg]
      ],
    );
  }

  void setImage({
    required String orderNo,
    required int row,
    required int col,
    required Object image,
    required bool isSigned,
  }) {
    final map = isSigned ? signedImages : boxImages;
    map[orderNo]?[row][col] = image;
    map.refresh();
  }

  bool isBoxInvalid(String orderNo) =>
      boxImages[orderNo]?.any((r) => r.any((e) => e == null)) ?? true;

  bool isSignedInvalid(String orderNo) => signedImages[orderNo]?[0][0] == null;

  Future<bool> uploadImage(
      DDModel order, File pickedImage, String fileName) async {
    File selectedImages = File(pickedImage.path);
    final locationId = await AuthService.getLocationId();
    final response = await GainerApiService().dispatchDetailsImgUploadV2(
      dispatchOrderNo: order.dispatchOrderNo,
      lRNumber: order.lrNumber,
      tCode: order.tCode.toString(),
      fileName: fileName,
      imageFiles: selectedImages,
      locationId: locationId,
    );

    if (response['success']) {
      GainerBottomSheet.showSnackBar(response['data']);
      return true;
    } else {
      GainerBottomSheet.showSnackBar(
          '${response['message']}\nPlease Upload Again');
      return false;
    }
  }

  Future<void> pickAndUpload({
    required DDModel order,
    required int row,
    required int col,
    required bool isSigned,
    required String fileName,
    required ImageSource source,
  }) async {
    Get.back();
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: source);
    if (picked == null) return;

    final key = '${order.dispatchOrderNo}_$row$col$isSigned';

    uploadingMap[key] = true;
    final uploaded = await uploadImage(order, File(picked.path), fileName);
    uploadingMap[key] = false;

    if (uploaded) {
      setImage(
        orderNo: order.dispatchOrderNo,
        row: row,
        col: col,
        image: File(picked.path),
        isSigned: isSigned,
      );
    }
  }

  (String, String?) imageMeta(String text, DDModel order) {
    switch (text) {
      case 'With pkg slip':
        return ('WithPkgSlipImg', order.withPkgSlipImg);
      case '3D image 1':
        return ('Img1', order.img1);
      case '3D image 2':
        return ('Img2', order.img2);
      case 'Signed packing slip':
        return ('SignedCopyPkgSlipImg', order.signedCopyPkgSlipImg);
      case 'Other details':
        return ('OtherDetailImg', order.otherDetailImg);
      default:
        return ('', null);
    }
  }

  void onImageTap(
    BuildContext context,
    Object? image,
    String? apiImage,
    String title,
    DDModel order,
    int row,
    int col,
    bool isSigned,
    String fileName,
    Size size,
  ) {
    if (image != null || apiImage != null) {
      ImagePreview.show(image: image, title: title);
      return;
    }

    GainerBottomSheet.show(
      context: context,
      onPressedCamera: () => pickAndUpload(
        order: order,
        row: row,
        col: col,
        isSigned: isSigned,
        fileName: fileName,
        source: ImageSource.camera,
      ),
      onPressedGallery: () => pickAndUpload(
        order: order,
        row: row,
        col: col,
        isSigned: isSigned,
        fileName: fileName,
        source: ImageSource.gallery,
      ),
    );
  }

  /// ---------- Images Null checks ----------
  bool isAnyNullInBox(String orderNo) {
    final rows = boxImages[orderNo];
    if (rows == null || rows.isEmpty) return true;

    return rows.any(
      (row) => row.any((element) => element == null),
    );
  }

  bool isAnyNullInPickup(String orderNo) {
    final rows = signedImages[orderNo];
    if (rows == null || rows.isEmpty) return true;

    final pickupRow = rows.first;
    if (pickupRow.length < 2) return true;

    return pickupRow.any((e) => e == null);
  }

  ///Final submit DISPATCHED ORDER DETAILS
  // RxBool isSubmit = false.obs;
  final RxMap<String, bool> isSubmit = <String, bool>{}.obs;

  bool isSubmitting(String orderNo) => isSubmit[orderNo] ?? false;
  void onSubmit(String dispatchNo, String lrNo) async {
    // check for Box Image image if any empty or null
    bool boxImg = isAnyNullInBox(dispatchNo);
    bool pickupImg = isAnyNullInBox(dispatchNo);

    if (boxImg) {
      GainerBottomSheet.showSnackBar(
          'All image is required\nPlease upload all image');
      return;
    }
    if (pickupImg) {
      GainerBottomSheet.showSnackBar("Signed Packing Slip Image is Required");
      return;
    }

    // String locationId = await AuthService.getLocationId();
    // String tCode = await AuthService.getTCode();

    GainerDialog.dialogForYesNo(
      text: 'Do you want to save Dispatch Details',
      imgPath: GainerImages.decisionMaking,
      yesFunction: () async {
        Get.back();
        // isLoading.value = true;
        isSubmit[dispatchNo] = true;
        final response = await GainerApiService()
            .dispatchDetailsSubmit(dispatchNo, lrNo, locationID, tCode);
        // isLoading.value = false;
        isSubmit[dispatchNo] = false;
        if (response['success']) {
          _initWork();
          GainerDialog.midPopUp(GainerImages.checkIcon, response['data']);
        } else {
          GainerBottomSheet.showSnackBar(response['message']);
        }
      },
      noFunction: Get.back,
    );
  }

  RxInt expandedIndex = (-1).obs;

  void toggle(int index, bool isExpanded) {
    expandedIndex.value = isExpanded ? index : -1;
  }
}
