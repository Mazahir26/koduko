import 'package:flutter/material.dart';
import 'package:koduko/services/routines_provider.dart';
import 'package:provider/provider.dart';

class RoutinesScreen extends StatelessWidget {
  const RoutinesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {},
      ),
      body: Consumer<RoutineModel>(
        builder: ((context, value, child) => ListView.builder(
              itemCount: value.routines.length,
              itemBuilder: (context, index) => ListTile(
                title: Text(
                  value.routines[index].name,
                  style: Theme.of(context).textTheme.titleSmall,
                ),
              ),
            )),
      ),
    );
  }
}
