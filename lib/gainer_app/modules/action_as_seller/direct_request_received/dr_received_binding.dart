import 'package:get/get.dart';
import 'dr_received_controller.dart';

class DrReceivedBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(DrReceivedController());
  }
}
