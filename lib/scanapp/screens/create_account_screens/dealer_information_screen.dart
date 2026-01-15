// import 'package:flutter/material.dart';
// import 'package:gainer/gainer/widget/reusable_dropdown.dart';
// import 'package:gainer/scanapp/widgets/custom_text_button.dart';
// import 'package:gainer/scanapp/widgets/custom_text_field.dart';
// import '../../../main.dart';
//
// class DealerInfoScreen extends StatefulWidget {
//   final GlobalKey<FormState> formKey;
//   final VoidCallback onNext;
//
//   const DealerInfoScreen({
//     super.key,
//     required this.formKey,
//     required this.onNext,
//   });
//
//   @override
//   State<DealerInfoScreen> createState() => _DealerInfoScreenState();
// }
//
// class _DealerInfoScreenState extends State<DealerInfoScreen> {
//   String? _brand;
//   String? _location;
//   String? _industry;
//   DateTime? _registrationDate;
//
//   final TextEditingController _dealerNameController = TextEditingController();
//   final TextEditingController _addressController = TextEditingController();
//   final TextEditingController _cityController = TextEditingController();
//   final TextEditingController _stateController = TextEditingController();
//
//   @override
//   Widget build(BuildContext context) {
//     return Form(
//       key: widget.formKey,
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           const Text("Dealer Information",
//               style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
//           const SizedBox(height: 16),
//
//           /// Brand
//           // DropdownButtonFormField<String>(
//           //   value: _brand,
//           //   decoration: const InputDecoration(labelText: "Select brand"),
//           //   items: ["Brand A", "Brand B", "Brand C"]
//           //       .map((e) => DropdownMenuItem(value: e, child: Text(e)))
//           //       .toList(),
//           //   onChanged: (val) => setState(() => _brand = val),
//           //   validator: (val) => val == null ? "Select brand" : null,
//           // ),
//           CustomDropdown(
//             isTextFiled: true,
//             hintText: "Select brand",
//             options: ["Brand A", "Brand B", "Brand C"],
//             validator: (val) => val == null ? "Select brand" : null,
//             onChanged: (val) => setState(() => _brand = val),
//           ),
//
//           const SizedBox(height: 10),
//
//           /// Dealer Name
//           CustomTextField(
//             text: "Dealer name",
//             controller: _dealerNameController,
//             validator: (val) =>
//                 val == null || val.isEmpty ? "Enter dealer name" : null,
//           ),
//
//           const SizedBox(height: 10),
//
//           /// Dealer Location
//           CustomDropdown(
//             isTextFiled: true,
//             hintText: "Select location",
//             options: ["Delhi", "Gurugram", "Noida"],
//             onChanged: (val) => setState(() => _location = val),
//             validator: (val) => val == null ? "Select location" : null,
//           ),
//
//           const SizedBox(height: 10),
//
//           /// Industry Type
//           CustomDropdown(
//             isTextFiled: true,
//             hintText: "Select industry type",
//             options: ["Retail", "Wholesale", "Manufacturing"],
//             onChanged: (val) => setState(() => _industry = val),
//             validator: (val) => val == null ? "Select industry type" : null,
//           ),
//
//           const SizedBox(height: 10),
//
//           /// Address
//           CustomTextField(
//             text: "Warehouse / Office Address",
//             controller: _addressController,
//             validator: (val) =>
//                 val == null || val.isEmpty ? "Enter address" : null,
//           ),
//
//           const SizedBox(height: 10),
//
//           /// City & State
//           Row(
//             children: [
//               Expanded(
//                 child: CustomTextField(
//                   text: "State",
//                   controller: _stateController,
//                   validator: (val) =>
//                       val == null || val.isEmpty ? "Enter state" : null,
//                 ),
//               ),
//               const SizedBox(width: 10),
//               Expanded(
//                 child: CustomTextField(
//                   text: "City",
//                   controller: _cityController,
//                   validator: (val) =>
//                       val == null || val.isEmpty ? "Enter city" : null,
//                 ),
//               ),
//             ],
//           ),
//
//           const SizedBox(height: 10),
//
//           /// Date of Registration
//           InkWell(
//             onTap: () async {
//               final date = await showDatePicker(
//                 context: context,
//                 initialDate: DateTime.now(),
//                 firstDate: DateTime(2000),
//                 lastDate: DateTime(2100),
//               );
//               if (date != null) {
//                 setState(() => _registrationDate = date);
//               }
//             },
//             child: InputDecorator(
//               decoration: InputDecoration(
//                 labelText: "Date of Registration",
//                 // border: const OutlineInputBorder(),
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(8), // rounded corners
//                   borderSide: const BorderSide(color: Colors.grey), // border color
//                 ),
//               ),
//               child: Text(
//                 _registrationDate == null
//                     ? "Select Date"
//                     : "${_registrationDate!.day}-${_registrationDate!.month}-${_registrationDate!.year}",
//               ),
//             ),
//           ),
//
//           const SizedBox(height: 20),
//
//           /// Save Button
//           Center(
//             child: SizedBox(
//               width: mq.width * .35,
//               child: CustomTextButton(
//                   text: "Save",
//                   onPressed: () {
//                     if (widget.formKey.currentState!.validate()) {
//                       if (widget.formKey.currentState!.validate()) {
//                         widget.onNext();
//                       }
//                       ScaffoldMessenger.of(context).showSnackBar(
//                         const SnackBar(
//                             content:
//                                 Text("Dealer Information Saved Successfully")),
//                       );
//                     }
//                   }),
//             ),
//           ),
//
//           const SizedBox(height: 20),
//
//           const SizedBox(height: 20),
//
//           // /// Logo
//           // const Center(
//           //   child: Text(
//           //     "ACCUSLOCK",
//           //     style: TextStyle(
//           //       fontSize: 20,
//           //       fontWeight: FontWeight.bold,
//           //       letterSpacing: 2,
//           //     ),
//           //   ),
//           // ),
//         ],
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:gainer/scanapp/controllers/create_account_controller.dart';
import 'package:get/get.dart';
import 'package:gainer/gainer/widget/reusable_dropdown.dart';
import 'package:gainer/scanapp/widgets/custom_text_button.dart';
import 'package:gainer/scanapp/widgets/custom_text_field.dart';
import '../../../main.dart';

class DealerInfoScreen extends StatelessWidget {
  final VoidCallback onNext;
  final CreateAccountController c;

  const DealerInfoScreen({super.key, required this.onNext, required this.c});

  @override
  Widget build(BuildContext context) {
    // final controller = Get.put(CreateAccountController());

    return Form(
      key: c.dealerFormKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Dealer Information",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),

          /// Brand
          CustomDropdown(
            isTextFiled: true,
            hintText: "Select brand",
            options: ["Brand A", "Brand B", "Brand C"],
            selectedValue: c.brand.value, // <- initially null
            validator: (val) {
              if (val == null || val.isEmpty) {
                return "Select brand";
              }
              return null;
            },
            onChanged: (val) {
              c.brand.value = val; // val will be null if reset
              // print("value: ${c.brand.value}");
            },
          ),

          const SizedBox(height: 10),

          /// Dealer Name
          CustomTextField(
            text: "Dealer name",
            controller: c.dealerNameController,
            validator: (val) =>
                val == null || val.isEmpty ? "Enter dealer name" : null,
          ),

          const SizedBox(height: 10),

          /// Dealer Location
          CustomDropdown(
            isTextFiled: true,
            hintText: "Select location",
            options: ["Delhi", "Gurugram", "Noida"],
            onChanged: (val) => c.location.value = val,
            validator: (val) => val == null ? "Select location" : null,
          ),

          const SizedBox(height: 10),

          /// Industry Type
          CustomDropdown(
            isTextFiled: true,
            hintText: "Select industry type",
            options: ["Retail", "Wholesale", "Manufacturing"],
            onChanged: (val) => c.industry.value = val,
            validator: (val) => val == null ? "Select industry type" : null,
          ),

          const SizedBox(height: 10),

          /// Address
          CustomTextField(
            text: "Warehouse / Office Address",
            controller: c.addressController,
            validator: (val) =>
                val == null || val.isEmpty ? "Enter address" : null,
          ),

          const SizedBox(height: 10),

          /// City & State
          Row(
            children: [
              Expanded(
                child: CustomTextField(
                  text: "State",
                  controller: c.stateController,
                  validator: (val) =>
                      val == null || val.isEmpty ? "Enter state" : null,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: CustomTextField(
                  text: "City",
                  controller: c.cityController,
                  validator: (val) =>
                      val == null || val.isEmpty ? "Enter city" : null,
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),

          /// Date of Registration
          Obx(() => InkWell(
                onTap: () async {
                  final date = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2100),
                  );
                  if (date != null) c.registrationDate.value = date;
                },
                child: InputDecorator(
                  decoration: InputDecoration(
                    labelText: "Date of Registration",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(color: Colors.grey),
                    ),
                  ),
                  child: Text(
                    c.registrationDate.value == null
                        ? "Select Date"
                        : "${c.registrationDate.value!.day}-${c.registrationDate.value!.month}-${c.registrationDate.value!.year}",
                  ),
                ),
              )),

          const SizedBox(height: 20),

          /// Save Button
          Center(
            child: SizedBox(
              width: mq.width * .35,
              child: CustomTextButton(
                  text: "Save", onPressed: () => c.saveDealerInfo(onNext, context)),
            ),
          ),
        ],
      ),
    );
  }
}
