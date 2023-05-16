import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:student_canteens/models/Canteen.dart';
import 'package:student_canteens/services/AuthService.dart';
import 'package:student_canteens/services/GCF.dart';
import 'package:student_canteens/services/StorageService.dart';
import 'package:student_canteens/utils/Comparator.dart';
import 'package:student_canteens/views/canteens/CanteenView.dart';

class CanteensView extends StatefulWidget {
  const CanteensView({super.key});

  @override
  State<CanteensView> createState() => _CanteensViewState();
}

class _CanteensViewState extends State<CanteensView> {
  AuthService authService = AuthService.sharedInstance;
  StorageService storageService = StorageService();
  GCF gcf = GCF.sharedInstance;

  Map<String, List<Canteen>> canteenMap = HashMap();
  Set<String> cities = SplayTreeSet((key1, key2) {
    return HR_Comparator.compare(key1, key2);
  });

  String selectedCity = "";
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
        try {
          selectedCity = value[0] as String;
          selectedCanteens = canteenMap[selectedCity] ?? [];
        } catch (e) {
          try {
            selectedCity = cities.first;
            selectedCanteens = canteenMap[selectedCity] ?? [];
          } catch (e) {
            selectedCity = "";
            selectedCanteens = [];
          }
        }
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

            const SliverToBoxAdapter(
              child: SizedBox(height: 8),
            ),

            // city picker
            SliverVisibility(
              visible: !isLoading,
              sliver: SliverToBoxAdapter(
                child: Center(
                  child: SizedBox(
                    width: 220,
                    height: 50,
                    child: DropdownButton(
                      focusColor: Colors.white,
                      isExpanded: true,
                      style: const TextStyle(
                        fontSize: 20,
                        color: Colors.black,
                      ),
                      iconSize: 26,
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
                    childCount: selectedCanteens.length,
                    (context, index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Card(
                          child: ListTile(
                            title: Text(selectedCanteens[index].name),
                            subtitle: Text(selectedCanteens[index].address),
                            tileColor: Colors.white70,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            onTap: () => selectCanteen(selectedCanteens[index]),
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
      for (Canteen canteen in value) {
        String city = canteen.city;
        cities.add(city);
        if (canteenMap.containsKey(city)) {
          canteenMap[city]?.add(canteen);
        } else {
          canteenMap[city] = [canteen];
        }
      }

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

  void selectCanteen(Canteen canteen) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CanteenView(canteen: canteen),
      ),
    );
  }
}
