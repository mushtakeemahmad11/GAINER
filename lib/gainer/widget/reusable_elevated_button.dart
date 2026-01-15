import 'package:flutter/material.dart';
import '../../main.dart';
import '../screens/colors.dart';

class CustomElevatedButton extends StatefulWidget {
  final VoidCallback onTap;
  final String? text;
  final IconData? icon;

  const CustomElevatedButton(
      {super.key, this.text, required this.onTap, this.icon})
      : assert(
          text != null || icon != null,
          'Either text or icon must be provided',
        ), // Ensure at least one is provided
        assert(
          text == null || icon == null,
          'Provide only one of text or icon',
        ); // Ensure only one is provided;

  @override
  State<CustomElevatedButton> createState() => _CustomElevatedButtonState();
}

class _CustomElevatedButtonState extends State<CustomElevatedButton> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: mq.width,
      child: ElevatedButton(
        onPressed: widget.onTap,
        style: ButtonStyle(
          backgroundColor: WidgetStatePropertyAll(AppColor.primary),
          shape: WidgetStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
          ),
        ),
        child: widget.text != null
            ? Text(
                widget.text!,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.white),
              )
            : Icon(widget.icon,color: Colors.white,),
      ),
    );
  }
}
