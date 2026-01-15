import 'package:flutter/material.dart';
import 'package:gainer/scanapp/widgets/custom_icon_button.dart';
import 'package:get/get.dart';
import '../../../main.dart';
import '../../controllers/pi_audit_controller.dart';
import '../../core/themes/scanapp_colors.dart';
import '../../widgets/custom_qr_title_row.dart';
import '../../widgets/custom_text_button.dart';
import '../../widgets/custom_text_field.dart';

class PIGenericTab extends StatelessWidget {
  const PIGenericTab({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.put(PIGenericController());
    return SingleChildScrollView(
      padding: EdgeInsets.all(mq.width * .02),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Search Location Audit ID
          CustomQrTitleRow(
            title: "Scan Location",
            onTap: () {
              // print("Scan Location");
            },
          ),
          // Row(
          //   children: [
          //     IconButton(
          //         onPressed: () {
          //           // Get.to(()=>const ScannerScreen());
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

          //Location Number
          // const Text("  Location Number"),
          Row(
            children: [
              Expanded(
                child: CustomTextField(
                  text: "  Enter Location Number",
                  controller: c.location,
                ),
                // child: CustomDisableTextField(text: "  TextEnter Location Number"),
              ),
              IconButton(
                  icon: Icon(
                    Icons.add_circle_outline,
                    size: 35,
                    color: ScanappColors.secondary,
                  ),
                  onPressed: () {}),
            ],
          ),
          SizedBox(height: mq.width * .01),

          //Scan Location QR/
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              CustomQrTitleRow(
                title: "Scan Part",
                onTap: () {
                  // print("Scan Part");
                },
              ),
              // Row(
              //   children: [
              //     IconButton(
              //         onPressed: () {
              //           // Get.to(()=>const ScannerScreen());
              //         },
              //         icon: const Icon(
              //           Icons.qr_code_scanner,
              //           size: 35,
              //           color: ScanappColors.black,
              //         )),
              //     const Text("Scan Location"),
              //   ],
              // ),
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
                              // controller.genericPiaQuantity.toString(),
                              c.partQty.value.toString().padLeft(
                                  2, '0'), // Display as '01', '02', etc.
                              style: const TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                          ),
                          // child: Text("0"),
                        ),
                        // Increment Button
                        CustomCircleButton(
                          icon: Icons.add,
                          onTap: c.increment,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: mq.width * .01),

          // Part Number
          // const Text("  Part Number"),
          Row(
            children: [
              Expanded(
                  child: CustomTextField(
                text: "  Enter Location Number",
                controller: c.locationNum,
              )
                  // child: CustomDisableTextField(text: "  TextEnter Location Number"),
                  ),
              IconButton(
                icon: Icon(
                  Icons.add_circle_outline,
                  color: ScanappColors.secondary,
                  size: 35,
                ),
                onPressed: () {},
              ),
            ],
          ),
          SizedBox(height: mq.height * .01),

          // Part Description
          // const Text("  Part Description"),
          CustomTextField(
            text: "  Part Description",
            controller: c.description,
          ),
          // const CustomDisableTextField(text: "  Part Description"),
          SizedBox(height: mq.height * .04),

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
}
