import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:student_canteens/models/SCUser.dart';
import 'package:student_canteens/services/AuthService.dart';
import 'package:student_canteens/services/GCF.dart';
import 'package:student_canteens/services/SessionManager.dart';
import 'package:student_canteens/services/StorageService.dart';
import 'package:student_canteens/views/canteens/CanteensView.dart';
import 'package:student_canteens/views/favorite_canteens/FavoriteCanteensView.dart';
import 'package:student_canteens/views/main/DrawerItem.dart';
import 'package:student_canteens/views/map/MapView.dart';

int selectedDrawerItemIndex = 0;

class MainView extends StatefulWidget {
  @override
  State<MainView> createState() => _HomeViewState();
}

class _HomeViewState extends State<MainView> {
  final GCF gcf = GCF.sharedInstance;
  final AuthService authService = AuthService.sharedInstance;
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  final SessionManager sessionManager = SessionManager.sharedInstance;
  final StorageService storageService = StorageService.sharedInstance;

  SCUser? currentUser;
  String? profileImageUrl;

  final views = [
    const CanteensView(),
    const FavoriteCanteensView(),
    MapView(),
  ];

  @override
  void initState() {
    super.initState();
    Future.wait([
      storageService.getInt("selectedDrawerItemIndex"),
    ]).then((values) {
      updateWidget(() {
        selectedDrawerItemIndex = values[0] ?? 0;
      });
    });
    currentUser = sessionManager.currentUser;
    profileImageUrl = firebaseAuth.currentUser?.photoURL;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      drawer: Drawer(
        backgroundColor: Colors.grey[200],
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            UserAccountsDrawerHeader(
              accountName: Text(
                currentUser?.getDisplayName() ?? "",
                style: TextStyle(
                  color: Colors.grey[200],
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
              accountEmail: Text(
                currentUser?.email ?? "",
                style: TextStyle(
                  color: Colors.grey[200],
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                ),
              ),
              currentAccountPicture: Padding(
                padding: const EdgeInsets.all(4.0),
                child: CircleAvatar(
                  backgroundColor: Colors.grey[200],
                  backgroundImage: profileImageUrl != null
                      ? NetworkImage(profileImageUrl!)
                      : null,
                  child: profileImageUrl == null
                      ? Text(
                          currentUser?.getInitials() ?? "",
                          style: TextStyle(
                            color: Colors.grey[900],
                            fontFamily: "",
                            fontSize: 22,
                          ),
                        )
                      : null,
                ),
              ),
              decoration: BoxDecoration(
                color: Colors.grey[900],
              ),
            ),
            DrawerItem(
              index: 0,
              title: "Popis menza",
              icon: Icons.list,
              onTap: () {
                setState(() {
                  selectedDrawerItemIndex = 0;
                  storageService.saveInt("selectedDrawerItemIndex", 0);
                });
                Navigator.pop(context);
              },
            ),
            DrawerItem(
              index: 1,
              title: "Omiljene menze",
              icon: Icons.star,
              onTap: () {
                setState(() {
                  selectedDrawerItemIndex = 1;
                  storageService.saveInt("selectedDrawerItemIndex", 1);
                });
                Navigator.pop(context);
              },
            ),
            DrawerItem(
              index: 2,
              title: "Karta",
              icon: Icons.map,
              onTap: () {
                updateWidget(() {
                  selectedDrawerItemIndex = 2;
                  storageService.saveInt("selectedDrawerItemIndex", 2);
                });
                Navigator.pop(context);
              },
            ),
            const Divider(
              indent: 16,
              endIndent: 16,
            ),
            DrawerItem(
              index: 3,
              title: "Odjava",
              icon: Icons.logout,
              onTap: () {
                Navigator.pop(context);
                authService.signOut();
              },
            ),
          ],
        ),
      ),
      body: views[selectedDrawerItemIndex],
    );
  }

  void updateWidget(VoidCallback callback) {
    if (mounted) setState(callback);
  }
}