import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:student_canteens/models/WrokSchedule.dart';

class WorkSchedules {
  Set<WorkSchedule> workSchedules = HashSet();

  Map<int, Map<int, List<WorkSchedule>>> workSchedule_byMealOfDay = HashMap();

  WorkSchedules({required Set<WorkSchedule> workSchedules}) {
    this.workSchedules.addAll(workSchedules);
    processWorkSchedules();
  }

  void processWorkSchedules() {
    for (WorkSchedule ws in workSchedules) {
      int mealOfDay = ws.mealOfDay;
      int dayOfWeek = ws.dayOfWeek;

      if (workSchedule_byMealOfDay.containsKey(mealOfDay)) {
        Map<int, List<WorkSchedule>> workSchedule_byMealOfDay_byDayOfWeek =
            workSchedule_byMealOfDay[mealOfDay]!;
        if (workSchedule_byMealOfDay_byDayOfWeek.containsKey(dayOfWeek)) {
          workSchedule_byMealOfDay_byDayOfWeek[dayOfWeek]!.add(ws);
        } else {
          workSchedule_byMealOfDay_byDayOfWeek[dayOfWeek] = [ws];
        }
      } else {
        workSchedule_byMealOfDay[mealOfDay] = HashMap();
        workSchedule_byMealOfDay[mealOfDay]![dayOfWeek] = [ws];
      }
    }
  }

  Map<String, String> getWorkScheduleForMealOfDay(int mealOfDay) {
    // Map dayOfWeek -> List of work schedules as string (Mon -> 8:00-12:00, 14:00-16:00, 18:00-20:00)
    Map<String, String> workSchedule_byMealOfDay_byDayOfWeek_string = {};

    if (workSchedule_byMealOfDay.containsKey(mealOfDay)) {
      // get work schedules for given meal of day
      Map<int, List<WorkSchedule>> workSchedule_byMealOfDay_byDayOfWeek =
          workSchedule_byMealOfDay[mealOfDay]!;

      // for each day of week extract work schedules as string
      for (int dayOfWeek in workSchedule_byMealOfDay_byDayOfWeek.keys) {
        List<WorkSchedule> workSchedulesForDayOfWeek =
            workSchedule_byMealOfDay_byDayOfWeek[dayOfWeek]!;

        List<String> workTimes = [];

        for (WorkSchedule ws in workSchedulesForDayOfWeek) {
          workTimes.add(ws.getTimesString());
        }

        workTimes.sort();

        String dayOfWeekString = getDayOfWeekString(dayOfWeek);

        workSchedule_byMealOfDay_byDayOfWeek_string[dayOfWeekString] =
            workTimes.join(', ');
      }
    }

    return workSchedule_byMealOfDay_byDayOfWeek_string;
  }

  String getDayOfWeekString(int dayOfWeek) {
    switch (dayOfWeek) {
      case 1:
        return 'Pon';
      case 2:
        return 'Uto';
      case 3:
        return 'Sri';
      case 4:
        return 'Čet';
      case 5:
        return 'Pet';
      case 6:
        return 'Sub';
      case 7:
        return 'Ned';
      default:
        return 'Nepoznato';
    }
  }
}
