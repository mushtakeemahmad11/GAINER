import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CreateAccountController extends GetxController {
  ///Create Account
  RxInt currentStep = 0.obs;

  ///Dealer Information
  final dealerFormKey = GlobalKey<FormState>();

  // Dropdown values
  var brand = RxnString();
  var location = RxnString();
  var industry = RxnString();
  var registrationDate = Rxn<DateTime>();

  // Text controllers
  final dealerNameController = TextEditingController();
  final addressController = TextEditingController();
  final cityController = TextEditingController();
  final stateController = TextEditingController();

  // Save and Next function
  void saveDealerInfo(VoidCallback onNext, BuildContext context) {
    if (dealerFormKey.currentState!.validate()) {
      onNext();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Dealer Information Saved Successfully")),
      );
    }
  }

  ///Contact Information
  final contactFormKey = GlobalKey<FormState>();
  var fullName = RxnString();
  final locationController = TextEditingController();
  final designationController = TextEditingController();
  final phoneNumController = TextEditingController();
  final emailController = TextEditingController();

  void saveContactInfo(VoidCallback onNext, BuildContext context) {
    if (contactFormKey.currentState!.validate()) {
      onNext();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Contact Information Saved Successfully")),
      );
    }
  }

  @override
  void onClose() {
    dealerNameController.dispose();
    addressController.dispose();
    cityController.dispose();
    stateController.dispose();
    super.onClose();
  }
}
