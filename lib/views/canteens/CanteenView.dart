import 'package:flutter/material.dart';
import 'package:student_canteens/models/Canteen.dart';
import 'package:student_canteens/services/GCF.dart';
import 'package:student_canteens/services/StorageService.dart';

class CanteenView extends StatefulWidget {
  final Canteen canteen;

  const CanteenView({super.key, required this.canteen});

  @override
  State<CanteenView> createState() => _CanteenViewState(canteen: canteen);
}

class _CanteenViewState extends State<CanteenView> {
  final Canteen canteen;

  _CanteenViewState({required this.canteen});

  StorageService storageService = StorageService();
  GCF gcf = GCF.sharedInstance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: RefreshIndicator(
        onRefresh: refreshWidget,
        edgeOffset: 180,
        child: CustomScrollView(
          slivers: [
            // app bar
            SliverAppBar(
              surfaceTintColor: Colors.grey[900],
              leading: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.arrow_back),
              ),
              title: Text(
                canteen.name,
                style: const TextStyle(
                  color: Colors.white,
                ),
              ),
              actions: [],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> refreshWidget() async {
    return getCanteen();
  }

  Future<void> getCanteen() async {
    gcf.getCanteens();
  }
}
