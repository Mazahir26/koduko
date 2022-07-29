import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:koduko/components/daily_activity.dart';
import 'package:koduko/components/header.dart';
import 'package:koduko/components/weekly_chart.dart';
import 'package:koduko/models/task_event.dart';
import 'package:koduko/services/routines_provider.dart';
import 'package:provider/provider.dart';

class Statistics extends StatelessWidget {
  const Statistics({Key? key}) : super(key: key);
  static const routeName = "/stats";

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context)
        .textTheme
        .apply(displayColor: Theme.of(context).colorScheme.onSurface);
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: ListView(
          children: [
            const SizedBox(height: 10),
            const ScreenHeader(text: "Statistics", tag: "Statistics"),
            const SizedBox(height: 25),
            TodayProgress(textTheme: textTheme),
            WeeklyChart(textTheme: textTheme),
            const SizedBox(height: 15),
            Text(
              "History",
              style: textTheme.headlineMedium,
            ),
            const SizedBox(height: 15),
            Selector<RoutineModel, List<TaskEvent>>(
                builder: ((context, value, child) => Column(
                      children: value
                          .map((e) => Card(
                                child: ListTile(
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
