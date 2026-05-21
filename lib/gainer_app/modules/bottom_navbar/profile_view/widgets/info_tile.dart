import 'package:flutter/material.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';

import '../../../../core/constants/gainer_color.dart';

class InfoTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final RxString value;
  // final bool showArrow;

  const InfoTile({
    super.key,
    required this.icon,
    required this.title,
    required this.value,
    // required this.showArrow,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      // dense: true,
      leading: CircleAvatar(
        // backgroundColor: Colors.teal.withOpacity(.1),
        backgroundColor: GainerColors.secondary,
        child: Icon(icon, color: Colors.teal),
      ),
      title: Text(title),
      subtitle: Obx(() => Text(value.value)),
      // trailing:
      //     showArrow ? const Icon(Icons.arrow_forward_ios, size: 16) : null,
    );
  }
}
