import 'package:flutter/material.dart';
import 'package:gainer/gainer_app/core/constants/gainer_color.dart';
import 'package:gainer/gainer_app/modules/app_switcher_view/app_switcher_controller.dart';
import 'package:get/get.dart';

class BalanceCard extends StatelessWidget {
  const BalanceCard({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.find<AppSwitcherController>();
    return Card(
      // color: Colors.white,
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Row(
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
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Fund Balance"),
                    Text("₹ 318.2",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                  ],
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text("Last Stock Update"),
                Text(c.getStock()!.stockDate ?? '',
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
