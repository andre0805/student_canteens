
class WorkSchedule {
  int id;
  int canteenId;
  int dayOfWeek;
  String? openTime;
  String? closeTime;
  int mealOfDay;

  WorkSchedule({
    required this.id,
    required this.canteenId,
    required this.dayOfWeek,
    required this.openTime,
    required this.closeTime,
    required this.mealOfDay,
  });

  factory WorkSchedule.fromJson(Map<String, dynamic> json) {
    WorkSchedule ws = WorkSchedule(
      id: json['id'],
      canteenId: json['canteen_id'],
      dayOfWeek: json['day_of_week'],
      openTime: json['open_time'],
      closeTime: json['close_time'],
      mealOfDay: json['meal_of_day'],
    );

    ws.openTime = ws.openTime == null ? null : ws.openTime!.substring(0, 5);
    ws.closeTime = ws.closeTime == null ? null : ws.closeTime!.substring(0, 5);

    return ws;
  }

  String getDayOfWeekString() {
    switch (dayOfWeek) {
      case 1:
        return "Ponedjeljak";
      case 2:
        return "Utorak";
      case 3:
        return "Srijeda";
      case 4:
        return "Četvrtak";
      case 5:
        return "Petak";
      case 6:
        return "Subota";
      case 7:
        return "Nedjelja";
      default:
        return "Nepoznato";
    }
  }

  String getDayOfWeekAbbrString() {
    switch (dayOfWeek) {
      case 1:
        return "Pon";
      case 2:
        return "Uto";
      case 3:
        return "Sri";
      case 4:
        return "Čet";
      case 5:
        return "Pet";
      case 6:
        return "Sub";
      case 7:
        return "Ned";
      default:
        return "Nepoznato";
    }
  }

  String getMealOfDayString() {
    switch (mealOfDay) {
      case -1:
        return "Cijeli dan";
      case 1:
        return "Doručak";
      case 2:
        return "Ručak";
      case 3:
        return "Večera";
      default:
        return "Nepoznato";
    }
  }

  String getTimesString() {
    if (openTime == null || closeTime == null) {
      return "Zatvoreno";
    } else {
      return openTime! + "-" + closeTime!;
    }
  }

  String toString() {
    return getDayOfWeekString() + " " + getTimesString();
  }

  int compareTo(other) {
    if (dayOfWeek == other.dayOfWeek) {
      return mealOfDay.compareTo(other.mealOfDay);
    } else {
      return dayOfWeek.compareTo(other.dayOfWeek);
    }
  }
}
