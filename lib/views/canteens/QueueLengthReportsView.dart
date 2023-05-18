import 'package:flutter/material.dart';
import 'package:student_canteens/models/Canteen.dart';
import 'package:student_canteens/models/QueueLengthReport.dart';
import 'package:student_canteens/services/SessionManager.dart';
import 'package:student_canteens/utils/utils.dart';
import 'package:student_canteens/views/canteens/QueueLengthView.dart';

class QueueLengthReportsView extends StatelessWidget {
  final Canteen canteen;
  final List<QueueLengthReport> queueLengthReports;
  final Function onRemoveReport;

  const QueueLengthReportsView({
    super.key,
    required this.canteen,
    required this.queueLengthReports,
    required this.onRemoveReport,
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
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: ListTile(
              tileColor: Colors.white70,
              splashColor: Colors.grey[200],
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              onTap: () => handleReportTapped(context, queueLengthReport),
              title: Wrap(
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

  void handleReportTapped(
    BuildContext context,
    QueueLengthReport queueLengthReport,
  ) {
    String? userId = SessionManager.sharedInstance.currentUser?.id;

    if (userId == null) return;

    if (queueLengthReport.userId == userId) {
      Utils.showAlertDialogWithActions(context, 'Poništi prijavu',
          'Možeš poništiti svoju prijavu ako misliš da je pogrešna.', [
        TextButton(
          style: ButtonStyle(
            textStyle: MaterialStateProperty.all(
              const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Odustani'),
        ),
        TextButton(
          style: ButtonStyle(
            foregroundColor: MaterialStateProperty.all(Colors.red[400]),
            overlayColor: MaterialStateProperty.all(Colors.red[50]),
            textStyle: MaterialStateProperty.all(
              const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          onPressed: () {
            Navigator.of(context).pop();
            onRemoveReport(queueLengthReport.id);
          },
          child: const Text('Poništi prijavu'),
        ),
      ]);
    }
  }
}
