import 'package:flutter/material.dart';
import 'package:student_canteens/services/AuthService.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HomeView extends StatelessWidget {
  HomeView({super.key});

  AuthService authService = AuthService();
  User? user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: const Text("Home"),
        backgroundColor: Colors.grey[800],
        actions: [
          IconButton(
            onPressed: () {
              authService.signOut();
            },
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: Center(
        child: Text("logged in as: ${user?.email ?? "unknown"}"),
      ),
    );
  }
}
