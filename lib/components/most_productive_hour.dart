import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:koduko/services/routines_provider.dart';
import 'package:koduko/utils/time_of_day_util.dart';
import 'package:provider/provider.dart';

class ProductiveHour extends StatelessWidget {
  const ProductiveHour({super.key, required this.textTheme});
  final TextTheme textTheme;

  @override
  Widget build(BuildContext context) {
    return Card(
        child: Selector<RoutineModel, int>(
      selector: (p0, p1) => p1.getMostProductiveHour(),
      builder: (context, value, child) => Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            const SizedBox(height: 15),
            Text(
              "Most Productive Hour",
              style: textTheme.titleSmall,
            ),
            const SizedBox(height: 10),
            Text(
              DateFormat.j().format(
                  timeOfDayToDateTime(TimeOfDay(hour: value, minute: 0)) ??
                      DateTime.now()),
              style: textTheme.headlineLarge,
            ),
            const SizedBox(height: 15),
          ],
        ),
      ),
    ));
  }
}
