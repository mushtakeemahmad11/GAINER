import 'package:flutter/material.dart';
import '../../main.dart';

// Widget buildToggleButton(String text, bool isSelected) {
//   return Container(
//     padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 6.0),
//     decoration: BoxDecoration(
//       color: isSelected ? AppColor.primary : Colors.cyan[50],
//       borderRadius: BorderRadius.circular(20.0),
//       border: Border.all(color: AppColor.primary)
//     ),
//     child: Text(
//       text,
//       style: TextStyle(
//         color: isSelected ? Colors.white : AppColor.primary,
//         fontWeight: FontWeight.bold,
//       ),
//     ),
//   );
// }

Widget switchWithText(
    String text, bool toggleValue, ValueChanged<bool> onChange) {
  return Row(
    children: [
      Text(text),
      SizedBox(
        width: mq.width * .02,
      ),
      Switch.adaptive(value: toggleValue, onChanged: onChange),
      // Switch(
      //   value: toggleValue,
      //   onChanged: onChange,
      //   activeColor: AppColor.primary,
      //   activeTrackColor: AppColor.primaryShade,
      // ),
    ],
  );
}