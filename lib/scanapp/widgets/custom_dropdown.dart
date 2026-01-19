import 'package:flutter/material.dart';

class CustomDropDownTextField extends StatefulWidget {
  final String labelText; // Label for the field
  final ValueChanged<String?> onChanged; // Callback for value change
  final List<String> dropdownItems; // List of dropdown options
  final String? initialValue; // Optional initial value

  const CustomDropDownTextField({
    super.key,
    required this.labelText,
    required this.onChanged,
    required this.dropdownItems,
    this.initialValue,
  });

  @override
  State<CustomDropDownTextField> createState() =>
      _CustomDropDownTextFieldState();
}

class _CustomDropDownTextFieldState
    extends State<CustomDropDownTextField> {
  String? _selectedValue;

  @override
  void initState() {
    super.initState();
    _selectedValue = widget.initialValue; // Initialize with default value
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      // dropdownColor: Colors.teal[50],
      elevation: 12,
      borderRadius: BorderRadius.circular(17),
      initialValue: _selectedValue,
      decoration: InputDecoration(
        labelText: widget.labelText,
        border: const OutlineInputBorder(),
        contentPadding: const EdgeInsets.symmetric(horizontal: 10),
      ),
      items: widget.dropdownItems.map((String item) {
        return DropdownMenuItem<String>(
          value: item,
          child: Text(item),
        );
      }).toList(),
      onChanged: (String? newValue) {
        setState(() {
          _selectedValue = newValue; // Update internal value
        });
        widget.onChanged(newValue); // Trigger callback
      },
    );
  }
}