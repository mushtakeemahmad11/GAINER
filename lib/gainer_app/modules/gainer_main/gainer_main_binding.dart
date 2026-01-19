import 'package:get/get.dart';
import 'gainer_main_controller.dart';

class GainerMainBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<GainerMainController>(() => GainerMainController());
  }
}
