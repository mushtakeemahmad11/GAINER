import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/Services/auth_service.dart';
import '../../core/Services/gainer_api_service.dart';
import '../../core/services/fcm_service/firebase_notification_service.dart';
import '../../routes/app_routes.dart';
import 'model/user_model.dart';

class LoginController extends GetxController {
  final GlobalKey<FormState> loginKey = GlobalKey<FormState>();
  final userIdCtrl = TextEditingController();
  final passwordCtrl = TextEditingController();

  var rememberMe = false.obs;
  var isPasswordVisible = false.obs;
  var isLoading = false.obs;

  final errMsg = RxnString();

  void toggleRemember() => rememberMe.toggle();
  void togglePassword() => isPasswordVisible.toggle();

  @override
  void onInit() {
    super.onInit();
    loadSavedCredentials();
  }

  Future<void> login() async {
    if (loginKey.currentState!.validate()) {
      final userid = userIdCtrl.text.trim();
      final password = passwordCtrl.text.trim();

      isLoading.value = true;
      //request call for DeviceToken
      String deviceToken =
          // await NotificationServices.getFirebaseMessagingToken() ??
          await NotificationServiceNEW.getFirebaseMessagingToken() ??
              'deviceTokenNotFound ';
      errMsg.value = null;
      final response =
          await GainerApiService().loginUser(userid, password, deviceToken);
      isLoading.value = false;
      if (response['success']) {
        final userData = response['data'];
        final user = UserModel.fromJson(userData);
        await _storeDetails(user, userid, password);
        Get.offAllNamed(Routes.APPSWITCHER);
      } else {
        errMsg.value = response['message'];
      }
    }
  }

  Future<void> _storeDetails(
      UserModel user, String userid, String password) async {
    await AuthService.saveUser(userid, user);
    if (rememberMe.value) {
      await AuthService.saveCredentials(userid, password);
    } else {
      await AuthService.removeCredentials();
    }
  }

  Future<void> loadSavedCredentials() async {
    final isRemembered = await AuthService.isRememberMe();

    if (isRemembered) {
      final cred = await AuthService.getCredentials();
      userIdCtrl.text = cred['userId'] ?? '';
      passwordCtrl.text = cred['password'] ?? '';
      rememberMe.value = true;
    }
  }
}
