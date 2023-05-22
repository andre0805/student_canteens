import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:student_canteens/services/AuthService.dart';
import 'package:student_canteens/services/SessionManager.dart';
import 'package:student_canteens/views/canteens/CanteensView.dart';

class HomeView extends StatefulWidget {
  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final AuthService authService = AuthService.sharedInstance;
  final SessionManager sessionManager = SessionManager.sharedInstance;
  final String? profileImageUrl = FirebaseAuth.instance.currentUser?.photoURL;

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
                sessionManager.currentUser?.getDisplayName() ?? "",
                style: TextStyle(
                  color: Colors.grey[200],
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
              accountEmail: Text(
                sessionManager.currentUser?.email ?? "",
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
                          sessionManager.currentUser?.getInitials() ?? "",
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
            const Divider(
              indent: 16,
              endIndent: 16,
            ),
            ListTile(
              leading: const Icon(
                Icons.logout,
              ),
              title: Text(
                "Odjava",
                style: TextStyle(
                  color: Colors.grey[900],
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              onTap: authService.signOut,
            ),
          ],
        ),
      ),
      body: CanteensView(),
    );
  }
}
