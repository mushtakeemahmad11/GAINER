import 'package:flutter/material.dart';
import 'package:animated_custom_dropdown/custom_dropdown.dart';
import '../constants/gainer_color.dart';

class GainerAppDropdown<T> extends StatelessWidget {
  final String hintText;
  final List<T> items;
  final T? selectedItem;
  final ValueChanged<T?> onChanged;
  final String? Function(T?)? validator;
  // final String Function(T) itemLabelBuilder;

  const GainerAppDropdown({
    super.key,
    required this.hintText,
    required this.items,
    required this.onChanged,
    // required this.itemLabelBuilder,
    this.selectedItem,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return CustomDropdown<T>(
      hintText: hintText,
      items: items,
      initialItem: selectedItem,
      onChanged: onChanged,
      validator: validator,
      closedHeaderPadding: const EdgeInsets.all(10),
      decoration: CustomDropdownDecoration(
        closedBorder: Border.all(
          color: GainerColors.border,
        ),
        closedSuffixIcon: const Icon(
          Icons.arrow_drop_down_sharp,
          color: Colors.black54,
        ),
      ),
    );
  }
}
