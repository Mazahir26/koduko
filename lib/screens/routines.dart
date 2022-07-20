import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:koduko/components/create_routine_bottom_sheet.dart';
import 'package:koduko/models/routine.dart';
import 'package:koduko/screens/routine.dart';
import 'package:koduko/services/routines_provider.dart';
import 'package:provider/provider.dart';

class RoutinesScreen extends StatelessWidget {
  const RoutinesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    void _addRoutine(Routine r) {
      Provider.of<RoutineModel>(context, listen: false).add(r);
    }

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () async {
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
              builder: ((context) => const CreateRoutineBottomSheet()));

          if (r != null) {
            _addRoutine(r);
          }
        },
      ),
      body: Consumer<RoutineModel>(
        builder: ((context, value, child) => ListView.builder(
            itemCount: 2,
            itemBuilder: (context, index) {
              if (index == 0) {
                List<Widget> t = value.routines
                    .where(
                      (element) => element.days.contains(
                        DateFormat('EEEE').format(DateTime.now()),
                      ),
                    )
                    .map((e) => RoutineTile(
                          routine: e,
                          isToday: true,
                        ))
                    .toList();
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Today's Routines",
                          style: GoogleFonts.lato(
                            fontWeight: FontWeight.bold,
                            textStyle: Theme.of(context)
                                .textTheme
                                .apply(
                                    displayColor:
                                        Theme.of(context).colorScheme.onSurface)
                                .headlineMedium,
                          ),
                        ),
                        const SizedBox(height: 20),
                        ...t
                      ]),
                );
              } else {
                List<Widget> t = value.routines
                    .where(
                      (element) => !element.days.contains(
                        DateFormat('EEEE').format(DateTime.now()),
                      ),
                    )
                    .map((e) => RoutineTile(routine: e))
                    .toList();
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "All Routines",
                          style: GoogleFonts.lato(
                              fontWeight: FontWeight.bold,
                              textStyle: Theme.of(context)
                                  .textTheme
                                  .apply(
                                      displayColor: Theme.of(context)
                                          .colorScheme
                                          .onSurface)
                                  .headlineMedium),
                        ),
                        const SizedBox(height: 20),
                        ...t
                      ]),
                );
              }
            })),
      ),
    );
  }
}

class RoutineTile extends StatelessWidget {
  const RoutineTile({
    Key? key,
    required this.routine,
    this.isToday = false,
  }) : super(key: key);
  final Routine routine;
  final bool isToday;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: ElevatedButton(
        onLongPress: (() async {
          await showModalBottomSheet<Routine>(
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
