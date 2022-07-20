import 'package:hive/hive.dart';
import 'package:koduko/models/task.dart';
import 'package:koduko/models/task_event.dart';
import 'package:uuid/uuid.dart';

part 'routine.g.dart';

@HiveType(typeId: 2)
class Routine {
  @HiveField(0)
  late final String id;

  @HiveField(1)
  String name;

  @HiveField(2)
  List<Task> tasks;

  @HiveField(3)
  late List<TaskEvent> completedTasks;

  @HiveField(4)
  late List<DateTime> history;

  @HiveField(5, defaultValue: true)
  late bool isDaily;

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

  Routine.create({
    required this.name,
    required this.tasks,
    required this.days,
  }) {
    id = const Uuid().v4();
    isDaily = days.length == 7;
    history = [];
    completedTasks = [];
  }
}
