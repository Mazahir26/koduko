import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:koduko/components/daily_activity.dart';
import 'package:koduko/components/header.dart';
import 'package:koduko/components/most_productive_hour.dart';
import 'package:koduko/components/productive_day.dart';
import 'package:koduko/components/time_spent_today.dart';
import 'package:koduko/components/weekly_chart.dart';
import 'package:koduko/models/task_event.dart';
import 'package:koduko/services/routines_provider.dart';
import 'package:provider/provider.dart';

class Statistics extends StatelessWidget {
  const Statistics({super.key});
  static const routeName = "/stats";

  @override
  Widget build(BuildContext context) {
    void clearHistory() {
      Provider.of<RoutineModel>(context, listen: false).clearHistory();
    }

    final textTheme = Theme.of(context).textTheme.apply(
          displayColor: Theme.of(context).colorScheme.onSurface,
        );
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: ListView(
          children: [
            const SizedBox(height: 10),
            const ScreenHeader(text: "Statistics", tag: "Statistics"),
            const SizedBox(height: 25),
            TodayProgress(textTheme: textTheme),
            Hero(tag: 'WeeklyChart', child: WeeklyChart(textTheme: textTheme)),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(child: ProductiveHour(textTheme: textTheme)),
                Expanded(child: ProductiveDay(textTheme: textTheme)),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(child: TimeSpentToday(textTheme: textTheme)),
              ],
            ),
            const SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "History",
                  style: textTheme.headlineMedium,
                ),
                TextButton.icon(
                    onPressed: () async {
                      final b = await showDialog<bool>(
                        context: context,
                        builder: ((context) => AlertDialog(
                              title: const Text("Clear History"),
                              content: const Text(
                                  "This is an irreversible action. This will delete all your stats."),
                              actions: [
                                TextButton(
                                  onPressed: (() =>
                                      Navigator.pop(context, false)),
                                  child: const Text("CANCEL"),
                                ),
                                TextButton(
                                  style: TextButton.styleFrom(
                                      foregroundColor:
                                          Theme.of(context).colorScheme.error),
                                  onPressed: (() =>
                                      Navigator.pop(context, true)),
                                  child: const Text("DELETE"),
                                )
                              ],
                            )),
                      );
                      if (b == true) {
                        clearHistory();
                      }
                    },
                    style:
                        TextButton.styleFrom(foregroundColor: Colors.red[300]),
                    icon: const Icon(Icons.delete),
                    label: const Text("Clear History"))
              ],
            ),
            const SizedBox(height: 15),
            Selector<RoutineModel, List<TaskEvent>>(
                builder: ((context, value, child) => Column(
                      children: value.reversed
                          .map((e) => Card(
                                child: ListTile(
                                  trailing: IconButton(
                                    onPressed: () => Provider.of<RoutineModel>(
                                            context,
                                            listen: false)
                                        .removeHistory(e.id),
                                    color: Colors.red[300],
                                    icon: const Icon(Icons.close,
                                        semanticLabel: 'Delete'),
                                  ),
                                  // onTap: () => ,
                                  title: Text(e.taskName),
                                  subtitle: Text(DateFormat("MMMM d, y")
                                      .add_jm()
                                      .format(e.time)),
                                ),
                              ))
                          .toList(),
                    )),
                selector: (p0, p1) => p1.getHistory())
          ],
        ),
      ),
    );
  }
}
