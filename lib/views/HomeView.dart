import 'dart:collection';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:student_canteens/models/Canteen.dart';
import 'package:student_canteens/services/AuthService.dart';
import 'package:student_canteens/services/GCF.dart';
import 'package:student_canteens/utils/Comparator.dart';

class HomeView extends StatefulWidget {
  HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  AuthService authService = AuthService();
  GCF gcf = GCF.sharedInstance;

  Map<String, List<Canteen>> canteenMap = HashMap();
  Set<String> cities = SplayTreeSet((key1, key2) {
    return HR_Comparator.compare(key1, key2);
  });

  String selectedCity = "Bjelovar";
  List<Canteen> selectedCanteens = [];

  @override
  void initState() {
    super.initState();
    getCanteens().then((value) {
      setState(() {
        selectedCanteens = canteenMap[selectedCity]!;
      });
    });
  }

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
            SliverAppBar.medium(
              surfaceTintColor: Colors.grey[900],
              leading: IconButton(
                onPressed: () {},
                icon: const Icon(Icons.menu),
              ),
              title: const Text(
                "Popis menza",
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

            // city picker
            SliverToBoxAdapter(
              child: Center(
                child: SizedBox(
                  width: 200,
                  child: DropdownButton(
                    focusColor: Colors.white,
                    isExpanded: true,
                    value: selectedCity,
                    items: cities.map((e) {
                      return DropdownMenuItem(
                        value: e,
                        child: Text(e),
                      );
                    }).toList(),
                    onChanged: (value) {
                      selectCity(value.toString());
                    },
                  ),
                ),
              ),
            ),

            // list of canteens
            SliverList(
              delegate: SliverChildBuilderDelegate(
                childCount: selectedCanteens.length,
                (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Card(
                      child: ListTile(
                        title: Text(selectedCanteens[index].name),
                        subtitle: Text(selectedCanteens[index].address),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> refreshWidget() async {
    return getCanteens();
  }

  Future<void> getCanteens() {
    canteenMap.clear();
    return gcf.getCanteens().then((value) {
      value.forEach((e) {
        String city = e.city;
        cities.add(city);
        if (canteenMap.containsKey(city)) {
          canteenMap[city]?.add(e);
        } else {
          canteenMap[city] = [e];
        }
      });
      setState(() {});
    });
  }

  void selectCity(String city) {
    setState(() {
      selectedCity = city;
      selectedCanteens = canteenMap[city]!;
    });
  }
}
