// import 'dart:math';
import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:koduko/services/routines_provider.dart';
import 'package:provider/provider.dart';

class WeeklyChart extends StatelessWidget {
  const WeeklyChart({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Text("Weekly Activity",
                style: Theme.of(context).textTheme.titleMedium!),
          ),
          SizedBox(
              height: 160,
              child: Consumer<RoutineModel>(
                builder: ((context, value, child) {
                  var ok = value
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
                                      .surfaceVariant,
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
                                color: Theme.of(context)
                                    .colorScheme
                                    .inversePrimary,
                              ),
                            ],
                          )))
                      .values
                      .toList();
                  return BarChart(BarChartData(
                    borderData: FlBorderData(show: false),
                    gridData: FlGridData(show: false),
                    alignment: BarChartAlignment.spaceAround,
                    titlesData: FlTitlesData(
                      show: true,
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 30,
                          getTitlesWidget: ((value, meta) => getTitles(
                              value,
                              meta,
                              Theme.of(context).colorScheme.onBackground)),
                        ),
                      ),
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                      topTitles: AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                      rightTitles: AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                    ),
                    barGroups: ok,
                  ));
                }),
              ))
        ],
      ),
    );
  }
}

Widget getTitles(double value, TitleMeta meta, Color color) {
  var style = TextStyle(
    color: color,
    fontWeight: FontWeight.bold,
    fontSize: 14,
  );
  String text;
  switch (value.toInt()) {
    case 0:
      text = 'Mn';
      break;
    case 1:
      text = 'Te';
      break;
    case 2:
      text = 'Wd';
      break;
    case 3:
      text = 'Tu';
      break;
    case 4:
      text = 'Fr';
      break;
    case 5:
      text = 'St';
      break;
    case 6:
      text = 'Sn';
      break;
    default:
      text = '';
      break;
  }
  return SideTitleWidget(
    axisSide: meta.axisSide,
    space: 4.0,
    child: Text(text, style: style),
  );
}
