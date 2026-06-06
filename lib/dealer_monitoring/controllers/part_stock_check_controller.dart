import 'package:flutter/material.dart';
import 'package:gainer/dealer_monitoring/core/services/dm_api_services.dart';
import 'package:gainer/gainer_app/core/Services/auth_service.dart';
import 'package:gainer/gainer_app/core/utils/check_internet.dart';
import 'package:gainer/gainer_app/core/widgets/scrollable_text_widget.dart';
import 'package:get/get.dart';
import '../../gainer_app/routes/app_routes.dart';
import '../core/theme/app_colors.dart';
import '../core/utils/transform_value_ind.dart';
import '../screens/substitution_check/substitution_check_screen.dart';
import '../widgets/access_denied_snackbar.dart';
import '../widgets/no_internet_dialog.dart';

class PartStockCheckController extends GetxController {
  DMApiServices api = DMApiServices();
  TextEditingController searchController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

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
  RxList reservedDetails = [].obs;
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
        _norms(data);
        _stock(data);
        _reserved(data);

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

              // final value = (item['GroupStock'] ?? 0) as num;
              final value = (item['GroupFreeStock'] ?? 0) as num;
              groupStock.value += value.toDouble();

              // ⏪ Early return null if stock is zero or less
              if (value <= 0) return null;

              return {
                // "Location": item["location"],
                "Location": item["Location"],
                "stockdate": TransformValue()
                    .formatDateToIndianDate(item["StockDate"] ?? "", day: true),
                // "qty": item["GroupStock"],
                "qty": item["GroupFreeStock"],
                "type": type,
              };
            })
            .whereType<Map<String, dynamic>>()
            .toList();
        if (locationsList.isNotEmpty) {
          locationsList.insert(0, {
            "Location": 'Location',
            "stockdate": 'Stock Date',
            "qty": 'Grp Free Stock',
            "type": 'null',
          });
        }
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

  void _norms(final data) {
    if (data['Norms'].isNotEmpty) {
      max.value = (data['Norms'] as List)
          .map((item) => (item['Maxvalue'] ?? 0.0 as num).toDouble())
          .fold(0.0, (sum, qty) => sum + qty);
    } else {
      max.value = 0.0;
    }
  }

  void _stock(final data) {
    if (data['Stock'].isNotEmpty) {
      stock.value = (data['Stock'] as List)
          .map((item) => (item['Qty'] ?? 0.0 as num).toDouble())
          .fold(0.0, (sum, qty) => sum + qty);
    } else {
      stock.value = 0.0;
    }
  }

  void _reserved(final data) {
    // reservedForVehicle.value = (data['Reserved'] != null &&
    //         data['Reserved'] is List &&
    //         data['Reserved'].isNotEmpty)
    //     ? data['Reserved'][0]['ReservedforVehicle'].toDouble() ?? 0.0
    //     : 0.0;

    if (data['Reserved'] != null && data['Reserved'] is List
        // data['Reserved'].isNotEmpty) {
        ) {
      reservedDetails.value = data['Reserved'];
      // reservedDetails.value = [
      //   {
      //     "Location": "Alwar",
      //     "Vehiclenumber": "25BH9436D",
      //     "Advisor": "VishakhaKatariya",
      //     "ReservedforVehicle": 1,
      //     "SCS_Submit_Date": "2026-05-06T17:00:08.683Z",
      //     "final_close": "Close" //For close job card
      //   },
      //   {
      //     "Location": "Bareilly",
      //     "Vehiclenumber": "25BH90000",
      //     "Advisor": "Mushtakeem-Ahmad",
      //     "ReservedforVehicle": 5,
      //     "SCS_Submit_Date": "2026-05-06T17:00:08.683Z",
      //     "final_close": "N", //for Open job card
      //   },
      //   {
      //     "Location": "Bareilly",
      //     "Vehiclenumber": "25BH90000",
      //     "Advisor": "Mushtakeem-Ahmad",
      //     "ReservedforVehicle": 35,
      //     "SCS_Submit_Date": "2026-05-06T17:00:08.683Z",
      //     "final_close": "N", //for Open job card
      //   }
      //
      //   // {
      //   //   "Vehiclenumber": "RJ14UK7947",
      //   //   "Advisor": "JitendraSharma",
      //   //   "ReservedforVehicle": 10
      //   // },
      //   // {
      //   //   "Vehiclenumber": "RJ14UK1234",
      //   //   "Advisor": "MushtakeemAhmad",
      //   //   "ReservedforVehicle": 12
      //   // },
      //   // {
      //   //   "Vehiclenumber": "RJ14UK0987",
      //   //   "Advisor": "MA-Sparecare",
      //   //   "ReservedforVehicle": 14
      //   // }
      // ];

      reservedForVehicle.value = (reservedDetails).fold(
        0.0,
        (sum, d) => sum + ((d['ReservedforVehicle'] ?? 0.0) as num).toDouble(),
      );
    }
  }

  void showReservedDetails() {
    List data = reservedDetails;
    Get.bottomSheet(
      // backgroundColor: DMAppColors.primary,
      DraggableScrollableSheet(
        initialChildSize: 0.5,
        maxChildSize: 0.9,
        minChildSize: 0.3,
        builder: (BuildContext context, ScrollController scrollController) {
          return SafeArea(
            child: Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                // color: Colors.white,
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Header
                  Text(
                    "Reserved Details",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Container(
                    height: 4,
                    decoration: BoxDecoration(
                        color: Colors.black12,
                        borderRadius: BorderRadius.circular(50)),
                    width: 100,
                  ),
                  SizedBox(height: 10),

                  // List
                  Expanded(
                    child: ListView.builder(
                      controller: scrollController,
                      shrinkWrap: true,
                      itemCount: data.length,
                      itemBuilder: (context, index) {
                        final item = data[index];
                        final bool jobCardStatus = item['final_close'] == 'N';
                        return Container(
                          margin: EdgeInsets.symmetric(vertical: 6),
                          padding: EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            // color: Colors.grey.shade100,
                            color: DMAppColors.surface,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.directions_car,
                                  color: DMAppColors.secondary),
                              SizedBox(width: 10),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    ScrollableTextWidget(
                                      textWidget: Row(
                                        children: [
                                          Text('Vehicle Num  :  '),
                                          Text(
                                            item["Vehiclenumber"],
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 14,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    ScrollableTextWidget(
                                      textWidget: Row(
                                        children: [
                                          Text('Advisor Name:  '),
                                          Text(
                                            item["Advisor"],
                                            style:
                                                TextStyle(color: Colors.grey),
                                          ),
                                        ],
                                      ),
                                    ),
                                    ScrollableTextWidget(
                                      textWidget: Row(
                                        children: [
                                          Text('Location:  '),
                                          Text(
                                            item["Location"],
                                            style:
                                                TextStyle(color: Colors.grey),
                                          ),
                                        ],
                                      ),
                                    ),
                                    ScrollableTextWidget(
                                      textWidget: Row(
                                        children: [
                                          Text('Approval Date:  '),
                                          Text(
                                            TransformValue()
                                                .formatDateToIndianDate(
                                                    item["SCS_Submit_Date"],
                                                    day: true),
                                            style:
                                                TextStyle(color: Colors.grey),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Text(
                                      jobCardStatus
                                          ? "Job Card Open"
                                          : "Job Card Closed",
                                      style: TextStyle(
                                          color: jobCardStatus
                                              ? Colors.green
                                              : Colors.red),
                                    )
                                  ],
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 5),
                                decoration: BoxDecoration(
                                  color: DMAppColors.secondary,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  "${item["ReservedforVehicle"]}",
                                  style: TextStyle(color: Colors.white),
                                ),
                              )
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
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
