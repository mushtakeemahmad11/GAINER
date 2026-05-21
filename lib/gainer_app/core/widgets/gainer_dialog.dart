import 'package:flutter/material.dart';
import 'package:gainer/gainer_app/core/widgets/gainer_primary_button.dart';
import 'package:get/get.dart';
import '../../../main.dart';
import '../constants/gainer_image.dart';
import '../utils/url_launch_utils.dart';

class GainerDialog {
  /// 🔹 Common helper to show dialog with image, text & buttons
  static Future<void> _showDialog({
    required Widget content,
    List<Widget>? actions,
    bool autoClose = false,
    int closeAfter = 3,
  }) async {
    if (autoClose) {
      Future.delayed(Duration(seconds: closeAfter), () {
        if (Get.isDialogOpen ?? false) Get.back();
      });
    }

    return Get.defaultDialog(
      title: '',
      titlePadding: EdgeInsets.zero,
      content: content,
      actions: actions,
    );
  }

  // /// 🔹 Logout Confirmation
  // static Future<void> logoutBtnFunctionality() async {
  //   return _showDialog(
  //     content: Column(
  //       children: [
  //         Image.asset(GainerImages.decisionMaking, width: mq.width * .2),
  //         SizedBox(height: mq.height * .01),
  //         const Text(
  //           'Are you sure, you want to logout ?',
  //           textAlign: TextAlign.center,
  //           style: TextStyle(fontSize: 16),
  //         ),
  //         SizedBox(height: mq.height * .02),
  //         SizedBox(
  //           width: mq.width * .5,
  //           child: Row(
  //             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  //             children: [
  //               Flexible(
  //                 child: CustomElevatedButton(
  //                   text: 'Yes',
  //                   onTap: () async {
  //                     int tCode = await getIntData("tCode") ?? 0;
  //                     String userId = await getStringData('UserID');
  //                     String deviceToken = await getStringData("deviceToken") ??
  //                         'DeviceTokenNotFound';
  //
  //                     final isSuccess = await ApiService().logoutContinue(
  //                       empId: tCode.toString(),
  //                       userId: userId,
  //                       deviceToken: deviceToken,
  //                       logoutType: 'UserLogout',
  //                     );
  //
  //                     await setBoolData('isLogin', false);
  //                     await removeData('tCode');
  //                     await removeData('userProfile');
  //                     Get.offAll(() => const LoginScreen());
  //
  //                     if (!isSuccess) {
  //                       Get.snackbar(
  //                           "Problem", "Logout failed, logged out locally.",
  //                           snackPosition: SnackPosition.BOTTOM);
  //                     }
  //                   },
  //                 ),
  //               ),
  //               const SizedBox(width: 10),
  //               Flexible(
  //                 child: CustomElevatedButton(
  //                   text: 'No',
  //                   onTap: () => Get.back(),
  //                 ),
  //               ),
  //             ],
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  /// 🔹 Yes / No Dialog
  static Future<void> dialogForYesNo({
    required String text,
    required String imgPath,
    required VoidCallback yesFunction,
    required VoidCallback noFunction,
  }) {
    return _showDialog(
      content: Column(
        children: [
          Image.asset(imgPath, width: mq.width * .2),
          SizedBox(height: mq.height * .01),
          Text(text,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 12)),
          SizedBox(height: mq.height * .02),
          SizedBox(
            width: mq.width * .5,
            height: 35,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Flexible(
                    child:
                        // CustomElevatedButton(text: 'Yes', onTap: yesFunction)),
                        GainerPrimaryButton(
                            title: 'Yes', onPressed: yesFunction)),
                const SizedBox(width: 10),
                Flexible(
                    // child: CustomElevatedButton(text: 'No', onTap: noFunction)),
                    child: GainerPrimaryButton(
                        title: 'No', onPressed: noFunction)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// 🔹 Auto-Close PopUp
  static Future<void> midPopUp(String imagePath, String text) {
    return _showDialog(
      autoClose: true,
      content: Column(
        children: [
          Image.asset(imagePath, width: mq.width * .2),
          Text(text,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 18)),
        ],
      ),
    );
  }

  // /// 🔹 Remarks PopUp
  // static Future<void> getRemarksPopUp(
  //     String title, List<Widget> columnChildren) {
  //   return Get.dialog(
  //     AlertDialog(
  //       title: Text(title),
  //       content: Column(
  //         mainAxisSize: MainAxisSize.min,
  //         crossAxisAlignment: CrossAxisAlignment.start,
  //         children: columnChildren,
  //       ),
  //       actions: [
  //         TextButton(onPressed: () => Get.back(), child: const Text("Close")),
  //       ],
  //     ),
  //   );
  // }

  /// 🔹 Invoice Download PopUp
  static Future<void> invoiceDownloadPopUp(
      BuildContext context, String invoiceCopy) async {
    Size size = MediaQuery.of(context).size;
    if (invoiceCopy.contains(',')) {
      List<String> invoiceList = invoiceCopy.split(',');
      return _showDialog(
        content: SizedBox(
          height: size.height * .25,
          width: size.width,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: invoiceList.length,
            itemBuilder: (_, index) {
              String invoiceItem = invoiceList[index];
              return ListTile(
                leading: const Icon(Icons.picture_as_pdf, size: 20),
                title: Text(invoiceItem, style: TextStyle(fontSize: 14)),
                onTap: () {
                  Get.back();
                  UrlLaunchUtils.openUrl(
                      'https://scope.sparecare.in/Upload/InvoiceCopySPM/$invoiceItem');
                },
              );
            },
          ),
        ),
        actions: [TextButton(onPressed: Get.back, child: const Text("Close"))],
      );
    } else {
      return dialogForYesNo(
        text: 'Do you want to download Invoice',
        imgPath: GainerImages.decisionMaking,
        yesFunction: () {
          Get.back();
          UrlLaunchUtils.openUrl(
              'https://scope.sparecare.in/Upload/InvoiceCopySPM/$invoiceCopy');
        },
        noFunction: Get.back,
      );
    }
  }

  static void showRemarksSheet({
    required String title,
    required Map<String, String?> remarks,
  }) {
    // remove empty / null values
    final entries = remarks.entries
        .where((e) => e.value != null && e.value!.trim().isNotEmpty)
        .toList();

    if (entries.isEmpty) {
      Get.snackbar('Info', 'No remarks available');
      return;
    }

    Get.bottomSheet(
      SafeArea(
        child: Container(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Drag handle
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),

              // Title
              Center(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),

              const SizedBox(height: 12),

              // Key–Value Remarks
              Flexible(
                child: ListView.separated(
                  shrinkWrap: true,
                  itemCount: entries.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 4),
                  itemBuilder: (_, index) {
                    final entry = entries[index];

                    return RichText(
                      text: TextSpan(
                        text: entry.key,
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                          color: Colors.black87,
                        ),
                        children: [
                          TextSpan(
                            text: entry.value ?? '',
                            style: const TextStyle(
                              fontWeight: FontWeight.normal,
                              color: Colors.black54,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: 8),

              // Close button
              GainerPrimaryButton(onPressed: Get.back, title: 'Close'),
              // SizedBox(
              //   width: double.infinity,
              //   child: ElevatedButton(
              //     onPressed: () => Get.back(),
              //     style: ElevatedButton.styleFrom(
              //       padding: const EdgeInsets.symmetric(vertical: 14),
              //       shape: RoundedRectangleBorder(
              //         borderRadius: BorderRadius.circular(12),
              //       ),
              //     ),
              //     child: const Text("Close"),
              //   ),
              // ),
            ],
          ),
        ),
      ),
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
    );
  }

  /// 🔹 Auto-Close PopUp
  // static Future<void> lowFund(String balance) {
  //   return _showDialog(
  //     // autoClose: true,
  //     content: Container(
  //       padding: const EdgeInsets.all(20),
  //       // decoration: BoxDecoration(
  //       //   borderRadius: BorderRadius.circular(20),
  //       //   color: GainerColors.primary,
  //       //   // gradient: const LinearGradient(
  //       //   //   colors: [Color(0xff1f2937), Color(0xff111827)],
  //       //   //   begin: Alignment.topLeft,
  //       //   //   end: Alignment.bottomRight,
  //       //   // ),
  //       //   boxShadow: [
  //       //     BoxShadow(
  //       //       color: Colors.black.withOpacity(0.4),
  //       //       blurRadius: 20,
  //       //       offset: const Offset(0, 10),
  //       //     )
  //       //   ],
  //       // ),
  //       child: Column(
  //         mainAxisSize: MainAxisSize.min,
  //         children: [
  //           Container(
  //             padding: const EdgeInsets.all(14),
  //             decoration: BoxDecoration(
  //               shape: BoxShape.circle,
  //               color: Colors.red.withOpacity(.15),
  //             ),
  //             child: const Icon(
  //               Icons.account_balance_wallet_outlined,
  //               // color: Colors.redAccent,
  //               color: GainerColors.secondary,
  //               size: 34,
  //             ),
  //           ),
  //           const SizedBox(height: 16),
  //           const Text(
  //             "Low Balance",
  //             style: TextStyle(
  //               fontSize: 20,
  //               fontWeight: FontWeight.bold,
  //               color: Colors.white,
  //             ),
  //           ),
  //           const SizedBox(height: 10),
  //           Text(
  //             "Your wallet balance is low.\nCurrent Balance: ₹$balance",
  //             textAlign: TextAlign.center,
  //             style: TextStyle(
  //               color: Colors.grey.shade300,
  //               fontSize: 14,
  //             ),
  //           ),
  //           const SizedBox(height: 20),
  //           // Row(
  //           //   children: [
  //           //     Expanded(
  //           //       child: OutlinedButton(
  //           //         style: OutlinedButton.styleFrom(
  //           //           foregroundColor: Colors.white70,
  //           //           side: BorderSide(color: Colors.white24),
  //           //           shape: RoundedRectangleBorder(
  //           //             borderRadius: BorderRadius.circular(10),
  //           //           ),
  //           //         ),
  //           //         onPressed: Get.back,
  //           //         child: const Text("Later"),
  //           //       ),
  //           //     ),
  //           //     const SizedBox(width: 10),
  //           //     Expanded(
  //           //       child: ElevatedButton(
  //           //         style: ElevatedButton.styleFrom(
  //           //           backgroundColor: Colors.orangeAccent,
  //           //           shape: RoundedRectangleBorder(
  //           //             borderRadius: BorderRadius.circular(10),
  //           //           ),
  //           //         ),
  //           //         onPressed: () {
  //           //           // Navigate to Add Funds
  //           //         },
  //           //         child: const Text("Add Funds"),
  //           //       ),
  //           //     ),
  //           //   ],
  //           // )
  //         ],
  //       ),
  //     ),
  //     actions: [
  //       Expanded(
  //         child: OutlinedButton(
  //           style: OutlinedButton.styleFrom(
  //             foregroundColor: Colors.white70,
  //             side: BorderSide(color: Colors.white24),
  //             shape: RoundedRectangleBorder(
  //               borderRadius: BorderRadius.circular(10),
  //             ),
  //           ),
  //           onPressed: Get.back,
  //           child: const Text("Later"),
  //         ),
  //       ),
  //       const SizedBox(width: 10),
  //       Expanded(
  //         child: ElevatedButton(
  //           style: ElevatedButton.styleFrom(
  //             backgroundColor: Colors.orangeAccent,
  //             shape: RoundedRectangleBorder(
  //               borderRadius: BorderRadius.circular(10),
  //             ),
  //           ),
  //           onPressed: () {
  //             // Navigate to Add Funds
  //           },
  //           child: const Text("Add Funds"),
  //         ),
  //       ),
  //     ],
  //   );
  // }
}
