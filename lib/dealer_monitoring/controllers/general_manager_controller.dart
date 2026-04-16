import 'package:gainer/gainer_app/core/Services/auth_service.dart';
import 'package:gainer/gainer_app/core/utils/check_internet.dart';
import 'package:get/get.dart';
import '../../app_switcher_view/app_switcher_controller.dart';
import '../core/services/api_services.dart';
import '../core/utils/transform_graph_ppni_data.dart';
import '../models/location_group_model.dart';
import '../widgets/no_internet_dialog.dart';

class GeneralManagerController extends GetxController {
  ApiServices api = ApiServices();
  // final LocationController _locationController = Get.put(LocationController());
  final appSwitcherCtrl = Get.find<AppSwitcherController>();
  RxBool isLoading = false.obs;
  var selectedCategory = 'Stockable'.obs;
  var showChart = false.obs;
  RxString lakhsTitle = "".obs;
  var expandedRows = <String, bool>{}.obs;
  // RxBool isNonStockable = true.obs;

  RxnString error = RxnString(null);
  RxnString graphError = RxnString(null);
  RxnString selectedStatus = RxnString(null);
  RxnString selectedPartNature = RxnString(null);

// // RxList to hold the API result
//   var locationListGeneralM = <Map<String, dynamic>>[].obs;
//
//   // Method to update list
//   void setLocation(List<Map<String, dynamic>> list) {
//     locationListGeneralM.value = list;
//   }

  RxDouble totalPPNIValue = 0.0.obs;

  // Observable list
  RxList<Map<String, dynamic>> tableData = <Map<String, dynamic>>[].obs;

  // Function to load or set data
  void setTableData(List<Map<String, dynamic>> newData) {
    tableData.value = newData;
  }

  // Optional: Function to fetch and transform API response
  void fetchPPNIData(List<dynamic> rawData) {
    final transformed =
        transformPPNIData(rawData); // Assume you have this function
    tableData.value = transformed.map((e) => e.toJson()).toList();

    // Calculate total PPNI from all locations
    totalPPNIValue.value = transformed.fold(
      0.0,
      (sum, loc) => sum + (loc.ppniTotal),
    );
  }

  Future<void> initWork(String? everLocationId,
      {String? monthYear, String? title}) async {
    lakhsTitle.value =
        title != null ? "Location wise PPNI breakdown - $title" : "";
    // String dealerId = _locationController.stockDetails['DealerID'].toString();
    String dealerId = appSwitcherCtrl.getStock()?.dealerId.toString() ?? '';
    String locationId = appSwitcherCtrl.getStock()?.locationId.toString() ?? '';
    // _locationController .stockDetails['LocationID'].toString();
    // String selectedLocationID = await getStringData("selectedLocationID");
    final val1 = selectedPartNature.value;
    String? nonStockable = (val1 == "All time NS -Y")
        ? "Y"
        : (val1 == "All time NS -N")
            ? "N"
            : null;
    final val2 = selectedStatus.value;
    String? cardStatus = val2 == "Closed"
        ? "Close"
        : val2 == "Open"
            ? "Open"
            : null;
    // int tCode = await getIntData("tCode");
    String tCode = await AuthService.getTCode();
    bool checkInt = await CheckInternet.checkInternet();
    if (!checkInt) {
      error.value = "no Internet connection ";
      return NoInternetDialog.show();
    } else {
      error.value = null;
      isLoading.value = true;
      final responses = await Future.wait([
        api.fetchPPNIValuesByDealer(
          dealerId: dealerId,
          locationId: locationId,
          nonStockable: nonStockable,
          jobCardStatus: cardStatus,
          monthDate: monthYear,
          userId: tCode.toString(),
          // jobCardStatus: isJobCard,
        ),
        api.fetchGraphPPNIValue(
          dealerId: dealerId,
          locationId: null,
          nonStockable: nonStockable,
          jobCardStatus: cardStatus,
        ),
      ]);
      isLoading.value = false;

      // final result = await api.fetchPPNIValuesByDealer(
      //   dealerId: dealerId,
      //   // nonStockable: isNonStockable ? "Y" : "N",
      //   nonStockable: nonStockable,
      //   jobCardStatus: cardStatus,
      //   monthDate: monthYear,
      //   // jobCardStatus: isJobCard,
      // );

      final result = responses[0];
      if (result['success']) {
        List<Map<String, dynamic>> data =
            List<Map<String, dynamic>>.from(result['data']);
        fetchPPNIData(data);
        // setLocation(data);
      } else {
        error.value = result['message'];
      }

      graphError.value = null;
      // final response = await api.fetchGraphPPNIValue(
      //   dealerId: dealerId,
      //   // locationId: everLocationId ?? locationId,
      //   locationId: null,
      //   nonStockable: nonStockable,
      //   jobCardStatus: cardStatus,
      //   // advisor: ,
      // );

      final response = responses[1];
      if (response['success']) {
        final graphData = transformGraphPPNIDataLast12Months(response['data']);
        updateGraph(graphData);
      } else {
        data.clear();
        xLabels.clear();
        monthDate.clear();
        graphError.value = response['message'];
      }
    }
  }

  // //Transform api data to passTable type
  List<LocationGroup> transformPPNIData(List<dynamic> rawData) {
    final Map<String, List<AdvisorEntry>> grouped = {};
    final Map<String, String> locationIdMap = {};

    for (var item in rawData) {
      final String location = item['Location'];
      final String locationID = item['LocationId'].toString();
      final String advisor = item['Advisor'];
      final double ppni = (item['PPNI_Value'] ?? 0).toDouble();

      locationIdMap[location] =
          locationID; // store LocationId for each Location

      grouped.putIfAbsent(location, () => []);
      grouped[location]!.add(AdvisorEntry(advisor: advisor, ppniValue: ppni));
    }

    List<LocationGroup> result = [];

    grouped.forEach((location, advisorList) {
      final total =
          advisorList.fold<double>(0.0, (sum, a) => sum + a.ppniValue);
      final locationID = locationIdMap[location] ?? '0';

      result.add(LocationGroup(
        location: location,
        locationId: locationID,
        ppniTotal: total,
        advisors: advisorList,
      ));
    });

    return result;
  }

  RxList<Map<String, double>> data = <Map<String, double>>[].obs;
  RxList<String> xLabels = <String>[].obs;
  RxList<String> monthDate = <String>[].obs;
  void updateGraph(Map<String, dynamic> graphData) {
    data.assignAll(List<Map<String, double>>.from(graphData['data']));
    xLabels.assignAll(List<String>.from(graphData['xLabels']));
    monthDate.assignAll(List<String>.from(graphData['monthDate']));
    // showChart.value = true;
    // graphError.value = '';
  }

  // void transformGraphPPNIData(List<dynamic> rawData) {
  //   const List<String> monthNames = [
  //     '',
  //     'Jan',
  //     'Feb',
  //     'Mar',
  //     'Apr',
  //     'May',
  //     'Jun',
  //     'Jul',
  //     'Aug',
  //     'Sep',
  //     'Oct',
  //     'Nov',
  //     'Dec'
  //   ];
  //
  //   // Sort by year then month
  //   rawData.sort((a, b) {
  //     List<String> aParts = a['Date'].split('-');
  //     List<String> bParts = b['Date'].split('-');
  //     int aYear = int.parse(aParts[1]);
  //     int bYear = int.parse(bParts[1]);
  //     int aMonth = int.parse(aParts[0]);
  //     int bMonth = int.parse(bParts[0]);
  //
  //     if (aYear == bYear) {
  //       return aMonth.compareTo(bMonth);
  //     } else {
  //       return aYear.compareTo(bYear);
  //     }
  //   });
  //
  //   // Clear previous data
  //   data.clear();
  //   xLabels.clear();
  //   monthDate.clear();
  //
  //   // Populate new values
  //   for (var entry in rawData) {
  //     int month = int.parse(entry['Date'].split('-')[0]);
  //     // data.add({'y1': entry['PPNI_Value']});
  //     data.add({'y1': (entry['PPNI_Value'] as num).toDouble()});
  //     xLabels.add(monthNames[month]);
  //     monthDate.add(entry['Date']);
  //   }
  // }

  // List<LocationGroup> transformPPNIData(List<dynamic> rawData) {
  //   final Map<String, List<AdvisorEntry>> grouped = {};
  //
  //   for (var item in rawData) {
  //     final String location = item['Location'];
  //     final String locationID = item['LocationId'];
  //     final String advisor = item['Advisor'];
  //     final double ppni = (item['PPNI_Value'] ?? 0).toDouble();
  //
  //     grouped.putIfAbsent(location, () => []);
  //     grouped[location]!.add(AdvisorEntry(advisor: advisor, ppniValue: ppni));
  //   }
  //
  //   List<LocationGroup> result = [];
  //
  //   grouped.forEach((location, advisorList) {
  //     final total = advisorList.fold<double>(0.0, (sum, a) => sum + a.ppniValue);
  //     result.add(LocationGroup(location: location, locationId: locationID, ppniTotal: total, advisors: advisorList));
  //   });
  //
  //   return result;
  // }
}
