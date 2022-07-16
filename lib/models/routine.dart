import 'package:hive/hive.dart';
import 'package:koduko/models/task.dart';
import 'package:koduko/models/task_event.dart';

part 'routine.g.dart';

@HiveType(typeId: 2)
class Routine {
  @HiveField(0)
  String id;

  @HiveField(1)
  String name;

  @HiveField(2)
  List<Task> tasks;

  @HiveField(3)
  List<TaskEvent> completedTasks;

  @HiveField(4)
  List<DateTime> history;

  @HiveField(5, defaultValue: true)
  bool isDaily;

  @HiveField(6)
  List<String> days;

  Routine({
    required this.name,
    required this.tasks,
    required this.completedTasks,
    required this.history,
    required this.id,
    required this.days,
    required this.isDaily,
  });
}
