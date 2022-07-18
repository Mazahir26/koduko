import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:koduko/models/routine.dart';

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

  void add(Routine task) {
    _routines.add(task);
    _box.add(task);
    notifyListeners();
  }

  void delete(String id) {
    if (_routines.indexWhere((element) => element.id.compareTo(id) == 0) > -1) {
      _box.deleteAt(
          _routines.indexWhere((element) => element.id.compareTo(id) == 0));
      _routines.removeWhere((element) => element.id.compareTo(id) == 0);
      notifyListeners();
    }
  }
}
