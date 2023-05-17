import 'package:flutter/material.dart';

enum QueueLength {
  NONE,
  SHORT,
  MEDIUM,
  LONG,
  VERY_LONG,
  UNKNOWN,
}

QueueLength queueLengthFromInt(int? length) {
  if (length == null) return QueueLength.UNKNOWN;

  switch (length) {
    case 1:
      return QueueLength.NONE;
    case 2:
      return QueueLength.SHORT;
    case 3:
      return QueueLength.MEDIUM;
    case 4:
      return QueueLength.LONG;
    case 5:
      return QueueLength.VERY_LONG;
    default:
      return QueueLength.UNKNOWN;
  }
}

String getQueueLengthString(QueueLength length) {
  switch (length) {
    case QueueLength.NONE:
      return 'Nema reda';
    case QueueLength.SHORT:
      return 'Kratak red';
    case QueueLength.MEDIUM:
      return 'Srednji red';
    case QueueLength.LONG:
      return 'Dugačak red';
    case QueueLength.VERY_LONG:
      return 'Vrlo dugačak red';
    default:
      return 'Nepoznato';
  }
}

Color getColorFromQueueLength(QueueLength length) {
  switch (length) {
    case QueueLength.NONE:
      return Colors.green;
    case QueueLength.SHORT:
      return Colors.green.shade400;
    case QueueLength.MEDIUM:
      return Colors.yellow.shade400;
    case QueueLength.LONG:
      return Colors.orange;
    case QueueLength.VERY_LONG:
      return Colors.red;
    default:
      return Colors.grey;
  }
}
