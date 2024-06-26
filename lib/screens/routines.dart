import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:koduko/components/create_routine_bottom_sheet.dart';
import 'package:koduko/components/routine_tile.dart';
import 'package:koduko/models/routine.dart';
import 'package:koduko/services/routines_provider.dart';
import 'package:provider/provider.dart';

class RoutinesScreen extends StatelessWidget {
  const RoutinesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    void addRoutine(Routine r) {
      Provider.of<RoutineModel>(context, listen: false).add(r);
    }

    void editRoutine(Routine r) {
      Provider.of<RoutineModel>(context, listen: false).edit(r);
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
            addRoutine(r);
          }
        },
      ),
      body: Consumer<RoutineModel>(
        builder: ((context, value, child) {
          final Duration totalTime = value.todaysRoutines().fold(
              Duration.zero,
              (previousValue, element) =>
                  previousValue + element.getTimeLeft());
          return value.todaysRoutines().isEmpty && value.allRoutines().isEmpty
              ? Padding(
                  padding: const EdgeInsets.all(15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 20),
                      Expanded(
                        flex: 1,
                        child: Text(
                          "Routines",
                          style: GoogleFonts.lato(
                            fontWeight: FontWeight.bold,
                            textStyle: Theme.of(context)
                                .textTheme
                                .apply(
                                    displayColor:
                                        Theme.of(context).colorScheme.onSurface)
                                .headlineLarge,
                          ),
                        ),
                      ),
                      const SizedBox(height: 30),
                      Expanded(
                        flex: 10,
                        child: Center(
                          child: Text(
                            "Looks Empty! \n Try to add a routine",
                            textAlign: TextAlign.center,
                            style: Theme.of(context)
                                .textTheme
                                .apply(
                                    displayColor:
                                        Theme.of(context).colorScheme.onSurface)
                                .headlineMedium,
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              : ListView(
                  children: [
                    value.todaysRoutines().isEmpty
                        ? Container()
                        : Padding(
                            padding: const EdgeInsets.all(15),
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(height: 20),
                                  Text(
                                    "Today's Routines",
                                    style: GoogleFonts.lato(
                                      fontWeight: FontWeight.bold,
                                      textStyle: Theme.of(context)
                                          .textTheme
                                          .apply(
                                              displayColor: Theme.of(context)
                                                  .colorScheme
                                                  .onSurface)
                                          .headlineMedium,
                                    ),
                                  ),
                                  Text(
                                    "${totalTime.inMinutes} mins left to reach your goal today ",
                                    style: GoogleFonts.lato(
                                      fontWeight: FontWeight.w400,
                                      textStyle: Theme.of(context)
                                          .textTheme
                                          .apply(
                                              displayColor: Theme.of(context)
                                                  .colorScheme
                                                  .onSurface)
                                          .bodyLarge,
                                    ),
                                  ),
                                  const SizedBox(height: 20),
                                  ...value
                                      .todaysRoutines()
                                      .map((e) => RoutineTile(
                                            routine: e,
                                            isToday: true,
                                            onEdit: editRoutine,
                                          ))
                                      
                                ]),
                          ),
                    value.allRoutines().isEmpty
                        ? Container()
                        : Padding(
                            padding: const EdgeInsets.all(15),
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  value.routines
                                          .where(
                                            (element) => element.days.contains(
                                              DateFormat('EEEE')
                                                  .format(DateTime.now()),
                                            ),
                                          )
                                          .isEmpty
                                      ? const SizedBox(height: 20)
                                      : Container(),
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
                                  ...value
                                      .allRoutines()
                                      .map((e) => RoutineTile(
                                            routine: e,
                                            onEdit: editRoutine,
                                          ))
                                      
                                ]),
                          )
                  ],
                );
        }),
      ),
    );
  }
}
