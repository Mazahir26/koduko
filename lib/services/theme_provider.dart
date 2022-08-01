import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class ThemeModel with ChangeNotifier {
  var _themeMode = ThemeMode.system;
  final _box = Hive.box<bool>('Theme');

  get getTheme => _themeMode;
  setTheme(themeMode) {
    _themeMode = themeMode;
    _box.put("darkMode", themeMode == ThemeMode.dark);
    notifyListeners();
  }

  bool isDark() => _themeMode == ThemeMode.dark;

  ThemeModel() {
    if (_box.isOpen) {
      if (_box.get("darkMode") != null) {
        _themeMode = _box.get("darkMode")! ? ThemeMode.dark : ThemeMode.light;
      } else {
        _themeMode = ThemeMode.system;
      }
    }
  }

  toggleTheme() {
    switch (_themeMode) {
      case ThemeMode.dark:
        _themeMode = ThemeMode.light;
        _box.put("darkMode", false);
        break;
      case ThemeMode.light:
        _themeMode = ThemeMode.system;
        _box.delete('darkMode');
        break;
      case ThemeMode.system:
        _themeMode = ThemeMode.dark;
        _box.put("darkMode", true);
        break;
      default:
        _themeMode = _themeMode;
    }
    notifyListeners();
  }
}
