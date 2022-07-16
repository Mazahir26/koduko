import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:koduko/models/routine.dart';
import 'package:koduko/models/task.dart';
import 'package:koduko/screens/app.dart';
import 'package:koduko/services/routines_provider.dart';
import 'package:koduko/services/tasks_provider.dart';
import 'package:provider/provider.dart';

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
            colorSchemeSeed: Colors.blue[200],
            // colorScheme: ColorScheme.fromSwatch(
            //   primarySwatch: Colors.deepPurple,
            // ),
            useMaterial3: true,
            brightness: Brightness.light,
          ),
          // routes: {
          //   '/': (context) => const App(),
          // },
          // initialRoute: '/',
          home: FutureBuilder(
              future: Future.wait([
                Hive.openBox<Routine>("Routines"),
                Hive.openBox<Task>("Tasks"),
              ]),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Scaffold(
                    body: Center(
                      child: Text(
                        "Oops! Try again later",
                        style: Theme.of(context).textTheme.displayMedium,
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
                    child: const App(),
                  );
                }
                return const Scaffold(
                    body: Center(
                  child: SizedBox(
                    height: 60,
                    width: 60,
                    child: CircularProgressIndicator(
                      strokeWidth: 6,
                    ),
                  ),
                ));
              }));
    });
  }
}
