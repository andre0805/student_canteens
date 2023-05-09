import 'package:flutter/material.dart';
import 'package:student_canteens/models/Canteen.dart';
import 'package:student_canteens/services/AuthService.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:student_canteens/services/GCF.dart';

class HomeView extends StatefulWidget {
  HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  AuthService authService = AuthService();
  GCF gcf = GCF.sharedInstance;

  List<Canteen> canteens = [];

  @override
  void initState() {
    super.initState();
    gcf.getCanteens().then((value) {
      setState(() {
        canteens = value;
      });
    });

    print("Canteens: " + canteens.toString());
  }

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
      body: ListView.builder(
          itemCount: canteens.length,
          itemBuilder: (context, index) {
            return Card(
              child: ListTile(
                title: Text(canteens[index].name),
                subtitle: Text(canteens[index].address),
              ),
            );
          }),
    );
  }
}
