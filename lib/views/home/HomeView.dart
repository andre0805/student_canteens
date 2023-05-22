import 'package:flutter/material.dart';
import 'package:student_canteens/views/canteens/CanteensView.dart';
import 'package:student_canteens/views/home/CustomDrawer.dart';

int selectedDrawerItemIndex = 0;

class HomeView extends StatefulWidget {
  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final views = [
    const CanteensView(),
    const CanteensView(),
    const CanteensView(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      drawer: const CustomDrawer(),
      body: views[selectedDrawerItemIndex],
    );
  }
}
