import 'dart:async';
import 'package:flutter/material.dart';
import 'package:student_canteens/models/Canteen.dart';
import 'package:student_canteens/services/AuthService.dart';
import 'package:student_canteens/services/GCF.dart';
import 'package:student_canteens/services/StorageService.dart';
import 'package:student_canteens/views/canteens/CanteenView.dart';
import 'package:student_canteens/views/canteens/CanteenListItemView.dart';

class FavoriteCanteensView extends StatefulWidget {
  const FavoriteCanteensView({super.key});

  @override
  State<FavoriteCanteensView> createState() => _FavoriteCanteensViewState();
}

class _FavoriteCanteensViewState extends State<FavoriteCanteensView> {
  AuthService authService = AuthService.sharedInstance;
  StorageService storageService = StorageService();
  GCF gcf = GCF.sharedInstance;

  List<Canteen> favoriteCanteens = [];
  bool isLoading = false;
  Timer? refreshDataTimer;

  @override
  void initState() {
    super.initState();

    updateWidget(() {
      isLoading = true;
    });

    Future.wait([
      getFavoriteCanteens(),
    ]).then((value) {
      updateWidget(() {
        isLoading = false;
      });
    });

    refreshDataTimer = Timer.periodic(
      const Duration(seconds: 10),
      (timer) {
        refreshWidget();
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
    refreshDataTimer?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: refreshWidget,
      edgeOffset: 180,
      child: CustomScrollView(
        slivers: [
          // app bar
          SliverAppBar.medium(
            surfaceTintColor: Colors.grey[900],
            title: const Text(
              "Omiljene menze",
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            actions: [
              IconButton(
                onPressed: () {
                  authService.signOut();
                },
                icon: const Icon(Icons.logout),
              ),
            ],
          ),

          // loading indicator
          SliverVisibility(
            visible: isLoading,
            sliver: const SliverFillRemaining(
              child: Center(
                child: CircularProgressIndicator(),
              ),
            ),
          ),

          const SliverToBoxAdapter(
            child: SizedBox(height: 8),
          ),

          // list of canteens
          SliverVisibility(
            visible: !isLoading,
            sliver: SliverPadding(
              padding: const EdgeInsets.only(bottom: 24),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  childCount: favoriteCanteens.length,
                  (context, index) {
                    return CanteenListItemView(
                      canteen: favoriteCanteens[index],
                      onTap: () => selectCanteen(favoriteCanteens[index]),
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void updateWidget(void Function() callback) {
    if (!mounted) return;
    setState(callback);
  }

  Future<void> refreshWidget() async {
    return getFavoriteCanteens().then((value) {
      updateWidget(() {});
    });
  }

  Future<void> getFavoriteCanteens() {
    favoriteCanteens.clear();
    return gcf.getFavoriteCanteens().then((value) {
      updateWidget(() {
        favoriteCanteens = value;
      });
    });
  }

  void selectCanteen(Canteen canteen) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            CanteenView(canteen: canteen, parentRefreshWidget: refreshWidget),
      ),
    );
  }
}
