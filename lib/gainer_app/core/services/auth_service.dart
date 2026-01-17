import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';

import '../../../gainer/apis_functionality/api_service.dart';
import '../../../gainer/model/user_model.dart';
import '../../routes/app_routes.dart';

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

  static const String _brandId = 'brand_id';
  static const String _dealerId = 'dealer_id';
  static const String _locationId = 'location_id';

  /* ================= USER ID ================= */

  static Future<void> saveUserId(String userId) async {
    await _storage.write(key: _userId, value: userId);
  }

  static Future<String?> getUserId() async {
    return _storage.read(key: _userId);
  }

  /* ================= CREDENTIALS ================= */

  static Future<void> saveCredentials(String password) async {
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

    return UserModel.fromJson2(jsonDecode(userString));
  }

  static Future<bool> isLoggedIn() async {
    final value = await _storage.read(key: _loginKey);
    return value == 'true';
  }

  /* ================= SESSION EXPIRY ================= */

  static Future<bool> checkSessionExpired() async {
    final logTime = await _storage.read(key: _loginTime);
    final int loginTime = int.tryParse(logTime ?? '') ?? 0;

    const int fourHours = 4 * 60 * 60 * 1000;
    final int currentTime = DateTime.now().millisecondsSinceEpoch;

    return (currentTime - loginTime) > fourHours;
  }

  /* ================= TCODE ================= */

  static Future<void> saveTCode(String tCode) async {
    await _storage.write(key: _tCode, value: tCode);
  }

  static Future<String?> getTCode() async {
    return _storage.read(key: _tCode);
  }

  /* ================= FCM ================= */

  static Future<void> saveDeviceToken(String token) async {
    await _storage.write(key: _deviceToken, value: token);
  }

  static Future<String?> getDeviceToken() async {
    return _storage.read(key: _deviceToken);
  }

  /* ================= store Brand Dealer Location ================= */
  static Future<void> saveBDL(
      String brandId, String dealerId, String locationId) async {
    await _storage.write(key: _brandId, value: brandId);
    await _storage.write(key: _dealerId, value: dealerId);
    await _storage.write(key: _locationId, value: locationId);
  }

  static Future<String> getBrandId() async {
    return await _storage.read(key: _brandId) ?? '';
  }

  static Future<String> getDealerId() async {
    return await _storage.read(key: _dealerId) ?? '';
  }

  static Future<String> getLocationId() async {
    return await _storage.read(key: _locationId) ?? '';
  }

  static Future<Map<String, String>> getBDL() async {
    final bid = await getBrandId();
    final did = await getDealerId();
    final lid = await getLocationId();
    return {
      'brandId': bid,
      'dealerId': did,
      'locationId': lid,
    };
  }

  /* ================= LOGOUT ================= */

  static Future<void> logout(String logoutType) async {
    final tCode = await getTCode() ?? '';
    final userId = await getUserId() ?? '';
    final token = await getDeviceToken() ?? '';

    try {
      await ApiService().logoutContinue(
        empId: tCode,
        userId: userId,
        deviceToken: token,
        logoutType: logoutType,
      );
    } catch (_) {}

    // Clear session data
    await _storage.delete(key: _loginKey);
    await _storage.delete(key: _loginTime);
    await _storage.delete(key: _userData);
    await _storage.delete(key: _tCode);
    await _storage.delete(key: _brandId);
    await _storage.delete(key: _dealerId);
    await _storage.delete(key: _locationId);
    // await _storage.delete(key: _userId);

    Get.offAllNamed(Routes.LOGIN);
  }
}

// import 'package:flutter_secure_storage/flutter_secure_storage.dart';
// import 'package:gainer/gainer/model/user_model.dart';
// import 'package:get/get.dart';
// import 'dart:convert';
// import '../../gainer/apis_functionality/api_service.dart';
// import '../routes/app_routes.dart';
//
// class AuthService {
//   // static const _storage = FlutterSecureStorage();
//   static final FlutterSecureStorage _storage = FlutterSecureStorage();
//
//   // static const _tokenKey = 'auth_token';
//   static const _loginKey = 'is_logged_in';
//   static const _isRememberCred = 'is_remember_cred';
//   static const _userId = 'user_id';
//   static const _tCode = 't_code';
//   static const _pass = 'user_pass';
//   static const _userData = 'user_data';
//   static const _loginTime = 'login_time';
//   static const _deviceToken = 'device_token';
//
//   //save suerId
//   static Future<void> saveUserId(String userId) async {
//     await _storage.write(key: _userId, value: userId);
//   }
//
//   //Get suerId
//   static Future<String?> getUserId() async {
//     return await _storage.read(key: _userId);
//   }
//
//   // // Save login
//   // static Future<void> saveLogin(String userId) async {
//   //   await _storage.write(key: _loginKey, value: 'true');
//   //   await saveUserId(userId);
//   //   // await _storage.write(key: _userId, value: userId);
//   //   // await _storage.write(key: _tokenKey, value: token);
//   // }
//
//   // Save cred
//   static Future<void> saveCred(String pass) async {
//     await _storage.write(key: _pass, value: pass);
//     await _storage.write(key: _isRememberCred, value: 'true');
//   }
//
//   // Get cred
//   static Future<Map<String, String?>> getCred() async {
//     final userId = await _storage.read(key: _userId);
//     final pass = await _storage.read(key: _pass);
//     return {'userId': userId, 'pass': pass};
//   }
//
//   // cred remove
//   static Future<void> removeCred() async {
//     await _storage.delete(key: _pass);
//     await _storage.delete(key: _isRememberCred);
//   }
//
//   //save user data
//   // static Future<void> saveUser(UserModel user)async{
//   //   await _storage.write(key: _userData, value: user);
//   // }
//
//   //save TCode
//   static Future<void> saveTCode(String tCode) async {
//     await _storage.write(key: _tCode, value: tCode);
//   }
//
//   //get TCode
//   static Future<String?> getTCode() async {
//     return await _storage.read(key: _tCode);
//   }
//
//   static Future<void> saveUser(String userid, UserModel user) async {
//     await _storage.write(key: _loginKey, value: 'true');
//     await _storage.write(
//         key: _loginTime,
//         value: DateTime.now().millisecondsSinceEpoch.toString());
//     await saveUserId(userid);
//     await saveTCode(user.userTCode.toString());
//     final userJson = jsonEncode(user.toJson2());
//     await _storage.write(
//       key: _userData,
//       value: userJson,
//     );
//   }
//
//   //save device token for FCM
//   static Future<void> saveDeviceToken(String token) async {
//     await _storage.write(key: _deviceToken, value: token);
//   }
//
//   static Future<String?> getDeviceToken() async {
//     return await _storage.read(key: _deviceToken);
//   }
//
//   // Check login
//   static Future<bool> isLoggedIn() async {
//     final value = await _storage.read(key: _loginKey);
//     return value == 'true';
//   }
//
//   // Check session expired(true) or not(false)
//   static Future<bool> checkSession() async {
//     final String? logTime = await _storage.read(key: _loginTime);
//     int currentTime = DateTime.now().millisecondsSinceEpoch;
//     const int fourHours = 4 * 60 * 60 * 1000;
//     final int loginTime = int.parse(logTime ?? '0');
//     return (currentTime - loginTime) > fourHours;
//   }
//
//   // Check remember cred
//   static Future<bool> isRememberMe() async {
//     final value = await _storage.read(key: _isRememberCred);
//     return value == 'true';
//   }
//
//   // // Get token
//   // static Future<String?> getToken() async {
//   //   return await _storage.read(key: _tokenKey);
//   // }
//
//   // get userData
//   static Future<UserModel?> getUser() async {
//     final userString = await _storage.read(key: _userData);
//
//     if (userString == null) return null;
//
//     return UserModel.fromJson2(
//       jsonDecode(userString),
//     );
//   }
//
//   // Logout
//   static Future<void> logout(String logoutType) async {
//     // await _storage.deleteAll();
//     await _storage.delete(key: _loginKey);
//     Get.offAllNamed(Routes.LOGIN);
//     final tCode = await getTCode() ?? "";
//     final userid = await getUserId() ?? "";
//     final token = await getDeviceToken() ?? "";
//     await ApiService().logoutContinue(
//       empId: tCode,
//       userId: userid,
//       deviceToken: token,
//       logoutType: logoutType,
//     );
//
//     // await _storage.delete(key: _tokenKey);
//   }
// }
