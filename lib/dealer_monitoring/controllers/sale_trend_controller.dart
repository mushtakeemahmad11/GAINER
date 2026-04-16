import 'package:flutter/material.dart';
import 'package:gainer/gainer_app/core/utils/check_internet.dart';
import 'package:get/get.dart';
import '../../gainer_app/core/Services/auth_service.dart';
import '../core/services/api_services.dart';
import '../widgets/no_internet_dialog.dart';

class SaleTrendController extends GetxController {
  ApiServices api = ApiServices();
  final TextEditingController searchController = TextEditingController();
  // final LocationController _locationController = Get.put(LocationController());
  // RxnString selectedSaleType = RxnString(null);
  RxString selectedSaleType = "WorkShop Sale".obs;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  RxMap<String, dynamic> partDetails = <String, dynamic>{}.obs;

  RxList<dynamic> partFamily = <dynamic>[].obs;
  var stock = 0.0.obs;
  var max = 0.0.obs;
  RxString finalStatus = ''.obs;
  RxList<String> xLabelMonth = <String>[].obs;
  // RxList<Map<dynamic, dynamic>> partDetails = <Map<dynamic, dynamic>>[].obs;
  RxBool isLoading = false.obs;
  RxnString error = RxnString(null);
  RxnString graphError = RxnString(null);
  // Store last 3-month data
  RxMap<String, double> last3 = <String, double>{}.obs;
  // Store last 6-month data
  RxMap<String, double> last6 = <String, double>{}.obs;

  RxString showLast3 = "0".obs;
  RxString showLast6 = "0".obs;

  // Reactive list for chart data (ws + cs)
  RxList<Map<String, double>> combinedChartData = <Map<String, double>>[].obs;
  RxList<Map<String, double>> chartData = <Map<String, double>>[].obs;

  reset() {
    partDetails.clear();
    partSuggestions.clear();
    chartData.value = [];
    error.value = null;
    max.value = 0.0;
    stock.value = 0.0;
    partFamily.clear();
    combinedChartData.clear();
  }

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
      // String brandId = await getStringData('brandID') ?? 0;
      // String brandId = await getStringData('brandID') ?? 0;
      partSearchLoading.value = true;
      final response =
          await api.searchPart(query); // API call function
      partSearchLoading.value = false;
      if (response['success']) {
        partSuggestions.value = response['data'];
      } else {
        partSuggestions.clear();
      }
    }
  }

  ///search part
  Future<void> search() async {
    if (isLoading.value) return;
    if (formKey.currentState!.validate()) {
      String partNumber = searchController.text;
      // var stockDetails = _locationController.stockDetails;
      // String brandId = stockDetails['BrandID'].toString();
      // String dealerId = stockDetails['DealerID'].toString();
      // String locationId = stockDetails['LocationID'].toString();
      // int tCode = await getIntData("tCode");
      final bdl = await AuthService.getBDLId();
      String brandId = bdl['brandId'] ?? '';
      String dealerId = bdl['dealerId'] ?? '';
      String locationId = bdl['locationId'] ?? '';
      String tCode = await AuthService.getTCode();
      bool checkInt = await CheckInternet.checkInternet();
      if (!checkInt) {
        error.value = "no Internet connection ";
        return NoInternetDialog.show();
      }

      // final response = await ApiServices().getPartDetails(
      //   brandId: brandId,
      //   dealerId: dealerId,
      //   locationId: locationId,
      //   partNumber: partNumber,
      // );

      reset();
      isLoading.value = true;
      final response = await api.getPartSale(
        brandId: brandId,
        dealerId: dealerId,
        locationId: locationId,
        partNumber: partNumber,
        userId: tCode.toString(),
      );
      isLoading.value = false;
      // if (response['success']) {
      //   print("Response of success getPartDetails: ${response['data']}");
      //   // partDetails = response['data'];
      //   partDetails.value = List<Map>.from(response['data']);
      //   // partDetails.addAll(List<Map>.from(response['data']));
      // } else {
      //   print("Response of failure $response");
      //   errorMessage.value = response['message'];
      // }

      if (response['success']) {
        final data = response['data'];
        partDetails.value = data['Details'][0];
        // if (data['Norms'].isNotEmpty) {
        //   max.value = data['Norms']
        //       .map((item) => item['Maxvalue'])
        //       .fold(0, (sum, qty) => sum + (qty ?? 0));
        // }
        // if (data['Stock'].isNotEmpty) {
        //   stock.value = data['Stock']
        //       .map((item) => item['Qty'])
        //       .fold(0, (sum, qty) => sum + (qty ?? 0));
        // }
        if (data['Norms'].isNotEmpty) {
          max.value = (data['Norms'] as List)
              .map((item) => (item['Maxvalue'] as num).toDouble())
              .fold(0.0, (sum, qty) => sum + qty);
        } else {
          max.value = 0.0;
        }
        if (data['Stock'].isNotEmpty) {
          stock.value = (data['Stock'] as List)
              .map((item) => (item['Qty'] as num).toDouble())
              .fold(0.0, (sum, qty) => sum + qty);
        } else {
          stock.value = 0.0;
        }
        // if (data['Norms'].isNotEmpty) {
        //   max.value = data['Norms'][0]['Maxvalue'];
        // }
        // if (data['Stock'].isNotEmpty) {
        //   stock.value = data['Stock'][0]['Qty'];
        // }
        partFamily.value = data['PartFamily'];

        final stockColor = data['StockColor'];

        if (stockColor.any((p) => p['Partstatus'] == 'Stockable')) {
          finalStatus.value = 'Stockable';
        } else if (stockColor.any((p) => p['Partstatus'] == 'Non-Moving')) {
          finalStatus.value = 'Non-Moving';
        } else {
          finalStatus.value = 'Non-Stockable';
          // finalStatus.value = '';
        }
        final sales = data['Sales'];
        // final chartData = extractMonthlySales(sales[0]);
        final matchedItem = sales.firstWhere(
          (item) => item['partnumber'] == partNumber,
          orElse: () => {},
        );
        // final stockColor = data['StockColor'];
        // if (stockColor.any((p) => p['PartStatus'] == 'Stockable')) {
        //   finalStatus.value = 'Stockable';
        // } else if (stockColor.every((p) => p['PartStatus'] == 'Non-Moving')) {
        //   finalStatus.value = 'Non-Moving';
        // } else {
        //   finalStatus.value = 'Non-Stockable';
        // }
        // print("StockColor ${stockColor.value}");
        // print("Color:: ${finalStatus.value}");

        // bool isSaleZero = matchedItem;
        if (matchedItem.isNotEmpty) {
          final chartData = extractMonthlySales(matchedItem);
          // print("chartData: $chartData");
          // Check if all values are 0.0
          final allZero = chartData['chartData'].every((item) =>
              (item["ws"] == 0.0 || item["ws"] == 0) &&
              (item["cs"] == 0.0 || item["cs"] == 0));
          if (!allZero) {
            combinedChartData.value = chartData['chartData'];
            xLabelMonth.value = chartData['months'];
            last3.assignAll(Map<String, double>.from(chartData['last3']));
            last6.assignAll(Map<String, double>.from(chartData['last6']));
          } else {
            graphError.value = "Data not available";
          }
        } else {
          graphError.value = "Data not available";
        }
      } else {
        error.value = response['message'];
        // errorMessagePartSale.value = response['message'];
      }
    }
  }

  // Map<String, dynamic> extractMonthlySales(Map<String, dynamic> item) {
  //   final Map<String, Map<String, double>> monthSales = {};
  //   final Set<String> monthSet = {}; // to preserve insertion order without duplicates
  //
  //   item.forEach((key, value) {
  //     if (key.contains('_WS') || key.contains('_CS')) {
  //       final parts = key.split('_'); // e.g., ["Apr", "25", "WS"]
  //       if (parts.length >= 3) {
  //         final month = parts[0]; // "Apr"
  //         final type = parts[2].toLowerCase(); // "ws" or "cs"
  //
  //         monthSet.add(month); // auto-track the month
  //
  //         monthSales.putIfAbsent(month, () => {'ws': 0.0, 'cs': 0.0});
  //         monthSales[month]![type] = double.tryParse(value.toString()) ?? 0.0;
  //       }
  //     }
  //   });
  //
  //   final List<String> months = monthSet.toList();
  //
  //   final List<Map<String, double>> chartData = months.map((month) {
  //     final sales = monthSales[month] ?? {'ws': 0.0, 'cs': 0.0};
  //     return {
  //       'ws': sales['ws']!,
  //       'cs': sales['cs']!,
  //     };
  //   }).toList();
  //
  //   return {
  //     'months': months,
  //     'chartData': chartData,
  //   };
  // }

  Map<String, dynamic> extractMonthlySales(Map<String, dynamic> item) {
    final Map<String, Map<String, double>> monthSales = {};
    final List<String> orderedMonths = [];

    item.forEach((key, value) {
      if (key.contains('_WS') || key.contains('_CS')) {
        final parts = key.split('_'); // e.g., ["Apr", "25", "WS"]
        if (parts.length >= 3) {
          // final month = '${parts[0]}_${parts[1]}'; // "Apr_25"
          final month = parts[0]; // "Apr"
          final type = parts[2].toLowerCase(); // "ws" or "cs"

          if (!orderedMonths.contains(month)) {
            orderedMonths.add(month);
          }

          monthSales.putIfAbsent(month, () => {'ws': 0.0, 'cs': 0.0});
          monthSales[month]![type] = double.tryParse(value.toString()) ?? 0.0;
        }
      }
    });

    // Reverse to get recent months first
    final List<String> months = orderedMonths.reversed.toList();

    // Build chart data
    final List<Map<String, double>> chartData = months.map((month) {
      final sales = monthSales[month] ?? {'ws': 0.0, 'cs': 0.0};
      return {
        'ws': sales['ws']!,
        'cs': sales['cs']!,
      };
    }).toList();

    // Calculate 3-month and 6-month aggregates
    double sumWs(List<Map<String, double>> data) =>
        data.fold(0.0, (sum, row) => sum + (row['ws'] ?? 0));
    double sumCs(List<Map<String, double>> data) =>
        data.fold(0.0, (sum, row) => sum + (row['cs'] ?? 0));

    // final last3 = chartData.take(3).toList();
    final last3 = chartData.length >= 3
        ? chartData.sublist(chartData.length - 3)
        : chartData;
    final last6 = chartData.take(6).toList();

    final double ws3 = sumWs(last3);
    final double cs3 = sumCs(last3);
    final double total3 = ws3 + cs3;

    final double ws6 = sumWs(last6);
    final double cs6 = sumCs(last6);
    final double total6 = ws6 + cs6;

    return {
      'months': months,
      'chartData': chartData,
      'last3': {
        'ws': ws3,
        'cs': cs3,
        'total': total3,
      },
      'last6': {
        'ws': ws6,
        'cs': cs6,
        'total': total6,
      },
    };
  }

  Map<String, dynamic>? getPartByNumber(
      List<dynamic> data, String targetPartNumber) {
    try {
      return data.firstWhere(
        (part) =>
            part['partnumber'].toString().trim() == targetPartNumber.trim(),
      ) as Map<String, dynamic>;
    } catch (e) {
      return null;
    }
  }

  // Map<String, dynamic>? getStockAndMax(
  //     List<dynamic> data, String locationId) {
  //   try {
  //     return data.firstWhere(
  //           (part) =>
  //       part['locationid'].toString().trim() == locationId,
  //     ) as Map<String, dynamic>;
  //   } catch (e) {
  //     return null;
  //   }
  // }

  // void getStockAndMax(List<dynamic> data, String locationId) {
  //   final match = data.firstWhere(
  //     (part) => part['locationid'].toString().trim() == locationId,
  //     orElse: () => {}, // return empty map if not found
  //   );
  //   if (match != null) {
  //     stock.value = match['Stock'] ?? 0;
  //     max.value = match['Max'] ?? 0;
  //   }
  // }

  void updateChartData(String selectedSaleType) {
    if (selectedSaleType == 'WorkShop Sale') {
      chartData.value = combinedChartData.map((e) => {'y1': e['ws']!}).toList();
      // showLast3.value = last3['ws'].toString();
      // showLast6.value = last6['ws'].toString();
      showLast3.value = formatValue(last3['ws'] ?? 0);
      showLast6.value = formatValue(last6['ws'] ?? 0);
    } else if (selectedSaleType == 'Counter Sale') {
      chartData.value = combinedChartData.map((e) => {'y1': e['cs']!}).toList();
      // showLast3.value = last3['cs'].toString();
      // showLast6.value = last6['cs'].toString();
      showLast3.value = formatValue(last3['cs'] ?? 0);
      showLast6.value = formatValue(last6['cs'] ?? 0);
    } else {
      chartData.value = combinedChartData
          .map(
            (e) => {
              'y1': e['ws'] ?? 0,
              'y2': e['cs'] ?? 0,
            },
          )
          .toList();

      showLast3.value = formatValue((last3['ws'] ?? 0) + (last3['cs'] ?? 0));
      showLast6.value = formatValue((last6['ws'] ?? 0) + (last6['cs'] ?? 0));

      // chartData.value = combinedChartData
      //     .map((e) => {'y1': e['ws']!, 'y2': e['cs']!})
      //     .toList();
      // showLast3.value = (last3['ws']! + last3['cs']!).toString();
      // showLast6.value = (last6['ws']! + last6['cs']!).toString();
      // showLast3.value = formatValue((last3['ws'] ?? 0 + last3['cs']!));
      // showLast6.value = formatValue((last6['ws'] ?? 0 + last6['cs']!));
    }
  }

  String formatValue(double value) {
    // Check if the value is a whole number
    if (value == value.toInt()) {
      return value.toInt().toString(); // Return as integer without decimal
    } else {
      return value.toStringAsFixed(
          1); // Return with one decimal place if it's a floating-point number
    }
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }
}
