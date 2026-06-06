import 'package:flutter/material.dart';
import 'package:gainer/dealer_monitoring/widgets/no_internet_dialog.dart';
import 'package:gainer/gainer_app/core/Services/auth_service.dart';
import 'package:gainer/gainer_app/core/utils/check_internet.dart';
import 'package:gainer/gainer_app/core/widgets/gainer_dialog.dart';
import 'package:get/get.dart';
import '../../gainer_app/core/constants/gainer_image.dart';
import '../core/services/dm_api_services.dart';
import '../core/theme/app_colors.dart';
import '../widgets/remarks_bottom_sheet.dart';
import '../widgets/vehicle_search_reserved_details_sheet.dart';
import '../widgets/vehicle_search_stock_details_sheet.dart';

class VehicleSearchController extends GetxController {
  DMApiServices api = DMApiServices();
  final TextEditingController searchController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  RxnString selectedValue1 = RxnString("Part not issued");
  RxnString selectedValue2 = RxnString(null);
  RxnString selectedValue3 = RxnString(null);
  RxnString vehicleNumber = RxnString(null);

  //Dates
  RxnString stockDate = RxnString("--/--/----");
  RxnString jobLineDate = RxnString("--/--/----");
  RxnString jobCardDate = RxnString("--/--/----");

  RxBool isLoading = false.obs;
  RxBool isMoreLoading = false.obs;
  RxBool isPagination = false.obs;
  RxBool isVehicleSuggestionLoading = false.obs;
  RxBool isNonStockable = true.obs;

  RxnString errorMsg = RxnString(null);

  RxBool showScrollButton = false.obs;
  RxBool hasMore = true.obs;
  RxInt currentPage = 1.obs;
  final int pageSize = 10;
  final ScrollController scrollController = ScrollController();

  RxList<Map<String, dynamic>> vehicleData = <Map<String, dynamic>>[].obs;
  RxList<Map<String, dynamic>> scoreData = <Map<String, dynamic>>[].obs;

  //for checkbox btn
  RxBool isCheck = false.obs;
  var checkedMap = <String, bool>{}.obs;

  void toggleCheckBox(bool? val) {
    isCheck.value = val ?? false;
  }

  @override
  void onInit() {
    super.onInit();
    scrollController.addListener(() {
      if (scrollController.position.pixels >=
              scrollController.position.maxScrollExtent - 200 &&
          !isLoading.value &&
          !isMoreLoading.value &&
          hasMore.value) {
        isPagination(true);
        loadNextPage();
      }
    });
  }

  void scrollToBottom() {
    scrollController.animateTo(
      scrollController.position.maxScrollExtent + 50,
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeOut,
    );
  }

  void showRemarksBottomSheet(
    BuildContext context,
    Map<String, dynamic> part,
    String screenType,
  ) {
    final controller = Get.put(RemarksController());
    controller.fetchDropRemarks(screenType);
    String text = "Part No. ${part["part_number1"]}";
    showModalBottomSheet(
      context: context,
      isScrollControlled: true, // ✅ Allows keyboard to push sheet up
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: EdgeInsets.only(
              // ✅ Push sheet above keyboard
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            child: RemarksBottomSheet(
              titleText: text,
              item: part,
              screen: "v$screenType",
            ),
          ),
        );
      },
    );
  }

  var vehicleSuggestionList = [].obs;
  // API Call to fetch matching vehicle numbers
  Future<void> fetchVehicleSuggestions(String vehicleNum) async {
    if (vehicleNum.length < 4) {
      vehicleSuggestionList.clear();
      return;
    } else if (vehicleNum.isNotEmpty) {
      String dealerId = await AuthService.getDealerId();
      isVehicleSuggestionLoading.value = true;
      final response = await api.getVehicleSuggestion(
          dealerId: dealerId, vehicleNumber: vehicleNum); // API call function
      isVehicleSuggestionLoading.value = false;
      if (response['success']) {
        vehicleSuggestionList.value = response['data'];
      } else {
        vehicleSuggestionList.clear();
      }
    }
  }

  // Function to handle part number selection
  void selectPartNumber(String partNumber1) {
    searchController.text = partNumber1;
    vehicleSuggestionList.clear();
  }

  void reset() {
    errorMsg.value = null;
    // isCardStatusOther.value = null;
    vehicleSuggestionList.clear();
    vehicleData.clear();
    // groupedData.clear();
    isPagination(false);
    hasMore(true);
    showScrollButton(false);
    currentPage.value = 1;
    vehicleNumber.value = searchController.text.trim();
    toggleCheckBox(false);
  }

  Future<void> search() async {
    if (isLoading.value) return;
    if (formKey.currentState!.validate()) {
      // print('Searching: ${searchController.text}');
      bool checkInt = await CheckInternet.checkInternet();
      if (!checkInt) {
        errorMsg.value = "no Internet connection ";
        return NoInternetDialog.show();
      } else {
        reset();
        isLoading(true);
        await loadNextPage();
        isLoading(false);
      }
    }
  }

  String? dealerId;
  String? locationId;
  Future<void> loadNextPage() async {
    dealerId = await AuthService.getDealerId();
    locationId = await AuthService.getLocationId();
    // int tCode = await getIntData("tCode");
    String tCode = await AuthService.getTCode();
    final val2 = selectedValue2.value;
    String? jobCardStatus = (val2?.startsWith("Open") == true)
        ? "Open"
        : (val2?.startsWith("Close") == true)
            ? "Close"
            : null;

    // Issued or not: "1" / "0" / null
    final val1 = selectedValue1.value;
    String? issuedOrNot = (val1?.startsWith("Part issued") == true)
        ? "1"
        : (val1?.startsWith("Part not issued") == true)
            ? "0"
            : null;

    // Non‐stockable flag: "Y" / "N" / null
    // (Assuming you meant selectedValue3 for this; if it’s still selectedValue1, just replace val3 with val1)
    final val3 = selectedValue3.value;
    String? nonStockable = (val3 == "All time NS -Y")
        ? "Y"
        : (val3 == "All time NS -N")
            ? "N"
            : null;
    errorMsg.value = null;
    isMoreLoading(true);
    final response = await api.fetchVehicleData(
      userId: tCode.toString(),
      dealerId: dealerId!,
      locationId: locationId!,
      vehicleNo: vehicleNumber.value ?? "",
      jobCardStatus: jobCardStatus,
      issued: issuedOrNot,
      nonStockable: nonStockable,
      page: currentPage.value,
      limit: pageSize,
    );
    isMoreLoading(false);
    if (response['success']) {
      List<Map<String, dynamic>> data =
          List<Map<String, dynamic>>.from(response['data']);
      List<Map<String, dynamic>> score =
          List<Map<String, dynamic>>.from(response['score']);
      bool isHasMore = response['hasMore'];

      vehicleData.addAll(data);
      scoreData.value = score.cast<Map<String, dynamic>>();

      showScrollButton(true);
      if (!isHasMore || data.length < pageSize) {
        hasMore(false);
        showScrollButton(false);
      } else {
        currentPage.value++;
      }
    } else {
      final err = response['message'];
      if (isPagination.value) {
        Get.rawSnackbar(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          messageText: Center(
            child: Text(err, style: TextStyle(color: Colors.white)),
          ),
        );

        if (err == "Data not available") {
          hasMore(false);
          showScrollButton(false);
        }
      } else {
        errorMsg.value = err;
      }
    }
  }

  RxBool isCheckFinal = false.obs;
  RxBool isCheckSuccess = false.obs;
  RxBool isCheckLoading = false.obs;
  RxnString checkErr = RxnString();
  // var data = [].obs;

  Future<void> confirmToClose() async {
    // int tCode = await getIntData("tCode") ?? 0;
    String tCode = await AuthService.getTCode();
    checkErr(null);
    // // data.clear();
    isCheckSuccess(false);
    isCheckLoading(true);

    final response = await api.vehicleSearchCheckBox(
      vehicleNumber: vehicleNumber.value ?? "",
      dealerId: dealerId!,
      locationId: locationId!,
      userId: tCode,
    );
    isCheckLoading(false);
    if (response['success']) {
      toggleCheckBox(true);
      Get.back();
      GainerDialog.midPopUp(GainerImages.checkIcon, "Successfully Confirm");
    } else {
      toggleCheckBox(false);
      final err = response['message'];
      checkErr.value = err;
      Get.rawSnackbar(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        messageText: Center(
          child: Text(
            err,
            style: const TextStyle(color: Colors.white),
          ),
        ),
      );
    }
  }

  Future<bool?> showBottomSheet(
    BuildContext context,
    String partNumber,
    bool isReserved,
  ) {
    isReserved ? getReservedDetails(partNumber) : getGroupStock(partNumber);

    // RJ29GB1915
    //9554
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: DMAppColors.primary,
      builder: (context) {
        return isReserved
            ? const VehicleSearchReservedDetailsSheet()
            : const VehicleSearchGrpStockDetailsSheet();
      },
    );
  }

  RxnString grpStockError = RxnString();
  RxnString lastFSPart = RxnString();
  RxBool isLoadingGrpStock = false.obs;
  List<dynamic> grpFreeStockList = [].obs;
  Future<void> getGroupStock(String partNumber) async {
    final lastP = lastFSPart.value;
    if (lastP != null && lastP == partNumber) {
      if (grpFreeStockList.isNotEmpty) return;
    }
    lastFSPart.value = partNumber;
    isLoadingGrpStock(true);
    final response = await api.getGrpStockForVehicle(partNumber);
    isLoadingGrpStock(false);
    if (response['success']) {
      grpFreeStockList = (response['data'] as List)
          .where((item) => item['GroupFreeStock'] > 0)
          .toList();
    } else {
      grpFreeStockList.clear();
      grpStockError.value = response['message'];
    }
  }

  RxnString reservedDetailsError = RxnString();
  RxnString lastReservedPart = RxnString();
  RxBool isLoadingReservedDetails = false.obs;
  List<dynamic> reservedDetailsList = [].obs;
  Future<void> getReservedDetails(String partNumber) async {
    final lastP = lastReservedPart.value;
    if (lastP != null && lastP == partNumber) {
      if (reservedDetailsList.isNotEmpty) return;
    }
    lastReservedPart.value = partNumber;
    isLoadingReservedDetails(true);
    final response = await api.getPartReservedDetails(partNumber);
    isLoadingReservedDetails(false);
    if (response['success']) {
      reservedDetailsList = response['data'];
    } else {
      reservedDetailsList.clear();
      reservedDetailsError.value = response['message'];
    }
  }
}
