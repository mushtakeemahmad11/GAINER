import 'package:get/get.dart';
import 'dispatched_details_controller.dart';

class DDBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DDController>(
      () => DDController(),
    );
  }
}
