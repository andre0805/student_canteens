import 'package:flutter/material.dart';
import 'package:student_canteens/views/home/HomeView.dart';

class DrawerItem extends StatelessWidget {
  final int index;
  final String title;
  final IconData icon;
  final VoidCallback onTap;

  const DrawerItem({
    super.key,
    required this.index,
    required this.title,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      tileColor: index == selectedDrawerItemIndex
          ? Colors.grey[350]
          : Colors.transparent,
      leading: Icon(
        icon,
        color: Colors.grey[800],
      ),
      title: Text(
        title,
        style: TextStyle(
          color: Colors.grey[800],
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
      ),
      onTap: onTap,
    );
  }
}
