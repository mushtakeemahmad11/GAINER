import 'dart:io';

import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class PickImageController extends GetxController {
  // var imageFile = Rx<File?>(null); // Reactive File variable

  Future<File?> pickImage(ImageSource source) async {

    final ImagePicker picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source);

    if (pickedFile != null) {
      // imageFile.value = File(pickedFile.path);
      return File(pickedFile.path);
    }
    return null;
  }

  Future<List<File>> pickMultipleImages() async {
    final ImagePicker picker = ImagePicker();
    final List<XFile> pickedFiles = await picker.pickMultiImage(); // Allows multiple selection

    if (pickedFiles.isNotEmpty) {
      return pickedFiles.take(4).map((file) => File(file.path)).toList(); // Limit to 4 images
    }
    return [];
  }

}
