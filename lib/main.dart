import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:koduko/models/routine.dart';
import 'package:koduko/models/task.dart';
import 'package:koduko/models/task_event.dart';
import 'package:koduko/screens/app.dart';
import 'package:koduko/screens/tasks.dart';
import 'package:koduko/services/routines_provider.dart';
import 'package:koduko/services/tasks_provider.dart';
import 'package:provider/provider.dart';

void main() async {
  await Hive.initFlutter();
  Hive.registerAdapter(TaskAdapter());
  Hive.registerAdapter(RoutineAdapter());
  Hive.registerAdapter(TaskEventAdapter());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Future.wait([
        Hive.openBox<Routine>("Routines"),
        Hive.openBox<Task>("Tasks"),
      ]),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return MaterialApp(
            home: Scaffold(
              body: Center(
                child: Text(
                  "Oops! Try again later",
                  style: Theme.of(context).textTheme.displayMedium,
                ),
              ),
            ),
          );
        } else if (snapshot.hasData) {
          return MultiProvider(
            providers: [
              ChangeNotifierProvider(
                create: (context) => RoutineModel(),
              ),
              ChangeNotifierProvider(
                create: (context) => TaskModel(),
              )
            ],
            child: MaterialApp(
                debugShowCheckedModeBanner: false,
                title: 'Flutter Demo',
                theme: ThemeData(
                  colorSchemeSeed: Colors.lightBlue,
                  // colorScheme: ColorScheme.fromSwatch(
                  //   primarySwatch: Colors.deepPurple,
                  // ),
                  useMaterial3: true,
                  brightness: Brightness.light,
                ),
                initialRoute: '/',
                routes: {
                  TasksScreen.routeName: (context) => const TasksScreen(),
                  App.routeName: (context) => const App()
                }),
          );
        }
        return const MaterialApp(
          home: Scaffold(
              body: Center(
            child: SizedBox(
              height: 60,
              width: 60,
              child: CircularProgressIndicator(
                strokeWidth: 6,
              ),
            ),
          )),
        );
      },
    );
  }
}
