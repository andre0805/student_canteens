import 'package:flutter/material.dart';
import 'package:student_canteens/models/Canteen.dart';
import 'package:student_canteens/models/QueueLength.dart';

class CanteenListItemView extends StatelessWidget {
  const CanteenListItemView({
    super.key,
    required this.canteen,
    required this.onTap,
  });

  final Canteen canteen;
  final Function() onTap;

  final IconData queueIcon = Icons.person;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Card(
        child: ListTile(
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: getQueueLengthWidgets(),
              ),
              Text(
                canteen.name,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          subtitle: Text(
            canteen.address,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w300,
            ),
          ),
          tileColor: Colors.white70,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          onTap: onTap,
        ),
      ),
    );
  }

  List<Widget> getQueueLengthWidgets() {
    List<Widget> widgets = [];

    if (canteen.queueLength == QueueLength.UNKNOWN) return widgets;

    for (int i = 0; i < canteen.queueLength.index + 1; i++) {
      widgets.add(
        Icon(
          queueIcon,
          color: getColorFromQueueLength(canteen.queueLength),
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

    for (int i = 0; i < 4 - canteen.queueLength.index; i++) {
      widgets.add(
        Icon(
          queueIcon,
          color: Colors.grey.shade200,
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

    widgets.add(
      const SizedBox(width: 8),
    );

    widgets.add(
      Text(
        getQueueLengthString(canteen.queueLength),
        style: const TextStyle(
          fontWeight: FontWeight.w300,
          fontSize: 12,
        ),
      ),
    );

    return widgets;
  }
}
