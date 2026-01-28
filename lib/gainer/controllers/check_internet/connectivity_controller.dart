import 'dart:async';
import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:gainer/gainer/widget/bottom_snack_bar.dart';
import 'package:get/get.dart';

class ConnectivityController extends GetxController {
  final Connectivity _connectivity = Connectivity();
  StreamSubscription<List<ConnectivityResult>>? _subscription;

  RxBool isConnected = true.obs;
  RxString lastSnackbar = ''.obs;
  RxBool wasSlow = false.obs;
  bool initialCheckDone = false; // Not observable, just local use

  @override
  // void onInit() {
  //   super.onInit();
  void onReady() {
    super.onReady();
    initConnectivity();
    _subscription = _connectivity.onConnectivityChanged
        .listen((List<ConnectivityResult> results) {
      final singleResult =
          results.isNotEmpty ? results.first : ConnectivityResult.none;
      _updateConnectionStatus(singleResult);
    });
  }

  Future<void> initConnectivity() async {
    try {
      final results = await _connectivity.checkConnectivity();
      final singleResult =
          results.isNotEmpty ? results.first : ConnectivityResult.none;
      await _updateConnectionStatus(singleResult);
    } catch (_) {
      isConnected.value = false;
      _showSnackBar("Error checking connectivity", isError: true);
    }
  }

  // Future<void> _updateConnectionStatus(ConnectivityResult result) async {
  //   if (result == ConnectivityResult.none) {
  //     isConnected.value = false;
  //     wasSlow.value = false; // reset
  //     _showSnackBar("No Internet Connection. You're offline",
  //         isError: true, longDuration: true);
  //   } else {
  //     final isFast = await _isConnectionFast();
  //
  //     if (!isConnected.value) {
  //       // ➤ was previously offline
  //       isConnected.value = true;
  //
  //       if (!isFast) {
  //         _showSnackBar("You're online but connection seems slow");
  //         wasSlow.value = true;
  //       } else {
  //         _showSnackBar("Back Online! You're connected to internet");
  //         wasSlow.value = false;
  //       }
  //     } else {
  //       // ➤ already online
  //       if (!isFast && !wasSlow.value) {
  //         _showSnackBar("You're online but connection seems slow");
  //         print("You're online but connection seems slow");
  //         wasSlow.value = true;
  //       } else if (isFast && wasSlow.value) {
  //         // _showSnackBar("Connection speed improved");
  //         print("Connection speed improved");
  //         wasSlow.value = false;
  //       }
  //     }
  //   }
  // }

  Future<void> _updateConnectionStatus(ConnectivityResult result) async {
    final isFast = await _isConnectionFast();
    final wasConnected = isConnected.value;
    final wasSlowBefore = wasSlow.value;

    // print(
    //     "RESULT: $result | isFast: $isFast | wasSlow: ${wasSlow.value} | connected: ${isConnected.value}");

    // Case: No internet now
    if (result == ConnectivityResult.none) {
      isConnected.value = false;
      wasSlow.value = false;

      if (!initialCheckDone || wasConnected) {
        // print("No Internet Connection. You're offline");
        _showSnackBar("No Internet Connection. You're offline",
            isError: true, longDuration: true);
      }

      initialCheckDone = true;
      return;
    }

    // Internet available now
    isConnected.value = true;

    // First time launch
    if (!initialCheckDone) {
      initialCheckDone = true;
      wasSlow.value = !isFast;

      if (!isFast) {
        // print("Connection is slow (initial check)");
        _showSnackBar("Connection is slow", isError: true);
      } else {
        // print("Fast connection detected (initial). No snackbar.");
      }

      return;
    }

    // Check transitions after initial
    if (!wasConnected && isConnected.value) {
      // Internet came back
      if (isFast) {
        // print("Back Online! You're connected");
        _showSnackBar("Back Online! You're connected");
        wasSlow.value = false;
      } else {
        // print("Back Online but connection is slow");
        _showSnackBar("Back Online but connection is slow");
        wasSlow.value = true;
      }
      return;
    }

    // Still online — check speed transitions
    if (!wasSlowBefore && !isFast) {
      // Speed got slow
      // print("Connection is slow");
      _showSnackBar("Connection is slow", isError: true);
      wasSlow.value = true;
    } else if (wasSlowBefore && isFast) {
      // Speed improved
      // print("Connection speed improved");
      _showSnackBar("Connection speed improved");
      wasSlow.value = false;
    } else {
      // Still same (fast or slow), no need to notify
      // print("No change in connection or speed. Skipping snackbar.");
    }
  }

  Future<bool> _isConnectionFast() async {
    try {
      final stopwatch = Stopwatch()..start();
      final result = await InternetAddress.lookup('example.com');
      stopwatch.stop();

      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        final ms = stopwatch.elapsedMilliseconds;
        return ms < 600; // <600ms = fast
      }
    } catch (_) {
      return false;
    }
    return false;
  }

  void _showSnackBar(String message,
      {bool isError = false, bool longDuration = false}) {
    if (lastSnackbar.value == message) return; // avoid duplicate snackbar
    lastSnackbar.value = message;

    SnackBarService.showError(message,
        isError: isError, longDuration: longDuration);
  }

  @override
  void onClose() {
    _subscription?.cancel();
    super.onClose();
  }
}
