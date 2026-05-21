import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:gainer/dealer_monitoring/widgets/no_internet_dialog.dart';
import 'package:gainer/gainer_app/core/Services/auth_service.dart';
import 'package:gainer/gainer_app/core/utils/check_internet.dart';
import 'package:gainer/gainer_app/core/widgets/gainer_dialog.dart';
import 'package:get/get.dart';
import '../../gainer_app/core/constants/gainer_image.dart';
import '../../gainer_app/core/widgets/scrollable_text_widget.dart';
import '../core/services/dm_api_services.dart';
import '../core/theme/app_colors.dart';
import '../widgets/remarks_bottom_sheet.dart';

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
  // RxnString isCardStatusOther = RxnString(null);

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
    // final controller = Get.put(RemarksController(), permanent: false);
    final controller = Get.put(RemarksController());
    controller.fetchDropRemarks(screenType);
    String text = "Part No. ${part["part_number1"]}";
    showModalBottomSheet(
      context: context,
      isScrollControlled: true, // ✅ Allows keyboard to push sheet up
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            // ✅ Push sheet above keyboard
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: RemarksBottomSheet(
            titleText: text,
            item: part,
            screen: "v$screenType",
          ),
        );
      },
    );
  }

  // void showRemarksBottomSheet(BuildContext context, String number) {
  //   showModalBottomSheet(
  //     context: context,
  //     shape: const RoundedRectangleBorder(
  //       borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
  //     ),
  //     builder: (_) => RemarksBottomSheet(number: number),
  //   );
  // }

  var vehicleSuggestionList = [].obs;
  // API Call to fetch matching vehicle numbers
  Future<void> fetchVehicleSuggestions(String vehicleNum) async {
    if (vehicleNum.length < 4) {
      vehicleSuggestionList.clear();
      return;
    } else if (vehicleNum.isNotEmpty) {
      // String dealerId = await getStringData('dealerID') ?? 0;
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
        // for vehicle search log
        // int tCode = await getIntData("tCode") ?? 0;
        // await Future.wait([
        //   api.vehicleSearchLog(
        //     vehicleNumber: vehicleNumber.value?.trim() ?? "",
        //     userId: tCode.toString(),
        //   ),
        //   loadNextPage(),
        // ]);
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

    // if (response['success']) {
    //   List<Map<String, dynamic>> data =
    //       List<Map<String, dynamic>>.from(response['data']);
    //   List<Map<String, dynamic>> score =
    //       List<Map<String, dynamic>>.from(response['score']);
    //   bool isHasMore = response['hasMore'];
    //   print("HasMore:: $isHasMore");
    //   // final List<Map<String, dynamic>> newData =
    //   // List<Map<String, dynamic>>.from(result['data']);
    //   // vehicleData.addAll(newData);
    //
    //   print("dataaa: $data");
    //   // vehicleData.value = data.cast<Map<String, dynamic>>();
    //   vehicleData.addAll(data);
    //   scoreData.value = score.cast<Map<String, dynamic>>();
    //
    //   final formatedData = groupByJobCard(data);
    //   // final formatedData = data;
    //   // To replace all entries:
    //   print("foramttted:   $formatedData, ${data.length} ${data.isNotEmpty}");
    //   groupedData.addAll(formatedData);
    //
    //   if (formatedData.isEmpty && data.isNotEmpty) {
    //     isCardStatusOther.value = "No vehicle found";
    //   }
    //
    //   // if (newData.length < pageSize) {
    //   if (!isHasMore) {
    //     hasMore.value = false;
    //   } else {
    //     currentPage.value++;
    //   }
    // } else {
    //   Get.snackbar("Error", response['message']);
    //   hasMore.value = false;
    // }
    // isLoading.value = false;
  }

// // for get Dates
  // Future initWork() async {
  //   String dealerID = await getStringData("dealerID");
  //   String locationId = await getStringData("selectedLocationID");
  //   final responseDate = await api
  //       .getStockDate(dealerId: dealerID, locationId: locationId);
  //   if (responseDate['success']) {
  //     print("ResponseDate in Vehicle Search: $responseDate");
  //     final data = responseDate['data'];
  //     // Find the entry where source == 'stock'
  //     // String? stockDate = data.firstWhere(
  //     //       (item) => item['source'] == 'stock',
  //     //   orElse: () => {}, // Return empty map if not found
  //     // )['latest_date'];
  //     // print("date: $stockDate");
  //
  //     stockDate.value =
  //         TransformValue().formatToReadableDate(data[0][0]['StockDate']);
  //     jobLineDate.value =
  //         TransformValue().formatToReadableDate(data[1][0]['JoblineCloseDate']);
  //     jobCardDate.value =
  //         TransformValue().formatToReadableDate(data[2][0]['JobCardCloseDate']);
  //
  //     // final raw = "2025-07-17T18:39:20.200Z";
  //     //
  //     // print("DateTime IST full: ${TransformValue().formatToIST(raw)}");
  //     // print("Only IST Date: ${TransformValue().formatISTDateOnly(raw)}");
  //     print("jobCardDate Date: ${jobCardDate.value}");
  //   }
  // }

  /// Transforms the raw list into a grouped-by-vehicle structure:
//   List<Map<String, dynamic>> groupByJobCard(List<Map<String, dynamic>> raw) {
//     //filtered data only work on open and close jobCardStatus
//     // final filtered = raw.where((entry) {
//     //   final status = entry['current_status']?.toString().toLowerCase();
//     //   return status == 'close' || status == 'open'; //show only
//     // }).toList();
//     final filtered = raw.where((entry) {
//       final status = entry['Final_close']?.toString().toLowerCase();
//       return status == 'close' || status == 'open'; //show only
//     }).toList();
//
//     // 1) Create a map from jobcard_number → List of that jobcard’s entries
//     final Map<String, List<Map<String, dynamic>>> groupedMap = {};
//
//     for (final entry in filtered) {
//       final String jobcard = entry['jobcard_number'] as String;
//       groupedMap.putIfAbsent(jobcard, () => []);
//       groupedMap[jobcard]!.add(entry);
//     }
//
//     // 2) Build the final List by iterating over each group
//     final List<Map<String, dynamic>> result = [];
//     groupedMap.forEach((jobcard, entries) {
//       // Sum up all "Value" fields in this group
//       double totalValue = entries.fold(
//         0.0,
//         (sum, e) => sum + ((e['Value'] as num).toDouble()),
//       );
//
//       /// checking issued or not issued value
//       final issueStatusValue = entries.fold<Map<String, double>>(
//         {
//           'issuedValue': 0.0,
//           'notIssuedValue': 0.0,
//         },
//         (acc, e) {
//           final value = (e['Value'] as num).toDouble();
//           final status = e['IssueStatus'];
//
//           if (status == "Issued") {
//             acc['issuedValue'] = acc['issuedValue'] ?? 0 + value;
//           } else if (status == "Not Issued") {
//             acc['notIssuedValue'] = acc['notIssuedValue'] ?? 0 + value;
//           }
//
//           return acc;
//         },
//       );
//
// // Access the values
//       final double issuedValue = issueStatusValue['issuedValue']!;
//       final double notIssuedValue = issueStatusValue['notIssuedValue']!;
//       // print(
//       //     "Total Value: $totalValue, issuedValue: $issuedValue, notIssuedValue: $notIssuedValue");
//
//       ///
//
//       // Pick current_status from the first entry (assumes all have same status)
//       // final String status = entries.first['current_status'] as String? ?? '';
//       final String status = entries.first['Final_close'] as String? ?? '';
//
//       // Build the parts list
//       final List<Map<String, dynamic>> partsList = entries.map((e) {
//         return {
//           'partNumber': e['part_number1'],
//           'description': e['partdesc'],
//           'category': e['category'],
//           'ndp': (e['Price'] ?? 0 as num).toDouble(),
//           'qty': e['Qty'] ?? 0,
//           'stockQty': e['StockQty'] ?? 0,
//           'ppniQty': e['PPNI_Qty'] ?? 0,
//           'value': (e['Value'] ?? 0 as num).toDouble(),
//           'All_Time_NonStck': e['All_Time_NonStck'] ?? "",
//           'IssueStatus': e['IssueStatus'] ?? "",
//           'orderDate': e['OrderDate'] ?? "",
//           // 'orderDate': TransformValue().formatDateToIndia(e['OrderDate'] ?? "") ?? "",
//         };
//       }).toList();
//
//       result.add({
//         'jobcard_number': jobcard,
//         'totalValue': totalValue,
//         'currentStatus': status,
//         'parts': partsList,
//       });
//     });
//
//     return result;
//   }
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
    // final response = await api.checkJobcard(
    //   vehicleNumber: vehicleNumber.value ?? "",
    //   userId: tCode.toString(),
    // );
    final response = await api.vehicleSearchCheckBox(
      vehicleNumber: vehicleNumber.value ?? "",
      dealerId: dealerId!,
      locationId: locationId!,
      userId: tCode,
    );
    // print(response);
    isCheckLoading(false);
    if (response['success']) {
      toggleCheckBox(true);
      // data.value = response['data'];
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
}
