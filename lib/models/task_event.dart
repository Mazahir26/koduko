import 'package:hive_flutter/adapters.dart';
import 'package:uuid/uuid.dart';

part 'task_event.g.dart';

@HiveType(typeId: 3)
class TaskEvent {
  @HiveField(0)
  late final String id;

  @HiveField(1)
  final String taskName;

  @HiveField(2)
  final DateTime time;

  @HiveField(3)
  final String taskId;

  TaskEvent({
    required this.id,
    required this.taskName,
    required this.time,
    required this.taskId,
  });

  @override
  String toString() {
    return '[Id : $id, Name: $taskName, Time: $time, TaskId: $taskId]';
  }

  TaskEvent.create({
    required this.taskName,
    required this.taskId,
    required this.time,
  }) {
    id = const Uuid().v4();
  }
}
