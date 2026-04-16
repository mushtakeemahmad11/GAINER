import 'package:flutter/material.dart';
import 'package:gainer/dealer_monitoring/core/utils/dm_images.dart';
import 'package:get/get.dart';
import '../gainer_app/core/constants/gainer_color.dart';
import '../gainer_app/core/constants/gainer_image.dart';
import '../gainer_app/core/utils/url_launch_utils.dart';
import 'app_switcher_controller.dart';

class AppSwitcherView extends GetView<AppSwitcherController> {
  const AppSwitcherView({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SafeArea(
      top: false,
      child: Scaffold(
        backgroundColor: GainerColors.background,
        appBar: AppBar(
          backgroundColor: GainerColors.primary,
          elevation: 0,
          title: Obx(
            () => Text(
              'Hi, ${controller.userName.value}',
              style: const TextStyle(fontSize: 18),
            ),
          ),
        ),
        body: Obx(() {
          // if (controller.isLoading.value) {
          //   return const Center(child: CircularProgressIndicator());
          // }

          return Stack(
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _appCard(
                      logo: GainerImages.gLogo,
                      title: 'Gainer',
                      // subTitle: 'Dead Stock Liquidation',
                      subTitle: 'Faster Liquidation of Dead Stock',
                      isAccessed: controller.appAccess['IsGainerActive'] ?? 1,
                    ),
                    _appCard(
                      logo: DMImages.simsLogo,
                      title: 'SIMS',
                      subTitle: 'Smart Inventory  Management System',
                      isAccessed: controller.appAccess['IsSimsActive'] ?? 1,
                    ),
                    // ElevatedButton(onPressed: (){
                    //   Navigator.push(context, MaterialPageRoute(builder: (_)=>PinScreen()));
                    // }, child: Text("PIN SCREEN")),

                    // _appCard(
                    //   logo: GainerImages.scsCircle,
                    //   title: 'ScanApp',
                    //   subTitle:
                    //       'Two layered audit process ensuring best accuracy',
                    //   isAccessed: 1,
                    // ),
                    // GainerPrimaryButton(
                    //   onPressed: () async {
                    //     await PushNotification.notifyDealer(
                    //       locationID: '30634',
                    //       title: 'ORDER ENQUIRY (Testing Notification)',
                    //       body:
                    //           'Enquiry Received at  for Parts:  worth Rs: /- from "30634". Pl check & accept order via Gainer APP',
                    //       data: {
                    //         'route': Routes.ORDERPLACED,
                    //         'notifyTo': '30634',
                    //       },
                    //     );
                    //   },
                    //   title: 'Test Notification',
                    // ),
                    Spacer(),
                    _AppFooter(version: controller.oldVersion.value),
                  ],
                ),
              ),
              Obx(() {
                if (controller.isAppUpdated.value) {
                  return const SizedBox.shrink();
                }
                return Container(color: Colors.black26);
              }),
              Obx(() {
                if (controller.isAppUpdated.value) {
                  return const SizedBox.shrink();
                }
                return Align(
                    alignment: Alignment.bottomRight,
                    child: _updateAppCard(size));
              }),
            ],
          );
        }),
        // bottomNavigationBar: _AppFooter(
        //   version: controller.oldVersion.value,
        // ),
      ),
    );
  }

  Widget _appCard({
    required String logo,
    required String title,
    required String subTitle,
    required int isAccessed,
  }) {
    bool enable = isAccessed == 1;
    return Card(
      color: enable ? null : Colors.white12,
      // shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: enable ? () => controller.onModuleTap(title) : null,
        borderRadius: BorderRadius.circular(12),
        child: ListTile(
          // leading: Icon(icon, color: const Color(0xFF2C9AA0)),
          leading: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: GainerColors.primary.withAlpha(30),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Image.asset(
              logo,
              height: 32,
            ),
          ),
          // leading: Image.asset(logo, height: 40),
          title: Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              letterSpacing: .2,
            ),
            // style: TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: Text(
            subTitle,
            style: TextStyle(
              fontSize: 13,
              color: Colors.grey.shade600,
            ),
          ),
          trailing: const Icon(Icons.arrow_forward_ios, size: 14),
        ),
      ),
    );
  }

  Widget _updateAppCard(Size size) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 40),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            // color: Colors.black.withOpacity(0.08),
            color: Colors.black.withAlpha(20),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 🔵 Icon Container
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: GainerColors.primary.withAlpha(25),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.system_update_alt_rounded,
              color: GainerColors.primary,
              size: 28,
            ),
          ),

          const SizedBox(width: 14),

          // 📝 Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Update Available 🚀',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),

                const SizedBox(height: 6),

                Text(
                  'A newer version of the app is available. Update now for better performance and new features.',
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.black54,
                    height: 1.4,
                  ),
                ),

                const SizedBox(height: 12),

                // 🔘 Button
                Align(
                  alignment: Alignment.centerRight,
                  child: GestureDetector(
                    onTap: UrlLaunchUtils.downloadApk,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: GainerColors.primary,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: const Text(
                        'Update Now',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );

    // return Card(
    //   color: GainerColors.background,
    //   margin: EdgeInsets.symmetric(horizontal: 15, vertical: 45),
    //   elevation: 2,
    //   child: Padding(
    //     padding: const EdgeInsets.all(8.0),
    //     child: Row(
    //       mainAxisAlignment: MainAxisAlignment.center,
    //       crossAxisAlignment: CrossAxisAlignment.start,
    //       children: [
    //         Icon(Icons.system_update, color: GainerColors.primary, size: 45),
    //         Column(
    //           mainAxisSize: MainAxisSize.min,
    //           crossAxisAlignment: CrossAxisAlignment.start,
    //           children: [
    //             Text(
    //               'Update Available',
    //               style: TextStyle(
    //                 fontSize: 18,
    //                 fontWeight: FontWeight.bold,
    //                 color: GainerColors.primary,
    //               ),
    //             ),
    //             const Text(
    //               'A newer version of the App is available.',
    //               style: TextStyle(
    //                 fontSize: 14,
    //                 color: Colors.black54,
    //                 height: 1.4,
    //               ),
    //             ),
    //             const SizedBox(height: 5),
    //             GainerPrimaryButton(
    //               width: size.width * .5,
    //               height: 35,
    //               title: 'Update Now',
    //               onPressed: DownloadUtils.downloadApk,
    //             ),
    //           ],
    //         ),
    //       ],
    //     ),
    //   ),
    // );
  }

  // Widget _updateAppCard(Size size) {
  //   return Card(
  //     color: GainerColors.background,
  //     margin: EdgeInsets.symmetric(horizontal: 15, vertical: 45),
  //     elevation: 2,
  //     child: Padding(
  //       padding: const EdgeInsets.all(8.0),
  //       child: Row(
  //         mainAxisAlignment: MainAxisAlignment.center,
  //         crossAxisAlignment: CrossAxisAlignment.start,
  //         children: [
  //           Icon(Icons.system_update, color: GainerColors.primary, size: 45),
  //           Column(
  //             mainAxisSize: MainAxisSize.min,
  //             crossAxisAlignment: CrossAxisAlignment.start,
  //             children: [
  //               Text(
  //                 'Update Available',
  //                 style: TextStyle(
  //                   fontSize: 18,
  //                   fontWeight: FontWeight.bold,
  //                   color: GainerColors.primary,
  //                 ),
  //               ),
  //               const Text(
  //                 'A newer version of the App is available.',
  //                 style: TextStyle(
  //                   fontSize: 14,
  //                   color: Colors.black54,
  //                   height: 1.4,
  //                 ),
  //               ),
  //               const SizedBox(height: 5),
  //               GainerPrimaryButton(
  //                 width: size.width * .5,
  //                 height: 35,
  //                 title: 'Update Now',
  //                 onPressed: DownloadUtils.downloadApk,
  //               ),
  //             ],
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }
}

class _AppFooter extends StatelessWidget {
  final String version;

  const _AppFooter({required this.version});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        RichText(
          text: TextSpan(
            style: const TextStyle(
              fontSize: 13,
              color: Colors.black87,
            ),
            children: [
              const TextSpan(text: 'Powered by '),
              TextSpan(
                text: 'SpareCare Solutions',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).primaryColor,
                ),
              ),
            ],
          ),
        ),
        Text(
          "v$version",
          style: const TextStyle(color: Colors.black54, fontSize: 12),
        ),
      ],
    );
    // return Container(
    //   padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
    //   decoration: BoxDecoration(
    //     // color: Colors.grey.shade50,
    //     color: GainerColors.background,
    //     border: Border(
    //       top: BorderSide(color: Colors.grey.shade300),
    //     ),
    //   ),
    //   child: Row(
    //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //     children: [
    //       // Company branding
    //       Row(
    //         children: [
    //           Container(
    //             height: 8,
    //             width: 8,
    //             decoration: BoxDecoration(
    //               color: Theme.of(context).primaryColor,
    //               shape: BoxShape.circle,
    //             ),
    //           ),
    //           const SizedBox(width: 8),
    //           const Text(
    //             'SpareCare Solutions',
    //             style: TextStyle(
    //               fontSize: 14,
    //               fontWeight: FontWeight.w600,
    //               letterSpacing: 0.4,
    //             ),
    //           ),
    //         ],
    //       ),
    //
    //       // Version
    //       Text(
    //         'v$version',
    //         style: const TextStyle(
    //           fontSize: 12,
    //           color: Colors.black54,
    //           fontWeight: FontWeight.w500,
    //         ),
    //       ),
    //     ],
    //   ),
    // );
  }
}
