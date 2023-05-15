import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:student_canteens/models/Canteen.dart';
import 'package:student_canteens/models/WorkSchedule.dart';
import 'package:student_canteens/services/GCF.dart';
import 'package:student_canteens/services/StorageService.dart';
import 'package:student_canteens/views/canteens/WorkScheduleListView.dart';
import 'package:url_launcher/url_launcher.dart';

class CanteenView extends StatefulWidget {
  final Canteen canteen;

  const CanteenView({super.key, required this.canteen});

  @override
  State<CanteenView> createState() => _CanteenViewState(canteen: canteen);
}

class _CanteenViewState extends State<CanteenView> {
  final Canteen canteen;

  _CanteenViewState({required this.canteen});

  StorageService storageService = StorageService();
  GCF gcf = GCF.sharedInstance;

  Set<WorkSchedule> workSchedules = {};

  bool isLoading = false;

  @override
  void initState() {
    super.initState();

    setState(() {
      isLoading = true;
    });

    Future.wait([
      getWorkschedule(),
    ]).then((value) {
      setState(() {
        workSchedules = value[0];
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
        edgeOffset: 120,
        child: CustomScrollView(
          slivers: [
            // app bar
            SliverAppBar(
              surfaceTintColor: Colors.grey[900],
              leading: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.arrow_back),
              ),
              title: const Text(
                "",
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              actions: [
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.star_border),
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

            // google map
            SliverVisibility(
              visible: !isLoading,
              sliver: SliverToBoxAdapter(
                child: Container(
                  height: 200,
                  color: Colors.green[400],
                  child: const Center(
                    child: Text("Google map"),
                  ),
                ),
              ),
            ),

            // canteen info
            SliverVisibility(
              visible: !isLoading,
              sliver: SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // canteen name
                      Text(
                        canteen.name,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 8),

                      // canteen address
                      Text(
                        canteen.address,
                        style: const TextStyle(
                          fontSize: 16,
                        ),
                      ),

                      const SizedBox(height: 24),

                      // work schedule
                      Visibility(
                        visible: workSchedules.isNotEmpty,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Radno vrijeme",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 0,
                                vertical: 8,
                              ),
                              child: WorkScheduleListView(
                                canteen: canteen,
                                workSchedules: workSchedules,
                              ),
                            ),
                            const SizedBox(height: 12),
                          ],
                        ),
                      ),

                      // contact
                      Visibility(
                        visible: canteen.contact != null,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Kontakt",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              canteen.contact.toString(),
                              style: const TextStyle(
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(height: 24),
                          ],
                        ),
                      ),

                      // web
                      Visibility(
                        visible: canteen.url != null,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Web",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            InkWell(
                              onTap: openCanteenWeb,
                              child: const Text(
                                "Otvori web",
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.blue,
                                  decoration: TextDecoration.underline,
                                  decorationColor: Colors.blue,
                                ),
                              ),
                            )
                          ],
                        ),
                      ),

                      const SizedBox(height: 24),
                    ],
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
    Future.wait([
      getWorkschedule(),
    ]).then((value) {
      setState(() {
        workSchedules = value[0];
      });
    });
  }

  Future<Set<WorkSchedule>> getWorkschedule() async {
    return gcf.getWorkSchedule(canteen.id);
  }

  void openCanteenWeb() async {
    if (await canLaunchUrl(Uri.parse(canteen.url.toString()))) {
      await launchUrl(Uri.parse(canteen.url.toString()));
    } else {
      print('Could not launch ${canteen.url.toString()}');
    }
  }
}
