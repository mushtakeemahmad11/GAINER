import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:gainer/dealer_monitoring/controllers/vehicle_search_controller.dart';

import 'dealer_app_loader.dart';
import 'dm_elevated_button.dart';

class ConfirmationDialog extends StatelessWidget {
  const ConfirmationDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.put(VehicleSearchController());
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      // backgroundColor: Theme.of(context).dialogBackgroundColor,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Align(
              alignment: Alignment.topRight,
              child: InkWell(
                onTap: () => Navigator.of(context).pop(),
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  height: 25,
                  width: 25,
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: const Icon(Icons.close, size: 16, color: Colors.white),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Obx(
                  () => Checkbox(
                    value: c.isCheckFinal.value,
                    onChanged: (value) => c.isCheckFinal.value = value ?? false,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    "I, as an advisor, confirm that all procured parts have been issued. For any parts not issued, an advance has been collected.",
                    style: TextStyle(fontSize: 14),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Obx(() {
              if (c.isCheckLoading.value) return DealerAppLoader();
              return Opacity(
                opacity: c.isCheckFinal.value ? 1.0 : 0.5,
                child: SizedBox(
                  width: 125,
                  child: DmElevatedButton(
                    text: "Submit",
                    onTap: c.isCheckFinal.value
                        ? () => c.confirmToClose()
                        : () {}, // disable button when not checked
                  ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
