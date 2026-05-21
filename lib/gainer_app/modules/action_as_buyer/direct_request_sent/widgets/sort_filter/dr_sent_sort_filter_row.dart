import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../core/constants/gainer_color.dart';
import '../../dr_sent_controller.dart';

class DrSentSortFilterRow extends GetView<DrSentController> {
  const DrSentSortFilterRow({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: Colors.grey.shade300)),
        // border: Border.all(color: Colors.grey.shade300),
        color: GainerColors.lightWhite,
      ),
      child: InkWell(
        onTap: () => controller.openSortSheet(context),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: const [
            SizedBox(width: 50),
            Icon(
              Icons.swap_vert,
              color: Colors.black,
            ),
            SizedBox(width: 6),
            Text("SORT"),
          ],
        ),
      ),
    );
  }
}
