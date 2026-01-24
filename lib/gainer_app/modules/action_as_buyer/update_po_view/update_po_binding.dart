import 'package:gainer/gainer_app/modules/action_as_buyer/update_po_view/update_po_controller.dart';
import 'package:get/get.dart';


class UpdatePoBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => UpdatePoController());
  }
}
