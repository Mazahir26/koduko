import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:koduko/models/task.dart';
import 'package:koduko/models/task_event.dart';
import 'package:koduko/utils/date_time_extension.dart';
import 'package:koduko/utils/time_of_day_util.dart';
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

  @HiveField(7, defaultValue: null)
  DateTime? time;

  Routine({
    required this.name,
    required this.tasks,
    required this.inCompletedTasks,
    required this.history,
    required this.id,
    required this.days,
    required this.isCompleted,
    required this.time,
    bool isSkip = false,
  }) {
    if (isSkip) {
      return;
    }
    if (inCompletedTasks.isNotEmpty || isCompleted) {
      if (history.isNotEmpty) {
        bool isNewDay = true;
        for (var element in history) {
          if (element.time.isSameDate(DateTime.now())) {
            isNewDay = false;
            break;
          }
        }
        if (isNewDay) {
          isCompleted = false;
          inCompletedTasks = [];
        }
      }
    }
    if (inCompletedTasks.isEmpty && !isCompleted) {
      inCompletedTasks = tasks;
    }
  }

  Routine.create({
    required this.name,
    required this.tasks,
    required this.days,
    required this.time,
    // List<Task>? inCompletedTasks,
  }) {
    id = const Uuid().v4();
    isCompleted = false;
    history = [];
    tasks = tasks;
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
    TimeOfDay? time,
    bool isSkip = false,
  }) {
    return Routine(
        name: name ?? this.name,
        tasks: tasks ?? this.tasks,
        inCompletedTasks: inCompletedTasks ?? this.inCompletedTasks,
        history: history ?? this.history,
        id: id ?? this.id,
        days: days ?? this.days,
        isCompleted: isCompleted ?? this.isCompleted,
        time: timeOfDayToDateTime(time) ?? this.time,
        isSkip: isSkip);
  }

  Routine skipTask() {
    List<Task> r = List.from(inCompletedTasks);
    Task t = r.removeAt(0);
    r.add(t);

    final g = copyWith(inCompletedTasks: r, isSkip: true);
    return g;
  }

  Routine completeTask() {
    List<Task> r = List.from(inCompletedTasks);
    var t = r.removeAt(0);
    List<TaskEvent> h = List.from(history);
    h.add(
        TaskEvent.create(taskName: t.name, taskId: t.id, time: DateTime.now()));
    h.sort((a, b) => b.time.compareTo(a.time));
    return copyWith(
        inCompletedTasks: r, isCompleted: r.isEmpty ? true : false, history: h);
  }

  Routine replay() {
    return copyWith(isCompleted: false);
  }

  int getCompletedTasks(DateTime d) {
    var count = 0;
    if (history.isEmpty) {
      return count;
    } else {
      for (var element in history) {
        if (element.time.isSameDate(d)) {
          count++;
        }
      }
    }
    return count;
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

  static List<Task> taskDiff(List<Task> first, List<Task> second) {
    var a = [...first];
    var b = [...second];
    if (a.length > b.length) {
      for (int i = 0; i < b.length; i++) {
        int index = a.indexWhere((t) => t.id == b[i].id);
        if (index > -1) {
          a.removeAt(index);
        }
      }
      return a;
    } else {
      for (int i = 0; i < a.length; i++) {
        int index = b.indexWhere((t) => t.id == a[i].id);
        if (index > -1) {
          b.removeAt(index);
        }
      }
      return b;
    }
  }

  bool isToday() {
    return days.contains(DateFormat("EEEE").format(DateTime.now()));
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
