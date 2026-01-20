import 'package:flutter/material.dart';

class ActionCardModel {
  final IconData icon;
  final String title;
  final String subtitle;
  final String status;
  final Color iconColor;
  final String actionKey; // 🔥 navigation key

  ActionCardModel({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.status,
    required this.iconColor,
    required this.actionKey,
  });
}
