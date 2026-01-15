import 'package:get/get.dart';

class PoRejectController extends GetxController {
  RxBool isLoading = false.obs;

  RxBool isDemandExpired = false.obs;
  RxBool isArrangedFromOtherSource = false.obs;
  RxBool isPoReleasedToOEM = false.obs;
  RxBool isQualityIssues = false.obs;
  RxBool isWithoutPacking = false.obs;
  RxBool isLeadTimeHigh = false.obs;
  RxBool isFreeStockNotAvl = false.obs;
  RxBool isDelayResponse = false.obs;
  RxBool isInsufficientFund = false.obs;
  RxBool isTransportArrangementNotOk = false.obs;

  // List of toggle button labels and their corresponding controller values
  final List<Map<String, dynamic>> toggleButtons = [
    {'text': 'Demand Expired/Customer Refused', 'state': 'isDemandExpired'},
    {'text': 'Arranged From Other Source', 'state': 'isArrangedFromOtherSource'},
    {'text': 'PO Released To OEM', 'state': 'isPoReleasedToOEM'},
    {'text': 'Quality Issues at Supplier', 'state': 'isQualityIssues'},
    {'text': 'Without Packing', 'state': 'isWithoutPacking'},
    {'text': 'Lead Time High', 'state': 'isLeadTimeHigh'},
    {'text': 'Free Stock Not Available', 'state': 'isFreeStockNotAvl'},
    {'text': 'Delay Response From Seller', 'state': 'isDelayResponse'},
    {'text': 'Insufficient Fund', 'state': 'isInsufficientFund'},
    {'text': 'Transport Arrangement not ok', 'state': 'isTransportArrangementNotOk'},
  ];

  // Method to update states dynamically
  void updateSelection(String selectedState) {
    isDemandExpired.value = selectedState == 'isDemandExpired';
    isArrangedFromOtherSource.value =
        selectedState == 'isArrangedFromOtherSource';
    isPoReleasedToOEM.value = selectedState == 'isPoReleasedToOEM';
    isQualityIssues.value = selectedState == 'isQualityIssues';
    isWithoutPacking.value = selectedState == 'isWithoutPacking';
    isLeadTimeHigh.value = selectedState == 'isLeadTimeHigh';
    isFreeStockNotAvl.value = selectedState == 'isFreeStockNotAvl';
    isDelayResponse.value = selectedState == 'isDelayResponse';
    isInsufficientFund.value = selectedState == 'isInsufficientFund';
    isTransportArrangementNotOk.value =
        selectedState == 'isTransportArrangementNotOk';
  }

  // Getter for accessing the value dynamically
  bool getState(String state) {
    switch (state) {
      case 'isDemandExpired':
        return isDemandExpired.value;
      case 'isArrangedFromOtherSource':
        return isArrangedFromOtherSource.value;
      case 'isPoReleasedToOEM':
        return isPoReleasedToOEM.value;
      case 'isQualityIssues':
        return isQualityIssues.value;
      case 'isWithoutPacking':
        return isWithoutPacking.value;
      case 'isLeadTimeHigh':
        return isLeadTimeHigh.value;
      case 'isFreeStockNotAvl':
        return isFreeStockNotAvl.value;
      case 'isDelayResponse':
        return isDelayResponse.value;
      case 'isInsufficientFund':
        return isInsufficientFund.value;
      case 'isTransportArrangementNotOk':
        return isTransportArrangementNotOk.value;

      default:
        return false;
    }
  }

  // Method to get the selected issue
  String? getSelectedIssue() {
    if (isDemandExpired.value) return 'Demand Expired/Customer Refused';
    if (isArrangedFromOtherSource.value) return 'Arranged From Other Source';
    if (isPoReleasedToOEM.value) return 'PO Released To OEM';
    if (isQualityIssues.value) return 'Quality Issues at Supplier';
    if (isWithoutPacking.value) return 'Without Packing';
    if (isLeadTimeHigh.value) return 'Lead Time High';
    if (isFreeStockNotAvl.value) return 'Free Stock Not Available';
    if (isDelayResponse.value) return 'Delay Response From Seller';
    if (isInsufficientFund.value) return 'Insufficient Fund';
    if (isTransportArrangementNotOk.value) return 'Transport Arrangement not ok';
    return null;
  }
}
