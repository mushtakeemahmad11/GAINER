import 'package:flutter/material.dart';
import 'package:gainer/scanapp/core/utils/scanapp_constant_image.dart';
import 'package:get/get.dart';
import '../../main.dart';
import '../controllers/scanapp_main_screen_controller.dart';
import '../widgets/custom_middle_band.dart';

class ScanappHomeScreen extends StatelessWidget {
  const ScanappHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.put(ScanappMainScreenController());
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: mq.width * .01, vertical: mq.height * .02),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Image.asset(
            ScanappConstantImage.homeBack,
            height: mq.height * .35,
          ),
          Center(
            child: Padding(
              padding: EdgeInsets.only(top: mq.height * .035),
              child: const Text(
                "Warehouse management system\n is online now",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 20),
              ),
            ),
          ),
          const Spacer(),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                CustomHomeIcon(
                  icon: Icons.home_work,
                  bottomText: 'Location\nAudit',
                  bgColor: Colors.blue,
                  onPressed: () => c.changeTab(1),
                ),
                CustomHomeIcon(
                  icon: Icons.edit_note,
                  bottomText: 'Part\nAudit',
                  onPressed: () => c.changeTab(2),
                  bgColor: Colors.red,
                ),
                // CustomMiddleBand(
                //   // icon: Icons.menu_book_outlined,
                //   icon: Icons.event_note_outlined,
                //   bottomText: 'Self\nAudit',
                //   onPressed: () {
                //     // Get.to(() => const PerpetualInventoryAuditScreen());
                //   },
                //   bgColor: Colors.yellow,
                // ),
                // CustomMiddleBand(
                //   icon: Icons.fire_truck,
                //   bottomText: 'Goods\nReceipt',
                //   onPressed: () {
                //     print('Goods Receipt');
                //     // Get.to(() => const GoodsReceiptScreen());
                //   },
                //   bgColor: Colors.red,
                // ),
                // CustomMiddleBand(
                //   icon: Icons.home_work,
                //   bottomText: 'Location\nCheck',
                //   onPressed: () {
                //     // Get.to(() => const LocationAuditScreen());
                //   },
                //   bgColor: Colors.blue,
                // ),
                // CustomMiddleBand(
                //   icon: Icons.event_note_outlined,
                //   bottomText: 'Self\nAudit',
                //   onPressed: () {
                //     // Get.to(() => const PerpetualInventoryAuditScreen());
                //   },
                //   bgColor: Colors.yellow,
                // ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
