import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:koduko/models/task.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: Hive.openBox<Task>("Tasks"),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(
              child: Text(
                "Oops! Try again later",
                style: TextStyle(fontSize: 40),
              ),
            );
          } else if (snapshot.hasData) {
            return const Center(
              child: Text(
                "Hello World",
                style: TextStyle(fontSize: 40),
              ),
            );
          }
          return const Center(child: CircularProgressIndicator());
        });
  }
}
