import 'package:flutter/material.dart';
import 'package:student_canteens/models/Canteen.dart';
import 'package:student_canteens/views/canteens/QueueLengthView.dart';

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
              QueueLengthView(
                queueLength: canteen.queueLength,
                queueIconSize: 26,
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
