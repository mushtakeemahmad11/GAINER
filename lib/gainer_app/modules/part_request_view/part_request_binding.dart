import './part_request_controller.dart';
import 'package:get/get.dart';

class PartRequestBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PartRequestController>(() => PartRequestController());
  }
}
