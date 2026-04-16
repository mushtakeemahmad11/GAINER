import 'package:flutter/material.dart';
/// 🔹 AD MODEL
class AdItemModel {
  final String image;
  final String title;
  final VoidCallback onTap;

  const AdItemModel({
    required this.image,
    required this.title,
    required this.onTap,
  });
}