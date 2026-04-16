import 'package:get/get.dart';
import './part_receipt_controller.dart';

class PartReceiptBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PartReceiptController>(
      () => PartReceiptController(),
    );
  }
}
