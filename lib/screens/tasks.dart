import 'package:flutter/material.dart';
import 'package:koduko/components/create_task_bottom_sheet.dart';
import 'package:koduko/components/header.dart';
import 'package:koduko/components/task_tile.dart';
import 'package:koduko/models/task.dart';
import 'package:koduko/services/routines_provider.dart';
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
      Provider.of<RoutineModel>(context, listen: false).editTask(t);
    }

    void _onCreateTask() async {
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
    }

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: _onCreateTask,
        child: const Icon(Icons.add),
      ),
      body: Consumer<TaskModel>(
          builder: ((context, value, child) => value.tasks.isEmpty
              ? SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 20, horizontal: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        child ?? Container(),
                        const Spacer(),
                        Text(
                          "Looks like you haven't created any tasks",
                          style: Theme.of(context)
                              .textTheme
                              .headlineMedium!
                              .apply(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onBackground),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 10),
                        Center(
                          child: TextButton.icon(
                              icon: const Icon(Icons.add),
                              onPressed: _onCreateTask,
                              label: const Text(
                                "Create One",
                                style: TextStyle(fontSize: 18),
                              )),
                        ),
                        const Spacer(),
                      ],
                    ),
                  ),
                )
              : ListView.builder(
                  itemCount: value.tasks.length,
                  itemBuilder: (context, index) {
                    if (index == 0) {
                      return Padding(
                        padding:
                            const EdgeInsets.only(top: 20, right: 10, left: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            child ?? Container(),
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
          child: const ScreenHeader(
            text: "My Tasks",
            tag: "My Tasks",
          )),
    );
  }
}
