import 'package:get/get.dart';
import '../controllers/cal_f_c_controller.dart';

class CalFCBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CalFCController>(
      () => CalFCController(),
    );
  }
}
