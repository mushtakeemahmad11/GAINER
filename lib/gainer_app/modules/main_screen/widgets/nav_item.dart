import 'package:flutter/material.dart';
import '../nav_model.dart';

class ModularBottomNav extends StatelessWidget {
  final List<NavItem> items;
  final int currentIndex;
  final ValueChanged<int> onTap;

  const ModularBottomNav({
    super.key,
    required this.items,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      type: BottomNavigationBarType.fixed,
      selectedItemColor: Colors.teal,
      unselectedItemColor: Colors.grey,
      onTap: onTap,
      items: items
          .map(
            (item) => BottomNavigationBarItem(
          icon: Icon(item.icon),
          label: item.label,
        ),
      )
          .toList(),
    );
  }
}
