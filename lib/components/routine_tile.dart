import 'package:flutter/material.dart';
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
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: ElevatedButton(
        onLongPress: (() async {
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
        }),
        onPressed: (() {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: ((context) => RoutineScreen(routine: routine))));
        }),
        style: ButtonStyle(
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
          ),
        ),
        child: ListTile(
            title: Text(
              routine.name,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            subtitle: Text(routine.getDays()),
            trailing: isToday
                ? Stack(
                    alignment: AlignmentDirectional.center,
                    children: [
                      CircularProgressIndicator(
                        color: Theme.of(context).colorScheme.inversePrimary,
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
                : const Icon(
                    Icons.play_arrow_rounded,
                    size: 30,
                  )),
      ),
    );
  }
}
