import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

part 'task.g.dart';

@HiveType(typeId: 1)
class Task {
  @HiveField(0)
  String name;

  @HiveField(1)
  Duration duration;

  @HiveField(2)
  Color color;

  Task({required this.duration, required this.name, required this.color});
}
