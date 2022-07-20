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
