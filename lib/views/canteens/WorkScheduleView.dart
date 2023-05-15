import 'package:flutter/material.dart';

class WorkScheduleView extends StatelessWidget {
  const WorkScheduleView({
    super.key,
    this.title,
    required this.workSchedule,
  });

  final String? title;
  final Map<String, String> workSchedule;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Visibility(
          visible: title != null,
          child: Text(
            title ?? "",
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: List<Widget>.generate(workSchedule.length, (index) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 2),
              child: Row(
                children: [
                  SizedBox(
                    width: 40,
                    child: Text(
                      workSchedule.keys.elementAt(index),
                      style: const TextStyle(
                        fontSize: 16,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Text(
                    workSchedule.values.elementAt(index),
                    style: const TextStyle(
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            );
          }),
        ),
      ],
    );
  }
}
