import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:student_canteens/models/SCUser.dart';
import 'package:student_canteens/services/AuthService.dart';
import 'package:student_canteens/services/SessionManager.dart';
import 'package:student_canteens/views/home/DrawerItem.dart';
import 'package:student_canteens/views/home/HomeView.dart';

class CustomDrawer extends StatefulWidget {
  const CustomDrawer({super.key});

  @override
  State<CustomDrawer> createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  final AuthService authService = AuthService.sharedInstance;

  final SCUser? currentUser = SessionManager.sharedInstance.currentUser;
  final String? profileImageUrl = FirebaseAuth.instance.currentUser?.photoURL;

  @override
  Widget build(BuildContext context) {
    return Drawer(
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
    );
  }

  void updateWidget(VoidCallback callback) {
    if (mounted) setState(callback);
  }
}
