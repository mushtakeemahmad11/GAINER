import 'package:flutter/material.dart';
import 'package:gainer/dealer_monitoring/core/services/api_services.dart';
import 'package:gainer/gainer_app/core/Services/auth_service.dart';
import 'package:gainer/gainer_app/core/utils/check_internet.dart';
import 'package:get/get.dart';
import '../../gainer_app/routes/app_routes.dart';
import '../core/theme/app_colors.dart';
import '../core/utils/transform_value_ind.dart';
import '../screens/substitution_check/substitution_check_screen.dart';
import '../widgets/access_denied_snackbar.dart';
import '../widgets/no_internet_dialog.dart';

class PartStockCheckController extends GetxController {
  ApiServices api = ApiServices();
  TextEditingController searchController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  // final LocationController _locationController = Get.put(LocationController());
  // final SubstitutionCheckController _substitutionCheckController =
  //     Get.put(SubstitutionCheckController());

  RxBool isLoading = false.obs;
  RxBool partSearchLoading = false.obs;
  RxnString errorMessage = RxnString(null);

  RxMap<String, dynamic> partDetails = <String, dynamic>{}.obs;
  RxnString partStatus = RxnString(null);
  var max = 0.0.obs;
  var stock = 0.0.obs;
  List<Map<String, dynamic>> locationsList = <Map<String, dynamic>>[].obs;
  RxList groupStockList = [].obs;
  var reservedForVehicle = 0.0.obs;
  // RxInt groupStock = 0.obs;
  var groupStock = 0.0.obs;
  RxBool isSubstitute = false.obs;
  var partSuggestions = <String>[].obs; // List to store part number suggestions

  void reset() {
    errorMessage.value = null;
    partStatus.value = null;
    partSuggestions.clear();
    partDetails.clear();
    reservedForVehicle.value = 0.0;
    isSubstitute.value = false;
    groupStockList.clear();
    groupStock.value = 0.0;
    locationsList.clear();
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }

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
      // String brandId = await getStringData('brandID') ?? 0;
      // String brandId = await AuthService.getBrandId();
      partSearchLoading.value = true;
      final response = await api.searchPart(query); // API call function
      partSearchLoading.value = false;
      if (response['success']) {
        partSuggestions.value = response['data'];
      } else {
        partSuggestions.clear();
      }
    }
  }

  Future<void> search() async {
    if (isLoading.value) return;
    if (formKey.currentState!.validate()) {
      String partNumber = searchController.text;
      final bdl = await AuthService.getBDLId();
      String brandId = bdl['brandId'] ?? '';
      String dealerId = bdl['dealerId'] ?? '';
      String locationId = bdl['locationId'] ?? '';
      String tCode = await AuthService.getTCode();
      // String brandId = await getStringData("brandID");
      // String dealerId = await getStringData("dealerID");
      // String locationId = await getStringData("selectedLocationID");
      // int tCode = await getIntData("tCode");
      // print(
      //     "PartNumber: $partNumber DealerId: $dealerId, BrandId: $brandId, LocationId: $locationId");
      bool checkInt = await CheckInternet.checkInternet();
      if (!checkInt) {
        errorMessage.value = "no Internet connection ";
        return NoInternetDialog.show();
      }

      reset();
      isLoading.value = true;
      final response = await api.getPartStock(
        brandId: brandId,
        dealerId: dealerId,
        locationId: locationId,
        partNumber: partNumber,
        userId: tCode,
      );
      isLoading.value = false;
      if (response['success']) {
        final data = response['data'];
        partDetails.value = data['Details'][0];

        // print("Norms:: ${data['Norms']}");
        // print("Norms:: ${data['Norms'].isNotEmpty}");
        if (data['Norms'].isNotEmpty) {
          max.value = (data['Norms'] as List)
              .map((item) => (item['Maxvalue'] ?? 0.0 as num).toDouble())
              .fold(0.0, (sum, qty) => sum + qty);
        } else {
          max.value = 0.0;
        }
        if (data['Stock'].isNotEmpty) {
          stock.value = (data['Stock'] as List)
              .map((item) => (item['Qty'] ?? 0.0 as num).toDouble())
              .fold(0.0, (sum, qty) => sum + qty);
        } else {
          stock.value = 0.0;
        }
        reservedForVehicle.value = (data['Reserved'] != null &&
                data['Reserved'] is List &&
                data['Reserved'].isNotEmpty)
            ? data['Reserved'][0]['ReservedforVehicle'].toDouble() ?? 0.0
            : 0.0;

        isSubstitute.value = data["Substitutes"].length > 1;
        //0105ZAW00211N true
        //0108AAW00390N false
        if ((data['Group'] != null &&
            data['Group'] is List &&
            data['Group'].isNotEmpty)) {
          groupStockList.value = data['Group'];
        } else {
          groupStockList.value = [];
          partStatus.value = "Non-Stockable"; //if location stock not available
        }

        groupStock.value = 0.0;
        locationsList = groupStockList
            .map((item) {
              final status = item["Partstatus"] ?? "null";
              final type =
                  ["Non-Stockable", "Stockable", "Non-Moving"].contains(status)
                      ? status
                      : "null";

              if (item['LocationID'] == locationId) partStatus.value = status;

              final value = (item['GroupStock'] ?? 0) as num;
              groupStock.value += value.toDouble();

              // ⏪ Early return null if stock is zero or less
              if (value <= 0) return null;

              return {
                "Location": item["location"],
                "stockdate": TransformValue()
                    .formatDateToIndianDate(item["Stockdate"] ?? "", day: true),
                "qty": item["GroupStock"],
                "type": type,
              };
            })
            .whereType<Map<String, dynamic>>()
            .toList();
        // locationsList = groupStockList.map((item) {
        //   final status = item["Partstatus"] ?? "null";
        //   final type =
        //       ["Non-Stockable", "Stockable", "Non-Moving"].contains(status)
        //           ? status
        //           : "null";
        //   if (item['LocationID'] == locationId) {
        //     partStatus.value = status;
        //   }
        //   var value = (item['GroupStock'] ?? 0) as num;
        //   groupStock.value += value.toDouble();
        //   return {
        //     "Location": item["location"],
        //     "stockdate": TransformValue()
        //         .formatDateToIndianDate(item["Stockdate"] ?? "", day: true),
        //     "qty": item["GroupStock"],
        //     "type": type,
        //   };
        // }).toList();
        if (partStatus.value == null) {
          partStatus.value = "Non-Stockable";
        }
        partSuggestions.clear();
      } else {
        partDetails.clear();
        partSuggestions.clear();
        errorMessage.value = response['message'];
      }
    }
  }

  void onTapSubstitutionCheck() {
    Get.to(
      () => Scaffold(
        appBar: AppBar(
          backgroundColor: DMAppColors.secondary,
          title: Text("Substitution Check"),
        ),
        body: SafeArea(
          child: SubstitutionCheckScreen(),
        ),
      ),
      arguments: {
        "partNumber": searchController.text,
      },
    );
  }

  Future<void> onTapGainerStockCheck() async {
    // final String userRole = await getStringData("userRole");
    final String userRole = await AuthService.getUserRole();
    if (userRole == 'workshop advisor' || userRole == 'sales executive') {
      DealerSnackbar.showAccessDenied('you cannot access Gainer Stock Check');
    } else {
      // print("You are in onTapGainerStockCheck");
      Get.toNamed(
        Routes.PARTREQUESTVIEW,
        arguments: {'part': searchController.text, 'isDealer': true},
      );
      // Get.to(
      //     () => Scaffold(
      //           appBar: AppBar(title: Text("Gainer Stock Check")),
      //           body: SafeArea(child: PartRequestScreen()),
      //         ),
      //     arguments: {
      //       "partNumber": searchController.text,
      //     },
      // );
    }
  }
}
