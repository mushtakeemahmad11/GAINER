import 'package:flutter/material.dart';
import 'package:gainer/scanapp/controllers/create_account_controller.dart';
import 'package:gainer/gainer/widget/reusable_dropdown.dart';
import 'package:gainer/scanapp/widgets/custom_text_button.dart';
import 'package:gainer/scanapp/widgets/custom_text_field.dart';
import '../../../main.dart';

class ContactInfoScreen extends StatelessWidget {
  final VoidCallback onNext;
  final CreateAccountController c;

  const ContactInfoScreen({super.key, required this.onNext, required this.c});

  @override
  Widget build(BuildContext context) {
    // final controller = Get.put(CreateAccountController());

    return Form(
      key: c.contactFormKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Contact Information",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),

          /// Name
          CustomDropdown(
            isTextFiled: true,
            hintText: "Full name",
            options: ["Name A", "Name B", "Name C"],
            selectedValue: c.fullName.value, // <- initially null
            onChanged: (val) => c.fullName.value = val,
            validator: (val) =>
                (val == null || val.isEmpty) ? "Select name" : null,
          ),

          const SizedBox(height: 10),

          /// Location Name
          CustomTextField(
            text: "Location",
            controller: c.locationController,
            validator: (val) =>
                val == null || val.isEmpty ? "Enter location name" : null,
          ),

          const SizedBox(height: 10),

          /// Designation
          CustomTextField(
            text: "Designation",
            controller: c.designationController,
            validator: (val) =>
                val == null || val.isEmpty ? "Enter Designation" : null,
          ),

          const SizedBox(height: 10),

          /// Phone number
          CustomTextField(
            text: "Phone number",
            controller: c.phoneNumController,
            validator: (val) =>
                val == null || val.isEmpty ? "Enter Phone number" : null,
          ),

          const SizedBox(height: 10),

          /// Email
          CustomTextField(
            text: "Email Id",
            controller: c.emailController,
            validator: (val) =>
                val == null || val.isEmpty ? "Enter email Id" : null,
          ),
          const SizedBox(height: 20),

          /// Save Button
          Center(
            child: SizedBox(
              width: mq.width * .35,
              child: CustomTextButton(
                  text: "Save",
                  onPressed: () => c.saveContactInfo(onNext, context)),
            ),
          ),
        ],
      ),
    );
  }
}
