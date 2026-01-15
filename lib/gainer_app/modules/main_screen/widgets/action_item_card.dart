import 'package:flutter/material.dart';
import 'package:gainer/gainer_app/modules/navbar/home_view/home_controller.dart';
import 'package:get/get.dart';

import '../action_item_model.dart';

class ActionItemCard extends StatelessWidget {
  final ActionItem item;

  const ActionItemCard({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final HomeController controller = Get.find<HomeController>();
    return GestureDetector(
      onTap: () => controller.onActionTap(item.actionKey),
      child: Card(
        margin: const EdgeInsets.all(4),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(item.icon, color: item.iconColor, size: 20),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(item.title,
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 12)),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              item.subtitle,
                              style: const TextStyle(fontSize: 12),
                            ),
                            const Icon(
                              Icons.arrow_forward_ios,
                              size: 14,
                              color: Colors.black87,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  // const Icon(Icons.arrow_forward_ios, size: 14,color: Colors.black87,),
                ],
              ),
              const SizedBox(height: 4),
              Align(
                alignment: Alignment.bottomCenter,
                child: Text(
                  item.status,
                  style: const TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                      fontSize: 8),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
