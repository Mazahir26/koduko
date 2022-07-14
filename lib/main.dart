import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:koduko/models/routine.dart';
import 'package:koduko/models/task.dart';
import 'package:koduko/screens/routine.dart';
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
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
          primarySwatch: Colors.indigo,
          primaryIconTheme:
              const IconThemeData(color: Color.fromRGBO(36, 41, 49, 1))),
      home: FutureBuilder(
        future: Hive.openBox<Task>("Tasks"),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return ChangeNotifierProvider(
              create: (context) => TaskModel(),
              child: RoutineScreen(
                routine: Routine(
                    name: "ok",
                    tasks: [
                      Task.fromDuration(
                        duration: const Duration(seconds: 5),
                        name: "Test 1",
                        color: Colors.blueAccent,
                      ),
                      Task.fromDuration(
                        duration: const Duration(seconds: 15),
                        name: "Test 2",
                        color: Colors.greenAccent,
                      ),
                      Task.fromDuration(
                        duration: const Duration(seconds: 10),
                        name: "Test 3",
                        color: Colors.redAccent,
                      ),
                      Task.fromDuration(
                        duration: const Duration(seconds: 12),
                        name: "Test 3",
                        color: Color.fromARGB(255, 191, 254, 193),
                      ),
                      Task.fromDuration(
                        duration: const Duration(seconds: 18),
                        name: "Test 3",
                        color: Colors.redAccent,
                      )
                    ].reversed.toList()),
              ),
            );
          }
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        },
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  @override
  Widget build(BuildContext context) {
    void _incrementCounter() {
      Provider.of<TaskModel>(context, listen: false).add(Task.fromDuration(
          duration: Duration(minutes: 5, seconds: _counter),
          name: "Task$_counter",
          color: Colors.deepOrangeAccent));
      setState(() {
        _counter++;
      });
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Consumer<TaskModel>(
          builder: ((context, value, child) => ListView.builder(
                itemCount: value.tasks.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListTile(
                      trailing: ElevatedButton(
                          onPressed: () =>
                              Provider.of<TaskModel>(context, listen: false)
                                  .delete(value.tasks[index].id),
                          child: const Icon(Icons.delete)),
                      title: Text(value.tasks[index].name,
                          style: TextStyle(
                              fontSize: 26,
                              color: Color(value.tasks[index].color))),
                    ),
                  );
                },
              ))),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
