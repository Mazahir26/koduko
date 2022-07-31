import 'package:flutter/material.dart';

DateTime? timeOfDayToDateTime(TimeOfDay? t) {
  if (t == null) {
    return null;
  }
  final now = DateTime.now();
  return DateTime(now.year, now.month, now.day, t.hour, t.minute);
}

TimeOfDay dateTimeToTimeOfDay(DateTime t) {
  return TimeOfDay.fromDateTime(t);
}
