import 'package:flutter/material.dart';

class StageActionConfig {
  final IconData icon;
  // final Color buyerColor;
  // final Color sellerColor;

  const StageActionConfig({
    required this.icon,
    // required this.buyerColor,
    // required this.sellerColor,
  });
}

final Map<String, StageActionConfig> stageConfigMap = {
  'OrderPlaced': StageActionConfig(
    icon: Icons.shopping_cart,
    // buyerColor: Colors.blue,
    // sellerColor: Colors.green,
  ),
  'PoUpdation': StageActionConfig(
    icon: Icons.update,
    // buyerColor: Colors.blue,
    // sellerColor: Colors.green,
  ),
  'PartsReceipt': StageActionConfig(
    icon: Icons.inventory,
    // buyerColor: Colors.blue,
    // sellerColor: Colors.green,
  ),
  'OrderDue': StageActionConfig(
    icon: Icons.question_mark,
    // buyerColor: Colors.blue,
    // sellerColor: Colors.green,
  ),
  'Manifestation': StageActionConfig(
    icon: Icons.local_shipping,
    // buyerColor: Colors.blue,
    // sellerColor: Colors.green,
  ),
  'DispatchDetail': StageActionConfig(
    icon: Icons.local_shipping,
    // buyerColor: Colors.blue,
    // sellerColor: Colors.green,
  ),
};
