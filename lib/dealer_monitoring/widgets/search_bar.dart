import 'package:flutter/material.dart';
import 'package:gainer/gainer_app/core/utils/gainer_text_filed_validator.dart';
import '../core/theme/app_colors.dart';

class SearchBarWidget extends StatelessWidget {
  const SearchBarWidget({
    super.key,
    required this.hintText,
    required this.onSearch,
    this.onChanged,
    required this.controller,
    required this.formKey,
  });

  final String hintText;
  final TextEditingController controller;
  final VoidCallback onSearch;
  final Future<void> Function(String)? onChanged;
  final GlobalKey<FormState> formKey;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: TextFormField(
        controller: controller,
        onChanged: (value) async {
          if (value.isEmpty) {
            controller.clear();
            return;
          }

          // Save current cursor
          final oldSelection = controller.selection;

          // Validate
          String filteredValue =
              await GainerTextFiledValidator.partNumberValidation(value);
              // await ControllerUtils.partNumberValidation(value);

          if (filteredValue != value) {
            final newOffset =
                oldSelection.baseOffset.clamp(0, filteredValue.length);

            controller.value = TextEditingValue(
              text: filteredValue,
              selection: TextSelection.collapsed(offset: newOffset),
            );
          }

          if (onChanged != null) {
            await onChanged!(controller.text);
          }
        },
        // onChanged: (value) async {
        //   // 1️⃣ Clear if empty
        //   if (value.isEmpty) {
        //     controller.clear();
        //   }
        //
        //   // // 2️⃣ Convert to uppercase
        //   // String upperText = value.toUpperCase();
        //   // controller.value = controller.value.copyWith(
        //   //   text: upperText,
        //   // //   // selection: TextSelection.collapsed(offset: upperText.length),
        //   // );
        //
        //   // 3️⃣ Default async validation
        //
        //   final oldSelection = controller.selection;
        //   String filteredValue =
        //       await ControllerUtils.partNumberValidation(value);
        //   // if (filteredValue != value) {
        //   //   controller.value = TextEditingValue(
        //   //     text: filteredValue,
        //   //     selection: oldSelection.copyWith(
        //   //       baseOffset: filteredValue.length < oldSelection.baseOffset
        //   //           ? filteredValue.length
        //   //           : oldSelection.baseOffset,
        //   //       extentOffset: filteredValue.length < oldSelection.extentOffset
        //   //           ? filteredValue.length
        //   //           : oldSelection.extentOffset,
        //   //     ),
        //   //   );
        //   // }
        //
        //   if(filteredValue!=value){
        //     controller.value = TextEditingValue(
        //       text: filteredValue,
        //       // selection: TextSelection.collapsed(offset: filteredValue.length),
        //     );
        //   }
        //   // if (filteredValue != value) {
        //   //   controller.text = filteredValue;
        //   //   // controller.selection = TextSelection.fromPosition(
        //   //   //   TextPosition(offset: filteredValue.length),
        //   //   // );
        //   // }
        //
        //   // 4️⃣ Run custom onChanged from parent after all checks
        //   if (onChanged != null) {
        //     await onChanged!(controller.text);
        //   }
        // },
        decoration: InputDecoration(
          suffixIcon: IconButton(
            icon: const Icon(Icons.search, color: DMAppColors.secondary),
            onPressed: onSearch,
          ),
          labelText: hintText,
        ),
        validator: (value) {
          if (value == null || value.trim().isEmpty) {
            return 'Please Enter Part Number';
          }
          return null;
        },
      ),
    );
  }
}

// import 'package:flutter/material.dart';
// import '../../gainer/utility/controller_utils.dart';
// import '../core/theme/app_colors.dart';
//
// class SearchBarWidget extends StatelessWidget {
//   const SearchBarWidget({
//     super.key,
//     required this.hintText,
//     required this.onSearch,
//     this.onChanged,
//     required this.controller,
//     required this.formKey,
//   });
//
//   final String hintText;
//   final TextEditingController controller;
//   final VoidCallback onSearch;
//   final Future<void> Function(String)? onChanged;
//   final GlobalKey<FormState> formKey;
//
//   @override
//   Widget build(BuildContext context) {
//     return Form(
//       key: formKey,
//       child: TextFormField(
//         controller: controller,
//         onChanged: (value) async {
//           if (onChanged != null) {
//             await onChanged!(value); // user-provided logic
//           } else {
//             if (value.isEmpty) {
//               controller.clear();
//             }
//             // Convert to uppercase and update text
//             String upperText = value.toUpperCase();
//             controller.value = controller.value.copyWith(
//               text: upperText,
//               // selection: TextSelection.collapsed(offset: upperText.length),
//             );
//             // default async validation logic
//             String filteredValue =
//                 await ControllerUtils.partNumberValidation(value);
//             if (filteredValue != value) {
//               controller.text = filteredValue;
//               controller.selection = TextSelection.fromPosition(
//                 TextPosition(offset: filteredValue.length),
//               );
//             }
//
//
//           }
//         },
//         decoration: InputDecoration(
//           suffixIcon: IconButton(
//             icon: const Icon(
//               Icons.search,
//               color: DMAppColors.secondary,
//             ),
//             onPressed: onSearch,
//           ),
//           labelText: hintText,
//         ),
//         validator: (value) {
//           if (value == null || value.trim().isEmpty) {
//             return 'Please Enter Part Number';
//           }
//           // if(value.length<9){
//           //   return 'Invalid Vehicle Number';
//           // }
//           return null;
//         },
//       ),
//     );
//   }
// }
