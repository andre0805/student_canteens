import 'package:student_canteens/models/QueueLength.dart';
import 'package:timeago/timeago.dart' as timeago;

class QueueLengthReport {
  final int id;
  final int canteenId;
  final QueueLength queueLength;
  final String? description;
  final DateTime createdAt;
  final int userId;
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
      queueLength: QueueLengthExtension.fromInt(json['queue_length'] as int),
      description: json['description'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String).toLocal(),
      userId: json['user_id'] as int,
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
    return timeago.format(createdAt.toLocal(), locale: 'hr');
  }
}
