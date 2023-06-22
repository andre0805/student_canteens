import 'package:flutter/material.dart';
import 'package:student_canteens/models/Canteen.dart';
import 'package:student_canteens/views/queue_length/QueueLengthView.dart';

class CanteenListItemView extends StatelessWidget {
  CanteenListItemView({
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
          contentPadding: const EdgeInsets.fromLTRB(16, 4, 12, 4),
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  QueueLengthView(
                    queueLength: canteen.queueLength,
                    queueIconSize: 26,
                  ),
                  Wrap(
                    direction: Axis.horizontal,
                    spacing: 4,
                    children: [
                      Text(
                        canteen.getDistanceFromUserString(),
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: Colors.grey,
                        ),
                      ),
                      const Icon(
                        Icons.location_on,
                        color: Colors.grey,
                        size: 18,
                      )
                    ],
                  )
                ],
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
}
