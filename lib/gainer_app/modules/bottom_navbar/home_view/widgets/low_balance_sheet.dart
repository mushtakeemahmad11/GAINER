import 'package:flutter/material.dart';
import 'package:gainer/gainer_app/core/widgets/gainer_primary_button.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';

import '../../../../core/constants/gainer_color.dart';

class LowBalanceSheet extends StatelessWidget {
  final int balance;

  const LowBalanceSheet({super.key, required this.balance});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 5,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              const Icon(Icons.account_balance_wallet,
                  color: GainerColors.error, size: 28),
              const SizedBox(width: 10),
              const Text(
                "Low Fund Balance",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: GainerColors.error,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            // "Your current balance is ₹${balance.toStringAsFixed(2)}.",
            "Your current balance is ₹$balance.",
            style: const TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 6),
          const Text(
            "Add funds to continue smooth transactions.",
            style: TextStyle(color: Colors.grey),
          ),
          const SizedBox(height: 20),

          GainerPrimaryButton(onPressed: Get.back, title: "Closed"),
          // Row(
          //   children: [
          //     Expanded(
          //       child: OutlinedButton(
          //         onPressed: () => Get.back(),
          //         child: const Text("Later"),
          //       ),
          //     ),
          //     const SizedBox(width: 12),
          //     Expanded(
          //       child: ElevatedButton(
          //         onPressed: () {
          //           Get.back();
          //           // Get.toNamed('/add-fund');
          //         },
          //         child: const Text("Add Funds"),
          //       ),
          //     ),
          //   ],
          // ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}
