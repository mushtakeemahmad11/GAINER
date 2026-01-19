import 'package:flutter/material.dart';
import 'package:gainer/scanapp/core/themes/scanapp_colors.dart';

import 'horizontal_stepper.dart';

class DealerInfoScreen extends StatefulWidget {
  const DealerInfoScreen({super.key});

  @override
  State<DealerInfoScreen> createState() => _DealerInfoScreenState();
}

class _DealerInfoScreenState extends State<DealerInfoScreen> {
  final _formKey = GlobalKey<FormState>();

  String? _brand;
  String? _location;
  String? _industry;
  DateTime? _registrationDate;

  final _dealerNameController = TextEditingController();
  final _addressController = TextEditingController();
  final _cityController = TextEditingController();
  final _stateController = TextEditingController();

  // int _currentStep = 0;

  // final List<Widget> _steps = [
  //   Center(child: Text("Dealer Info Form", style: TextStyle(fontSize: 18))),
  //   Center(child: Text("Contact Person Form", style: TextStyle(fontSize: 18))),
  //   Center(child: Text("KYC Info Form", style: TextStyle(fontSize: 18))),
  //   Center(child: Text("Plan Selection", style: TextStyle(fontSize: 18))),
  //   Center(child: Text("Payment Screen", style: TextStyle(fontSize: 18))),
  // ];

  // void _nextStep() {
  //   if (_currentStep < _steps.length - 1) {
  //     setState(() => _currentStep++);
  //   }
  // }

  // void _prevStep() {
  //   if (_currentStep > 0) {
  //     setState(() => _currentStep--);
  //   }
  // }

  final int currentStep = 0;
  final steps = [
    {"icon": Icons.store, "title": "Store"},
    {"icon": Icons.person, "title": "Profile"},
    {"icon": Icons.description, "title": "Docs"},
    {"icon": Icons.list_alt, "title": "Orders"},
    {"icon": Icons.payment, "title": "Payment"},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.black,
        title: Text("Create your Account"),
        backgroundColor: ScanappColors.primary,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              HorizontalStepper(
                currentStep: 2, // highlights up to step 2
                // totalSteps: 5,
                titles: ["Dealer\nInfo", "Contact\nPerson", "KYC\nInfo", "Select\nPlan", "Payment"],
                icons: [Icons.store,Icons.person,Icons.description,Icons.list_alt,Icons.payment],
              ),


              /// Stepper Progress (Custom simplified UI)
              // ListView.builder(
              //     shrinkWrap: false,
              //     itemCount: steps.length,
              //     itemBuilder: (BuildContext context, int index) {
              //       final item = steps[index];
              //       final stepIndex = index ~/ 2;
              //       if (index.isOdd) {
              //         return const Expanded(child: Divider(thickness: 2));
              //       } else {
              //         return Column(
              //           children: [
              //             CircleAvatar(
              //               child: Icon(
              //                 item["icon"] as IconData,
              //                 color: stepIndex <= currentStep
              //                     ? Colors.teal
              //                     : Colors.grey,
              //               ),
              //             ),
              //             const SizedBox(height: 4),
              //             Text(
              //               item["title"] as String,
              //               style: TextStyle(
              //                 fontSize: 12,
              //                 color: stepIndex <= currentStep
              //                     ? Colors.teal
              //                     : Colors.grey,
              //               ),
              //             ),
              //           ],
              //         );
              //       }
              //     }),
              // Row(
              //   crossAxisAlignment: CrossAxisAlignment.center,
              //   mainAxisAlignment: MainAxisAlignment.spaceAround,
              //   children: List.generate(steps.length * 2 - 1, (index) {
              //     if (index.isOdd) {
              //       // Divider between steps
              //       return const Expanded(child: Divider(thickness: 2));
              //     }
              //     final stepIndex = index ~/ 2;
              //     final step = steps[stepIndex];
              //
              //     return Column(
              //       children: [
              //         CircleAvatar(
              //           child: Icon(
              //             step["icon"] as IconData,
              //             color: stepIndex <= currentStep
              //                 ? Colors.teal
              //                 : Colors.grey,
              //           ),
              //         ),
              //         const SizedBox(height: 4),
              //         Text(
              //           step["title"] as String,
              //           style: TextStyle(
              //             fontSize: 12,
              //             color: stepIndex <= currentStep
              //                 ? Colors.teal
              //                 : Colors.grey,
              //           ),
              //         ),
              //       ],
              //     );
              //   }),
              // ),
              ///

              Text("Dealer Information",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),

              SizedBox(height: 16),

              /// Brand
              DropdownButtonFormField<String>(
                initialValue: _brand,
                decoration: InputDecoration(labelText: "Select brand"),
                items: ["Brand A", "Brand B", "Brand C"]
                    .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                    .toList(),
                onChanged: (val) => setState(() => _brand = val),
              ),

              SizedBox(height: 10),

              /// Dealer Name
              TextFormField(
                controller: _dealerNameController,
                decoration: InputDecoration(labelText: "Dealer name"),
              ),

              SizedBox(height: 10),

              /// Dealer Location
              DropdownButtonFormField<String>(
                initialValue: _location,
                decoration:
                    InputDecoration(labelText: "Select dealer location"),
                items: ["Delhi", "Gurugram", "Noida"]
                    .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                    .toList(),
                onChanged: (val) => setState(() => _location = val),
              ),

              SizedBox(height: 10),

              /// Industry Type
              DropdownButtonFormField<String>(
                initialValue: _industry,
                decoration: InputDecoration(labelText: "Select industry type"),
                items: ["Retail", "Wholesale", "Manufacturing"]
                    .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                    .toList(),
                onChanged: (val) => setState(() => _industry = val),
              ),

              SizedBox(height: 10),

              /// Address
              TextFormField(
                controller: _addressController,
                decoration:
                    InputDecoration(labelText: "Warehouse / Office Address"),
              ),

              SizedBox(height: 10),

              /// City & State (Row)
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _cityController,
                      decoration: InputDecoration(labelText: "City"),
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: TextFormField(
                      controller: _stateController,
                      decoration: InputDecoration(labelText: "State"),
                    ),
                  ),
                ],
              ),

              SizedBox(height: 10),

              /// Date of Registration
              InkWell(
                onTap: () async {
                  final date = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2100),
                  );
                  if (date != null) {
                    setState(() => _registrationDate = date);
                  }
                },
                child: InputDecorator(
                  decoration:
                      InputDecoration(labelText: "Date of Registration"),
                  child: Text(
                    _registrationDate == null
                        ? "Select Date"
                        : "${_registrationDate!.day}-${_registrationDate!.month}-${_registrationDate!.year}",
                  ),
                ),
              ),

              SizedBox(height: 20),

              /// Save Button
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      // save logic here
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal,
                    padding: EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                  ),
                  child: Text("Save"),
                ),
              ),

              SizedBox(height: 20),

              /// Next Button (bottom right style)
              Align(
                alignment: Alignment.centerRight,
                child: OutlinedButton(
                  onPressed: () {
                    // next step logic
                  },
                  child: Text("Next"),
                ),
              ),

              SizedBox(height: 20),

              /// Logo
              Center(
                child: Text(
                  "ACCUSLOCK",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Widget _stepperCircle(String title, Color? backcolor, IconData icon) {
  //   return Column(
  //     children: [
  //       CircleAvatar(child: Icon(icon, color: Colors.grey)),
  //       SizedBox(height: 4),
  //       Text(title, style: TextStyle(fontSize: 12)),
  //     ],
  //   );
  // }

  // // 🔹 Helper for Step Icons
  // Widget _buildStepIcon(IconData icon, int index) {
  //   final isActive = _currentStep >= index;
  //   return CircleAvatar(
  //     radius: 20,
  //     backgroundColor: isActive ? Colors.teal : Colors.grey.shade300,
  //     child: Icon(icon, color: isActive ? Colors.white : Colors.grey),
  //   );
  // }

  // // 🔹 Helper for Divider Line
  // Widget _buildLine() => Expanded(
  //       child: Divider(
  //         thickness: 2,
  //         color: Colors.grey.shade400,
  //       ),
  //     );
}
