import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:gainer/gainer_app/core/widgets/gainer_dialog.dart';
import 'package:get/get.dart';
import '../../modules/login/model/user_model.dart';
import '../../routes/app_routes.dart';
import '../constants/gainer_image.dart';
import 'gainer_api_service.dart';

class AuthService {
  static final FlutterSecureStorage _storage = FlutterSecureStorage();

  // Keys
  static const String _loginKey = 'is_logged_in';
  static const String _isRememberCred = 'is_remember_cred';
  static const String _userId = 'user_id';
  static const String _tCode = 't_code';
  static const String _password = 'user_pass';
  static const String _userData = 'user_data';
  static const String _loginTime = 'login_time';
  static const String _deviceToken = 'device_token';
  static const String _userRole = 'user_role';
  static const String _pickProfile = 'pick_profile';

  static const String _brandId = 'brand_id';
  static const String _dealerId = 'dealer_id';
  static const String _locationId = 'location_id';

  static const String _brand = 'brand';
  static const String _dealer = 'dealer';
  static const String _location = 'location';


  /* ================= USER ID ================= */

  static Future<void> saveUserId(String userId) async {
    await _storage.write(key: _userId, value: userId);
  }

  static Future<String> getUserId() async {
    return await _storage.read(key: _userId) ?? '';
  }

  /* ================= CREDENTIALS ================= */

  static Future<void> saveCredentials(String userId, String password) async {
    await _storage.write(key: _userId, value: userId);
    await _storage.write(key: _password, value: password);
    await _storage.write(key: _isRememberCred, value: 'true');
  }

  static Future<Map<String, String?>> getCredentials() async {
    final userId = await _storage.read(key: _userId);
    final password = await _storage.read(key: _password);
    return {
      'userId': userId,
      'password': password,
    };
  }

  static Future<void> removeCredentials() async {
    await _storage.delete(key: _password);
    await _storage.delete(key: _isRememberCred);
  }

  static Future<bool> isRememberMe() async {
    final value = await _storage.read(key: _isRememberCred);
    return value == 'true';
  }

  /* ================= USER SESSION ================= */

  static Future<void> saveUser(String userId, UserModel user) async {
    await _storage.write(key: _loginKey, value: 'true');
    await _storage.write(
      key: _loginTime,
      value: DateTime.now().millisecondsSinceEpoch.toString(),
    );

    await saveUserId(userId);
    await saveTCode(user.userTCode.toString());

    final userJson = jsonEncode(user.toJson2());
    await _storage.write(key: _userData, value: userJson);
  }

  static Future<UserModel?> getUser() async {
    final userString = await _storage.read(key: _userData);
    if (userString == null) return null;

    return UserModel.fromJson(jsonDecode(userString));
  }

  static Future<bool> isLoggedIn() async {
    final value = await _storage.read(key: _loginKey);
    return value == 'true';
  }

  /* ================= SESSION EXPIRY ================= */
  static Future<bool> checkSessionExpired() async {
    final stored = await _storage.read(key: _loginTime);

    final loginTime = int.tryParse(stored ?? '');
    if (loginTime == null) return true;

    final now = DateTime.now().millisecondsSinceEpoch;
    final maxSessionMs = Duration(hours: 4).inMilliseconds;
    return now - loginTime >= maxSessionMs;
  }


  /* ================= TCODE ================= */
  static Future<void> saveTCode(String tCode) async {
    await _storage.write(key: _tCode, value: tCode);
  }

  static Future<String> getTCode() async {
    return await _storage.read(key: _tCode) ?? "NULL";
  }

  /* ================= FCM ================= */

  static Future<void> saveDeviceToken(String token) async {
    await _storage.write(key: _deviceToken, value: token);
  }

  static Future<String> getDeviceToken() async {
    return await _storage.read(key: _deviceToken) ?? '';
  }

  /* ================= User Role ================= */

  static Future<void> saveUserRole(String role) async {
    await _storage.write(key: _userRole, value: role);
  }

  static Future<String> getUserRole() async {
    return await _storage.read(key: _userRole) ?? '';
  }

  /* ================= store Brand Dealer Location ================= */
  static Future<void> saveBDLId(
      String brandId, String dealerId, String locationId) async {
    await _storage.write(key: _brandId, value: brandId);
    await _storage.write(key: _dealerId, value: dealerId);
    await saveLocationId(locationId);
    // await _storage.write(key: _locationId, value: locationId);
  }

  ///SAVE BRAND DEALER LOCATION
  static Future<void> saveBDL(
      String brand, String dealer, String location) async {
    await _storage.write(key: _brand, value: brand);
    await _storage.write(key: _dealer, value: dealer);
    await saveLocation(location);
    // await _storage.write(key: _locationId, value: locationId);
  }

  static Future<void> saveLocationId(String locationId) async {
    await _storage.write(key: _locationId, value: locationId);
  }

  static Future<void> saveLocation(String locationId) async {
    await _storage.write(key: _location, value: locationId);
  }

  static Future<String> getBrandId() async {
    return await _storage.read(key: _brandId) ?? '';
  }

  static Future<String> getBrand() async {
    return await _storage.read(key: _brand) ?? '';
  }

  static Future<String> getDealerId() async {
    return await _storage.read(key: _dealerId) ?? '';
  }

  static Future<String> getDealer() async {
    return await _storage.read(key: _dealer) ?? '';
  }

  static Future<String> getLocationId() async {
    return await _storage.read(key: _locationId) ?? '';
  }

  static Future<String> getLocation() async {
    return await _storage.read(key: _location) ?? '';
  }

  static Future<Map<String, String>> getBDLId() async {
    final bid = await getBrandId();
    final did = await getDealerId();
    final lid = await getLocationId();
    return {
      'brandId': bid,
      'dealerId': did,
      'locationId': lid,
    };
  }

  ///GET BRAND DEALER LOCATION
  static Future<Map<String, String>> getBDL() async {
    final b = await getBrand();
    final d = await getDealer();
    final l = await getLocation();
    return {
      'brand': b,
      'dealer': d,
      'location': l,
    };
  }

  /* ================= PICK PROFILE ================= */
  static Future<void> saveProfile(String path) async {
    await _storage.write(key: _pickProfile, value: path);
  }

  static Future<String?> getProfile() async {
    return await _storage.read(key: _pickProfile);
  }

  /* ================= LOGOUT ================= */

  static Future<void> logout(String logoutType) async {
    void yesLogout() async {
      final tCode = await getTCode();
      final userId = await getUserId();
      final locationId = await getLocationId();
      final token = await getDeviceToken();

      try {
        await GainerApiService().logoutContinue(
          empId: tCode,
          userId: userId,
          deviceToken: token,
          logoutType: logoutType,
          locationId: locationId,
        );
      } catch (_) {}
      // Clear session data
      await deleteStorage();

      Get.offAllNamed(Routes.LOGIN);
    }

    //if session expired then without asked logout
    if (logoutType == 'SessionExpired') {
      yesLogout();
    } else {
      GainerDialog.dialogForYesNo(
        text: 'Are you sure, you want to logout ?',
        imgPath: GainerImages.decisionMaking,
        yesFunction: yesLogout,
        noFunction: Get.back,
      );
    }
  }

  ///Delete local storage data
  static Future<void> deleteStorage() async {
    final isRemember = await isRememberMe();
    if (isRemember) {
      final cred = await getCredentials();
      await _storage.deleteAll();
      await saveCredentials(cred['userId']!, cred['password']!);
      return;
    }
    await _storage.deleteAll();
  }
}
