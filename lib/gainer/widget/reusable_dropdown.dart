import 'package:flutter/material.dart';

class CustomDropdown extends StatelessWidget {
  final String? selectedValue;
  final String hintText;
  final List<String> options;
  final Function(String?) onChanged;
  final String? Function(String?)? validator;
  final bool isTextFiled;

  const CustomDropdown({
    super.key,
    required this.hintText,
    required this.options,
    required this.onChanged,
    this.selectedValue,
    this.validator,
    this.isTextFiled = false,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      isExpanded: true,
      borderRadius: const BorderRadius.all(Radius.circular(8)),
      initialValue: selectedValue,
      hint: Text(hintText),
      // onChanged: onChanged,
      decoration: isTextFiled
          ? InputDecoration(
              // labelText: hintText,
              // border: const OutlineInputBorder(),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8), // rounded corners
                borderSide:
                    const BorderSide(color: Colors.grey), // border color
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 10),
            )
          : null,
      onChanged: (value) {
        if (value == hintText) {
          onChanged(null); // Reset to null when "Select an Option" is chosen
        } else {
          onChanged(value);
        }
      },
      items: [
        DropdownMenuItem<String>(
          value: hintText,
          child: Text(hintText),
        ),
        ...options.map<DropdownMenuItem<String>>((value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }),
      ],
      // items: options.map<DropdownMenuItem<String>>((value) {
      //   return DropdownMenuItem<String>(
      //     value: value,
      //     child: Text(value),
      //   );
      // }).toList(),
      validator: validator,
    );
  }
}

class CustomOutlineDropdown extends StatelessWidget {
  final String? selectedVal;
  final String hintText;
  final List<String> items;
  final Function(String?) onChanged;
  final String? Function(String?)? validator;

  const CustomOutlineDropdown({
    super.key,
    this.selectedVal,
    required this.hintText,
    required this.items,
    required this.onChanged,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 10),
      ),
      hint: Text(hintText),
      initialValue: selectedVal, // your state variable
      items: items
          .map((item) => DropdownMenuItem(
                value: item,
                child: Text(item),
              ))
          .toList(),
      onChanged: onChanged,
      validator: validator,
    );
  }
}
