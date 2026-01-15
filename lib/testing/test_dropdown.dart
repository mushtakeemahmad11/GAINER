import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:flutter/material.dart';
import 'dart:developer';

import '../gainer_app/core/constants/gainer_color.dart';

const List<String> _list = [
  'Developer',
  'Designer',
  'Consultant',
  'Student',
];

class SimpleDropdown extends StatelessWidget {
  const SimpleDropdown({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomDropdown<String>(
      hintText: 'Select job role',
      items: _list,
      initialItem: _list[0],
      onChanged: (value) {
        log('changing value to: $value');
      },
      closedHeaderPadding: EdgeInsets.all(10),
      decoration: CustomDropdownDecoration(
        closedBorder: BoxBorder.all(
          color: GainerColors.border),
        closedSuffixIcon: Icon(
          Icons.arrow_drop_down_sharp,
          color: Colors.black54,
        ),
      ),
    );
  }
}
