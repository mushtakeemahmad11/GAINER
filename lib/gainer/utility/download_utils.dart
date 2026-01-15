import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:gal/gal.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart';

import '../../dealer_monitoring/core/theme/app_colors.dart';

class DownloadUtils {
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

  static void downloadApk() async {
    // final url = 'https://drive.google.com/uc?export=download&id=$fileId';
    final url =
        'https://play.google.com/store/apps/details?id=com.sparecare.tel_e_scope&hl=en';
    final uri = Uri.parse(url);

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      Get.snackbar('Error', 'Could not open Play Store.',
          backgroundColor: DMAppColors.accent, colorText: Colors.black);
    }
  }
}
