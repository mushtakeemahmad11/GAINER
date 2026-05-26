import 'package:get/get.dart';
import '../../../core/widgets/gainer_bottom_sheet.dart';
import '../../../routes/app_routes.dart';
import '../../main_view/gainer_main_controller.dart';

class HelpViewSnackBar {
  static void snackBar() {
    GainerBottomSheet.showSnackBar(
      "Part is not available in master\nPlease connect to Gainer team",
      isAction: true,
      label: "Help",
      onPressed: () {
        ///Going to Gainer Main Screen then Navigate to Help Index
        Get.until(
          (route) => route.settings.name == Routes.GAINERMAINVIEW,
        );

        ///Changes Current Index
        Future.microtask(() {
          Get.find<GainerMainController>().currentIndex.value = 2;
        });
      },
    );
  }
}
