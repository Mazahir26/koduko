import 'package:flutter/material.dart';
import 'package:koduko/components/create_task_bottom_sheet.dart';
import 'package:koduko/models/task.dart';
import 'package:koduko/services/tasks_provider.dart';
import 'package:koduko/utils/duration_to_string.dart';
import 'package:koduko/utils/parse_duration.dart';
import 'package:provider/provider.dart';

class TasksScreen extends StatelessWidget {
  const TasksScreen({Key? key}) : super(key: key);
  static const routeName = "/tasks";
  @override
  Widget build(BuildContext context) {
    void _addTask(Task t) {
      Provider.of<TaskModel>(context, listen: false).add(t);
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
              builder: ((context) => const CreateTaskSheet()));
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
                      Card(
                        child: ListTile(
                          trailing: SizedBox(
                            width: 100,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                IconButton(
                                    onPressed: () {},
                                    icon: const Icon(Icons.edit)),
                                IconButton(
                                    onPressed: () {},
                                    icon: Icon(
                                      Icons.delete,
                                      color: Colors.red[300],
                                    ))
                              ],
                            ),
                          ),
                          subtitle: Text(
                              'Duration : ${durationToString(parseDuration(value.tasks[index].duration))} Min'),
                          title: Text(
                            value.tasks[index].name,
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ),
                      )
                    ],
                  ),
                );
              }
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Card(
                  child: ListTile(
                    trailing: SizedBox(
                      width: 100,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(
                              onPressed: () {}, icon: const Icon(Icons.edit)),
                          IconButton(
                              onPressed: () {},
                              icon: Icon(
                                Icons.delete,
                                color: Colors.red[300],
                              ))
                        ],
                      ),
                    ),
                    subtitle: Text(
                        'Duration : ${durationToString(parseDuration(value.tasks[index].duration))} Min'),
                    title: Text(
                      value.tasks[index].name,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ),
                ),
              );
            })),
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
