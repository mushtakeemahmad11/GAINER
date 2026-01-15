import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gainer/scanapp/core/themes/scanapp_colors.dart';

import '../../main.dart';

// reusable TextFormField
class CustomTextFormField extends StatelessWidget {
  const CustomTextFormField({
    super.key,
    required this.controller,
    required this.text,
    this.isPass = false,
    this.textInputType = TextInputType.text,
    this.suffixIcon,
    this.isDisable = false,
    this.autoFocus = false,
    this.validator,
    this.length,
    this.onChanged,
    this.inputFormatters,
    // this.maxLine,
  });

  final TextEditingController controller;
  final String text;
  final bool isPass;
  final TextInputType textInputType;
  final Widget? suffixIcon;
  final FormFieldValidator<String>? validator;
  final bool isDisable;
  final bool autoFocus;
  final int? length;
  final Function(String)? onChanged;
  final List<TextInputFormatter>? inputFormatters;
  // final int? maxLine;
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      keyboardType: textInputType,
      readOnly: isDisable,
      obscureText: isPass,
      maxLength: length,
      controller: controller,
      decoration: InputDecoration(
        counterText: '',
        label: Text(text),
        suffixIcon: suffixIcon,
      ),
      validator: validator,
      onChanged: onChanged,
      autofocus: autoFocus,
      inputFormatters: inputFormatters,
      // maxLines: maxLine,
    );
  }
}

// reusable ListTile Icon/Img + Text
class CustomListTile extends StatelessWidget {
  final bool isScanappDrawer;
  final IconData? icon;
  final String? url;
  final String title;
  final VoidCallback onTap;

  const CustomListTile({
    super.key,
    this.icon,
    this.url,
    this.isScanappDrawer = false,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    Widget? leadingWidget;

    if (url != null && url!.isNotEmpty) {
      leadingWidget = Image.asset(
        url!,
        width: 30,
        height: 30,
        fit: BoxFit.contain,
        color: (title.startsWith("Substitution") || title.startsWith("PPNI"))
            ? Colors.white
            : null, // desired color
        colorBlendMode: BlendMode.srcIn, // keeps transparency
      );
    } else if (icon != null) {
      leadingWidget = Icon(
        icon,
        color: isScanappDrawer ? Colors.black : Colors.white,
      );
    }

    return ListTile(
      leading: leadingWidget,
      title: Text(
        title,
        style: TextStyle(
            color: isScanappDrawer ? ScanappColors.black : Colors.white),
      ),
      onTap: onTap,
    );
  }
}

// class CustomListTile extends StatelessWidget {
//   final IconData? icon;
//   final String? url;
//   final String title;
//   final VoidCallback onTap;
//
//   const CustomListTile(
//       {super.key,
//       this.icon,
//       this.url,
//       required this.onTap,
//       required this.title});
//   @override
//   Widget build(BuildContext context) {
//     return ListTile(
//       leading: url != null
//           ? Image.asset(url!, width: 30)
//           : Icon(
//               icon,
//               color: Colors.white,
//             ),
//       title: Text(
//         title,
//         style: const TextStyle(color: Colors.white),
//       ),
//       onTap: onTap,
//     );
//   }
// }

// Reusable Outline Button
class CustomOutlinedButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;
  const CustomOutlinedButton(
      {super.key, required this.icon, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        side: const BorderSide(color: Colors.white, width: 1.5), // Border color
        // padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        // shape: RoundedRectangleBorder(
        //   borderRadius: BorderRadius.circular(8.0), // Rounded corners
        // ),
      ),
      child: Icon(
        icon,
        color: Colors.white,
      ),
    );
  }
}

Widget buildDtlRow(String text1, String text2) {
  return Row(
    children: [
      Text(
        text1,
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      SizedBox(
        width: mq.width * .25,
        child: buildScrollText(text2),
      ),
    ],
  );
}

Widget buildScrollText(String text) {
  return SingleChildScrollView(
      scrollDirection: Axis.horizontal, child: Text(text));
}
