import 'package:flutter/material.dart';
import 'package:gainer/gainer_app/core/constants/gainer_color.dart';
import 'package:gainer/gainer_app/modules/app_switcher_view/app_switcher_controller.dart';
import 'package:gainer/gainer_app/modules/bottom_navbar/home_view/home_controller.dart';
import 'package:get/get.dart';

class BalanceCard extends StatelessWidget {
  const BalanceCard({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AppSwitcherController>();
    final c = Get.find<HomeController>();
    return Card(
      // color: Colors.white,
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Obx(() => Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    // Expanded(child: Container(width: 2,color: GainerColors.primary,)),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Container(
                        height: 45,
                        width: 2,
                        decoration: BoxDecoration(
                          color: GainerColors.primary,
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                        ),
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Fund Balance",
                          style: TextStyle(fontSize: 14),
                        ),
                        Text("₹ ${c.funBalance.value}",
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      "Last Stock Update",
                      style: TextStyle(fontSize: 14),
                    ),
                    // Text(controller.getStock()!.stockDate ?? '',
                    Text(controller.stockData.value,
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold)),
                  ],
                ),
              ],
            )),
      ),
    );
  }
}
