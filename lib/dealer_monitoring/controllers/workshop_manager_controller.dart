import 'package:gainer/dealer_monitoring/models/vehicle_parts_details_model.dart';
import 'package:get/get.dart';
import '../../gainer/controllers/check_internet/no_internet_screen.dart';
import '../../gainer/screens/check_internet/check_internet_connectivity.dart';
import '../../gainer/shared_preferences/shared_preferences_get_data.dart';
import '../core/services/api_services.dart';
import '../core/utils/transform_graph_ppni_data.dart';

class WorkShopManagerController extends GetxController {
  ApiServices api = ApiServices();
  RxBool isLoading = false.obs;
  RxBool isMoreLoading = false.obs;
  RxBool isFirstLoading = false.obs;
  var selectedCategory = 'Stockable'.obs;
  // var isJobCard = 'Open'.obs;
  RxnString selectedStatus = RxnString(null);
  RxnString selectedPartNature = RxnString(null);
  RxnString selectedStatusBody = RxnString(null);
  RxnString selectedPartNatureBody = RxnString(null);
  RxBool showChart = false.obs;
  RxString lakhsTitle = "".obs;
  RxString lakhsTitleAdvisor = "".obs;
  var expandedRows = <String, bool>{}.obs;

  RxnString selectedAdvisor = RxnString(null);

  RxDouble totalPPNIValue = 0.0.obs;
  RxDouble totalPPNIValueAdvisor = 0.0.obs;

  RxList<VehiclePPNI> vehiclePartsDetailsList = <VehiclePPNI>[].obs;
  RxList<Map<String, dynamic>> advisorPPNIList = <Map<String, dynamic>>[].obs;

  RxnString firstSError = RxnString(null);
  RxnString secondSError = RxnString(null);

  RxList<Map<String, double>> data = <Map<String, double>>[].obs;
  RxList<String> xLabels = <String>[].obs;
  RxList<String> monthDate = <String>[].obs;
  RxList<Map<String, double>> dataAdvisor = <Map<String, double>>[].obs;
  RxList<String> xLabelsAdvisor = <String>[].obs;
  RxList<String> monthDateAdvisor = <String>[].obs;
  RxnString graphError = RxnString(null);
  RxnString graphErrorAdvisor = RxnString(null);

  void updateGraph(Map<String, dynamic> graphData) {
    data.assignAll(List<Map<String, double>>.from(graphData['data']));
    xLabels.assignAll(List<String>.from(graphData['xLabels']));
    monthDate.assignAll(List<String>.from(graphData['monthDate']));
  }

  void updateGraphAdvisor(Map<String, dynamic> graphData) {
    dataAdvisor.assignAll(List<Map<String, double>>.from(graphData['data']));
    xLabelsAdvisor.assignAll(List<String>.from(graphData['xLabels']));
    monthDateAdvisor.assignAll(List<String>.from(graphData['monthDate']));
  }

  Future<void> initWork(String? everLocationId,
      {String? monthYear, String? title}) async {
    lakhsTitle.value =
        title != null ? "Advisor wise PPNI breakdown - $title" : "";
    // title != null ? " Data for $title" : "";
    String locationID =
        await getStringData("selectedLocationID"); //problemmmmmmmm sometime
    String dealerID = await getStringData("dealerID");
    bool checkInt = await checkInternet();
    final val = selectedPartNature.value;
    String? nonStockable = (val == "All time NS -Y")
        ? "Y"
        : (val == "All time NS -N")
            ? "N"
            : null;
    final val2 = selectedStatus.value;
    String? cardStatus = val2 == "Closed"
        ? "Close"
        : val2 == "Open"
            ? "Open"
            : null;
    int tCode = await getIntData("tCode");
    if (!checkInt) {
      firstSError.value = "no Internet connection ";
      return internetNotAvl();
    }
    firstSError.value = null;
    isFirstLoading.value = true;
    final response = await api.fetchAdvisorPPNIData(
      dealerId: dealerID, //"8"
      locationId: everLocationId ?? locationID, //"14"
      nonStockable: nonStockable,
      jobCardStatus: cardStatus,
      date: monthYear,
      userId: tCode.toString(),
    );
    isFirstLoading.value = false;
    // print("Response: of advisorPPNI: $response");

    if (response['success']) {
      advisorPPNIList.value =
          (response['data'] as List).cast<Map<String, dynamic>>();
      final sum = advisorPPNIList.fold<double>(
        0.0,
        (double previousValue, dynamic vehicle) =>
            previousValue + (vehicle["PPNI_Value"]?.toDouble() ?? 0.0),
      );
      totalPPNIValue.value = sum;
    } else {
      totalPPNIValue.value = 0;
      firstSError.value = response['message'];
    }

    // for fetch graph data
    graphError.value = null;
    final graphResponse = await api.fetchGraphPPNIValue(
      dealerId: dealerID,
      locationId: everLocationId ?? locationID,
      // nonStockable: isNonStockable.value ? "Y" : "N",
      nonStockable: nonStockable,
      // jobCardStatus: isJobCard.value,
      jobCardStatus: cardStatus,
    );
    if (graphResponse['success']) {
      final graphData =
          transformGraphPPNIDataLast12Months(graphResponse['data']);
      updateGraph(graphData);

      // print("transform graph data: ${graphData['monthDate']}");
      // print('data: ${data}');
      // print('xLabels: ${xLabels}');
    } else {
      // print("Error: ${response['message']}");
      data.clear();
      xLabels.clear();
      monthDate.clear();
      graphError.value = response['message'];
    }
  }

  String? dealerIdValue;
  String? isNonStockableValue;
  String? jobCardStatusValue;
  String? locationIdValue;
  String? advisorValue;
  String? monthDateValue;

  final List<Map<String, dynamic>> fakePPNIData = List.generate(
    10,
    (_) => {
      "vehicleNumber": "HR76E2282",
      "ppniValue": 12159.68,
      "InStockCount": 2,
      "NotIssued": 3,
      "parts": [
        {
          "partNumber": "1801AS200010N",
          "description": "WIRING HARNESS ENGINE",
          "category": "Spare Part",
          "ndp": 6079.84,
          "DemandedQty": 1,
          "StockQty": 2,
          "value": 12159.68,
          "alltimestk": "Y"
        }
      ]
    },
  );

// ----- Add these helper methods -----

  /// Called before a (re)fetch to set current filter/context and reset state.
  void prepareFetch({
    required String dealerID,
    required String locationID,
    required String advisor,
    String? nonStockable,
    String? cardStatus,
    String? monthDate,
  }) {
    dealerIdValue = dealerID;
    locationIdValue = locationID;
    advisorValue = advisor;
    isNonStockableValue = nonStockable;
    jobCardStatusValue = cardStatus;
    monthDateValue = monthDate;

    // reset error & list
    secondSError.value = null;
    vehiclePartsDetailsList.clear();
    totalPPNIValueAdvisor.value = 0;
  }

  /// Append fetched page to list and update running total.
  void addVehicleParts(List<dynamic> rawItems, num totalPPNIChunk) {
    final items = rawItems
        .map<VehiclePPNI>(
            (e) => VehiclePPNI.fromJson(e as Map<String, dynamic>))
        .toList();
    vehiclePartsDetailsList.addAll(items);
    totalPPNIValueAdvisor.value += totalPPNIChunk.toDouble();
  }

  /// Clear graph and set error message.
  void clearGraph(String message) {
    dataAdvisor.clear();
    xLabelsAdvisor.clear();
    monthDateAdvisor.clear();
    graphErrorAdvisor.value = message;
  }

  /// Centralized error handling used by pagination & first load.
  void handleError(String message, bool isPaginating) {
    if (!isPaginating) {
      secondSError.value = message;
    }
  }
}
