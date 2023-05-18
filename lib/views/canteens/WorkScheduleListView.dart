import 'package:flutter/material.dart';
import 'package:student_canteens/models/Canteen.dart';
import 'package:student_canteens/models/WorkSchedules.dart';
import 'package:student_canteens/models/WorkSchedule.dart';
import 'package:student_canteens/views/canteens/WorkScheduleView.dart';

class WorkScheduleListView extends StatelessWidget {
  final Canteen canteen;
  final WorkSchedules workSchedules;

  WorkScheduleListView({
    required this.canteen,
    required Set<WorkSchedule> workSchedules,
  }) : workSchedules = WorkSchedules(workSchedules: workSchedules) {
    workSchedule_allDay = this.workSchedules.getWorkScheduleForMealOfDay(-1);
    workSchedule_breakfast = this.workSchedules.getWorkScheduleForMealOfDay(1);
    workSchedule_lunch = this.workSchedules.getWorkScheduleForMealOfDay(2);
    workSchedule_dinner = this.workSchedules.getWorkScheduleForMealOfDay(3);
  }

  Map<String, String> workSchedule_allDay = {};
  Map<String, String> workSchedule_breakfast = {};
  Map<String, String> workSchedule_lunch = {};
  Map<String, String> workSchedule_dinner = {};

  @override
  Widget build(BuildContext context) {
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
