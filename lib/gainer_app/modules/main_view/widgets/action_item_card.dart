import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../bottom_navbar/home_view/home_controller.dart';
import '../models/action_item_model.dart';

class ActionItemCard extends StatelessWidget {
  final ActionItem item;

  const ActionItemCard({super.key, required this.item});
  @override
  Widget build(BuildContext context) {
    final HomeController controller = Get.find<HomeController>();
    if (item.title == 'Direct Req Sent' ||
        item.title == 'Direct Req Received') {
      return _isDirectReq(controller);
    }
    return _card(true, controller);
  }

  ///Direct Request Module (Obx Because It is Checking Allowing or Not)
  Widget _isDirectReq(HomeController c) {
    return Obx(() {
      final bool isEnable = c.checkAllow(item.title);
      final isShow = c.isAllowBuying.value || c.isAllowSelling.value;
      if(isShow) {
        return _card(isEnable, c);
      }
      return const SizedBox.shrink();
    });
  }

  ///Common Card for Both Direct and Normal
  Widget _card(bool isEnable, HomeController c) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      color: isEnable ? null : Colors.white12,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => isEnable ? c.onActionTap(item.actionKey) : c.getSnackBar(),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(item.icon,
                      color: isEnable ? item.iconColor : Colors.black38,
                      size: 20),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.title,
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                              color: isEnable ? Colors.black : Colors.black38),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                item.subtitle,
                                style: TextStyle(
                                    fontSize: 12,
                                    color: isEnable
                                        ? Colors.black
                                        : Colors.black38),
                              ),
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
                ],
              ),
              const SizedBox(height: 4),
              Align(
                alignment: Alignment.bottomCenter,
                child: Text(
                  item.status,
                  style: TextStyle(
                    color: isEnable ? Colors.red : Colors.black38,
                    fontWeight: FontWeight.bold,
                    fontSize: 8,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
