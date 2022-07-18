import 'package:flutter/material.dart';
import 'package:koduko/models/routine.dart';
import 'package:koduko/models/task.dart';
import 'package:koduko/screens/home.dart';
import 'package:koduko/screens/routine.dart';
import 'package:koduko/screens/routines.dart';

class App extends StatefulWidget {
  const App({Key? key}) : super(key: key);

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    // final textTheme = Theme.of(context)
    //     .textTheme
    //     .apply(displayColor: Theme.of(context).colorScheme.onSurface);
    final List<Widget> widgetOptions = <Widget>[
      const HomeScreen(),
      const RoutinesScreen(),
      RoutineScreen(
          routine: Routine.create(
              name: "Test",
              tasks: [
                Task.fromDuration(
                    duration: const Duration(seconds: 10),
                    name: "Task1",
                    color: Colors.blue),
                Task.fromDuration(
                    duration: const Duration(seconds: 15),
                    name: "Task2",
                    color: Colors.grey),
                Task.fromDuration(
                    duration: const Duration(seconds: 40),
                    name: "Task3",
                    color: Colors.greenAccent),
              ],
              completedTasks: [],
              history: [],
              days: ["Monday", "Tuesday"],
              isDaily: false))
    ];
    return Scaffold(
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: _onItemTapped,
        labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
        selectedIndex: _selectedIndex,
        destinations: const <Widget>[
          NavigationDestination(
            selectedIcon: Icon(Icons.home_rounded),
            icon: Icon(Icons.home_outlined),
            label: 'Home',
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.task_alt_rounded),
            icon: Icon(Icons.task_alt_outlined),
            label: 'Routines',
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.settings_rounded),
            icon: Icon(Icons.settings_outlined),
            label: 'Settings',
          ),
        ],
      ),
      body: SafeArea(
        child: widgetOptions.elementAt(_selectedIndex),
      ),
    );
  }
}
