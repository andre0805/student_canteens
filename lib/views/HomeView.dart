import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:student_canteens/models/Canteen.dart';
import 'package:student_canteens/services/AuthService.dart';
import 'package:student_canteens/services/GCF.dart';
import 'package:student_canteens/services/StorageService.dart';
import 'package:student_canteens/utils/Comparator.dart';

class HomeView extends StatefulWidget {
  HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  AuthService authService = AuthService();
  StorageService storageService = StorageService();
  GCF gcf = GCF.sharedInstance;

  Map<String, List<Canteen>> canteenMap = HashMap();
  Set<String> cities = SplayTreeSet((key1, key2) {
    return HR_Comparator.compare(key1, key2);
  });

  String? selectedCity;
  List<Canteen> selectedCanteens = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();

    setState(() {
      isLoading = true;
    });

    Future.wait([
      storageService.getString("selectedCity"),
      getCanteens(),
    ]).then((value) {
      setState(() {
        selectedCity = value[0] as String;
        selectedCanteens = canteenMap[selectedCity] ?? [];
        isLoading = false;
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

            // loading indicator
            SliverVisibility(
              visible: isLoading,
              sliver: const SliverFillRemaining(
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              ),
            ),

            // city picker
            SliverVisibility(
              visible: !isLoading,
              sliver: SliverToBoxAdapter(
                child: Center(
                  child: SizedBox(
                    width: 200,
                    child: DropdownButton(
                      focusColor: Colors.white,
                      isExpanded: true,
                      value: selectedCity ?? "Bjelovar",
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
            ),

            // list of canteens
            SliverVisibility(
              visible: !isLoading,
              sliver: SliverPadding(
                padding: const EdgeInsets.only(bottom: 24),
                sliver: SliverList(
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

  void selectCity(String city) async {
    await storageService.saveString("selectedCity", city);

    setState(() {
      selectedCity = city;
      selectedCanteens = canteenMap[city] ?? [];
    });
  }
}
