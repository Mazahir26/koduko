import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:koduko/components/create_routine_bottom_sheet.dart';
import 'package:koduko/models/routine.dart';
import 'package:koduko/screens/start_routine.dart';
import 'package:koduko/services/routines_provider.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:provider/provider.dart';

class RoutineTile extends StatelessWidget {
  const RoutineTile({
    Key? key,
    required this.routine,
    this.isToday = false,
    required this.onEdit,
  }) : super(key: key);
  final Routine routine;
  final bool isToday;
  final void Function(Routine) onEdit;

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
              editRoutine: routine,
            )));
    if (r != null) {
      onEdit(routine.copyWith(
        name: r.name,
        tasks: r.tasks,
        days: r.days,
      ));
    }
  }

  void onPress(BuildContext context) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: ((context) => RoutineScreen(
                  routine: routine,
                ))));
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(2),
      child: Slidable(
        key: Key(routine.id),
        startActionPane: ActionPane(
          motion: const ScrollMotion(),
          dismissible: DismissiblePane(onDismissed: () {
            Provider.of<RoutineModel>(context, listen: false)
                .delete(routine.id);
          }),
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Center(
                    child: TextButton.icon(
                  onPressed: (() {
                    Provider.of<RoutineModel>(context, listen: false)
                        .delete(routine.id);
                  }),
                  icon: Icon(
                    Icons.delete,
                    color: Colors.red[300],
                  ),
                  label: Text(
                    "Delete",
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge!
                        .apply(color: Colors.red[300]),
                  ),
                )),
              ),
            )
          ],
        ),
        endActionPane: ActionPane(
          motion: const ScrollMotion(),
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Center(
                    child: TextButton.icon(
                  onPressed: (() {
                    onLongPress(context);
                  }),
                  icon: Icon(
                    Icons.edit,
                    color: Colors.blue[300],
                  ),
                  label: Text(
                    "Edit",
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge!
                        .apply(color: Colors.blue[300]),
                  ),
                )),
              ),
            )
          ],
        ),
        child: Card(
          child: ListTile(
              title: Text(
                routine.name,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              subtitle: isToday
                  ? LinearPercentIndicator(
                      animateFromLastPercent: true,
                      animation: true,
                      percent: routine.getPercentage(),
                      barRadius: const Radius.circular(10),
                      lineHeight: 8,
                      progressColor:
                          Theme.of(context).colorScheme.inversePrimary,
                      padding: EdgeInsets.zero,
                    )
                  : Text(routine.getDays()),
              trailing: IconButton(
                  padding: EdgeInsets.zero,
                  onPressed: () {
                    onPress(context);
                  },
                  icon: Icon(
                    routine.isCompleted
                        ? Icons.replay_rounded
                        : Icons.play_arrow_rounded,
                    size: 30,
                  ))),
        ),
      ),
    );
  }
}
