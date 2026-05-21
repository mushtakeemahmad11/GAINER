import 'package:get/get.dart';
import 'direct_request_controller.dart';

class DirectRequestBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DirectRequestController>(
      () => DirectRequestController(),
    );
  }
}
