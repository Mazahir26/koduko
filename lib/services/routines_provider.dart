import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:koduko/models/routine.dart';
import 'package:koduko/models/task.dart';

class RoutineModel extends ChangeNotifier {
  late final List<Routine> _routines;
  final _box = Hive.box<Routine>('Routines');

  RoutineModel() {
    _init();
  }
  void _init() async {
    if (_box.isOpen) {
      _routines = _box.values.toList();
    } else {
      await Hive.openBox("Routines");
    }
  }

  UnmodifiableListView<Routine> get routines => UnmodifiableListView(_routines);

  void add(Routine routine) {
    _routines.add(routine);
    _box.add(routine);
    notifyListeners();
  }

  void edit(Routine routine) {
    int index = _routines
        .indexWhere((element) => element.id.compareTo(routine.id) == 0);
    if (index > -1) {
      _box.putAt(index, routine);
      _routines[index] = routine;
      notifyListeners();
    }
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
      _routines.map((e) => {
            noOfTasks += e.getCompletedTasks(
              startOfWeek.add(
                Duration(days: i),
              ),
            )
          });
      data.add(noOfTasks);
    }
    return data;
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
      _box.deleteAt(index);
      _routines.removeWhere((element) => element.id.compareTo(id) == 0);
      notifyListeners();
    }
  }
}
