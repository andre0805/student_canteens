import 'package:flutter/material.dart';
import 'package:student_canteens/models/QueueLength.dart';
import 'package:student_canteens/utils/utils.dart';

class QueueLengthView extends StatelessWidget {
  const QueueLengthView({
    Key? key,
    required this.queueLength,
  }) : super(key: key);

  final QueueLength queueLength;

  final IconData queueIcon = Icons.person;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Utils.showSnackBarMessage(
        context,
        getQueueLengthString(queueLength),
      ),
      child: Wrap(
        children: getQueueLengthWidgets(),
      ),
    );
  }

  List<Widget> getQueueLengthWidgets() {
    List<Widget> widgets = [];

    for (int i = 0; i < queueLength.index; i++) {
      widgets.add(
        Icon(
          queueIcon,
          color: getColorFromQueueLength(queueLength),
          shadows: [
            Shadow(
              blurRadius: 1,
              color: Colors.grey.shade400,
              offset: const Offset(1, 1),
            ),
          ],
        ),
      );
    }

    for (int i = 0; i < 5 - queueLength.index; i++) {
      widgets.add(
        Icon(
          queueIcon,
          color: Colors.grey.shade300,
          shadows: [
            Shadow(
              blurRadius: 1,
              color: Colors.grey.shade400,
              offset: const Offset(1, 1),
            ),
          ],
        ),
      );
    }

    return widgets;
  }
}
