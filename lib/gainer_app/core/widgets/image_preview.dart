import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'gainer_app_loader.dart';

class ImagePreview {
  static void show({
    required dynamic image, // File or String URL
    String? title,
  }) {
    Get.dialog(
      Dialog.fullscreen(
        child: Scaffold(
          backgroundColor: Colors.black,
          appBar: AppBar(
            backgroundColor: Colors.black,
            foregroundColor: Colors.white,
            elevation: 0,
            title: Text(
              title ?? 'Image Preview',
              style: const TextStyle(color: Colors.white),
            ),
          ),
          body: Center(
            child: InteractiveViewer(
              minScale: 0.5,
              maxScale: 5,
              child: image is File
                  ? Image.file(
                      image,
                      fit: BoxFit.contain,
                    )
                  : Image.network(
                      image.startsWith('http')
                          ? image
                          : 'https://scope.sparecare.in/Upload/DispatchDetails/$image',
                      fit: BoxFit.contain,
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return const Center(
                          child: GainerCircularLoader(color: Colors.white),
                        );
                      },
                      errorBuilder: (_, __, ___) {
                        return const Center(
                          child: Icon(
                            Icons.broken_image,
                            color: Colors.white,
                            size: 80,
                          ),
                        );
                      },
                    ),
            ),
          ),
        ),
      ),
    );
  }
}
