import 'package:get/get.dart';

import '../gainer_app/routes/app_routes.dart';

class PinController extends GetxController {
  RxList<int> digits = <int>[].obs;

  RxBool isSettingUp = true.obs; // change based on your flow
  RxString? errorText = RxString('');

  String? _savedPin;

  void onDigitTap(int digit) {
    if (digits.length >= 6) return;

    digits.add(digit);

    if (digits.length == 6) {
      _handleSubmit();
    }
  }

  void onBackspace() {
    if (digits.isNotEmpty) {
      digits.removeLast();
    }
  }

  void _handleSubmit() {
    final enteredPin = digits.join();

    if (isSettingUp.value) {
      _savedPin = enteredPin;
      isSettingUp.value = false;
      digits.clear();
      errorText?.value = 'PIN set successfully. Enter to verify.';
    } else {
      if (_savedPin == enteredPin) {
        errorText?.value = '';
        Get.offAllNamed(Routes.APPSWITCHER); // change route
      } else {
        errorText?.value = 'Incorrect PIN';
        digits.clear();
      }
    }
  }
}
