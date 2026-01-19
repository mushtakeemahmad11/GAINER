import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../gainer/apis_functionality/api_service.dart';
import '../../gainer/controllers/check_internet/no_internet_screen.dart';
import '../../gainer/controllers/home_screen_controller.dart';
import '../../gainer/screens/check_internet/check_internet_connectivity.dart';
import '../../gainer/shared_preferences/shared_preferences_get_data.dart';
import '../core/services/api_services.dart';

class OrderInfoController extends GetxController {
  ApiServices api = ApiServices();
  TextEditingController searchController = TextEditingController();
  // TextEditingController pickDateController = TextEditingController();
  final LocationController _locationController = Get.put(LocationController());
  // final TextEditingController fromDateController = TextEditingController();
  // final TextEditingController toDateController = TextEditingController();

  var selectedOption = "View Last 7 Days".obs;

  var fromDate = Rxn<DateTime>();
  var toDate = Rxn<DateTime>();
  RxBool isLoading = false.obs;
  // RxBool isCustom = false.obs;
  RxnString error = RxnString(null);
  final RxMap<String, dynamic> data = <String, dynamic>{}.obs;
  final RxMap<String, dynamic> orderDetails = <String, dynamic>{}.obs;
  RxList orderInfo = [].obs;
  var stock = 0.0.obs;
  var ooq = 0.0.obs;

  RxBool partSearchLoading = false.obs;
  var partSuggestions = <String>[].obs;
  // Function to handle part number selection
  void selectPartNumber(String partNumber) {
    searchController.text = partNumber;
    partSuggestions.clear();
  }

  // API Call to fetch matching part numbers
  Future<void> fetchPartSuggestions(String query) async {
    if (query.length < 5) {
      partSuggestions.clear();
      return;
    } else if (query.isNotEmpty) {
      String brandId = await getStringData('brandID') ?? 0;
      partSearchLoading.value = true;
      final response =
          await ApiService().searchPart(query, brandId); // API call function
      partSearchLoading.value = false;
      if (response['success']) {
        partSuggestions.value = response['data'];
      } else {
        partSuggestions.clear();
      }
    }
  }

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  Future<void> onSearch() async {
    if (isLoading.value) return;
    if (formKey.currentState!.validate()) {
      String partNumber = searchController.text;
      var stockDetails = _locationController.stockDetails;
      String brandId = stockDetails['BrandID'].toString();
      String dealerId = stockDetails['DealerID'].toString();
      String locationId = stockDetails['LocationID'].toString();
      int tCode = await getIntData("tCode");
      bool checkInt = await checkInternet();
      if (!checkInt) {
        error.value = "no Internet connection ";
        return internetNotAvl();
      }
      final now = DateTime.now();
      // String onlyDateFrom =
      //     DateFormat('yyyy-MM-dd').format(fromDate.value ?? now);
      // String onlyDateTo = DateFormat('yyyy-MM-dd')
      //     .format(toDate.value ?? now.subtract(Duration(days: 7)));

      String onlyDateFrom = DateFormat('yyyy-MM-dd')
          .format(fromDate.value ?? now.subtract(Duration(days: 7)));
      String onlyDateTo = DateFormat('yyyy-MM-dd').format(toDate.value ?? now);
      partSuggestions.clear();
      error.value = null;
      isLoading.value = true;
      data.clear();
      final response = await api.getOrderInfo(
        dealerId: dealerId,
        brandId: brandId,
        locationId: locationId,
        partNumber: partNumber,
        uDate: onlyDateTo,
        lDate: onlyDateFrom,
        userId: tCode.toString(),
      );
      isLoading.value = false;
      if (response['success']) {
        if (response['data'] != null) {
          data.value = Map<String, dynamic>.from(response['data']);

          orderDetails.assignAll(data['Details'][0]);
          if (orderDetails.isNotEmpty) {
            if ((data['Orders'] != null &&
                data['Orders'] is List &&
                data['Orders'].isNotEmpty)) {
              orderInfo.value = data['Orders'];
              ooq.value = orderInfo[0]['ooq'].toDouble();
            }else{
              orderInfo.value = [];
            }
            if (data['Stock'].isNotEmpty) {
              stock.value = (data['Stock'] as List)
                  .map((item) => (item['Qty'] as num).toDouble())
                  .fold(0.0, (sum, qty) => sum + qty);
            }else {
              stock.value = 0.0;
            }
          }
        } else {
          error.value = "Order information not available";
        }
      } else {
        error.value = response['message'];
      }
    }
  }

  void setDateRange(String option) {
    selectedOption.value = option;
    final now = DateTime.now();

    switch (option) {
      case "View Last 7 Days":
        fromDate.value = now.subtract(Duration(days: 7));
        toDate.value = now;
        break;
      case "View Last 15 Days":
        fromDate.value = now.subtract(Duration(days: 15));
        toDate.value = now;
        break;
      case "View Last 30 Days":
        fromDate.value = now.subtract(Duration(days: 30));
        toDate.value = now;
        break;
      case "View Last 60 Days":
        fromDate.value = now.subtract(Duration(days: 60));
        toDate.value = now;
        break;
      // case "View Last order Details":
      //   fromDate.value = now;
      //   toDate.value = now;
      //   break;
      // case "Custom View":
      // // Let user pick dates
      //   fromDate.value = null;
      //   toDate.value = null;
      //   break;
      default:
        // fromDate.value = now;
        fromDate.value = now.subtract(Duration(days: 7));
        toDate.value = now;
    }
  }

  String formatDate(String dateStr) {
    final DateTime utcDate =
        DateTime.parse(dateStr).toLocal(); // Convert to local time (Z+5:30H)
    final DateFormat formatter = DateFormat('MMM dd yyyy  h:mma');
    return formatter.format(utcDate); // Example: Apr 18 2025  1:38PM
  }

  // void updateFromDate(DateTime date) {
  //   fromDate.value = date;
  // }
  //
  // void updateToDate(DateTime date) {
  //   toDate.value = date;
  // }

  // Future<void> selectDate({
  //   required BuildContext context,
  //   required bool isFrom,
  // }) async {
  //   final DateTime now = DateTime.now();
  //   final DateTime? picked = await showDatePicker(
  //     context: context,
  //     initialDate: isFrom ? (_fromDate ?? now) : (_toDate ?? now),
  //     firstDate: DateTime(2000),
  //     lastDate: DateTime(2100),
  //   );
  //
  //   if (picked != null) {
  //     if (isFrom) {
  //       _fromDate = picked;
  //       fromDateController.text = _formatDate(picked);
  //     } else {
  //       _toDate = picked;
  //       toDateController.text = _formatDate(picked);
  //     }
  //   }
  // }

  // String _formatDate(DateTime date) {
  //   return "${date.day.toString().padLeft(2, '0')}-"
  //       "${date.month.toString().padLeft(2, '0')}-"
  //       "${date.year}";
  // }
}
