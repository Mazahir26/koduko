import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';
part 'task.g.dart';

@HiveType(typeId: 1)
class Task {
  @HiveField(0)
  late String id;

  @HiveField(1)
  String name;

  @HiveField(2)
  late String duration;

  @HiveField(3)
  late int color;

  Task(
      {required this.duration,
      required this.name,
      required this.color,
      required this.id});

  Task copyWith({
    String? duration,
    String? name,
    int? color,
    String? id,
  }) {
    return Task(
        duration: duration ?? this.duration,
        name: name ?? this.name,
        color: color ?? this.color,
        id: id ?? this.id);
  }

  Task.fromDuration(
      {required Duration duration, required this.name, required Color color}) {
    this.duration = duration.toString();
    this.color = color.value;
    id = const Uuid().v4();
  }
  @override
  String toString() {
    super.toString();
    return '{id: $id ,name: $name, color: $color, duration: $duration}';
  }
}
