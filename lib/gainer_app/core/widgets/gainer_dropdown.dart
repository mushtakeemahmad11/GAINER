import 'package:flutter/material.dart';
import 'package:animated_custom_dropdown/custom_dropdown.dart';
import '../constants/gainer_color.dart';

class GainerAppDropdown<T> extends StatelessWidget {
  final String hintText;
  final List<T> items;
  final T? selectedItem;
  final ValueChanged<T?> onChanged;
  // final String Function(T) itemLabelBuilder;

  const GainerAppDropdown({
    super.key,
    required this.hintText,
    required this.items,
    required this.onChanged,
    // required this.itemLabelBuilder,
    this.selectedItem,
  });

  @override
  Widget build(BuildContext context) {
    return CustomDropdown<T>(
      hintText: hintText,
      items: items,
      initialItem: selectedItem,
      onChanged: onChanged,
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
      // listItemBuilder: ,
      // itemBuilder: (context, item, isSelected) {
      //   return Text(
      //     itemLabelBuilder(item),
      //     style: TextStyle(
      //       fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
      //     ),
      //   );
      // },
    );
  }
}


// class AppDropdown<T> extends StatelessWidget {
//   final String? hintText;
//   final List<T> items;
//   final T? selectedItem;
//   final ValueChanged<T?> onChanged;
//   final String? Function(T?)? validator;
//
//   const AppDropdown({
//     super.key,
//     required this.items,
//     required this.onChanged,
//     this.hintText,
//     this.selectedItem,
//     this.validator,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return CustomDropdown<T>(
//       hintText: hintText,
//       items: items,
//
//       // ⭐ KEY LOGIC
//       initialItem: hintText == null
//           ? (selectedItem ?? items.first)
//           : selectedItem,
//
//       // onChanged: onChanged,
//       onChanged: (value) {
//         if (value == hintText) {
//           onChanged(null); // Reset to null when "Select an Option" is chosen
//         } else {
//           onChanged(value);
//         }
//       },
//       validator: validator,
//       closedHeaderPadding: const EdgeInsets.all(10),
//       decoration: CustomDropdownDecoration(
//         closedBorder: Border.all(color: GainerColors.border),
//         closedSuffixIcon: const Icon(
//           Icons.arrow_drop_down_sharp,
//           color: Colors.black54,
//         ),
//       ),
//     );
//   }
// }


class AppDropdown extends StatelessWidget {
  final List<String> items;
  final String? hintText;
  final String? selectedItem;
  final ValueChanged<String?> onChanged;
  final String? Function(String?)? validator;

  const AppDropdown({
    super.key,
    required this.items,
    required this.onChanged,
    this.hintText,
    this.selectedItem,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    // Inject hint into items if provided
    final List<String> dropdownItems =
    hintText != null ? [hintText!, ...items] : items;

    // Decide initial item safely
    final String initialItem = selectedItem ??
        (hintText != null ? hintText! : items.first);

    return CustomDropdown<String>(
      items: dropdownItems,
      initialItem: initialItem,
      onChanged: (value) {
        if (value == hintText) {
          onChanged(null); // deselect
        } else {
          onChanged(value);
        }
      },
      validator: validator != null
          ? (value) {
        if (value == hintText || value == null) {
          return validator!(null);
        }
        return null;
      }
          : null,
      closedHeaderPadding: const EdgeInsets.all(10),
      decoration: CustomDropdownDecoration(
        closedBorder: Border.all(color: GainerColors.border),
        closedSuffixIcon: const Icon(
          Icons.arrow_drop_down_sharp,
          color: Colors.black54,
        ),
      ),
    );
  }
}


