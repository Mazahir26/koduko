import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:koduko/models/routine.dart';
import 'package:koduko/models/task.dart';
import 'package:koduko/screens/app.dart';

void main() async {
  await Hive.initFlutter();
  Hive.registerAdapter(TaskAdapter());
  Hive.registerAdapter(RoutineAdapter());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(builder: (context, snapshot) {
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          colorSchemeSeed: Colors.deepPurple,
          useMaterial3: true,
          brightness: Brightness.light,
        ),
        routes: {
          '/': (context) => const App(),
        },
        initialRoute: '/',
      );
    });
  }
}
