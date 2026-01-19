import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../main.dart';
import '../../controllers/location_audit_controller.dart';
import '../../core/themes/scanapp_colors.dart';
import '../../widgets/custom_qr_title_row.dart';
import '../../widgets/custom_text_button.dart';
import '../../widgets/custom_text_field.dart';

class GenericTab extends StatelessWidget {
  const GenericTab({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.put(LocationGenericController());
    return SingleChildScrollView(
      // padding: const EdgeInsets.all(16.0),
      padding: EdgeInsets.all(mq.width * .02),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Search Location Audit ID
          CustomQrTitleRow(
            title: 'Scan Location',
            onTap: () {
              // print("Scan Location");
              // Get.to(() => const ScannerScreen());
            },
          ),
          // Row(
          //   children: [
          //     IconButton(
          //         onPressed: () {
          //           // Get.to(() => const ScannerScreen());
          //         },
          //         icon: const Icon(
          //           Icons.qr_code_scanner,
          //           size: 35,
          //           color: ScanappColors.black,
          //         )),
          //     SizedBox(width: mq.width * .04),
          //     const Text("Scan Location"),
          //   ],
          // ),
          SizedBox(height: mq.width * .01),

          // SCAN/Enter Part Number
          // const Text("  Location Number"),
          Row(
            children: [
              Expanded(
                child: CustomTextField(
                  text: "  Enter Location Number",
                  controller: c.locationNum,
                ),
              ),
              IconButton(
                  icon: Icon(
                    Icons.add_circle_outline,
                    color: ScanappColors.secondary,
                    size: 35,
                  ),
                  onPressed: () {}),
            ],
          ),
          SizedBox(height: mq.width * .01),

          //scan location
          CustomQrTitleRow(
            title: 'Scan Part',
            onTap: () {
              // print("Scan Part");
              // Get.to(() => const ScannerScreen());
            },
          ),
          SizedBox(height: mq.width * .01),

          // Part Number
          // const Text("  Part Number"),
          Row(
            children: [
              Expanded(
                child: CustomTextField(
                  text: "  Enter Part number",
                  controller: c.partNum,
                ),
              ),
              IconButton(
                  icon: Icon(
                    Icons.add_circle_outline,
                    color: ScanappColors.secondary,
                    size: 35,
                  ),
                  onPressed: () {}),
            ],
          ),
          SizedBox(height: mq.height * .01),

          // Part Description
          // const Text("  Part Description"),
          CustomTextField(
            text: " Enter Part Description",
            controller: c.description,
          ),
          SizedBox(height: mq.height * .03),

          // Save and Submit Buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                  width: mq.width * .45,
                  child: CustomTextButton(text: 'Save', onPressed: () {})),
              SizedBox(
                  width: mq.width * .45,
                  child: CustomTextButton(text: 'Close', onPressed: () {}))
            ],
          ),
        ],
      ),
    );
  }

  // Widget _buildQrRow(String text, VoidCallback onTap) {
  //   return Row(
  //     // mainAxisAlignment: MainAxisAlignment.center,
  //     children: [
  //       IconButton(
  //           onPressed: onTap,
  //           icon: const Icon(
  //             Icons.qr_code_scanner,
  //             size: 35,
  //             color: ScanappColors.black,
  //           )),
  //       SizedBox(width: mq.width * .04),
  //       Text(text),
  //     ],
  //   );
  // }
}
