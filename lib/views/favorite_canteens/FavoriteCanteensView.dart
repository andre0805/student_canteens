import 'dart:async';
import 'package:flutter/material.dart';
import 'package:student_canteens/models/Canteen.dart';
import 'package:student_canteens/services/AuthService.dart';
import 'package:student_canteens/services/GCF.dart';
import 'package:student_canteens/services/SessionManager.dart';
import 'package:student_canteens/services/StorageService.dart';
import 'package:student_canteens/views/canteen/CanteenView.dart';
import 'package:student_canteens/views/canteens/CanteenListItemView.dart';

class FavoriteCanteensView extends StatefulWidget {
  const FavoriteCanteensView({super.key});

  @override
  State<FavoriteCanteensView> createState() => _FavoriteCanteensViewState();
}

class _FavoriteCanteensViewState extends State<FavoriteCanteensView> {
  AuthService authService = AuthService.sharedInstance;
  StorageService storageService = StorageService();
  SessionManager sessionManager = SessionManager.sharedInstance;
  GCF gcf = GCF.sharedInstance;

  List<Canteen> favoriteCanteens = [];
  Timer? refreshDataTimer;

  @override
  void initState() {
    super.initState();

    favoriteCanteens = sessionManager.currentUser?.favoriteCanteens ?? [];

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
            centerTitle: true,
            surfaceTintColor: Colors.grey[900],
            title: const Text(
              "Omiljene menze",
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),

          const SliverToBoxAdapter(
            child: SizedBox(height: 8),
          ),

          // list of canteens
          SliverVisibility(
            visible: favoriteCanteens.isNotEmpty,
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

          // empty list message
          SliverVisibility(
            visible: favoriteCanteens.isEmpty,
            sliver: SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              sliver: SliverToBoxAdapter(
                child: Center(
                  child: Text(
                    "Nema omiljenih menzi.",
                    style: TextStyle(
                      color: Colors.grey[900],
                      fontSize: 18,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
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
        sessionManager.currentUser?.favoriteCanteens = value;
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
