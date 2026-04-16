import 'package:connectivity_plus/connectivity_plus.dart';

class CheckInternet {
  static Future<bool> checkInternet() async {
    final List<ConnectivityResult> connectivityResult =
        await Connectivity().checkConnectivity();

    // Check common internet-capable connections
    if (connectivityResult.contains(ConnectivityResult.mobile) ||
        connectivityResult.contains(ConnectivityResult.wifi) ||
        connectivityResult.contains(ConnectivityResult.ethernet) ||
        connectivityResult.contains(ConnectivityResult.other)) {
      return true;
    }

    // No network available
    if (connectivityResult.contains(ConnectivityResult.none)) {
      return false;
    }

    // Fallback in case of unexpected result
    return false;
  }
}
