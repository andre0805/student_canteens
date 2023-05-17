import 'package:student_canteens/models/QueueLength.dart';

class QueueLengthReport {
  final int id;
  final int canteenId;
  final QueueLength queueLength;
  final String? description;
  final DateTime createdAt;
  final String userId;
  final String name;
  final String surname;
  final String email;

  QueueLengthReport({
    required this.id,
    required this.canteenId,
    required this.queueLength,
    required this.description,
    required this.createdAt,
    required this.userId,
    required this.name,
    required this.surname,
    required this.email,
  });

  factory QueueLengthReport.fromJson(Map<String, dynamic> json) {
    return QueueLengthReport(
      id: json['id'] as int,
      canteenId: json['canteen_id'] as int,
      queueLength: queueLengthFromInt(json['queue_length'] as int),
      description: json['description'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String).toLocal(),
      userId: json['user_id'] as String,
      name: json['name'] as String,
      surname: json['surname'] as String,
      email: json['email'] as String,
    );
  }

  String getDisplayName() {
    return "$name ${surname.substring(0, 1)}.";
  }

  String getTimeString() {
    return createdAt.toLocal().toString();
  }

  String getRelativeTimeString() {
    return "${createdAt.hour}:${createdAt.minute}";
  }
}