import 'package:flutter/material.dart';

enum QueueLength {
  UNKNOWN,
  NONE,
  SHORT,
  MEDIUM,
  LONG,
  VERY_LONG,
}

extension QueueLengthIterable on QueueLength {
  static Iterable<QueueLength> get values => [
        QueueLength.UNKNOWN,
        QueueLength.NONE,
        QueueLength.SHORT,
        QueueLength.MEDIUM,
        QueueLength.LONG,
        QueueLength.VERY_LONG,
      ];
}

extension QueueLengthExtension on QueueLength {
  static QueueLength fromInt(int? queueLength) {
    if (queueLength == null) return QueueLength.UNKNOWN;

    switch (queueLength) {
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

  static int compare(QueueLength queueLength1, QueueLength queueLength2) {
    if (queueLength1 == queueLength2) return 0;
    if (queueLength1 == QueueLength.UNKNOWN) return 1;
    if (queueLength2 == QueueLength.UNKNOWN) return -1;
    return queueLength1.index.compareTo(queueLength2.index);
  }

  static String getString(QueueLength queueLength) {
    switch (queueLength) {
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

  static String getLegendDescription(QueueLength queueLength) {
    switch (queueLength) {
      case QueueLength.UNKNOWN:
        return "nepoznato stanje reda";
      case QueueLength.NONE:
        return "nema reda";
      case QueueLength.SHORT:
        return "kratak red (1-5 min)";
      case QueueLength.MEDIUM:
        return "srednji red (5-15 min)";
      case QueueLength.LONG:
        return "dugačak red (15-30 min)";
      case QueueLength.VERY_LONG:
        return "vrlo dugačak red (30+ min)";
    }
  }

  static Color getColor(QueueLength queueLength) {
    switch (queueLength) {
      case QueueLength.NONE:
        return Colors.green;
      case QueueLength.SHORT:
        return Colors.lightGreen;
      case QueueLength.MEDIUM:
        return Colors.yellow.shade400;
      case QueueLength.LONG:
        return Colors.orange.shade400;
      case QueueLength.VERY_LONG:
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  static String getReportActionMessage(QueueLength queueLength) {
    switch (queueLength) {
      case QueueLength.NONE:
        return "Prijavi da nema reda";
      case QueueLength.SHORT:
        return "Prijavi kratak red";
      case QueueLength.MEDIUM:
        return "Prijavi srednji red";
      case QueueLength.LONG:
        return "Prijavi dugačak red";
      case QueueLength.VERY_LONG:
        return "Prijavi vrlo dugačak red";
      case QueueLength.UNKNOWN:
        return "Greška!";
    }
  }

  static String getReportResponseMessage(QueueLength queueLength) {
    switch (queueLength) {
      case QueueLength.NONE:
        return "Prijavljeno da nema reda!";
      case QueueLength.SHORT:
        return "Prijavljen kratak red!";
      case QueueLength.MEDIUM:
        return "Prijavljen srednji red!";
      case QueueLength.LONG:
        return "Prijavljen dugačak red!";
      case QueueLength.VERY_LONG:
        return "Prijavljen vrlo dugačak red!";
      case QueueLength.UNKNOWN:
        return "Greška!";
    }
  }
}
