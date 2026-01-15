import 'package:gainer/gainer/widget/reusable_dropdown.dart';
import 'package:gainer/scanapp/controllers/location_audit_controller.dart';
import 'package:get/get.dart';
import '../../../main.dart';
import 'package:flutter/material.dart';
import 'package:gainer/scanapp/widgets/custom_qr_title_row.dart';
import '../../core/themes/scanapp_colors.dart';
import '../../widgets/custom_text_button.dart';
import '../../widgets/custom_text_field.dart';

class ByLocationTab extends StatelessWidget {
  const ByLocationTab({super.key});
  // Currently selected value for dropdown
  @override
  Widget build(BuildContext context) {
    final c = Get.put(ByLocationController());
    return SingleChildScrollView(
      padding: EdgeInsets.all(mq.width * .02),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Search Location Audit ID
          CustomTextField(
            text: "Search Location Audit ID",
            controller: c.locationAuditId,
          ),
          SizedBox(height: mq.height * .01),
          Obx(
            () => CustomDropdown(
              isTextFiled: true,
              hintText: "Select Location",
              options: c.dropdownItems,
              onChanged: (String? value) => c.location(value),
              selectedValue: c.location.value,
            ),
          ),
          SizedBox(height: mq.height * .01),
          // Confirm Location with SCAN Location
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustomQrTitleRow(
                title: "Scan Location",
                onTap: () {},
              ),
              SizedBox(
                width: mq.width * .4,
                child: CustomTextButton(
                  text: "Confirm Location",
                  onPressed: () {},
                ),
              ),
            ],
          ),
          SizedBox(height: mq.height * .01),

          // SCAN/Enter Part Number
          Row(
            children: [
              IconButton(
                  onPressed: () {
                    // Get.to(() => const QrScanner());
                  },
                  icon: const Icon(
                    Icons.qr_code_scanner,
                    size: 35,
                    color: ScanappColors.black,
                  )),
              Expanded(
                child: CustomTextField(
                  text: "  Scan / Enter Part Number",
                  controller: c.scanPartNumber,
                ),
              ),
              IconButton(
                  icon: Icon(
                    Icons.add_circle_outline,
                    color: ScanappColors.secondary,
                    size: 35,
                  ),
                  onPressed: () {
                    // setState(() {
                    //   if (qrScannerController.qrDisplayValue.value != null) {
                    //     qrScannerController.qrDisplayValue1.value =
                    //         qrScannerController.qrDisplayValue.value;
                    //     qrScannerController.qrDisplayValue.value = null;
                    //     scanBtn = true;
                    //   }
                    // });
                  })
            ],
          ),
          SizedBox(height: mq.height * .01),
          Obx(
            () => CustomDropdown(
              isTextFiled: true,
              hintText: "Select Part Remarks",
              options: c.remarksItem,
              onChanged: (value) => c.remarks(value),
              selectedValue: c.remarks.value,
            ),
          ),
          // CustomDropDownTextField(
          //   labelText: "Part Remark",
          //   onChanged: (String? value) {
          //     c.remarks(value);
          //   },
          //   dropdownItems: c.remarksItem,
          // ),

          SizedBox(height: mq.height * .01),

          // const Text("Part Description"),
          CustomTextField(
            text: "Enter Part Description",
            controller: c.partDescription,
          ),
          SizedBox(height: mq.height * .03),
          // Save and Submit Buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                width: mq.width * .45,
                child: CustomTextButton(text: 'Save', onPressed: () {}),
              ),
              SizedBox(
                width: mq.width * .45,
                child: CustomTextButton(text: 'Submit', onPressed: () {}),
              )
            ],
          ),
        ],
      ),
    );
  }
}
