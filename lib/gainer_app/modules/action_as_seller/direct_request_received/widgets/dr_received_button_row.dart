import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/widgets/gainer_secondary_button.dart';
import '../dr_received_controller.dart';
import '../models/dr_received_model.dart';

class DrReceivedButtonRow extends GetView<DrReceivedController> {
  final DrReceivedModel order;
  const DrReceivedButtonRow({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 10,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
            child: GainerSecondaryButton(
          onTap: () => controller.acceptRequest(order),
          title: 'Accept',
        )),
        Expanded(
            child: GainerSecondaryButton(
          onTap: ()=>controller.rejectRequest(order.id.toString()),
          title: 'Reject',
        )),
      ],
    );
  }
}
