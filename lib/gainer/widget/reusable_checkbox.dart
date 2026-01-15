import 'package:flutter/material.dart';
import '../screens/colors.dart';
class CustomCheckBox extends StatelessWidget {
  final bool value;
  final ValueChanged<bool?> onChanged;

  const CustomCheckBox({
    super.key,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Checkbox(
      value: value,
      onChanged: onChanged,
      fillColor: WidgetStateProperty.resolveWith<Color>(
            (Set<WidgetState> states) {
          if (states.contains(WidgetState.selected)) {
            return AppColor.primary; // Box color when selected
          }
          return AppColor.primaryShade; // Box color when unselected
        },
      ),
    );
  }
}
