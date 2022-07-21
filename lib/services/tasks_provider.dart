import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:koduko/models/task.dart';

class TaskModel extends ChangeNotifier {
  late final List<Task> _tasks;
  final _box = Hive.box<Task>('Tasks');

  UnmodifiableListView<Task> get tasks => UnmodifiableListView(_tasks);

  TaskModel() {
    _init();
  }

  void _init() async {
    if (_box.isOpen) {
      _tasks = _box.values.toList();
    } else {
      await Hive.openBox('Tasks');
    }
  }

  void add(Task task) {
    _tasks.add(task);
    _box.add(task);
    notifyListeners();
  }

  void edit(Task task) {
    int index =
        _tasks.indexWhere((element) => element.id.compareTo(task.id) == 0);
    if (index > -1) {
      _box.putAt(index, task);
      _tasks[index] = task;
      notifyListeners();
    }
  }

  void delete(String id) {
    if (_tasks.indexWhere((element) => element.id.compareTo(id) == 0) > -1) {
      _box.deleteAt(
          _tasks.indexWhere((element) => element.id.compareTo(id) == 0));
      _tasks.removeWhere((element) => element.id.compareTo(id) == 0);
      notifyListeners();
    }
  }
}
