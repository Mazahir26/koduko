import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:koduko/models/routine.dart';
import 'package:koduko/models/task.dart';
import 'package:koduko/models/task_event.dart';
import 'package:koduko/services/notification_service.dart';
import 'package:koduko/utils/time_of_day_util.dart';

class RoutineModel extends ChangeNotifier {
  late final List<Routine> _routines;
  final _box = Hive.box<Routine>('Routines');
  bool notifications = true;

  RoutineModel() {
    _init();
  }
  void _init() async {
    if (_box.isOpen) {
      _routines = _box.values.toList();
    } else {
      await Hive.openBox("Routines");
    }
    final box = Hive.box<bool>('Theme');
    if (box.isOpen) {
      notifications = box.get("notifications") ?? true;
    } else {
      await Hive.openBox("Theme");
    }
  }

  UnmodifiableListView<Routine> get routines => UnmodifiableListView(_routines);

  void add(Routine routine) {
    _routines.add(routine);
    _box.add(routine);
    if (routine.days.length == 7) {
      if (routine.time != null) {
        NotificationService().scheduleDaily(
          time: dateTimeToTimeOfDay(routine.time!),
          title: routine.name,
          des: "Tap to Start",
          uId: routine.id,
        );
      }
    } else {
      if (routine.time != null) {
        NotificationService().scheduleWeekly(
          days: routine.days,
          time: dateTimeToTimeOfDay(routine.time!),
          title: routine.name,
          des: "Tap to Start",
          uId: routine.id,
        );
      }
    }
    notifyListeners();
  }

  void edit(Routine routine) async {
    int index = _routines
        .indexWhere((element) => element.id.compareTo(routine.id) == 0);
    if (index > -1) {
      _box.putAt(index, routine);
      _routines[index] = routine;
      await NotificationService().cancelAllNotifications();
      notifyListeners();
      enableAllNotifications();
    }
  }

  List<TaskEvent> getHistory() {
    List<TaskEvent> list = [];
    for (var element in _routines) {
      list.addAll(element.history);
      list.sort(((a, b) => a.time.compareTo(b.time)));
    }
    return list;
  }

  void skipTask(String id) {
    int index =
        _routines.indexWhere((element) => element.id.compareTo(id) == 0);
    if (index > -1) {
      var r = _routines[index].skipTask();
      _box.putAt(index, r);
      _routines[index] = r;
      notifyListeners();
    }
  }

  Routine? getRoutine(String id) {
    int index =
        _routines.indexWhere((element) => element.id.compareTo(id) == 0);
    if (index > -1) {
      return _routines[index];
    }
    return null;
  }

  List<int> getWeeklyStats() {
    var startOfWeek = DateTime(DateTime.now().year, DateTime.now().month,
        DateTime.now().day - (DateTime.now().weekday - 1));
    List<int> data = [];
    for (var i = 0; i < 7; i++) {
      var noOfTasks = 0;
      var day = startOfWeek.add(Duration(days: i));
      for (var element in _routines) {
        noOfTasks += element.getCompletedTasks(day);
      }

      data.add(noOfTasks);
    }
    return data;
  }

  int totalNoOfTasksToday() {
    int noOfTasks = 0;
    for (var element in _routines) {
      if (element.isToday()) {
        noOfTasks += element.tasks.length;
      }
    }
    return noOfTasks;
  }

  int totalNoOfCompletedTasksToday() {
    int noOfTasks = 0;
    for (var element in _routines) {
      if (element.isToday()) {
        noOfTasks += (element.isCompleted
            ? element.tasks.length
            : element.tasks.length - element.inCompletedTasks.length);
      }
    }
    return noOfTasks;
  }

  void completeTask(String id) {
    int index =
        _routines.indexWhere((element) => element.id.compareTo(id) == 0);
    if (index > -1) {
      var r = _routines[index].completeTask();
      _box.putAt(index, r);
      _routines[index] = r;
      notifyListeners();
    }
  }

  void replay(String id) {
    int index =
        _routines.indexWhere((element) => element.id.compareTo(id) == 0);
    if (index > -1) {
      var r = _routines[index].replay();
      _box.putAt(index, r);
      _routines[index] = r;
      notifyListeners();
    }
  }

  void editTask(Task t) {
    List<Routine> temp = List.from(_routines);
    temp.asMap().map((key, value) {
      Routine? r = value.editTasks(t);
      if (r != null) {
        _box.putAt(key, r);
        _routines[key] = r;
      }
      return MapEntry(key, value);
    });
    notifyListeners();
  }

  void removeTask(Task t) {
    List<Routine> temp = List.from(_routines);
    temp.asMap().map((key, value) {
      Routine? r = value.taskExists(t);
      if (r != null) {
        if (r.tasks.isEmpty) {
          int index = _routines
              .indexWhere((element) => element.id.compareTo(r.id) == 0);
          if (index > -1) {
            _box.deleteAt(index);
            _routines.removeWhere((element) => element.id.compareTo(r.id) == 0);
          }
          delete(r.id);
        } else {
          _box.putAt(key, r);
          _routines[key] = r;
        }
      }
      return MapEntry(key, value);
    });
    notifyListeners();
  }

  void delete(String id) {
    int index =
        _routines.indexWhere((element) => element.id.compareTo(id) == 0);
    if (index > -1) {
      NotificationService().cancelNotification(id);
      _box.deleteAt(index);
      _routines.removeWhere((element) => element.id.compareTo(id) == 0);
      notifyListeners();
    }
  }

  void toggleNotifications() {
    final box = Hive.box<bool>('Theme');
    if (notifications) {
      box.put("notifications", false);
      cancelAllNotifications();
      notifications = false;
      notifyListeners();
    } else {
      box.put("notifications", true);
      enableAllNotifications();
      notifications = true;
      notifyListeners();
    }
  }

  void enableAllNotifications() {
    for (var element in _routines) {
      if (element.days.length == 7) {
        if (element.time != null) {
          NotificationService().scheduleDaily(
            time: dateTimeToTimeOfDay(element.time!),
            title: element.name,
            des: "Tap to Start",
            uId: element.id,
          );
        }
      } else {
        if (element.time != null) {
          NotificationService().scheduleWeekly(
            days: element.days,
            time: dateTimeToTimeOfDay(element.time!),
            title: element.name,
            des: "Tap to Start",
            uId: element.id,
          );
        }
      }
    }
  }

  void cancelAllNotifications() {
    NotificationService().cancelAllNotifications();
  }
}
