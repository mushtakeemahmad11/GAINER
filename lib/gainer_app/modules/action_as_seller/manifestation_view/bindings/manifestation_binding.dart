import 'package:get/get.dart';
import '../controllers/manifestation_controller.dart';

class ManifestationBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ManifestationController>(
      () => ManifestationController(),
    );
  }
}
