import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:student_canteens/models/Canteen.dart';
import 'package:student_canteens/models/WorkSchedules.dart';
import 'package:student_canteens/models/WorkSchedule.dart';
import 'package:student_canteens/views/canteens/WorkScheduleView.dart';

class WorkScheduleListView extends StatefulWidget {
  final Canteen canteen;
  final Set<WorkSchedule> workSchedules;

  WorkScheduleListView({
    Key? key,
    required this.canteen,
    required this.workSchedules,
  }) : super(key: key);

  @override
  State<WorkScheduleListView> createState() => _WorkScheduleListViewState(
        canteen: canteen,
        workSchedules: workSchedules,
      );
}

class _WorkScheduleListViewState extends State<WorkScheduleListView> {
  final Canteen canteen;
  final WorkSchedules workSchedules;

  _WorkScheduleListViewState({
    required this.canteen,
    required Set<WorkSchedule> workSchedules,
  }) : workSchedules = WorkSchedules(workSchedules: workSchedules);

  Map<String, String> workSchedule_allDay = {};
  Map<String, String> workSchedule_breakfast = {};
  Map<String, String> workSchedule_lunch = {};
  Map<String, String> workSchedule_dinner = {};

  @override
  void initState() {
    super.initState();
    workSchedule_allDay = workSchedules.getWorkScheduleForMealOfDay(-1);
    workSchedule_breakfast = workSchedules.getWorkScheduleForMealOfDay(1);
    workSchedule_lunch = workSchedules.getWorkScheduleForMealOfDay(2);
    workSchedule_dinner = workSchedules.getWorkScheduleForMealOfDay(3);
  }

  @override
  Widget build(BuildContext context) {
    return workSchedule_allDay.isNotEmpty
        ? WorkScheduleView(workSchedule: workSchedule_allDay)
        : SizedBox(
            height: 220,
            child: ListView(
              scrollDirection: Axis.horizontal,
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
