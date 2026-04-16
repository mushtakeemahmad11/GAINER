import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:gal/gal.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart';
import 'dart:typed_data';
import '../constants/gainer_color.dart';

class UrlLaunchUtils {
  /// Common error snackbar
  static SnackbarController _showError(String message) {
    if (Get.isSnackbarOpen) {
      Get.closeCurrentSnackbar();
    }

    return Get.snackbar(
      'Error',
      message,
      backgroundColor: GainerColors.secondary,
      colorText: Colors.black,
    );
  }

  /// Download & save image to gallery
  static Future<Map<String, dynamic>> downloadImage(
      String url, String folderName, imgName) async {
    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        Uint8List bytes = response.bodyBytes;

        await Gal.putImageBytes(
          bytes,
          album: folderName, // creates folder automatically
          name: imgName,
        );

        return {
          'success': true,
          'path': 'Image Saved: Storage/Pictures/$folderName/$imgName.jpg'
        };
      } else {
        return {'success': false, 'error': 'Failed to download image"'};
      }
    } catch (e) {
      return {'success': false, 'error': e.toString()};
    }
  }

  /// Open Play Store app page
  static void downloadApk() async {
    // final url = 'https://drive.google.com/uc?export=download&id=$fileId';
    final url =
        'https://play.google.com/store/apps/details?id=com.sparecare.tel_e_scope&hl=en';
    final uri = Uri.parse(url);

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      _showError('Could not open Play Store');
      // Get.snackbar('Error', 'Could not open Play Store.',
      //     backgroundColor: DMAppColors.accent, colorText: Colors.black);
    }
  }

  /// Open any external URL
  static Future<void> openUrl(
      String url, {
        String errorMessage = 'Could not open URL',
      }) async {
    final Uri uri = Uri.parse(url);
    try {
      if (!await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      )) {
        _showError(errorMessage);
      }
    } catch (e) {
      _showError(errorMessage);
    }
  }
}
