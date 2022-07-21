import 'package:flutter/material.dart';
import 'package:koduko/components/create_task_bottom_sheet.dart';
import 'package:koduko/models/task.dart';
import 'package:koduko/services/tasks_provider.dart';
import 'package:koduko/utils/duration_to_string.dart';
import 'package:koduko/utils/parse_duration.dart';
import 'package:provider/provider.dart';

class TaskTile extends StatelessWidget {
  const TaskTile({Key? key, required this.task}) : super(key: key);
  final Task task;
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
                        builder: ((context) => CreateTaskBottomSheet(
                              task: task,
                            )));
                  },
                  icon: const Icon(Icons.edit)),
              IconButton(
                  onPressed: () {
                    Provider.of<TaskModel>(context, listen: false)
                        .delete(task.id);
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
