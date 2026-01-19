import 'package:flutter/material.dart';
import 'package:gainer/gainer/widget/reusable_dropdown.dart';
import 'package:gainer/scanapp/controllers/pi_audit_controller.dart';
import 'package:get/get.dart';
import '../../../main.dart';
import '../../core/themes/scanapp_colors.dart';
import '../../widgets/custom_icon_button.dart';
import '../../widgets/custom_qr_title_row.dart';
import '../../widgets/custom_text_button.dart';
import '../../widgets/custom_text_field.dart';

class ByPartTab extends StatelessWidget {
  const ByPartTab({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.put(ByPartController());
    return SingleChildScrollView(
      padding: EdgeInsets.all(mq.width * .02),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Search Location Audit ID
          CustomTextField(
            text: " Search Perpetual Inventory Audit (PIA) ID",
            controller: c.auditId,
          ),
          SizedBox(height: mq.height * .01),
          CustomDropdown(
            hintText: "Select Part Number",
            options: c.locationItem,
            onChanged: (value) => c.selectedPartNumber(value),
            isTextFiled: true,
            selectedValue: c.selectedPartNumber.value,
          ),
          SizedBox(height: mq.height * .01),
          CustomTextField(
            text: " Enter Part Description",
            controller: c.description,
          ),
          SizedBox(height: mq.height * .01),
          CustomDropdown(
            hintText: "Select Location for Audit",
            options: c.locationItem,
            onChanged: (value) => c.location(value),
            isTextFiled: true,
            selectedValue: c.location.value,
          ),
          SizedBox(height: mq.height * .01),

          // Confirm Location with SCAN Location
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              CustomQrTitleRow(
                title: "Scan Location",
                onTap: () {
                  // print("Scan Location");
                },
              ),
              // Column(
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
              //     const Text("Scan Location"),
              //   ],
              // ),
              SizedBox(
                width: mq.width * .4,
                child: CustomTextButton(
                  text: "Confirm Location",
                  onPressed: () {},
                ),
              )
            ],
          ),
          SizedBox(height: mq.height * .01),

          // SCAN/Enter Part Number
          Row(
            children: [
              IconButton(
                onPressed: () {
                  // Get.to(() => const ScannerScreen());
                },
                icon: const Icon(
                  Icons.qr_code_scanner,
                  size: 35,
                  color: ScanappColors.black,
                ),
              ),
              Expanded(
                child: CustomTextField(
                  text: "  Scan/ Enter Part Number",
                  controller: c.partNumber,
                ),
              ),
              IconButton(
                icon: Icon(
                  Icons.add_circle_outline,
                  color: ScanappColors.secondary,
                  size: 35,
                ),
                onPressed: () {},
              )
            ],
          ),
          SizedBox(height: mq.height * .01),

          // Part Number

          Column(
            // crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // const Text("Quantity"),
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  // mainAxisSize: MainAxisSize.min,
                  children: [
                    // Decrement Button
                    CustomCircleButton(
                      icon: Icons.remove,
                      onTap: c.decrement,
                    ),
                    // Quantity Display
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Obx(
                        () => Text(
                          // c.partQty.toString(),
                          c.partQty.value
                              .toString()
                              .padLeft(2, '0'), // Display as '01', '02', etc.
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),

                    // Increment Button
                    CustomCircleButton(
                      icon: Icons.add,
                      onTap: c.increment,
                    )
                  ],
                ),
              ),
            ],
          ),

          SizedBox(height: mq.height * .01),
          // Save and Submit Buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                  width: mq.width * .45,
                  child: CustomTextButton(text: 'Save', onPressed: () {})),
              SizedBox(
                  width: mq.width * .45,
                  child: CustomTextButton(text: 'Submit', onPressed: () {}))
            ],
          ),
        ],
      ),
    );
  }
}
