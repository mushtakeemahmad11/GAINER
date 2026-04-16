import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';

class NavigationService {
  static void navigateTo(String route, {dynamic arguments}) {
    Get.toNamed(route, arguments: arguments);
  }
}
