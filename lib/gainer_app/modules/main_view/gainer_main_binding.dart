import 'package:get/get.dart';
import 'gainer_main_controller.dart';

class GainerMainBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(GainerMainController());
  }
}
