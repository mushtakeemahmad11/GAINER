import 'package:gainer/gainer_app/core/Services/auth_service.dart';
import 'package:get/get.dart';
import '../../dealer_monitoring/core/services/api_services.dart';
import '../../gainer_app/core/utils/check_internet.dart';
import '../widgets/no_internet_dialog.dart';

class WorkshopPartsController extends GetxController {
  ApiServices api = ApiServices();
  // Common params for all requests on this screen
  final String dealerId;
  final String locationId;
  final String advisorName;
  final String jobCardStatus;
  final String nonStockable;
  final String monthDate;

  WorkshopPartsController({
    required this.dealerId,
    required this.locationId,
    required this.advisorName,
    required this.jobCardStatus,
    required this.nonStockable,
    required this.monthDate,
  });

  /// vehicleNumber -> parts list
  final RxMap<String, List<Map<String, dynamic>>> partsByVehicle =
      <String, List<Map<String, dynamic>>>{}.obs;

  /// vehicles currently loading
  final RxSet<String> loading = <String>{}.obs;

  /// vehicleNumber -> error text
  final RxMap<String, String> errors = <String, String>{}.obs;

  bool get isBusy => loading.isNotEmpty;

  Future<void> fetchPartsForVehicle(String vehicleNumber) async {
    if (loading.contains(vehicleNumber)) return;

    bool checkInt = await CheckInternet.checkInternet();
    if (!checkInt) NoInternetDialog.show();

    loading.add(vehicleNumber);
    errors.remove(vehicleNumber);
    // int tCode = await getIntData("tCode");
    String tCode = await AuthService.getTCode();
    try {
      final resp = await api.fetchPPNIParts(
        vehicleNum: vehicleNumber,
        dealerId: dealerId,
        locationId: locationId,
        nonStockable: nonStockable.isEmpty ? null : nonStockable,
        jobCardStatus: jobCardStatus.isEmpty ? null : jobCardStatus,
        advisor: advisorName.isEmpty ? null : advisorName,
        monthDate: monthDate.isEmpty ? null : monthDate,
        userId: tCode,
      );

      if (resp['success']) {
        // Success response with data list
        final List<dynamic> data = resp['data'] ?? [];
        final parts = data
            .map((e) => _normalizePart(Map<String, dynamic>.from(e)))
            .toList();
        partsByVehicle[vehicleNumber] = parts;
      } else {
        errors[vehicleNumber] = resp['message'];
      }
    } catch (e) {
      errors[vehicleNumber] = e.toString();
    } finally {
      loading.remove(vehicleNumber);
    }
  }

  Map<String, dynamic> _normalizePart(Map<String, dynamic> j) {
    return {
      'partNumber': j['PartNumber']?.toString() ?? '',
      'demandedQty': j['DemandedQty'] ?? 0,
      'qty': j['StockQty'] ?? 0,
      'value': (j['PPNI_Val'] ?? j['price'] ?? 0),
      'category': j['part_category'] ?? '',
      'description': j['PartDesc'] ?? '',
      'bigid': j['bigid'] ?? '',
      'LocationId': j['LocationId'] ?? '',
      'DealerId': j['DealerId'] ?? '',
      'Vehiclenumber': j['Vehiclenumber'] ?? '',
      'alltimestk': (j['All_Time_NonStck'] ?? '').toString(), // Y/N
    };
  }
}
