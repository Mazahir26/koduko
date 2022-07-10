import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:koduko/models/task.dart';

part 'routine.g.dart';

@HiveType(typeId: 1)
class Routine {
  @HiveField(0)
  String name;

  @HiveField(1)
  List<Task> tasks;

  Routine({required this.name, required this.tasks});
}
