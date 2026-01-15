import 'package:get/get.dart';

class LoginControllers extends GetxController {
  RxBool isObscureText = true.obs;
  RxBool isLoading = false.obs;
  RxBool rememberMe = false.obs;

  void updateRemember(bool value) {
    rememberMe.value = value;
  }

  //For Error Message at the time of API calling of login
  Rx<String?> errorMsg = Rx<String?>(null);

  // isObscureText= isObscureText.obs?false:true;
  void toggleObscureText() {
    isObscureText.value = !isObscureText.value;
  }
}
