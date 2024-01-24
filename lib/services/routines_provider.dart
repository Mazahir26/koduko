import 'dart:collection';
import 'dart:math';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:koduko/models/routine.dart';
import 'package:koduko/models/task.dart';
import 'package:koduko/models/task_event.dart';
import 'package:koduko/services/notification_service.dart';
import 'package:koduko/utils/time_of_day_util.dart';
import 'package:koduko/utils/date_time_extension.dart';

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
        scheduleWeekly(routine);
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
          scheduleWeekly(routine);
        }
      }
      notifyListeners();
    }
  }

  List<TaskEvent> getHistory({int clamp = 0}) {
    List<TaskEvent> list = [];
    for (var element in _routines) {
      list.addAll(element.history);
      list.sort(((a, b) => a.time.compareTo(b.time)));
    }
    if (list.isEmpty) {
      return [];
    }
    return list.slice(0, min(list.length - 1, 25));
  }

  int getMostProductiveHour() {
    List<TaskEvent> list = getHistory();
    List<int> hours = List.filled(24, 0);
    for (var e in list) {
      hours[e.time.hour] += 1;
    }
    int max = 0;
    for (var i = 0; i < 24; i++) {
      if (hours[i] > hours[max]) {
        max = i;
      }
    }
    return max;
  }

  int getTimeSpentToday() {
    List<Routine> list = _routines;
    Duration d = Duration.zero;
    for (var e in list) {
      d += e.getTimeSpentToday();
    }
    return d.inMinutes;
  }

  DateTime? getMostProductiveDay() {
    List<TaskEvent> list = getHistory();
    final Map<DateTime, int> hours = HashMap();
    for (var e in list) {
      if (hours.containsKey(e.time)) {
        hours.update(e.time, (value) => value + 1);
      } else {
        hours.addAll({e.time: 0});
      }
    }
    if (hours.isNotEmpty) {
      DateTime max = hours.keys.first;
      hours.forEach((key, value) {
        if (value > (hours[max] ?? 0)) {
          max = key;
        }
      });
      return max;
    }
    return null;
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

  int getRoutineStartMaxDays(String id) {
    final r = getRoutine(id);
    if (r != null) {
      if (r.history.isNotEmpty) {
        return (DateTime.now().difference(r.history.last.time).inHours / 24)
            .ceil();
      }
    }
    return 0;
  }

  List<int> getRoutineStats(String id) {
    final r = getRoutine(id);
    List<int> data = [];
    if (r != null) {
      if (r.history.isNotEmpty) {
        final max = getRoutineStartMaxDays(id);
        var start =
            r.history.last.time.add(Duration(days: max > 7 ? max - 7 : 0));
        for (var i = max > 7 ? (max - 7) : 0; i <= max; i++) {
          var noOfTasks = 0;
          for (var element in r.history) {
            if (element.time.isSameDate(start)) {
              noOfTasks++;
            }
          }
          start = start.add(const Duration(days: 1));
          data.add(noOfTasks);
        }
      }
    }
    return data;
  }

  DateTime getStartDate(String id) {
    final r = getRoutine(id);
    if (r != null) {
      if (r.history.isNotEmpty) {
        final max = getRoutineStartMaxDays(id);
        return r.history.last.time.add(Duration(days: max > 7 ? max - 7 : 0));
      }
    }
    return DateTime.now();
  }

  void removeHistory(String tid) {
    for (var i = 0; i < _routines.length; i++) {
      final r = _routines[i].removeHistory(tid);
      if (r != null) {
        _box.putAt(i, r);
        _routines[i] = r;
      }
    }
    notifyListeners();
  }

  void clearHistory() {
    if (_routines.isNotEmpty) {
      for (var i = 0; i < _routines.length; i++) {
        final r = _routines[i].clearHistory();
        _box.putAt(i, r);
        _routines[i] = r;
      }
      notifyListeners();
    }
  }

  List<int> getRoutineDayFrequencyStats(String id) {
    final r = getRoutine(id);
    List<int> data = [];
    if (r != null) {
      for (var i = 0; i < 24; i++) {
        var noOfTasks = 0;
        for (var element in r.history) {
          if (element.time.hour == i) {
            noOfTasks++;
          }
        }
        data.add(noOfTasks);
      }
    }
    return data;
  }

  int totalNoOfTasksToday() {
    int noOfTasks = 0;
    for (var element in _routines) {
      if (!element.isArchive) {
        if (element.isToday()) {
          if (element.isToday()) {
            noOfTasks += element.tasks.length;
          }
        }
      }
    }
    return noOfTasks;
  }

  int totalNoOfCompletedTasksToday() {
    int noOfTasks = 0;
    for (var element in _routines) {
      if (!element.isArchive) {
        if (element.isToday()) {
          noOfTasks += (element.isCompleted
              ? element.tasks.length
              : element.tasks.length - element.inCompletedTasks.length);
        }
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

  void toggleMarkAsCompleted(String id) {
    int index =
        _routines.indexWhere((element) => element.id.compareTo(id) == 0);
    if (index > -1) {
      var r = _routines[index];
      if (_routines[index].isCompleted) {
        r = _routines[index].markAsInCompleted();
      } else {
        r = _routines[index].markAsCompleted();
      }
      _box.putAt(index, r);
      _routines[index] = r;
      notifyListeners();
    }
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

  List<Routine> todaysRoutines() {
    return routines
        .where((element) => element.isArchive == false)
        .where(
          (element) => element.days.contains(
            DateFormat('EEEE').format(DateTime.now()),
          ),
        )
        .toList();
  }

  List<Routine> allRoutines() {
    return routines
        .where((element) => element.isArchive == false)
        .where(
          (element) => !element.days.contains(
            DateFormat('EEEE').format(DateTime.now()),
          ),
        )
        .toList();
  }

  List<Routine> archiveRoutines() {
    return routines.where((element) => element.isArchive == true).toList();
  }

  void addToArchive(String id) {
    int index =
        _routines.indexWhere((element) => element.id.compareTo(id) == 0);
    if (index > -1) {
      var r = _routines[index].addToArchive();
      NotificationService().cancelNotification(r.id);
      _box.putAt(index, r);
      _routines[index] = r;
      notifyListeners();
    }
  }

  void removeFromArchive(String id) {
    int index =
        _routines.indexWhere((element) => element.id.compareTo(id) == 0);
    if (index > -1) {
      var r = _routines[index].removeFromArchive();
      _box.putAt(index, r);
      _routines[index] = r;
      if (r.days.length == 7) {
        if (r.time != null) {
          NotificationService().scheduleDaily(
            time: dateTimeToTimeOfDay(r.time!),
            title: r.name,
            des: "Tap to Start",
            uId: r.id,
          );
        }
      } else {
        if (r.time != null) {
          scheduleWeekly(r);
        }
      }
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
      if (!element.isArchive) {
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
            scheduleWeekly(element);
          }
        }
      }
    }
  }

  void scheduleWeekly(Routine r) {
    for (var day in r.days) {
      NotificationService().scheduleWeekly(
        day: day,
        time: dateTimeToTimeOfDay(r.time!),
        title: r.name,
        des: "Tap to Start",
        uId: r.id,
      );
    }
  }

  void cancelAllNotifications() {
    NotificationService().cancelAllNotifications();
  }
}
