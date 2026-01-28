import 'package:flutter/material.dart';
import 'package:gainer/dealer_monitoring/core/utils/dm_images.dart';
import 'package:gainer/gainer/widget/reusable_elevated_button.dart';
import 'package:gainer/gainer_app/core/constants/gainer_color.dart';
import 'package:get/get.dart';
import '../gainer/screens/colors.dart';
import '../gainer/utility/download_utils.dart';
import '../gainer_app/core/constants/gainer_image.dart';
import 'app_launcher_controller.dart';

// class AppLauncherScreen extends StatelessWidget {
//   AppLauncherScreen({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     // final AppLauncherController controller = Get.find();
//     final controller = Get.put(AppLauncherController());
//
//     // controller.init();
//     final size = MediaQuery.of(context).size;
class AppLauncherScreen extends GetView<AppLauncherController> {
  const AppLauncherScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: GainerColors.background,
      appBar: AppBar(
        // title: const Text("App Switcher"),
        title: Obx(
          () => Text(
            'Hi, ${controller.userName.value}',
            style: const TextStyle(fontSize: 18),
          ),
        ),
        // centerTitle: true,
        backgroundColor: Colors.teal,
      ),
      body: SafeArea(
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  // const Text(
                  //   "Choose which module you want to open",
                  //   style: TextStyle(
                  //       fontSize: 18,
                  //       fontWeight: FontWeight.bold,
                  //       color: Colors.black54),
                  //   textAlign: TextAlign.center,
                  // ),
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
//
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
//                             'A newer version of the App is available.',

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

