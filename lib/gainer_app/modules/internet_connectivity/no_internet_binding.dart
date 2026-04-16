import 'package:get/get.dart';
import 'no_internet_controller.dart';

class NoInternetBinding extends Bindings {
  @override
  void dependencies() {
    Get.find<NoInternetController>();
  }
}
