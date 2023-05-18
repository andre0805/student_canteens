import 'package:flutter/material.dart';
import 'package:student_canteens/models/Canteen.dart';
import 'package:student_canteens/models/WorkSchedules.dart';
import 'package:student_canteens/models/WorkSchedule.dart';
import 'package:student_canteens/views/canteens/WorkScheduleView.dart';

class WorkScheduleListView extends StatelessWidget {
  final Canteen canteen;
  final WorkSchedules workSchedules;

  WorkScheduleListView({
    super.key,
    required this.canteen,
    required Set<WorkSchedule> workSchedules,
  }) : workSchedules = WorkSchedules(workSchedules: workSchedules);

  @override
  Widget build(BuildContext context) {
    Map<String, String> workSchedule_allDay =
        workSchedules.getWorkScheduleForMealOfDay(-1);
    Map<String, String> workSchedule_breakfast =
        workSchedules.getWorkScheduleForMealOfDay(1);
    Map<String, String> workSchedule_lunch =
        workSchedules.getWorkScheduleForMealOfDay(2);
    Map<String, String> workSchedule_dinner =
        workSchedules.getWorkScheduleForMealOfDay(3);

    return workSchedule_allDay.isNotEmpty
        ? WorkScheduleView(workSchedule: workSchedule_allDay)
        : SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                // breakfast work schedule
                Visibility(
                  visible: workSchedule_breakfast.isNotEmpty,
                  child: Row(
                    children: [
                      WorkScheduleView(
                        title: "Doručak",
                        workSchedule: workSchedule_breakfast,
                      ),
                      const SizedBox(width: 32),
                    ],
                  ),
                ),

                // lunch work schedule
                Visibility(
                  visible: workSchedule_lunch.isNotEmpty,
                  child: Row(
                    children: [
                      WorkScheduleView(
                        title: "Ručak",
                        workSchedule: workSchedule_lunch,
                      ),
                      const SizedBox(width: 32),
                    ],
                  ),
                ),

                // dinner work schedule
                Visibility(
                  visible: workSchedule_dinner.isNotEmpty,
                  child: WorkScheduleView(
                    title: "Večera",
                    workSchedule: workSchedule_dinner,
                  ),
                ),
              ],
            ),
          );
  }
}
