import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:koduko/components/create_routine_bottom_sheet.dart';
import 'package:koduko/models/routine.dart';
import 'package:koduko/screens/routine.dart';

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
            builder: ((context) => RoutineScreen(routine: routine))));
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(2),
      child: Slidable(
        key: Key(routine.id),

        startActionPane: ActionPane(
          motion: const ScrollMotion(),
          dismissible: DismissiblePane(onDismissed: () {}),
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Center(
                    child: TextButton.icon(
                  onPressed: (() {}),
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
                  onPressed: (() {}),
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
        // background: Padding(
        //   padding: const EdgeInsets.symmetric(horizontal: 10),
        //   child: Align(
        //     alignment: Alignment.centerLeft,
        //     child: Text(
        //       "Edit",
        //       style: Theme.of(context)
        //           .textTheme
        //           .titleLarge!
        //           .apply(color: Colors.blue[300]),
        //     ),
        //   ),
        // ),
        // secondaryBackground: Padding(
        //   padding: const EdgeInsets.symmetric(horizontal: 10),
        //   child: Align(
        //     alignment: Alignment.centerRight,
        //     child: Text(
        //       "Delete",
        //       style: Theme.of(context)
        //           .textTheme
        //           .titleLarge!
        //           .apply(color: Colors.red[300]),
        //     ),
        //   ),
        // ),
        child: Card(
          child: ListTile(
              title: Text(
                routine.name,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              subtitle: Text(routine.getDays()),
              trailing: SizedBox(
                width: 100,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    isToday
                        ? Stack(
                            alignment: AlignmentDirectional.center,
                            children: [
                              CircularProgressIndicator(
                                color: Theme.of(context)
                                    .colorScheme
                                    .inversePrimary,
                                backgroundColor:
                                    Theme.of(context).colorScheme.onPrimary,
                                strokeWidth: 6.2,
                                semanticsLabel: "Hello",
                                value: routine.getPercentage(),
                              ),
                              Text(
                                routine.getPercentageString(),
                                style: Theme.of(context).textTheme.labelSmall,
                              )
                            ],
                          )
                        : Container(),
                    IconButton(
                        padding: EdgeInsets.zero,
                        onPressed: () {
                          onPress(context);
                        },
                        icon: const Icon(
                          Icons.play_arrow_rounded,
                          size: 30,
                        ))
                  ],
                ),
              )),
        ),
      ),
    );
  }
}
