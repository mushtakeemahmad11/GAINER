import 'package:flutter/material.dart';

import '../../core/themes/scanapp_colors.dart';

class HorizontalStepper extends StatelessWidget {
  final int currentStep;
  final List<String> titles;
  final List<IconData> icons;

  const HorizontalStepper({
    super.key,
    required this.currentStep,
    required this.titles,
    required this.icons,
  }) : assert(titles.length == icons.length,
            "Titles and Icons list must be the same length");

  @override
  Widget build(BuildContext context) {
    final totalSteps = titles.length;

    return Column(
      children: [
        // 🔹 Row for Icons + Connectors
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: List.generate(totalSteps * 2 - 1, (index) {
            if (index.isEven) {
              final stepIndex = index ~/ 2;
              final isActive = stepIndex <= currentStep;

              return Expanded(
                child: CircleAvatar(
                  radius: 20,
                  backgroundColor: isActive
                      ? stepIndex < currentStep
                          ? ScanappColors.secondary
                          : ScanappColors.primary
                      : Colors.grey[300],
                  child: Icon(
                    icons[stepIndex],
                    color: isActive ? Colors.white : Colors.grey,
                    size: 20,
                  ),
                ),
              );
            } else {
              // Connector line → perfectly aligned with center of icons
              return Expanded(
                child: Container(
                  height: 2,
                  color: index ~/ 2 < currentStep
                      ? ScanappColors.secondary
                      : Colors.grey[300],
                ),
              );
            }
          }),
        ),
        const SizedBox(height: 6),
        // 🔹 Row for Titles (aligned with icons above)
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(totalSteps, (stepIndex) {
            final isActive = stepIndex <= currentStep;

            return Text(
              titles[stepIndex],
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12,
                color: isActive ? ScanappColors.secondary : Colors.grey,
                fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
              ),
            );
          }),
        ),
      ],
    );
  }
}

class StepperExample extends StatefulWidget {
  const StepperExample({super.key});

  @override
  StepperExampleState createState() => StepperExampleState();
}

class StepperExampleState extends State<StepperExample> {
  int _currentStep = 0;
  final List<Widget> _steps = [
    Center(child: Text("Dealer\nInfo", style: TextStyle(fontSize: 12))),
    Center(child: Text("Contact\nPerson", style: TextStyle(fontSize: 12))),
    Center(child: Text("KYC\nInfo", style: TextStyle(fontSize: 12))),
    Center(child: Text("Plan\nSelection", style: TextStyle(fontSize: 12))),
    Center(child: Text("Payment\nScreen", style: TextStyle(fontSize: 12))),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.black,
        title: Text("Create your Account"),
        backgroundColor: ScanappColors.primary,
      ),
      body: Stepper(
        type:
            StepperType.horizontal, // 🔹 you can also try StepperType.vertical
        currentStep: _currentStep,
        onStepTapped: (step) => setState(() => _currentStep = step),
        onStepContinue: () {
          if (_currentStep < 5) {
            setState(() => _currentStep += 1);
          }
        },
        onStepCancel: () {
          if (_currentStep > 0) {
            setState(() => _currentStep -= 1);
          }
        },
        steps: List.generate(
          _steps.length,
          (index) => Step(
            title: _steps[index],
            content: const Text("Enter your details here."),
            isActive: _currentStep >= 0,
            state: _currentStep > 0 ? StepState.complete : StepState.indexed,
          ),
        ),
        // steps: [
        //   Step(
        //     title: const Text("Step 1"),
        //     content: const Text("Enter your details here."),
        //     isActive: _currentStep >= 0,
        //     state: _currentStep > 0 ? StepState.complete : StepState.indexed,
        //   ),
        //   Step(
        //     title: const Text("Step 2"),
        //     content: const Text("Review your information."),
        //     isActive: _currentStep >= 1,
        //     state: _currentStep > 1 ? StepState.complete : StepState.indexed,
        //   ),
        //   Step(
        //     title: const Text("Step 3"),
        //     content: const Text("Confirm & Submit."),
        //     isActive: _currentStep >= 2,
        //     state: _currentStep == 2 ? StepState.editing : StepState.indexed,
        //   ),
        // ],
      ),
    );
  }
}
