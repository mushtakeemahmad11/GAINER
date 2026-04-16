import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gainer/dealer_monitoring/core/theme/app_colors.dart';
import 'package:gainer/gainer_app/core/widgets/gainer_bottom_sheet.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../../main.dart';
import '../../widgets/dm_elevated_button.dart';
import '../../widgets/remarks_bottom_sheet.dart';

class ImagePickScreen extends StatefulWidget {
  const ImagePickScreen({super.key});

  @override
  State<ImagePickScreen> createState() => _ImagePickScreenState();
}

class _ImagePickScreenState extends State<ImagePickScreen> {
  final RemarksController _remarksController = Get.put(RemarksController());
  File? imagePath;
  String? from;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    final args = Get.arguments;
    if (args != null) {
      imagePath = args['imagePath'];
      from = args['from'];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Capture Advance Receipt"),
        centerTitle: true,
      ),
      body: Padding(
          padding: EdgeInsets.symmetric(
            vertical: mq.height * 0.02,
            horizontal: mq.width * 0.03,
          ),
          child: imagePath == null ? _buildEmptyState() : _buildImagePreview()),
    );
  }

  /// UI when no image is selected
  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: showCustomBottomSheet,
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.teal[50],
              ),
              child: Icon(Icons.add_a_photo_rounded,
                  size: 80, color: DMAppColors.secondary),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            "Tap to capture or select image",
            style: TextStyle(fontSize: 16, color: Colors.grey[700]),
          ),
        ],
      ),
    );
  }

  /// UI when image is selected
  Widget _buildImagePreview() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 8,
                  offset: Offset(0, 4),
                )
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.file(
                imagePath!,
                // height: mq.height * 0.3,
                // width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              icon: const Icon(Icons.camera_alt_rounded),
              label: const Text("Recapture Image"),
              onPressed: showCustomBottomSheet,
              style: OutlinedButton.styleFrom(
                foregroundColor: DMAppColors.secondary,
                side: BorderSide(color: DMAppColors.secondary),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.symmetric(vertical: 12),
                textStyle: const TextStyle(fontSize: 16),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Form(
            key: _formKey, // Assign the GlobalKey to the Form
            child: Column(
              children: [
                // CustomTextFormField(
                //     controller: _textEditingController,
                //     text: "Enter Advance Value"),
                TextFormField(
                  controller: _remarksController.advanceValueController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    label: const Text("Enter Advance Value"),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  // NEW: Add inputFormatters to allow only digits
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly, // Allows only 0-9
                    LengthLimitingTextInputFormatter(7), // Max 7 digits
                  ],
                  onChanged: (value) {
                    if (value == '0') {
                      _remarksController.advanceValueController.clear();
                    } else if (value.startsWith('0')) {
                      final newValue = value.replaceFirst(RegExp(r'^0+'), '');
                      _remarksController.advanceValueController.value =
                          TextEditingValue(
                        text: newValue,
                        selection:
                            TextSelection.collapsed(offset: newValue.length),
                      );
                    }
                    // Re-validate to remove warning if fixed
                    if (_formKey.currentState != null) {
                      _formKey.currentState!.validate();
                    }
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter advance value';
                    }
                    // // Optional: Add more specific number validation
                    // if (double.tryParse(value) == null) {
                    //   return 'Please enter a valid number';
                    // }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                SizedBox(
                  width: double.infinity,
                  child: DmElevatedButton(
                    onTap: () {
                      // Trigger validation when the button is pressed
                      if (_formKey.currentState!.validate()) {
                        Get.back();
                        if (from != "vehicleClose") {
                          _remarksController.onSubmit();
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                                content: Text(
                                    'There is some problem')),
                          );
                        }
                      }
                    },
                    text: "Submit",
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Bottom sheet to select image source
  void showCustomBottomSheet() {
    GainerBottomSheet.show(
      isGainer: false,
      context: context,
      onPressedCamera: () {
        _pickImage(ImageSource.camera);
        Get.back();
      },
      onPressedGallery: () {
        _pickImage(ImageSource.gallery);
        Get.back();
      },
    );
  }

  /// Image picker function
  Future<void> _pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final image = await picker.pickImage(source: source);

    if (image != null) {
      setState(() {
        imagePath = File(image.path);
      });
    }
  }
}
