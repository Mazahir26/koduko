import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:koduko/models/task.dart';

class TaskModel extends ChangeNotifier {
  late final List<Task> _tasks;
  final box = Hive.box<Task>('Tasks');

  UnmodifiableListView<Task> get tasks => UnmodifiableListView(_tasks);
  TaskModel() {
    _tasks = box.values.toList();
  }

  // Checks if the name of the task is unique
  // Don't want to implement

  // bool _isNameUnique(String name) {
  //   bool unique = true;
  //   _tasks.asMap().forEach((key, value) {
  //     if (value.name.compareTo(name) == 0) {
  //       unique = false;
  //       return;
  //     }
  //   });

  //   return unique;
  // }

  void add(Task task) {
    _tasks.add(task);
    box.add(task);
    notifyListeners();
  }

  void delete(String id) {
    if (_tasks.indexWhere((element) => element.id.compareTo(id) == 0) > -1) {
      box.deleteAt(
          _tasks.indexWhere((element) => element.id.compareTo(id) == 0));
      _tasks.removeWhere((element) => element.id.compareTo(id) == 0);
      notifyListeners();
    }
  }
}