import 'dart:math';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:koduko/services/routines_provider.dart';
import 'package:provider/provider.dart';
import 'package:collection/collection.dart';

class WeeklyChart extends StatefulWidget {
  const WeeklyChart({
    super.key,
    required this.textTheme,
  });
  final TextTheme textTheme;

  @override
  State<WeeklyChart> createState() => _WeeklyChartState();
}

class _WeeklyChartState extends State<WeeklyChart> {
  int index = -1;
  @override
  Widget build(BuildContext context) {
    return Card(
        margin: const EdgeInsets.symmetric(vertical: 10),
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Weekly Activity',
                  style: widget.textTheme.headlineSmall!
                      .apply(fontWeightDelta: 1)),
              Consumer<RoutineModel>(
                builder: ((context, value, child) => Text(
                    'You have completed ${value.getWeeklyStats().sum} ${value.getWeeklyStats().sum > 1 ? "tasks" : "task"} this week.',
                    style: widget.textTheme.bodyMedium)),
              ),
              const SizedBox(height: 15),
              SizedBox(
                  height: 160,
                  child: Consumer<RoutineModel>(
                    builder: ((context, value, child) {
                      var barGroupData = value
                          .getWeeklyStats()
                          .asMap()
                          .map((key, val) => MapEntry(
                              key,
                              BarChartGroupData(
                                x: key,
                                barRods: [
                                  BarChartRodData(
                                    width: 15,
                                    backDrawRodData: BackgroundBarChartRodData(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .surfaceContainerHighest,
                                      show: true,
                                      toY: value
                                                  .getWeeklyStats()
                                                  .reduce(max)
                                                  .toDouble() ==
                                              0
                                          ? 10
                                          : value
                                              .getWeeklyStats()
                                              .reduce(max)
                                              .toDouble(),
                                    ),
                                    toY: val.toDouble(),
                                    color: key == index
                                        ? Theme.of(context)
                                            .colorScheme
                                            .primary
                                            .withOpacity(0.5)
                                        : Theme.of(context)
                                            .colorScheme
                                            .inversePrimary,
                                  ),
                                ],
                              )))
                          .values
                          .toList();
                      return BarChart(
                          swapAnimationDuration:
                              const Duration(milliseconds: 250), // Optional
                          swapAnimationCurve: Curves.bounceOut,
                          BarChartData(
                            barTouchData: BarTouchData(
                              touchTooltipData: barToolTipData(context),
                              touchCallback:
                                  (FlTouchEvent event, barTouchResponse) {
                                setState(() {
                                  if (!event.isInterestedForInteractions ||
                                      barTouchResponse == null ||
                                      barTouchResponse.spot == null) {
                                    index = -1;
                                    return;
                                  }
                                  index = barTouchResponse
                                      .spot!.touchedBarGroupIndex;
                                });
                              },
                            ),
                            borderData: FlBorderData(show: false),
                            gridData: const FlGridData(show: false),
                            alignment: BarChartAlignment.spaceAround,
                            titlesData: FlTitlesData(
                              show: true,
                              bottomTitles: AxisTitles(
                                sideTitles: SideTitles(
                                  showTitles: true,
                                  reservedSize: 40,
                                  getTitlesWidget: ((value, meta) => getTitles(
                                      value,
                                      meta,
                                      Theme.of(context).colorScheme.onSurface,
                                      Theme.of(context)
                                          .colorScheme
                                          .inversePrimary)),
                                ),
                              ),
                              leftTitles: const AxisTitles(
                                sideTitles: SideTitles(showTitles: false),
                              ),
                              topTitles: const AxisTitles(
                                sideTitles: SideTitles(showTitles: false),
                              ),
                              rightTitles: const AxisTitles(
                                sideTitles: SideTitles(showTitles: false),
                              ),
                            ),
                            barGroups: barGroupData,
                          ));
                    }),
                  )),
            ],
          ),
        ));
  }
}

Widget getTitles(double value, TitleMeta meta, Color color, Color backColor) {
  var style = TextStyle(
    color: color,
  );
  String text;
  switch (value.toInt()) {
    case 0:
      text = 'Mon';
      break;
    case 1:
      text = 'Tue';
      break;
    case 2:
      text = 'Wed';
      break;
    case 3:
      text = 'Thu';
      break;
    case 4:
      text = 'Fri';
      break;
    case 5:
      text = 'Sat';
      break;
    case 6:
      text = 'Sun';
      break;
    default:
      text = '';
      break;
  }
  return SideTitleWidget(
    axisSide: meta.axisSide,
    space: 4.0,
    child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        margin: const EdgeInsets.only(top: 5),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: DateFormat("EEE").format(DateTime.now()) == text
                ? backColor.withOpacity(0.5)
                : null),
        child: Text(text, style: style)),
  );
}

BarTouchTooltipData barToolTipData(BuildContext context) {
  return BarTouchTooltipData(
    getTooltipItem: (group, groupIndex, rod, rodIndex) {
      String weekDay;
      switch (group.x.toInt()) {
        case 0:
          weekDay = 'Monday';
          break;
        case 1:
          weekDay = 'Tuesday';
          break;
        case 2:
          weekDay = 'Wednesday';
          break;
        case 3:
          weekDay = 'Thursday';
          break;
        case 4:
          weekDay = 'Friday';
          break;
        case 5:
          weekDay = 'Saturday';
          break;
        case 6:
          weekDay = 'Sunday';
          break;
        default:
          throw Error();
      }
      return BarTooltipItem(
        '$weekDay\n',
        Theme.of(context).textTheme.labelLarge!,
        children: <TextSpan>[
          TextSpan(
              text: '${rod.toY}',
              style: Theme.of(context).textTheme.labelMedium!),
        ],
      );
    },
  );
}
