import 'package:flutter/material.dart';
import 'package:gainer/gainer_app/core/constants/gainer_image.dart';
import 'package:get/get.dart';
import 'package:gainer/gainer/widget/reusable_elevated_button.dart';

import '../../../gainer/screens/constant_image_path.dart';
import '../../../main.dart';

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
  static Future<void> dialogForYesNo(String text, String path,
      VoidCallback yesFunction, VoidCallback noFunction) {
    return _showDialog(
      content: Column(
        children: [
          Image.asset(path, width: mq.width * .2),
          SizedBox(height: mq.height * .01),
          Text(text,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16)),
          SizedBox(height: mq.height * .02),
          SizedBox(
            width: mq.width * .5,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Flexible(
                    child:
                        CustomElevatedButton(text: 'Yes', onTap: yesFunction)),
                const SizedBox(width: 10),
                Flexible(
                    child: CustomElevatedButton(text: 'No', onTap: noFunction)),
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

  /// 🔹 Remarks PopUp
  static Future<void> getRemarksPopUp(
      String title, List<Widget> columnChildren) {
    return Get.dialog(
      AlertDialog(
        title: Text(title),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: columnChildren,
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text("Close")),
        ],
      ),
    );
  }

  // /// 🔹 Invoice Download PopUp
  // static Future<void> invoiceDownloadPopUp(
  //     BuildContext context, String invoiceCopy) async {
  //   if (invoiceCopy.contains(',')) {
  //     List<String> invoiceList = invoiceCopy.split(',');
  //     return _showDialog(
  //       content: SizedBox(
  //         height: mq.height * .25,
  //         width: mq.width,
  //         child: ListView.builder(
  //           shrinkWrap: true,
  //           itemCount: invoiceList.length,
  //           itemBuilder: (_, index) {
  //             String invoiceItem = invoiceList[index];
  //             return ListTile(
  //               leading: const Icon(Icons.picture_as_pdf),
  //               title: Text(invoiceItem),
  //               onTap: () async {
  //                 Get.back();
  //                 await launchURL(
  //                     'https://scope.sparecare.in/Upload/InvoiceCopySPM/$invoiceItem');
  //               },
  //             );
  //           },
  //         ),
  //       ),
  //       actions: [
  //         TextButton(onPressed: () => Get.back(), child: const Text("Close"))
  //       ],
  //     );
  //   } else {
  //     return dialogForYesNo(
  //       'Do you want to download Invoice',
  //       AppImages.decisionMaking,
  //       () async {
  //         Get.back();
  //         await launchURL(
  //             'https://scope.sparecare.in/Upload/InvoiceCopySPM/$invoiceCopy');
  //       },
  //       () => Get.back(),
  //     );
  //   }
  // }
}
