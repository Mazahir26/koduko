import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:koduko/models/routine.dart';

class RoutineProvider extends ChangeNotifier {
  late final List<Routine> _routines;
  final box = Hive.box<Routine>('Routines');

  RoutineProvider() {
    if (!(box.isOpen)) {
      return;
    }
    _routines = box.values.toList();
  }

  UnmodifiableListView<Routine> get routines => UnmodifiableListView(_routines);
}
