import 'package:gainer/gainer_app/modules/action_as_buyer/direct_request_sent/dr_sent_controller.dart';
import 'package:get/get.dart';

class DrSentBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(DrSentController());
  }
}
