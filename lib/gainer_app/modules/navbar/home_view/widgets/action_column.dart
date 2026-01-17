import 'package:flutter/material.dart';
import '../models/action_card_model.dart';
import 'action_item_card.dart';

class ActionColumn extends StatelessWidget {
  final String title;
  final Color headerColor;
  final List<ActionCardModel> items;

  const ActionColumn({
    super.key,
    required this.title,
    required this.headerColor,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Card(
        margin: EdgeInsets.zero,
        color: headerColor,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(6),
              child: Text(
                title,
                style: const TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
              ),
            ),
            Card(
              margin: EdgeInsets.zero,
              color: Colors.white70,
              child: Column(
                // mainAxisSize: MainAxisSize.max,
                children:
                    items.map((item) => ActionItemCard(item: item)).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
