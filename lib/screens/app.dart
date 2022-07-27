import 'package:flutter/material.dart';
import 'package:koduko/screens/home.dart';
import 'package:koduko/screens/routines.dart';
import 'package:koduko/screens/settings.dart';

class App extends StatefulWidget {
  const App({Key? key}) : super(key: key);
  static const routeName = "/";

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
      const SettingsScreen(),
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
