import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:koduko/components/daily_activity.dart';
import 'package:koduko/components/routine_tile.dart';
import 'package:koduko/components/weekly_chart.dart';
import 'package:koduko/screens/start_routine.dart';
import 'package:koduko/services/routines_provider.dart';
import 'package:koduko/utils/greetings.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:provider/provider.dart';
// import 'package:koduko/components/weekly_chart.dart';
// import 'package:koduko/models/task.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context)
        .textTheme
        .apply(displayColor: Theme.of(context).colorScheme.onSurface);
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
      children: [
        Header(textTheme: textTheme),
        const SizedBox(height: 20),
        WeeklyChart(textTheme: textTheme),
        Align(
          alignment: Alignment.centerRight,
          child: TextButton.icon(
            onPressed: () {},
            icon: const Text("More Stats"),
            label: const Icon(Icons.chevron_right_rounded),
          ),
        ),
        Text("Today's Routines",
            style: GoogleFonts.lato(
              fontWeight: FontWeight.bold,
              textStyle: textTheme.headlineMedium,
            )),
        const SizedBox(height: 10),
        Consumer<RoutineModel>(builder: (context, value, child) {
          return Column(
            children: value.routines
                .asMap()
                .map((key, value) => MapEntry(
                    key,
                    value.isToday()
                        ? Row(
                            children: [
                              Expanded(
                                flex: 1,
                                child: Text(
                                  '${key + 1}',
                                  style: GoogleFonts.lato(
                                    fontWeight: FontWeight.bold,
                                    textStyle: textTheme.headlineLarge,
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 10,
                                child: Card(
                                  margin: const EdgeInsets.symmetric(
                                    vertical: 5,
                                  ),
                                  child: ListTile(
                                      title: Text(
                                        value.name,
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleLarge,
                                      ),
                                      subtitle: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 3),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            value.inCompletedTasks.isEmpty
                                                ? const Text("Completed")
                                                : Text(
                                                    'Completed ${value.tasks.length - value.inCompletedTasks.length} out of ${value.tasks.length}'),
                                            const SizedBox(height: 5),
                                            LinearPercentIndicator(
                                              animateFromLastPercent: true,
                                              animation: true,
                                              percent: value.getPercentage(),
                                              barRadius:
                                                  const Radius.circular(10),
                                              lineHeight: 3,
                                              progressColor: Theme.of(context)
                                                  .colorScheme
                                                  .inversePrimary,
                                              padding: EdgeInsets.zero,
                                            ),
                                          ],
                                        ),
                                      ),
                                      trailing: IconButton(
                                          padding: EdgeInsets.zero,
                                          onPressed: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: ((context) =>
                                                        RoutineScreen(
                                                          routine: value,
                                                        ))));
                                          },
                                          icon: Icon(
                                            value.isCompleted
                                                ? Icons.replay_rounded
                                                : Icons.play_arrow_rounded,
                                            size: 30,
                                          ))),
                                ),
                              ),
                            ],
                          )
                        : Container()))
                .values
                .toList(),
          );
        })
      ],
    );
  }
}

class Header extends StatelessWidget {
  const Header({
    Key? key,
    required this.textTheme,
  }) : super(key: key);

  final TextTheme textTheme;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'Good ${greeting()} 👋',
          style: GoogleFonts.lato(
            fontWeight: FontWeight.bold,
            textStyle: textTheme.headlineLarge,
          ),
        ),
        Text(
          DateFormat.MMMMEEEEd().format(DateTime.now()),
          style: GoogleFonts.lato(
            fontWeight: FontWeight.w400,
            textStyle: Theme.of(context).textTheme.titleLarge!.apply(
                color:
                    Theme.of(context).colorScheme.onSurface.withOpacity(0.5)),
          ),
        ),
      ],
    );
  }
}
