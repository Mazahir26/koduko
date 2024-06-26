import 'package:flutter/material.dart';
import 'package:koduko/components/create_task_bottom_sheet.dart';
import 'package:koduko/models/task.dart';
import 'package:koduko/services/routines_provider.dart';
import 'package:koduko/services/tasks_provider.dart';
import 'package:koduko/utils/duration_to_string.dart';
import 'package:koduko/utils/parse_duration.dart';
import 'package:provider/provider.dart';

class TaskTile extends StatelessWidget {
  const TaskTile({super.key, required this.task, required this.onEdit});
  final Task task;
  final void Function(Task) onEdit;
  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        trailing: SizedBox(
          width: 100,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
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
                        builder: ((context) => CreateTaskBottomSheet(
                              task: task,
                            )));

                    if (t != null) {
                      onEdit(task.copyWith(
                          color: t.color, duration: t.duration, name: t.name));
                    }
                  },
                  icon: const Icon(Icons.edit)),
              IconButton(
                  onPressed: () async {
                    showDialog(
                        context: context,
                        builder: ((context) => AlertDialog(
                              title: const Text("Delete task?"),
                              content: const Text(
                                  "This Task will be removed from all the routines. if the routine has only this task, then routine will also be deleted."),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: const Text("CANCEL"),
                                ),
                                TextButton(
                                  style: TextButton.styleFrom(
                                      foregroundColor:
                                          Theme.of(context).colorScheme.error),
                                  onPressed: () {
                                    Provider.of<TaskModel>(context,
                                            listen: false)
                                        .delete(task.id);
                                    Provider.of<RoutineModel>(context,
                                            listen: false)
                                        .removeTask(task);
                                    Navigator.pop(context);
                                  },
                                  child: const Text("DELETE"),
                                )
                              ],
                            )));
                  },
                  icon: Icon(
                    Icons.delete,
                    color: Colors.red[300],
                  ))
            ],
          ),
        ),
        subtitle: Text(
            'Duration : ${durationToString(parseDuration(task.duration))} Min'),
        title: Text(
          task.name,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ),
    );
  }
}
