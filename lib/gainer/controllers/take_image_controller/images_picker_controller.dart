import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class ImagePickerController extends GetxController {
  var selectedImages = <File>[].obs;
  final ImagePicker _picker = ImagePicker();

  /// Pick multiple images from gallery (max limit enforced)
  Future<List<File>> pickImagesFromGallery(int maxImages, {int currentCount = 0}) async {
    final List<XFile> pickedFiles = await _picker.pickMultiImage();

    if (pickedFiles.isEmpty) return []; // User canceled or no files

    int availableSlots = maxImages - currentCount; // Remaining slots
    if (availableSlots <= 0) {
      Get.defaultDialog(
        title: "Limit Reached",
        content: Text("You can only select up to $maxImages images"),
      );
      return [];
    }

    List<File> newImages = pickedFiles
        .take(availableSlots)
        .map((file) => File(file.path))
        .toList();

    return newImages;
  }

  /// Pick a single image from camera (max limit enforced)
  Future<File?> pickImageFromCamera(int maxImages, {int currentCount = 0}) async {
    if (currentCount >= maxImages) {
      Get.defaultDialog(
        title: "Limit Reached",
        content: Text("You can only select up to $maxImages images"),
      );
      return null;
    }

    final XFile? pickedFile = await _picker.pickImage(source: ImageSource.camera);

    if (pickedFile != null) {
      return File(pickedFile.path);
    }
    return null;
  }
}
