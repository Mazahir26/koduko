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
  late List<Task> inCompletedTasks;

  @HiveField(4)
  late List<TaskEvent> history;

  @HiveField(5, defaultValue: true)
  late bool isCompleted;

  @HiveField(6)
  List<String> days;

  Routine({
    required this.name,
    required this.tasks,
    required this.inCompletedTasks,
    required this.history,
    required this.id,
    required this.days,
    required this.isCompleted,
  }) {
    if (inCompletedTasks.isEmpty && !isCompleted) {
      inCompletedTasks = tasks;
    }
  }

  Routine.create({
    required this.name,
    required this.tasks,
    required this.days,
  }) {
    id = const Uuid().v4();
    isCompleted = false;
    history = [];
    inCompletedTasks = tasks;
  }
  Routine copyWith({
    List<Task>? tasks,
    List<Task>? inCompletedTasks,
    List<TaskEvent>? history,
    String? id,
    String? name,
    List<String>? days,
    bool? isCompleted,
  }) {
    return Routine(
        name: name ?? this.name,
        tasks: tasks ?? this.tasks,
        inCompletedTasks: inCompletedTasks ?? this.inCompletedTasks,
        history: history ?? this.history,
        id: id ?? this.id,
        days: days ?? this.days,
        isCompleted: isCompleted ?? this.isCompleted);
  }

  Routine skipTask() {
    List<Task> r = List.from(inCompletedTasks);
    Task t = r.removeAt(0);
    r.add(t);
    return copyWith(inCompletedTasks: r);
  }

  Routine completeTask() {
    List<Task> r = List.from(inCompletedTasks);
    r.removeAt(0);
    return copyWith(inCompletedTasks: r, isCompleted: r.isEmpty ? true : false);
  }

  Routine replay() {
    return copyWith(isCompleted: false);
  }

  Routine? taskExists(Task t) {
    int index = tasks.indexWhere((element) => element.id.compareTo(t.id) == 0);
    if (index > -1) {
      List<Task> ts = List.from(tasks);
      ts.removeAt(index);
      return copyWith(tasks: ts);
    }
    return null;
  }

  String getDays() {
    return days.length == 7
        ? "Daily"
        : days.map((e) => e.substring(0, 3)).join(", ");
  }

  double getPercentage() {
    return (tasks.length - inCompletedTasks.length) == 0
        ? 0
        : ((tasks.length - inCompletedTasks.length) / tasks.length);
  }

  String getPercentageString() {
    return '${(getPercentage() * 100).toInt()}%';
  }
}
