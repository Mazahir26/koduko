import 'package:flutter/material.dart';
import 'package:koduko/components/create_routine_bottom_sheet.dart';
import 'package:koduko/models/routine.dart';
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
              itemCount: value.routines.length,
              itemBuilder: (context, index) => Card(
                child: ListTile(
                  title: Text(
                    value.routines[index].name,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  subtitle: Text(value.routines[index].getDays()),
                  trailing: Stack(
                    alignment: AlignmentDirectional.center,
                    children: [
                      CircularProgressIndicator(
                        color: Theme.of(context).colorScheme.inversePrimary,
                        backgroundColor:
                            Theme.of(context).colorScheme.onPrimary,
                        strokeWidth: 6.2,
                        semanticsLabel: "Hello",
                        value: value.routines[index].getPercentage(),
                      ),
                      Text(
                        value.routines[index].getPercentageString(),
                        style: Theme.of(context).textTheme.labelSmall,
                      )
                    ],
                  ),
                ),
              ),
            )),
      ),
    );
  }
}
