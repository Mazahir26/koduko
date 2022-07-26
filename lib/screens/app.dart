import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:koduko/screens/home.dart';
import 'package:koduko/screens/routines.dart';
import 'package:koduko/screens/settings.dart';
import 'package:koduko/screens/start_routine.dart';
import 'package:koduko/services/notification_service.dart';

class App extends StatefulWidget {
  const App({Key? key}) : super(key: key);
  static const routeName = "/";

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  int _selectedIndex = 0;
  late final NotificationService service;
  late final StreamSubscription<String?> stream;
  NotificationAppLaunchDetails? notificationAppLaunchDetails;
  late final PageController _pageController;

  getDeviceLaunch() async {
    notificationAppLaunchDetails = await service.getDeviceLaunchInfo();
    if (notificationAppLaunchDetails?.didNotificationLaunchApp ?? false) {
      if ((notificationAppLaunchDetails!.payload?.isNotEmpty ?? false)) {
        onNotificationListener(notificationAppLaunchDetails!.payload);
      }
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _pageController.animateToPage(
        index,
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeInOutCirc,
      );
      _selectedIndex = index;
    });
  }

  @override
  void initState() {
    service = NotificationService();
    getDeviceLaunch();
    _pageController = PageController();
    stream = service.onNotificationClick.stream.listen(onNotificationListener);
    super.initState();
  }

  @override
  void dispose() {
    stream.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> widgetOptions = <Widget>[
      HomeScreen(
        onTapChange: () => _onItemTapped(1),
      ),
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
        child: PageView(
          controller: _pageController,
          onPageChanged: (value) => setState(() {
            _selectedIndex = value;
          }),
          children: widgetOptions,
        ),
      ),
    );
  }

  void onNotificationListener(String? payload) {
    if (payload != null && payload.isNotEmpty) {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: ((context) => RoutineScreen(
                    routine: payload,
                  ))));
    }
  }
}
