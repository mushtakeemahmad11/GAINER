import 'package:flutter/material.dart';
import 'package:gainer/scanapp/widgets/custom_text_button.dart';
import 'package:gainer/scanapp/widgets/custom_text_field.dart';
import 'package:get/get.dart';
import '../../../gainer/widget/reusable_dropdown.dart';
import '../../../main.dart';
import '../../controllers/user_profile_creation_controller.dart';
import '../../core/themes/scanapp_colors.dart';

class UserProfileCreationScreen extends StatelessWidget {
  const UserProfileCreationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.put(UserProfileCreationController());
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.black,
        title: Text("User Profile Creation"),
        backgroundColor: ScanappColors.primary,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Form(
              key: c.formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomTextField(
                    text: "Enter Full Name",
                    controller: c.nameController,
                    validator: (val) => val == null || val.isEmpty
                        ? "Please Enter Full Name"
                        : null,
                  ),
                  const SizedBox(height: 10),
                  CustomTextField(
                    text: "Enter Email Id",
                    controller: c.emailIdController,
                    validator: (val) => val == null || val.isEmpty
                        ? "Please Enter Email Id"
                        : null,
                  ),
                  const SizedBox(height: 10),
                  CustomTextField(
                    text: "Enter Phone Number",
                    controller: c.phoneNumController,
                    validator: (val) => val == null || val.isEmpty
                        ? "Please Enter Phone Number"
                        : null,
                  ),
                  const SizedBox(height: 10),
                  CustomTextField(
                    text: "Enter Designation",
                    controller: c.designationController,
                    validator: (val) => val == null || val.isEmpty
                        ? "Please Enter Designation"
                        : null,
                  ),
                  const SizedBox(height: 10),
                  CustomTextField(
                    text: "Enter Department",
                    controller: c.departmentController,
                    validator: (val) => val == null || val.isEmpty
                        ? "Please Enter Department"
                        : null,
                  ),
                  const SizedBox(height: 15),
                  Text(
                    "Set Login Credentials",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  CustomTextField(
                    text: "Enter User Id",
                    controller: c.userIdController,
                    validator: (val) => val == null || val.isEmpty
                        ? "Please Enter User Id"
                        : null,
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: CustomTextField(
                          isPass: true,
                          text: "Enter Password",
                          controller: c.passController,
                          validator: (val) => val == null || val.isEmpty
                              ? "Please Enter Password"
                              : null,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: CustomTextField(
                          text: "Enter Confirm Password",
                          controller: c.conPassController,
                          validator: (val) => val == null || val.isEmpty
                              ? "Please Enter Confirm Password"
                              : null,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  // CustomOutlineDropdown(
                  //   hintText: "Assign Plan",
                  //   items: ["Plan A", "Plan B", "Plan C"],
                  //   // validator: (val) =>
                  //   //     (val == null || val.isEmpty) ? "Assign Plan" : null,
                  //   onChanged: (val) {
                  //     c.selectedPlan.value = val;
                  //     print("value: ${c.selectedPlan.value}");
                  //   },
                  // ),
                  // const SizedBox(height: 10),
                  Obx(
                    () => CustomDropdown(
                      isTextFiled: true,
                      hintText: "Assign Plan",
                      options: ["Plan A", "Plan B", "Plan C"],
                      selectedValue: c.selectedPlan.value,
                      onChanged: (val) => c.selectedPlan.value = val,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Center(
                    child: SizedBox(
                      width: mq.width * .35,
                      child: CustomTextButton(
                        text: "Save",
                        onPressed: () => c.onSaveProfile(context),
                      ),
                    ),
                  ),
                ],
              )),
        ),
      ),
    );
  }
}
