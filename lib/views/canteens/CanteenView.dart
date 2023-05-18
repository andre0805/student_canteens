import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:student_canteens/models/Canteen.dart';
import 'package:student_canteens/models/QueueLength.dart';
import 'package:student_canteens/models/QueueLengthReport.dart';
import 'package:student_canteens/models/WorkSchedule.dart';
import 'package:student_canteens/services/GCF.dart';
import 'package:student_canteens/services/SessionManager.dart';
import 'package:student_canteens/services/StorageService.dart';
import 'package:student_canteens/utils/utils.dart';
import 'package:student_canteens/views/canteens/CanteenMapView.dart';
import 'package:student_canteens/views/canteens/QueueLengthReportsView.dart';
import 'package:student_canteens/views/canteens/QueueLengthView.dart';
import 'package:student_canteens/views/canteens/WorkScheduleListView.dart';
import 'package:url_launcher/url_launcher.dart';

class CanteenView extends StatefulWidget {
  final Canteen canteen;
  final Function parentRefreshWidget;

  const CanteenView(
      {super.key, required this.canteen, required this.parentRefreshWidget});

  @override
  State<CanteenView> createState() => _CanteenViewState(
        canteen: canteen,
        parentRefreshWidget: parentRefreshWidget,
      );
}

class _CanteenViewState extends State<CanteenView> {
  Canteen canteen;
  final Function parentRefreshWidget;

  _CanteenViewState({required this.canteen, required this.parentRefreshWidget});

  SessionManager sessionManager = SessionManager.sharedInstance;
  StorageService storageService = StorageService();
  GCF gcf = GCF.sharedInstance;

  Set<WorkSchedule> workSchedules = {};
  List<QueueLengthReport> queueLengthReports = [];
  bool isLoading = false;
  bool isFavorite = false;

  @override
  void initState() {
    super.initState();

    updateWidget(() {
      isLoading = true;
    });

    Future.wait([
      getWorkschedule(),
      getFavoriteCanteens(),
      getQueueLengthReports(),
    ]).then((value) {
      updateWidget(() {
        workSchedules = value[0] as Set<WorkSchedule>;
        sessionManager.currentUser?.favoriteCanteens = value[1] as Set<int>;
        isLoading = false;
        isFavorite =
            sessionManager.currentUser?.isFavorite(canteen.id) ?? false;
        queueLengthReports = value[2] as List<QueueLengthReport>;
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      floatingActionButton: Visibility(
        visible: !isLoading,
        child: SpeedDial(
          backgroundColor: Colors.grey[900],
          foregroundColor: Colors.grey[200],
          elevation: 10.0,
          overlayColor: Colors.grey[900],
          overlayOpacity: 0.5,
          activeIcon: Icons.close,
          icon: Icons.people,
          spacing: 8,
          children: [
            SpeedDialChild(
              label: 'Prijavi vrlo dugačak red',
              backgroundColor: getColorFromQueueLength(QueueLength.VERY_LONG),
              child: const Icon(Icons.people),
              shape: const CircleBorder(),
              onTap: () => reportQueueLength(QueueLength.VERY_LONG),
            ),
            SpeedDialChild(
              label: 'Prijavi dugačak red',
              backgroundColor: getColorFromQueueLength(QueueLength.LONG),
              child: const Icon(Icons.people),
              shape: const CircleBorder(),
              onTap: () => reportQueueLength(QueueLength.LONG),
            ),
            SpeedDialChild(
              label: 'Prijavi srednji red',
              backgroundColor: getColorFromQueueLength(QueueLength.MEDIUM),
              child: const Icon(Icons.people),
              shape: const CircleBorder(),
              onTap: () => reportQueueLength(QueueLength.MEDIUM),
            ),
            SpeedDialChild(
              label: 'Prijavi kratak red',
              backgroundColor: getColorFromQueueLength(QueueLength.SHORT),
              child: const Icon(Icons.people),
              shape: const CircleBorder(),
              onTap: () => reportQueueLength(QueueLength.SHORT),
            ),
            SpeedDialChild(
              label: 'Prijavi bez reda',
              backgroundColor: getColorFromQueueLength(QueueLength.NONE),
              child: const Icon(Icons.people),
              shape: const CircleBorder(),
              onTap: () => reportQueueLength(QueueLength.NONE),
            ),
          ],
        ),
      ),
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
              actions: [
                Visibility(
                  visible: !isLoading,
                  child: IconButton(
                    onPressed:
                        isFavorite ? removeFavoriteCanteen : addFavoriteCanteen,
                    icon: Icon(
                      isFavorite ? Icons.star : Icons.star_border,
                    ),
                  ),
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
                  height: 250,
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        blurRadius: 1,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: CanteenMapView(canteen: canteen),
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
                      // queue length
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 0),
                        child: Wrap(
                          direction: Axis.horizontal,
                          crossAxisAlignment: WrapCrossAlignment.center,
                          children: [
                            QueueLengthView(
                              queueLength: canteen.queueLength,
                              queueIconSize: 30,
                            ),
                            IconButton(
                              onPressed: showQueueLengthInfo,
                              icon: Icon(
                                Icons.info_outline_rounded,
                                size: 20,
                                color: Colors.blue[200],
                              ),
                            ),
                          ],
                        ),
                      ),

                      // canteen name
                      Text(
                        canteen.name,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 4),

                      // canteen address
                      Text(
                        canteen.address,
                        style: const TextStyle(
                          fontSize: 16,
                        ),
                      ),

                      const SizedBox(height: 16),

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
                            const SizedBox(height: 8),
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
                            const SizedBox(height: 4),
                            Text(
                              canteen.contact.toString(),
                              style: const TextStyle(
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(height: 16),
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
                            const SizedBox(height: 4),
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
                            ),
                            const SizedBox(height: 16),
                          ],
                        ),
                      ),

                      // queue length reports
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Wrap(
                            direction: Axis.horizontal,
                            crossAxisAlignment: WrapCrossAlignment.center,
                            spacing: 0,
                            children: [
                              Text(
                                "Prijave (${queueLengthReports.length})",
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              IconButton(
                                onPressed: () {
                                  Utils.showAlertDialog(
                                    context,
                                    "Prijave",
                                    """• Prijave služe za informiranje drugih korisnika o duljini reda u menzi.\n\n• Ovdje možeš vidjeti svoje prijave i prijave drugih korisnika u posljednjih 15 min.""",
                                  );
                                },
                                icon: Icon(
                                  Icons.info_outline_rounded,
                                  size: 20,
                                  color: Colors.blue[200],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          QueueLengthReportsView(
                            canteen: canteen,
                            queueLengthReports: queueLengthReports,
                            onRemoveReport: removeQueueLengthReport,
                          ),
                          const SizedBox(height: 48),
                        ],
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

  void updateWidget(void Function() callback) {
    if (!mounted) return;
    setState(callback);
  }

  Future<void> refreshWidget() async {
    Future.wait([
      getCanteen(),
      getWorkschedule(),
      getFavoriteCanteens(),
      getQueueLengthReports(),
    ]).then((value) {
      updateWidget(() {
        canteen = value[0] as Canteen;
        workSchedules = value[1] as Set<WorkSchedule>;
        sessionManager.currentUser?.favoriteCanteens = value[2] as Set<int>;
        isFavorite =
            sessionManager.currentUser?.isFavorite(canteen.id) ?? false;
        queueLengthReports = value[3] as List<QueueLengthReport>;
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

  Future<Canteen?> getCanteen() {
    return gcf.getCanteen(canteen.id);
  }

  Future<List<QueueLengthReport>> getQueueLengthReports() {
    return gcf.getQueueLengthReports(canteen.id);
  }

  Future<Set<int>> getFavoriteCanteens() {
    return gcf.getFavoriteCanteens();
  }

  void addFavoriteCanteen() {
    updateWidget(() {
      isFavorite = !isFavorite;
    });

    gcf.addFavoriteCanteen(canteen.id).then((value) {
      updateWidget(() {
        isFavorite = value;
      });
    });
  }

  void removeFavoriteCanteen() {
    updateWidget(() {
      isFavorite = !isFavorite;
    });

    gcf.removeFavoriteCanteen(canteen.id).then(
      (value) {
        updateWidget(() {
          isFavorite = !value;
        });
      },
    );
  }

  void reportQueueLength(QueueLength queueLength) async {
    gcf.reportQueueLength(canteen.id, queueLength, null).then((reportId) {
      if (reportId != null) {
        refreshWidget();
        parentRefreshWidget();
        if (mounted) {
          Utils.showSnackBarMessageWithAction(
            context,
            getQueueLengthReportResponseMessage(queueLength),
            "Poništi",
            () => removeQueueLengthReport(reportId),
          );
        }
      } else {
        if (mounted) Utils.showSnackBarMessage(context, "Greška!");
      }
    });
  }

  void removeQueueLengthReport(int reportId) async {
    gcf.removeQueueLengthReport(reportId).then((result) {
      if (result) {
        refreshWidget();
        parentRefreshWidget();
        if (mounted) Utils.showSnackBarMessage(context, "Prijava poništena!");
      } else {
        if (mounted) Utils.showSnackBarMessage(context, "Greška!");
      }
    });
  }

  String getQueueLengthReportResponseMessage(QueueLength queueLength) {
    switch (queueLength) {
      case QueueLength.NONE:
        return "Prijavljeno da nema reda!";
      case QueueLength.SHORT:
        return "Prijavljen kratak red!";
      case QueueLength.MEDIUM:
        return "Prijavljen srednji red!";
      case QueueLength.LONG:
        return "Prijavljen dugačak red!";
      case QueueLength.VERY_LONG:
        return "Prijavljen vrlo dugačak red!";
      case QueueLength.UNKNOWN:
        return "Greška!";
    }
  }

  void showQueueLengthInfo() {
    Utils.showAlertDialogWithCustomContent(
      context,
      "Prosječna duljina reda",
      Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            """• Prosječna duljina reda u menzi računa se na temelju svih prijava u posljednjih 15 minuta.\n\n• Duljinu reda u menzi možeš prijaviti klikom na gumb u donjem desnom kutu ekrana.\n\n• Ako pogrešno prijaviš duljinu reda u menzi, možeš je poništiti klikom na jednu od svojih prijava u popisu prijava.""",
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w400,
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            "Legenda",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            direction: Axis.vertical,
            spacing: 8,
            children: [
              for (QueueLength queueLength in QueueLength.values) ...[
                Wrap(
                  direction: Axis.horizontal,
                  spacing: 4,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    QueueLengthView(
                      queueLength: queueLength,
                      queueIconSize: 18,
                    ),
                    Text(
                      " — ${queueLengthString(queueLength)}",
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[900],
                      ),
                    ),
                  ],
                )
              ],
            ],
          ),
        ],
      ),
      [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text(
            "OK",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  String queueLengthString(QueueLength queueLength) {
    switch (queueLength) {
      case QueueLength.UNKNOWN:
        return "nepoznato stanje reda";
      case QueueLength.NONE:
        return "nema reda";
      case QueueLength.SHORT:
        return "kratak red (1-5 min)";
      case QueueLength.MEDIUM:
        return "srednji red (5-15 min)";
      case QueueLength.LONG:
        return "dugačak red (15-30 min)";
      case QueueLength.VERY_LONG:
        return "vrlo dugačak red (30+ min)";
    }
  }
}
