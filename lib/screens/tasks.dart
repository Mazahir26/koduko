import 'package:flutter/material.dart';
import 'package:koduko/components/create_task_bottom_sheet.dart';
import 'package:koduko/components/task_tile.dart';
import 'package:koduko/models/task.dart';
import 'package:koduko/services/tasks_provider.dart';
import 'package:provider/provider.dart';

class TasksScreen extends StatelessWidget {
  const TasksScreen({Key? key}) : super(key: key);
  static const routeName = "/tasks";
  @override
  Widget build(BuildContext context) {
    void _addTask(Task t) {
      Provider.of<TaskModel>(context, listen: false).add(t);
    }

    void _onEdit(Task t) {
      Provider.of<TaskModel>(context, listen: false).edit(t);
    }

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () async {
          Task? t = await showModalBottomSheet<Task>(
              isScrollControlled: true,
              isDismissible: true,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(10),
                  bottom: Radius.zero,
                ),
              ),
              context: context,
              builder: ((context) => const CreateTaskBottomSheet()));
          if (t != null) {
            _addTask(t);
          }
        },
      ),
      body: Consumer<TaskModel>(
        builder: ((context, value, child) => ListView.builder(
            itemCount: value.tasks.length,
            itemBuilder: (context, index) {
              if (index == 0) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Tasks",
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                      const SizedBox(height: 25),
                      TaskTile(
                        task: value.tasks[index],
                        onEdit: _onEdit,
                      )
                    ],
                  ),
                );
              }
              return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: TaskTile(
                    task: value.tasks[index],
                    onEdit: _onEdit,
                  ));
            })),
      ),
    );
  }
}
