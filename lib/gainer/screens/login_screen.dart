import 'package:flutter/material.dart';
import 'package:gainer/gainer_app/core/constants/gainer_color.dart';
import 'package:get/get.dart';
// import '../../main.dart';
import '../../main.dart';
import '../apis_functionality/api_service.dart';
import '../apis_functionality/firebase_db_creation.dart';
import '../apis_functionality/firebase_notification_service.dart';
import '../controllers/home_screen_controller.dart';
import '../controllers/login_screen_controller.dart';
import '../controllers/user_details/user_controller.dart';
import '../model/user_model.dart';
import '../shared_preferences/shared_preferences_get_data.dart';
import '../shared_preferences/shared_preferences_remove_data.dart';
import '../shared_preferences/shared_preferences_set_data.dart';
import '../widget/circular_progress_indicator.dart';
import 'constant_image_path.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();

  // Dependency Injection using GetX
  final LocationController locationController = Get.put(LocationController());
  final LoginControllers loginControllers = Get.put(LoginControllers());
  final UserController userController = Get.put(UserController());

  // Text Controllers
  final TextEditingController userId = TextEditingController();
  final TextEditingController userPass = TextEditingController();
  final TextEditingController userIdForgetField = TextEditingController();
  final TextEditingController userEmailForgetField = TextEditingController();
  // make instance of Notification class
  NotificationServices notificationServices = NotificationServices();

  Future<void> loadSavedCredentials() async {
    final isRemembered = await getBoolData('remember_me') ?? false;

    if (isRemembered) {
      userId.text = await getStringData('username') ?? '';
      userPass.text = await getStringData('password') ?? '';
      loginControllers.updateRemember(true);
      // loginControllers.rememberMe.value = true;

      // // Trigger biometric login
      // final auth = LocalAuthentication();
      // final canCheck = await auth.canCheckBiometrics;
      // final supported = await auth.isDeviceSupported();
      //
      // if (canCheck && supported) {
      //   final authenticated = await auth.authenticate(
      //     localizedReason: 'Authenticate to login',
      //     options: const AuthenticationOptions(
      //       biometricOnly: false,
      //       stickyAuth: true,
      //     ),
      //   );
      //
      //   if (authenticated) {
      //     print("✅ Biometric Login Successful");
      //     // navigateToHome();
      //   } else {
      //     print("❌ Biometric Authentication Failed");
      //   }
      // }
    }
  }

  @override
  void initState() {
    super.initState();
    loadSavedCredentials();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SafeArea(
      top: false,
      bottom: true,
      child: Scaffold(
        backgroundColor: GainerColors.background,
        body: Stack(
          children: [
            LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: constraints.maxHeight,
                    ),
                    child: IntrinsicHeight(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // const SizedBox(height: 20),

                          /// Top Image (natural height)
                          Image.asset(
                            AppImages.loginBanner,
                            width: size.width,
                            height: size.height * .5,
                            fit: BoxFit.cover,
                          ),

                          // const SizedBox(height: 10),
                          // const Spacer(),
                          Expanded(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset(
                                  AppImages.appLogo,
                                  height: 30,
                                ),
                                const SizedBox(width: 10),
                                const Text(
                                  'Tel-e-scope',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          // Row(
                          //   mainAxisAlignment: MainAxisAlignment.center,
                          //   children: [
                          //     Image.asset(
                          //       AppImages.appLogo,
                          //       height: 50,
                          //     ),
                          //     const SizedBox(width: 10),
                          //     const Text(
                          //       'Tel-e-scope',
                          //       style: TextStyle(
                          //         fontSize: 25,
                          //         fontWeight: FontWeight.bold,
                          //       ),
                          //     ),
                          //   ],
                          // ),
                          // const SizedBox(height: 20),
                          // const Spacer(),
                          // Image.asset(
                          //   Constants.scsBlack,
                          //   height: 100,
                          // ),
                          // const SizedBox(height: 12),
                          /// THIS TAKES REMAINING HEIGHT
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            decoration: BoxDecoration(
                              color: Color(0xFFBBE4E1),
                              borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(30)),
                              // border: Border.symmetric(horizontal: BorderSide(color: Colors.black26))
                            ),
                            child: Form(
                              key: _formKey,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(height: 10),
                                  Image.asset(
                                    AppImages.scsBlack,
                                    height: 60,
                                  ),
                                  // Image.asset(
                                  //   AppImages.scsBlack,
                                  //   height: 100,
                                  // ),
                                  ///Error msg
                                  Obx(() {
                                    final err = loginControllers.errorMsg.value;
                                    return err != null
                                        ? Text(
                                            err,
                                            style: TextStyle(
                                                color: Colors.red,
                                                fontSize: 14),
                                          )
                                        : SizedBox.shrink();
                                  }),
                                  const SizedBox(height: 20),

                                  /// User ID
                                  TextFormField(
                                    controller: userId,
                                    decoration: InputDecoration(
                                      labelText: 'Enter your user id',
                                      prefixIcon: const Icon(Icons.person),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      fillColor: Colors.white,
                                      filled: true,
                                    ),
                                    onChanged: (val) {
                                      // Allow letters, numbers, and # @ ! $ . - _ %
                                      String filteredValue = val.replaceAll(
                                          RegExp(r'[^a-zA-Z0-9#@!$\.\-_]'), '');
                                      // Prevent unnecessary updates that reset the cursor position
                                      if (val != filteredValue) {
                                        userId.value = TextEditingValue(
                                          text: filteredValue,
                                          selection: TextSelection.collapsed(
                                              offset: filteredValue.length),
                                        );
                                      }
                                    },
                                    validator: (value) =>
                                        value == null || value.isEmpty
                                            ? 'user id required'
                                            : null,
                                  ),

                                  const SizedBox(height: 15),

                                  /// Password
                                  Obx(
                                    () => TextFormField(
                                      controller: userPass,
                                      obscureText:
                                          loginControllers.isObscureText.value,
                                      decoration: InputDecoration(
                                        labelText: 'Enter Your Password',
                                        prefixIcon: const Icon(Icons.lock),
                                        suffixIcon: IconButton(
                                          icon: Icon(
                                            loginControllers.isObscureText.value
                                                ? Icons.visibility
                                                : Icons.visibility_off,
                                            // color: AppColor.primary,
                                            color: const Color(0xFF2C9AA0),
                                          ),
                                          onPressed: loginControllers
                                              .toggleObscureText,
                                        ),
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                        ),
                                        fillColor: Colors.white,
                                        filled: true,
                                      ),
                                      onChanged: (val) {
                                        String filteredValue = val.replaceAll(
                                            RegExp(
                                                r'[^a-zA-Z0-9!@#$%^&*()_+\-=\[\]{};:,.<>?/|]'),
                                            ''); // Removes invalid characters

                                        if (val != filteredValue) {
                                          userPass.value = TextEditingValue(
                                            text: filteredValue,
                                            selection: TextSelection.collapsed(
                                                offset: filteredValue.length),
                                          );
                                        }
                                      },
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Please enter your password';
                                        }
                                        if (value.length < 6) {
                                          return 'Password must be at least 6 characters long';
                                        }
                                        return null;
                                      },
                                    ),
                                  ),

                                  // const SizedBox(height: 10),

                                  /// Remember Me
                                  Row(
                                    children: [
                                      Obx(
                                        () => Checkbox(
                                          activeColor: const Color(0xFF2C9AA0),
                                          value:
                                              loginControllers.rememberMe.value,
                                          onChanged: (value) => loginControllers
                                              .updateRemember(value ?? false),
                                        ),
                                      ),
                                      const Text('Remember Me'),
                                    ],
                                  ),

                                  // const SizedBox(height: 20),

                                  /// Login Button
                                  SizedBox(
                                    width: double.infinity,
                                    height: 50,
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor:
                                            const Color(0xFF2C9AA0),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(14),
                                        ),
                                      ),
                                      onPressed: () {
                                        if (_formKey.currentState!.validate()) {
                                          if (!loginControllers
                                              .isLoading.value) {
                                            _login();
                                          }
                                        }
                                      },
                                      // onPressed: controller.isLoading.value
                                      //     ? null
                                      //     : controller.login,
                                      child: Text(
                                        'Login',
                                        style: TextStyle(
                                          fontSize: 18,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: mq.height * .03),
                                  // const SizedBox(height: 20),
                                  // const SizedBox(height: 80),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),

            // Loading Indicator
            Obx(() => loginControllers.isLoading.value
                ? customCircularProgressIndicator()
                : const SizedBox.shrink()),
          ],
        ),
      ),
    );

    // return Scaffold(
    //   backgroundColor: AppColor.primary,
    //   body: Stack(
    //     children: [
    //       SingleChildScrollView(
    //         child: Column(
    //           children: [
    //             SizedBox(height: mq.height * .25),
    //
    //             // Login Card
    //             Padding(
    //               padding: EdgeInsets.symmetric(horizontal: mq.width * .05),
    //               child: Card(
    //                 elevation: 7,
    //                 child: Padding(
    //                   padding: EdgeInsets.symmetric(
    //                     horizontal: mq.width * .05,
    //                     vertical: mq.height * .01,
    //                   ),
    //                   child: Column(
    //                     children: [
    //                       // App Logo
    //                       Center(
    //                         child: SizedBox(
    //                             height: mq.height * .08,
    //                             // child: Image.asset(Constants.scsBlack)),
    //                             child: Image.asset(Constants.appLogo)),
    //                       ),
    //
    //                       // Error Message Display
    //                       Obx(() => loginControllers.errorMsg.value != null
    //                           ? Column(
    //                               children: [
    //                                 SizedBox(height: mq.height * .01),
    //                                 Text(
    //                                   loginControllers.errorMsg.value ?? '',
    //                                   textAlign: TextAlign.center,
    //                                   style: const TextStyle(color: Colors.red),
    //                                 ),
    //                               ],
    //                             )
    //                           : const SizedBox()),
    //
    //                       // Login Form
    //                       Form(
    //                         key: _formKey,
    //                         child: Column(
    //                           crossAxisAlignment: CrossAxisAlignment.end,
    //                           children: [
    //                             // User ID Field
    //                             CustomTextFormField(
    //                               controller: userId,
    //                               text: 'User ID',
    //                               suffixIcon: Icon(Icons.person,
    //                                   color: AppColor.primary),
    //                               onChanged: (val) {
    //                                 // Allow letters, numbers, and # @ ! $ . - _ %
    //                                 String filteredValue = val.replaceAll(
    //                                     RegExp(r'[^a-zA-Z0-9#@!$\.\-_]'), '');
    //                                 // String filteredValue = val.replaceAll(
    //                                 //     RegExp(r'[^a-zA-Z0-9#@!$\.\-_%]'), '');
    //
    //                                 // Prevent unnecessary updates that reset the cursor position
    //                                 if (val != filteredValue) {
    //                                   userId.value = TextEditingValue(
    //                                     text: filteredValue,
    //                                     selection: TextSelection.collapsed(
    //                                         offset: filteredValue.length),
    //                                   );
    //                                 }
    //                               },
    //                               validator: (value) =>
    //                                   value == null || value.isEmpty
    //                                       ? 'Please enter your user Id'
    //                                       : null,
    //                             ),
    //
    //                             // Password Field with Visibility Toggle
    //                             Obx(
    //                               () => CustomTextFormField(
    //                                 controller: userPass,
    //                                 text: 'Password',
    //                                 suffixIcon: IconButton(
    //                                   onPressed: () {
    //                                     loginControllers.toggleObscureText();
    //                                   },
    //                                   icon: Icon(
    //                                     loginControllers.isObscureText.value
    //                                         ? Icons.visibility
    //                                         : Icons.visibility_off,
    //                                     color: AppColor.primary,
    //                                   ),
    //                                 ),
    //                                 isPass:
    //                                     loginControllers.isObscureText.value,
    //                                 onChanged: (val) {
    //                                   // String filteredValue = val.replaceAll(
    //                                   //   RegExp(r'[^a-zA-Z0-9!@#$%^&*()_+\-=\[\]{};:,.<>?/|]'),
    //                                   //   '',
    //                                   // );
    //
    //                                   String filteredValue = val.replaceAll(
    //                                       RegExp(
    //                                           r'[^a-zA-Z0-9!@#$%^&*()_+\-=\[\]{};:,.<>?/|]'),
    //                                       ''); // Removes invalid characters
    //
    //                                   if (val != filteredValue) {
    //                                     userPass.value = TextEditingValue(
    //                                       text: filteredValue,
    //                                       selection: TextSelection.collapsed(
    //                                           offset: filteredValue.length),
    //                                     );
    //                                   }
    //                                 },
    //                                 validator: (value) {
    //                                   if (value == null || value.isEmpty) {
    //                                     return 'Please enter your password';
    //                                   }
    //                                   if (value.length < 6) {
    //                                     return 'Password must be at least 6 characters long';
    //                                   }
    //                                   return null;
    //                                 },
    //                               ),
    //                             ),
    //
    //                             Row(
    //                               // mainAxisAlignment: MainAxisAlignment.end,
    //                               children: [
    //                                 Obx(
    //                                   () => Checkbox(
    //                                       value:
    //                                           loginControllers.rememberMe.value,
    //                                       onChanged: (value) => loginControllers
    //                                           .updateRemember(value ?? false)),
    //                                 ),
    //                                 Text("Remember Me"),
    //                               ],
    //                             ),
    //                             SizedBox(height: mq.height * .02),
    //                             // // Forgot Password
    //                             // InkWell(
    //                             //   onTap: () => dialogForForgetPass(),
    //                             //   child: Text('Forget Password',
    //                             //       style:
    //                             //           TextStyle(color: AppColor.primary)),
    //                             // ),
    //                             // SizedBox(height: mq.height * .02), //comment
    //
    //                             // Login Button
    //                             CustomElevatedButton(
    //                               text: 'Login',
    //                               onTap: () {
    //                                 if (_formKey.currentState!.validate()) {
    //                                   if (!loginControllers.isLoading.value) {
    //                                     _login();
    //                                   }
    //                                 }
    //                               },
    //                             ),
    //                           ],
    //                         ),
    //                       ),
    //                     ],
    //                   ),
    //                 ),
    //               ),
    //             ),
    //           ],
    //         ),
    //       ),
    //
    //       // Loading Indicator
    //       Obx(() => loginControllers.isLoading.value
    //           ? customCircularProgressIndicator()
    //           : const SizedBox.shrink()),
    //     ],
    //   ),
    // );
  }

  Future<void> _storeDetailsForRememberMe(
      String userid, String password) async {
    if (loginControllers.rememberMe.value) {
      await setStringData('username', userid);
      await setStringData('password', password);
      await setBoolData('remember_me', true);
    } else {
      await removeData('username');
      await removeData('password');
      await setBoolData('remember_me', false);
    }
  }

  /// Handles user login process
  Future<void> _login() async {
    final userid = userId.text.trim();
    final password = userPass.text.trim();
    //request call for DeviceToken
    String deviceToken =
        await notificationServices.getFirebaseMessagingToken() ??
            'deviceTokenNotFound ';
    loginControllers.isLoading.value = true;
    loginControllers.errorMsg.value = null;

    final response =
        await ApiService().loginUser(userid, password, deviceToken);
    // loginControllers.isLoading.value = false;
    if (response['success']) {
      await _storeDetailsForRememberMe(userid, password);
      final userData = response['data'];
      _storeUserData(userData);

      locationController.getLocationUsingTCode().then((val) async {
        await setStringData('UserID', userid);
        int tCode = await getIntData("tCode");
        // Get the DealerID (assuming all have the same one)
        final dealerId = locationController.locationList.first['DealerID'];
        // Get all locations
        final List<String> locationsId = locationController.locationList
            .map<String>((item) => item['LocationID'].toString())
            .toList();
        loginControllers.isLoading.value = false;
        // Get.offAll(() => MainScreen());  // Only for Gainer
        // Get.offAll(() => AppLauncherScreen());
        Get.offAllNamed('/app-launching');

        // Get.offAll(() => const IntroScreen());
        FirebaseDB firebaseDB = FirebaseDB();
        await firebaseDB.storeDeviceToken(
          userId: userid,
          userCode: tCode.toString(),
          dealerId: dealerId.toString(),
          locationIds: locationsId,
        );
      });
    } else {
      loginControllers.isLoading.value = false;
      loginControllers.errorMsg.value = response['message'];
    }
  }

  /// Stores user data after successful login
  void _storeUserData(Map<String, dynamic> userData) {
    final user = UserModel.fromJson({
      "userStatus": userData['Status'],
      "userTCode": userData['tCode'],
      "firstName": userData['FirstName'],
      "lastName": userData['LastName'],
      "email": userData['Email'],
      "lastLogin": userData['LastLogin'],
      "photo": userData['Photo'],
    });

    userController.setUser(user);

    // Store user details in SharedPreferences
    setBoolData('isLogin', true);
    setIntData('tCode', user.userTCode.toInt());
    setStringData('firstName', user.firstName);
    setStringData('lastName', user.lastName);
    setStringData('email', user.email);
    setStringData('lastLogin', user.lastLogin);
    setStringData('photo', user.photo);
    setIntData('login_time', DateTime.now().millisecondsSinceEpoch);
  }
}
