import 'package:flutter/material.dart';
import 'package:gainer/scanapp/controllers/create_account_controller.dart';
import 'package:gainer/scanapp/screens/create_account_screens/contact_information_screen.dart';
import 'package:get/get.dart';
import '../../core/themes/scanapp_colors.dart';
import 'dealer_information_screen.dart';
import '../../widgets/test/horizontal_stepper.dart';

class CustomStepperScreen extends StatefulWidget {
  const CustomStepperScreen({super.key});

  @override
  CustomStepperScreenState createState() => CustomStepperScreenState();
}

class CustomStepperScreenState extends State<CustomStepperScreen> {
  final CreateAccountController _controller =
      Get.put(CreateAccountController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.black,
        title: Text("Create your Account"),
        backgroundColor: ScanappColors.primary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(8),
        child: Obx(() {
          return Column(
            children: [
              // 🔹 Stepper Header with Icons + Titles
              HorizontalStepper(
                currentStep: _controller.currentStep.value,
                titles: [
                  "Dealer\nInfo",
                  "Contact\nPerson",
                  "KYC\nInfo",
                  "Select\nPlan",
                  "Payment"
                ],
                icons: [
                  Icons.store,
                  Icons.person,
                  Icons.badge_outlined,
                  Icons.list_alt,
                  Icons.payment
                ],
              ),
              const SizedBox(height: 20),

              // 🔹 Step 1 Form
              if (_controller.currentStep.value == 0)
                DealerInfoScreen(
                  onNext: () => _controller.currentStep.value = 1,
                  c: _controller,
                ),

              // 🔹 Step 2 Form
              if (_controller.currentStep.value == 1)
                ContactInfoScreen(
                  onNext: () => _controller.currentStep.value = 2,
                  c: _controller,
                ),

              // 🔹 Step 3 Form
              if (_controller.currentStep.value == 2) _buildKycForm(),

              // 🔹 Step 4 Form
              if (_controller.currentStep.value == 3) _buildPlanSelectForm(),

              // 🔹 Step 5 Form
              if (_controller.currentStep.value == 4) _buildPaymentForm(),

              Row(
                // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (_controller.currentStep.value > 0)
                    TextButton(
                      onPressed: () {
                        if (_controller.currentStep.value > 0) {
                          _controller.currentStep.value -= 1;
                        }
                      },
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [Icon(Icons.arrow_back), Text("Back")],
                      ),
                    ),
                  Spacer(),
                  TextButton(
                    onPressed: () {
                      if (_controller.currentStep.value < 4) {
                        _controller.currentStep.value += 1;
                      }
                    },
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [Text("Next"), Icon(Icons.arrow_right_alt)],
                    ),
                  ),
                ],
              )
            ],
          );
        }),
      ),
    );
  }

  // Widget _buildContactForm() {
  //   return Column(
  //     crossAxisAlignment: CrossAxisAlignment.start,
  //     children: [
  //       const Text("Contact Person",
  //           style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
  //       const SizedBox(height: 10),
  //       TextField(
  //         decoration: const InputDecoration(
  //           labelText: "Full Name",
  //           border: OutlineInputBorder(),
  //         ),
  //       ),
  //       const SizedBox(height: 10),
  //       TextField(
  //         decoration: const InputDecoration(
  //           labelText: "Phone Number",
  //           border: OutlineInputBorder(),
  //         ),
  //       ),
  //       const SizedBox(height: 20),
  //       Row(
  //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //         children: [
  //           OutlinedButton(
  //             onPressed: () => _controller.currentStep.value = 0,
  //             child: const Text("Back"),
  //           ),
  //           ElevatedButton(
  //             onPressed: () => _controller.currentStep.value = 2,
  //             child: const Text("Next"),
  //           ),
  //         ],
  //       ),
  //     ],
  //   );
  // }

  // Step 3 Form
  Widget _buildKycForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("KYC Info",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 10),
        // TextField(
        //   decoration: const InputDecoration(
        //     labelText: "PAN Number",
        //     border: OutlineInputBorder(),
        //   ),
        // ),
        // const SizedBox(height: 10),
        // TextField(
        //   decoration: const InputDecoration(
        //     labelText: "Aadhar Number",
        //     border: OutlineInputBorder(),
        //   ),
        // ),
        // const SizedBox(height: 20),
        // Row(
        //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //   children: [
        //     OutlinedButton(
        //       onPressed: () => _controller.currentStep.value = 1,
        //       child: const Text("Back"),
        //     ),
        //     ElevatedButton(
        //       onPressed: () => _controller.currentStep.value = 3,
        //       child: const Text("Next"),
        //     ),
        //   ],
        // ),
      ],
    );
  }

  // Step 4 Form
  Widget _buildPlanSelectForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Select Your Plan",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 10),
      ],
    );
  }

  // Step 5 Form
  Widget _buildPaymentForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Payment",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 10),
      ],
    );
  }
}
