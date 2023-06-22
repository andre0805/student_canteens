import 'package:flutter/material.dart';
import 'package:student_canteens/models/QueueLength.dart';
import 'package:student_canteens/models/WorkSchedule.dart';
import 'package:student_canteens/utils/TimeOfDayExtension.dart';

class Canteen {
  final int id;
  final String name;
  final String address;
  final String city;
  final String zipCode;
  final String county;
  final String? contact;
  final String? url;
  final String? imageUrl;
  final String latitude;
  final String longitude;
  final QueueLength queueLength;
  Set<WorkSchedule> workSchedules = {};

  Canteen({
    required this.id,
    required this.name,
    required this.address,
    required this.city,
    required this.zipCode,
    required this.county,
    required this.contact,
    required this.url,
    required this.imageUrl,
    required this.latitude,
    required this.longitude,
    required this.queueLength,
  });

  factory Canteen.fromJson(Map<String, dynamic> json) {
    return Canteen(
      id: json['id'],
      name: json['name'],
      address: json['address'],
      city: json['city'],
      zipCode: json['zip_code'],
      county: json['county'],
      contact: json['contact'],
      url: json['url'],
      imageUrl: json['cover_picture'],
      latitude: json['latitude'],
      longitude: json['longitude'],
      queueLength: QueueLengthExtension.fromInt(json['queue_length']),
    );
  }

  bool get isOpen {
    TimeOfDay currentTime = TimeOfDay.now();
    int dayOfWeek = DateTime.now().weekday;

    Set<WorkSchedule> todayWorkSchedules = workSchedules
        .where((workSchedule) => workSchedule.dayOfWeek == dayOfWeek)
        .toSet();

    if (todayWorkSchedules.isEmpty) return false;

    for (WorkSchedule workSchedule in todayWorkSchedules) {
      TimeOfDay? openTime = workSchedule.getOpenTimeOfDay();
      TimeOfDay? closeTime = workSchedule.getCloseTimeOfDay();

      if (openTime == null || closeTime == null) continue;

      if (currentTime.isAfter(openTime) && currentTime.isBefore(closeTime))
        return true;
    }

    return false;
  }
}
