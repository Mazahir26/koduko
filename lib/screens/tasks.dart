import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:koduko/components/create_task_bottom_sheet.dart';
import 'package:koduko/models/task.dart';
import 'package:koduko/services/tasks_provider.dart';
import 'package:provider/provider.dart';

class TasksScreen extends StatelessWidget {
  const TasksScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () async {
          await showModalBottomSheet<Task>(
              isScrollControlled: true,
              isDismissible: true,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(10),
                  bottom: Radius.zero,
                ),
              ),
              context: context,
              builder: ((context) => const CreateTaskSheet()));
        },
      ),
      body: Consumer<TaskModel>(
        builder: ((context, value, child) => ListView.builder(
              itemCount: value.tasks.length,
              itemBuilder: (context, index) => ListTile(
                title: Text(
                  value.tasks[index].name,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
            )),
      ),
    );
  }
}

class CreateTaskSheet extends StatelessWidget {
  const CreateTaskSheet({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const CreateTaskBottomSheet();
  }
}
