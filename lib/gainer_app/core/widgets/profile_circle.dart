import 'dart:io';
import 'package:flutter/material.dart';
import '../constants/gainer_image.dart';

class ProfileCircle extends StatelessWidget {
  final double size;
  final String? pickedImg;
  final String? apiImg;
  const ProfileCircle({
    super.key,
    required this.size,
    required this.pickedImg,
    required this.apiImg,
  });

  @override
  Widget build(BuildContext context) {
    final String? imageUrl = (apiImg != null && apiImg!.isNotEmpty)
        ? 'https://scope.sparecare.in/Upload/Employee/$apiImg'
        : null;

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white10, width: 5),
      ),
      child: ClipOval(
        child: _buildImage(imageUrl),
      ),
    );
  }

  Widget _buildImage(String? imageUrl) {
    if (pickedImg != null) {
      return Image.file(
        File(pickedImg!),
        fit: BoxFit.cover,
      );
    }

    if (imageUrl != null) {
      try {
        return Image.network(
          imageUrl,
          fit: BoxFit.cover,
          loadingBuilder: (_, child, progress) {
            if (progress == null) return child;
            return const Center(
                child: CircularProgressIndicator(strokeWidth: 2));
          },
          errorBuilder: (_, __, ___) {
            return Image.asset(GainerImages.profile, fit: BoxFit.cover);
          },
        );
      } catch (e) {
        return Image.asset(
          GainerImages.profile,
          fit: BoxFit.cover,
        );
      }
    }

    return Image.asset(
      GainerImages.profile,
      fit: BoxFit.cover,
    );
  }
}
