import 'package:flutter/material.dart';
import 'package:student_canteens/models/Canteen.dart';
import 'package:student_canteens/models/QueueLengthReport.dart';
import 'package:student_canteens/views/canteens/QueueLengthView.dart';

class QueueLengthReportsView extends StatelessWidget {
  final Canteen canteen;
  final List<QueueLengthReport> queueLengthReports;

  const QueueLengthReportsView({
    super.key,
    required this.canteen,
    required this.queueLengthReports,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.only(top: 8, bottom: 24),
      itemCount: queueLengthReports.length,
      itemBuilder: (context, index) {
        QueueLengthReport queueLengthReport = queueLengthReports[index];
        return Card(
            elevation: 2,
            surfaceTintColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 12,
                horizontal: 12,
              ),
              child: Wrap(
                direction: Axis.horizontal,
                alignment: WrapAlignment.spaceBetween,
                crossAxisAlignment: WrapCrossAlignment.end,
                children: [
                  Wrap(
                    direction: Axis.vertical,
                    spacing: 8,
                    crossAxisAlignment: WrapCrossAlignment.start,
                    children: [
                      Text(
                        queueLengthReport.getRelativeTimeString(),
                        style: const TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                      Text(
                        queueLengthReport.getDisplayName(),
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  QueueLengthView(queueLength: queueLengthReport.queueLength),
                ],
              ),
            ));
      },
    );
  }
}
