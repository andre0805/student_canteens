import 'package:flutter/material.dart';
import 'package:student_canteens/models/Canteen.dart';
import 'package:student_canteens/models/QueueLength.dart';
import 'package:student_canteens/utils/utils.dart';

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
              GestureDetector(
                onTap: () => Utils.showSnackBarMessage(
                  context,
                  getQueueLengthString(canteen.queueLength),
                ),
                child: Row(
                  children: getQueueLengthWidgets(),
                ),
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

    for (int i = 0; i < canteen.queueLength.index; i++) {
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

    for (int i = 0; i < 5 - canteen.queueLength.index; i++) {
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

    return widgets;
  }
}
