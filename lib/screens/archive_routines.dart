import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:koduko/services/routines_provider.dart';
import 'package:provider/provider.dart';

class ArchiveRoutinesScreen extends StatelessWidget {
  const ArchiveRoutinesScreen({Key? key}) : super(key: key);
  static const routeName = "/archive";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Consumer<RoutineModel>(
            builder: (context, value, child) => value.archiveRoutines().isEmpty
                ? Padding(
                    padding: const EdgeInsets.all(15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 20),
                        Expanded(
                          flex: 1,
                          child: Text(
                            "Archive",
                            style: GoogleFonts.lato(
                              fontWeight: FontWeight.bold,
                              textStyle: Theme.of(context)
                                  .textTheme
                                  .apply(
                                      displayColor: Theme.of(context)
                                          .colorScheme
                                          .onSurface)
                                  .headlineLarge,
                            ),
                          ),
                        ),
                        const SizedBox(height: 30),
                        Expanded(
                          flex: 10,
                          child: Center(
                            child: Text(
                              "Archived routines will show up here!",
                              textAlign: TextAlign.center,
                              style: Theme.of(context)
                                  .textTheme
                                  .apply(
                                      displayColor: Theme.of(context)
                                          .colorScheme
                                          .onSurface)
                                  .headlineMedium,
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    itemCount: value.archiveRoutines().length + 1,
                    itemBuilder: (context, index) {
                      if (index == 0) {
                        return Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 20),
                              Text(
                                "Archive",
                                style: GoogleFonts.lato(
                                  fontWeight: FontWeight.bold,
                                  textStyle: Theme.of(context)
                                      .textTheme
                                      .apply(
                                          displayColor: Theme.of(context)
                                              .colorScheme
                                              .onSurface)
                                      .headlineLarge,
                                ),
                              ),
                              const SizedBox(height: 10),
                            ],
                          ),
                        );
                      }
                      index -= 1;
                      return Card(
                        margin: const EdgeInsets.all(10),
                        child: ListTile(
                          title: Text(
                            value.archiveRoutines()[index].name,
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          subtitle: const Text("Archived"),
                          trailing: SizedBox(
                            width: 100,
                            child: Row(
                              children: [
                                IconButton(
                                  color: Colors.brown[300],
                                  onPressed: () {
                                    Provider.of<RoutineModel>(context,
                                            listen: false)
                                        .removeFromArchive(
                                            value.archiveRoutines()[index].id);
                                  },
                                  icon: const Icon(Icons.unarchive_rounded),
                                ),
                                IconButton(
                                  color: Colors.red[300],
                                  onPressed: () {},
                                  icon: const Icon(Icons.delete),
                                )
                              ],
                            ),
                          ),
                        ),
                      );
                    })),
      ),
    );
  }
}

class Action extends StatelessWidget {
  const Action(
      {Key? key,
      required this.onPress,
      required this.color,
      required this.icon,
      required this.label})
      : super(key: key);

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