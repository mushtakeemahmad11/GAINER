import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gainer/dealer_monitoring/core/utils/dm_images.dart';
import 'package:gainer/dealer_monitoring/screens/dm_splash_screen.dart';
import 'package:gainer/gainer/widget/reusable_elevated_button.dart';
import 'package:gainer/gainer_app/core/constants/gainer_color.dart';
import 'package:gainer/scanapp/screens/scanapp_splash_screen.dart';
import 'package:get/get.dart';
import 'gainer/apis_functionality/api_service.dart';
import 'gainer/controllers/check_internet/connectivity_controller.dart';
import 'gainer/controllers/check_internet/no_internet_screen.dart';
import 'gainer/controllers/home_screen_controller.dart';
import 'gainer/screens/colors.dart';
import 'gainer/screens/login_screen.dart';
import 'gainer/screens/splash_screen.dart';
import 'gainer/shared_preferences/shared_preferences_get_data.dart';
import 'gainer/shared_preferences/shared_preferences_remove_data.dart';
import 'gainer/shared_preferences/shared_preferences_set_data.dart';
import 'gainer/utility/check_session.dart';
import 'gainer/utility/download_utils.dart';
import 'gainer_app/core/constants/gainer_image.dart';

class AppLauncherScreen extends StatelessWidget {
  AppLauncherScreen({super.key});

  final AppLauncherController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      // backgroundColor: Colors.white,
      backgroundColor: GainerColors.background,
      appBar: AppBar(
        title: const Text("App Switcher"),
        centerTitle: true,
        backgroundColor: Colors.teal,
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                const Text(
                  "Choose which module you want to open",
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black54),
                  textAlign: TextAlign.center,
                ),
                // const SizedBox(height: 30),
                // _buildAppCard(
                //   title: "Gainer",
                //   subtitle: "Business Performance Dashboard",
                //   icon: Icons.insights,
                //   color: Colors.deepPurple,
                //   onTap: () => controller.gotoScreen("gainer"),
                // ),
                _appCard(
                  logo: GainerImages.gLogo,
                  title: "Gainer",
                  subTitle: "Dead Stock Liquidation",
                  onTap: () => controller.gotoScreen("gainer"),
                ),
                // const SizedBox(height: 10),
                _appCard(
                  logo: DMImages.simsLogo,
                  title: "SIMS",
                  subTitle: "Smart Inventory Management System",
                  onTap: () => controller.gotoScreen("sims"),
                ),

                // _buildAppCard(
                //   title: "SIMS",
                //   subtitle: "Smart Inventory Management System",
                //   icon: Icons.inventory,
                //   color: Colors.indigo,
                //   onTap: () => controller.gotoScreen("sims"),
                // ),
                const Spacer(),
                // Obx(() {
                //   if (!controller.isAppUpdated.value) {
                //     return const SizedBox.shrink();
                //   }
                //   return _updateCard();
                // }),
                Align(
                  alignment: Alignment.bottomRight,
                  child: Text(
                    "Version: ${controller.oldVersion.value}",
                    style: const TextStyle(color: Colors.black54),
                  ),
                ),
              ],
            ),
          ),
          Obx(() {
            if (controller.isAppUpdated.value) return const SizedBox.shrink();
            return Container(color: Colors.black26);
          }),
          Obx(() {
            if (controller.isAppUpdated.value) return const SizedBox.shrink();
            return Align(
                alignment: Alignment.bottomRight, child: _updateCard(size));
          }),
        ],
      ),
    );
  }

// class AppLauncherScreen extends StatefulWidget {
//   const AppLauncherScreen({super.key});
//
//   @override
//   State<AppLauncherScreen> createState() => _AppLauncherScreenState();
// }
//
// class _AppLauncherScreenState extends State<AppLauncherScreen>
//     with WidgetsBindingObserver {
//   final LocationController locationController = Get.put(LocationController());
//   // final ConnectivityController _connectivityController =
//   //     Get.put(ConnectivityController());
//   // final Controller _c = Get.put(Controller());
//   final AppLauncherController _c = Get.find();
//
//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addObserver(this);
//     _initWork();
//   }
//
//   void _initWork() {
//     _c.checkSession();
//     _c.fetchVersionFromFirestore();
//     _navigateToNextScreen();
//   }
//
//   @override
//   void didChangeAppLifecycleState(AppLifecycleState state) {
//     if (state == AppLifecycleState.resumed) {
//       _c.checkSession();
//     }
//   }
//
//   /// Handles navigation logic based on user login status.
//   Future<void> _navigateToNextScreen() async {
//     bool isLoggedIn = await getBoolData('isLogin') ?? false;
//
//     if (isLoggedIn) {
//       bool checkInt = await checkInternet();
//       if (!checkInt) {
//         Get.to(() => NoInternetScreen());
//         // internetNotAvl();
//         return;
//       }
//       await locationController.getLocationUsingTCode();
//       if (locationController.errorMsg.value != null) {
//         Get.to(() => NoInternetScreen());
//         internetNotAvl();
//         CustomBottomSheet.showSnackBar(
//             context, locationController.errorMsg.value!);
//       } else {
//         // Get.off(() => MainScreen());
//         // // Get.offAll(() => const AppNavigate());
//         // // Get.offAll(() => const AppLauncherScreen());
//       }
//     } else {
//       Get.offAll(() => const LoginScreen());
//       // Get.offAll(() => const DMSplashScreen());
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         title: const Text("App Switcher"),
//         centerTitle: true,
//         backgroundColor: Colors.teal,
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(20.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.stretch,
//           // mainAxisSize: MainAxisSize.min,
//           children: [
//             const Text(
//               "Choose which module you want to open",
//               style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//               textAlign: TextAlign.center,
//             ),
//             const SizedBox(height: 30),
//             Expanded(
//               child: SingleChildScrollView(
//                 child: Column(
//                   children: [
//                     _buildAppCard(
//                       context,
//                       title: "Gainer",
//                       subtitle: "Business Performance Dashboard",
//                       icon: Icons.insights,
//                       color: Colors.deepPurple,
//                       onTap: () => _c.gotoScreen("Gainer"),
//                     ),
//                     const SizedBox(height: 20),
//                     _buildAppCard(
//                       context,
//                       title: "SIMS",
//                       subtitle: "Smart Inventory Management System",
//                       icon: Icons.inventory,
//                       color: Colors.indigo,
//                       onTap: () => _c.gotoScreen("SIMS"),
//                     ),
//                     const SizedBox(height: 50),
//                     ElevatedButton(
//                       onPressed: () => Get.to(() => AppSwitcherScreen()),
//                       child: Text("AppSwitcher"),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//
//             Obx(() {
//               if (_c.isAppUpdated.value) return SizedBox.shrink();
//               return Card(
//                 elevation: 2,
//                 child: Padding(
//                   padding: const EdgeInsets.all(8.0),
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Icon(Icons.system_update,
//                           color: AppColor.primary, size: 45),
//                       Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text(
//                             'Update Available',
//                             style: TextStyle(
//                               fontSize: 18,
//                               fontWeight: FontWeight.bold,
//                               color: AppColor.primary,
//                             ),
//                           ),
//                           const Text(
//                             'A newer version of the app_switcher_view is available.',
//                             style: TextStyle(
//                               fontSize: 14,
//                               color: Colors.black54,
//                               height: 1.4,
//                             ),
//                           ),
//                           const SizedBox(height: 5),
//                           SizedBox(
//                             width: mq.width * .5,
//                             child: CustomElevatedButton(
//                               onTap: () => DownloadUtils.downloadApk(),
//                               text: 'Update Now',
//                             ),
//                           ),
//                         ],
//                       ),
//                     ],
//                   ),
//                 ),
//               );
//             }),
//
//             // const SizedBox(height: 20),
//             // _buildAppCard(
//             //   context,
//             //   title: "Scan App",
//             //   subtitle: "Self Audit Scan Application",
//             //   icon: Icons.document_scanner_outlined,
//             //   color: Colors.blue,
//             //   onTap: () => gotoScreen("Scanapp"),
//             // ),
//
//             Obx(() => Align(
//                   alignment: Alignment.bottomRight,
//                   child: Text(
//                     "Version: ${_c.oldVersion.value}",
//                     style: TextStyle(color: Colors.black54),
//                   ),
//                 )),
//             const SizedBox(height: 5),
//           ],
//         ),
//       ),
//     );
//   }

  Widget _appCard({
    required String logo,
    required String title,
    required String subTitle,
    required VoidCallback onTap,
  }) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        // leading: Icon(icon, color: const Color(0xFF2C9AA0)),
        leading: Image.asset(logo, height: 40),
        title: Text(
          title,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(subTitle),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: onTap,
      ),
    );
  }

  // Widget _buildAppCard(
  //     {required String title,
  //     required String subtitle,
  //     required IconData icon,
  //     required Color color,
  //     required VoidCallback onTap}) {
  //   return GestureDetector(
  //     onTap: onTap,
  //     child: Card(
  //       elevation: 6,
  //       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
  //       child: Padding(
  //         padding: const EdgeInsets.all(20.0),
  //         child: Row(
  //           children: [
  //             CircleAvatar(
  //               radius: 30,
  //               backgroundColor: color.withAlpha(50),
  //               child: Icon(icon, size: 30, color: color),
  //             ),
  //             const SizedBox(width: 20),
  //             Expanded(
  //               child: Column(
  //                 crossAxisAlignment: CrossAxisAlignment.start,
  //                 children: [
  //                   Text(title,
  //                       style: const TextStyle(
  //                           fontSize: 18, fontWeight: FontWeight.bold)),
  //                   const SizedBox(height: 4),
  //                   Text(subtitle, style: const TextStyle(color: Colors.grey)),
  //                 ],
  //               ),
  //             ),
  //             const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
  //           ],
  //         ),
  //       ),
  //     ),
  //   );
  // }

  Widget _updateCard(Size size) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 15, vertical: 45),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(Icons.system_update, color: AppColor.primary, size: 45),
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Update Available',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColor.primary,
                  ),
                ),
                const Text(
                  'A newer version of the App is available.',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.black54,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 5),
                SizedBox(
                  width: size.width * .5,
                  child: CustomElevatedButton(
                    onTap: () => DownloadUtils.downloadApk(),
                    text: 'Update Now',
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class AppLauncherController extends GetxController with WidgetsBindingObserver {
  final LocationController locationController = Get.find();

  RxString oldVersion = '1.0.1'.obs;
  RxString newVersion = ''.obs;
  RxBool isAppUpdated = true.obs;

  @override
  void onReady() {
    super.onReady();
    WidgetsBinding.instance.addObserver(this);
    _init();
  }

  void _init() {
    checkSession();
    fetchVersionFromFirestore();
    navigateOnLaunch();
  }

  @override
  void onClose() {
    WidgetsBinding.instance.removeObserver(this);
    super.onClose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      checkSession();
    }
  }

  Future<void> navigateOnLaunch() async {
    final isLoggedIn = await getBoolData('isLogin') ?? false;

    if (!isLoggedIn) {
      Get.offAll(() => const LoginScreen());
      return;
    }

    if (!Get.find<ConnectivityController>().isConnected.value) {
      Get.to(() => NoInternetScreen());
      return;
    }

    await locationController.getLocationUsingTCode();

    if (locationController.errorMsg.value != null) {
      Get.to(() => NoInternetScreen());
    }
  }

  Future<void> fetchVersionFromFirestore() async {
    try {
      final doc = await FirebaseFirestore.instance
          .collection('update')
          .doc('tel-e-scope')
          .get();

      if (doc.exists) {
        newVersion.value = doc['versionName'];
        isAppUpdated.value = oldVersion.value == newVersion.value;
      }
    } catch (e) {
      debugPrint('Version fetch error: $e');
    }
  }

  Future<void> gotoScreen(String name) async {
    if (!Get.find<ConnectivityController>().isConnected.value) {
      Get.to(() => NoInternetScreen());
      return;
    }

    switch (name) {
      case 'gainer':
        Get.to(
          () => SplashScreen(),
          transition: Transition.rightToLeft,
        );
        break;
      case 'sims':
        Get.to(
          () => DMSplashScreen(),
          transition: Transition.rightToLeft,
        );
        break;
      case 'scanapp':
        Get.to(() => ScanappSplashScreen());
        break;
    }
  }

  Future<void> checkSession() async {
    final isLoggedIn = await getBoolData('isLogin') ?? false;

    if (!isLoggedIn) return;

    if (await isSessionExpired()) {
      await ApiService().logoutContinue(
        empId: (await getIntData("tCode")).toString(),
        userId: (await getStringData('UserID')).toString(),
        deviceToken: (await getStringData("deviceToken")).toString(),
        logoutType: 'SessionExpired',
      );

      await setBoolData('isLogin', false);
      await removeData('tCode');
      await removeData('userProfile');

      Get.offAll(() => const LoginScreen());
    }
  }
}
