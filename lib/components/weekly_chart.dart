// import 'dart:math';
import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:koduko/services/routines_provider.dart';
import 'package:provider/provider.dart';

class WeeklyChart extends StatelessWidget {
  const WeeklyChart({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.only(top: 20, bottom: 10),
        child: SizedBox(
            height: 180,
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
                              color:
                                  Theme.of(context).colorScheme.inversePrimary,
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
                        reservedSize: 40,
                        getTitlesWidget: ((value, meta) => getTitles(
                            value,
                            meta,
                            Theme.of(context).colorScheme.onBackground,
                            Theme.of(context).colorScheme.inversePrimary)),
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
            )),
      ),
    );
  }
}

Widget getTitles(double value, TitleMeta meta, Color color, Color backColor) {
  var style = TextStyle(
    color: color,
    fontWeight: FontWeight.bold,
    fontSize: 14,
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
