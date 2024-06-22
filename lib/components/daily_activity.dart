import 'package:flutter/material.dart';
import 'package:koduko/services/routines_provider.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:provider/provider.dart';

class TodayProgress extends StatelessWidget {
  const TodayProgress({
    super.key,
    required this.textTheme,
  });

  final TextTheme textTheme;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 15),
        child: Consumer<RoutineModel>(builder: ((context, value, child) {
          var inT = value.totalNoOfCompletedTasksToday();
          var t = value.totalNoOfTasksToday();
          double per;
          if (t == 0) {
            per = 0;
          } else {
            per = inT / t;
          }

          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${value.totalNoOfCompletedTasksToday()}/${value.totalNoOfTasksToday()}',
                    style: textTheme.headlineLarge,
                  ),
                  Text(
                    "Today's Progress",
                    style: textTheme.titleMedium,
                  )
                ],
              ),
              Stack(
                alignment: AlignmentDirectional.center,
                children: [
                  CircularPercentIndicator(
                    percent: per,
                    backgroundColor:
                        Theme.of(context).colorScheme.surfaceContainerHighest,
                    backgroundWidth: 15,
                    progressColor: Theme.of(context).colorScheme.inversePrimary,
                    animation: true,
                    circularStrokeCap: CircularStrokeCap.round,
                    radius: 40,
                    lineWidth: 8,
                  ),
                  Text(
                    '${(per * 100).toInt()}%',
                    style: textTheme.titleSmall!.apply(fontWeightDelta: 1),
                  )
                ],
              )
            ],
          );
        })),
      ),
    );
  }
}
