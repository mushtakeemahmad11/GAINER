import 'package:get/get.dart';
import 'scs_request_controller.dart';

class ScsRequestBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ScsRequestController>(
      () => ScsRequestController(),
    );
  }
}
