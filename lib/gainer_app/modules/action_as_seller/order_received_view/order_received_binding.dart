import 'package:get/get.dart';
import 'order_received_controller.dart';

class OrderReceivedBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<OrderReceivedController>(
      () => OrderReceivedController(),
    );
  }
}
