import 'package:get/get.dart';

class TrackOrderController extends GetxController {
  Rx<String?> errorMsg = Rx<String?>(null);
  RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    clearError(); // Clear error when the controller is initialized
  }

  void clearError() {
    errorMsg.value = null;
  }

  void setError(String msg) {
    errorMsg.value = msg;
  }

  //for box resize
  // var isInitialized = false.obs;
}
