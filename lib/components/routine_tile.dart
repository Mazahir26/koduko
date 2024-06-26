import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:koduko/components/create_routine_bottom_sheet.dart';
import 'package:koduko/components/routine_chart.dart';
import 'package:koduko/models/routine.dart';
import 'package:koduko/screens/start_routine.dart';
import 'package:koduko/services/routines_provider.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:provider/provider.dart';

class RoutineTile extends StatefulWidget {
  const RoutineTile({
    super.key,
    required this.routine,
    this.isToday = false,
    required this.onEdit,
  });
  final Routine routine;
  final bool isToday;
  final void Function(Routine) onEdit;

  @override
  State<RoutineTile> createState() => _RoutineTileState();
}

class _RoutineTileState extends State<RoutineTile> {
  void onLongPress(BuildContext context) async {
    Routine? r = await showModalBottomSheet<Routine>(
        isScrollControlled: true,
        isDismissible: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(10),
            bottom: Radius.zero,
          ),
        ),
        context: context,
        builder: ((context) => CreateRoutineBottomSheet(
              editRoutine: widget.routine,
            )));
    if (r != null) {
      widget.onEdit(r);
    }
  }

  void onExpanded(bool value) {
    setState(() {
      isExpanded = value;
    });
  }

  void onPress(BuildContext context) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: ((context) => RoutineScreen(
                  routine: widget.routine.id,
                ))));
  }

  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(2),
      child: Slidable(
        enabled: !isExpanded,
        closeOnScroll: true,
        key: Key(widget.routine.id),
        startActionPane: ActionPane(
          motion: const ScrollMotion(),
          dismissible: DismissiblePane(
              closeOnCancel: true,
              onDismissed: () {
                Provider.of<RoutineModel>(context, listen: false)
                    .addToArchive(widget.routine.id);
              }),
          children: [
            Action(
              onPress: ((context) {
                Provider.of<RoutineModel>(context, listen: false)
                    .addToArchive(widget.routine.id);
              }),
              color: Colors.brown[300]!,
              icon: Icons.archive_rounded,
              label: 'Archive',
            ),
          ],
        ),
        endActionPane: ActionPane(
          motion: const ScrollMotion(),
          children: [
            Action(
              onPress: ((context) {
                Provider.of<RoutineModel>(context, listen: false)
                    .toggleMarkAsCompleted(widget.routine.id);
              }),
              color: Colors.blue[300]!,
              icon: Icons.checklist_rounded,
              label: widget.routine.isCompleted
                  ? 'Mark as Incomplete'
                  : 'Mark as Completed',
            ),
          ],
        ),
        child: Card(
            child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 5),
                child: CustomTile(
                  isOpen: isExpanded,
                  onStateChange: onExpanded,
                  isToday: widget.isToday,
                  routine: widget.routine,
                  onPress: onPress,
                  onEdit: onLongPress,
                  onDelete: ((context) {
                    showDialog(
                      context: context,
                      builder: ((context) => AlertOnDelete(
                            onCancel: () {
                              Navigator.pop(context);
                            },
                            onDelete: (() {
                              Provider.of<RoutineModel>(context, listen: false)
                                  .delete(widget.routine.id);
                              Navigator.pop(context);
                            }),
                          )),
                    );
                  }),
                ))),
      ),
    );
  }
}

class AlertOnDelete extends StatelessWidget {
  const AlertOnDelete({
    super.key,
    required this.onCancel,
    required this.onDelete,
  });
  final void Function() onCancel;
  final void Function() onDelete;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Delete routine?"),
      content: const Text(
          "This routine will be deleted. This will remove all the history of this routine as well."),
      actions: [
        TextButton(
          onPressed: onCancel,
          child: const Text("CANCEL"),
        ),
        TextButton(
          style: TextButton.styleFrom(
              foregroundColor: Theme.of(context).colorScheme.error),
          onPressed: onDelete,
          child: const Text("DELETE"),
        )
      ],
    );
  }
}

class Action extends StatelessWidget {
  const Action(
      {super.key,
      required this.onPress,
      required this.color,
      required this.icon,
      required this.label});

  final Function(BuildContext context) onPress;
  final Color color;
  final IconData icon;
  final String label;
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Center(
            child: TextButton.icon(
          onPressed: (() {
            onPress(context);
            Slidable.of(context)?.close();
          }),
          icon: Icon(
            icon,
            color: color,
          ),
          label: Text(
            label,
            style: Theme.of(context).textTheme.titleMedium!.apply(color: color),
          ),
        )),
      ),
    );
  }
}

class CustomTile extends StatelessWidget {
  const CustomTile({
    super.key,
    required this.isToday,
    required this.routine,
    required this.onPress,
    required this.onDelete,
    required this.onEdit,
    required this.onStateChange,
    required this.isOpen,
  });

  final bool isToday;
  final Routine routine;
  final Function(BuildContext context) onPress;
  final Function(BuildContext context) onDelete;
  final Function(BuildContext context) onEdit;
  final Function(bool value) onStateChange;
  final bool isOpen;

  // bool isOpen = false;
  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        dividerColor: Colors.transparent,
        splashFactory: NoSplash.splashFactory,
        highlightColor: Colors.transparent,
      ),
      child: ExpansionTile(
        onExpansionChanged: (value) {
          Slidable.of(context)?.close();
          onStateChange(value);
        },
        title: Hero(
          tag: routine.name,
          child: Text(
            routine.name,
            style: Theme.of(context).textTheme.titleLarge,
          ),
        ),
        subtitle: isToday
            ? Padding(
                padding: const EdgeInsets.symmetric(vertical: 3),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (routine.inCompletedTasks.isEmpty)
                      const Text("Completed")
                    else
                      AnimatedCrossFade(
                        firstChild: Text(
                            'Completed ${routine.tasks.length - routine.inCompletedTasks.length} out of ${routine.tasks.length}'),
                        secondChild: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                  "${routine.getTimeLeft().inMinutes} mins left"),
                            ),
                            Expanded(
                              child: Align(
                                alignment: Alignment.centerRight,
                                child: Text(
                                  'Completed ${routine.tasks.length - routine.inCompletedTasks.length} / ${routine.tasks.length}',
                                  style: const TextStyle(
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                        crossFadeState: isOpen
                            ? CrossFadeState.showFirst
                            : CrossFadeState.showSecond,
                        duration: const Duration(milliseconds: 300),
                      ),
                    const SizedBox(height: 5),
                    LinearPercentIndicator(
                      animateFromLastPercent: true,
                      animation: true,
                      percent: routine.getPercentage().clamp(0, 1),
                      barRadius: const Radius.circular(10),
                      lineHeight: 3,
                      progressColor:
                          Theme.of(context).colorScheme.inversePrimary,
                      padding: EdgeInsets.zero,
                    ),
                  ],
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(routine.getDays()),
                  Text("${routine.getTotalTime().inMinutes} mins")
                ],
              ),
        trailing: IconButton(
          padding: EdgeInsets.zero,
          onPressed: () {
            onPress(context);
          },
          icon: isToday
              ? Icon(
                  routine.isCompleted
                      ? Icons.replay_rounded
                      : Icons.play_arrow_rounded,
                  size: 30,
                )
              : const Icon(
                  Icons.play_arrow_rounded,
                  size: 30,
                ),
        ),
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                    "Total duration ${routine.getTotalTime().inMinutes} mins")),
          ),
          RoutineChart(routine: routine),
          Theme(
            data: Theme.of(context),
            child: Row(
              children: [
                Expanded(
                  child: TextButton.icon(
                    onPressed: () => onDelete(context),
                    icon: Icon(
                      Icons.delete,
                      color: Colors.red[300],
                    ),
                    label: Text(
                      'Delete',
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium!
                          .apply(color: Colors.red[300]),
                    ),
                  ),
                ),
                Expanded(
                  child: TextButton.icon(
                    onPressed: () => onEdit(context),
                    icon: Icon(
                      Icons.edit,
                      color: Colors.blue[300],
                    ),
                    label: Text(
                      'Edit',
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium!
                          .apply(color: Colors.blue[300]),
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
