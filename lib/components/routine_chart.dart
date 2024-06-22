import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:koduko/models/routine.dart';
import 'package:koduko/services/routines_provider.dart';
import 'package:provider/provider.dart';

class RoutineChart extends StatelessWidget {
  const RoutineChart({super.key, required this.routine});

  // final List<Color> gradientColors = [
  //   const Color(0xff6f7bf7),
  //   const Color(0xff9bf8f4),
  // ];
  final Routine routine;
  @override
  Widget build(BuildContext context) {
    return Consumer<RoutineModel>(builder: (context, value, child) {
      double maxX =
          value.getRoutineStartMaxDays(routine.id).toDouble().clamp(0, 7);
      double maxY = value.getRoutineStats(routine.id).isNotEmpty
          ? value.getRoutineStats(routine.id).reduce(max).toDouble()
          : 10;
      Color c = Theme.of(context).brightness == Brightness.light
          ? Colors.black12
          : Colors.grey[800]!;

      final showChart = maxX >= 1 ? true : false;

      if (!showChart) {
        return Padding(
          padding: const EdgeInsets.all(15),
          child: Text(
            "${routine.name.trim()}'s activity will show up here. ",
            style: Theme.of(context).textTheme.bodyLarge,
            textAlign: TextAlign.center,
          ),
        );
      }
      return Column(
        children: [
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "${routine.name.trim()}'s Activity",
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 15,
            ),
            child: SizedBox(
              height: 200,
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: LineChart(
                  LineChartData(
                    titlesData: FlTitlesData(
                      show: true,
                      rightTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                      topTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 30,
                          interval: 1,
                          getTitlesWidget: ((v, meta) => bottomTitleWidgets(
                              v, c, meta, value.getStartDate(routine.id))),
                        ),
                      ),
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: false,
                          reservedSize: 30,
                          interval: 1,
                          getTitlesWidget: ((v, meta) =>
                              leftTitleWidgets(v, c, meta)),
                        ),
                      ),
                    ),
                    gridData: FlGridData(
                      show: true,
                      drawVerticalLine: true,
                      horizontalInterval: 1,
                      verticalInterval: 1,
                      getDrawingHorizontalLine: (value) {
                        return FlLine(
                          color: c,
                          strokeWidth: 1,
                        );
                      },
                      getDrawingVerticalLine: (value) {
                        return FlLine(
                          color: c,
                          strokeWidth: 1,
                        );
                      },
                    ),
                    borderData: FlBorderData(
                        show: true, border: Border.all(color: c, width: 1)),
                    minX: 0,
                    maxX: maxX,
                    minY: -0.2,
                    maxY: maxY + 1,
                    lineBarsData: [
                      LineChartBarData(
                        spots: value
                            .getRoutineStats(routine.id)
                            .asMap()
                            .map((key, value) => MapEntry(
                                key, FlSpot(key.toDouble(), value.toDouble())))
                            .values
                            .toList(),
                        isCurved: true,
                        curveSmoothness: 0.5,
                        barWidth: 3,
                        color: Theme.of(context).colorScheme.primary,
                        dotData: const FlDotData(
                          show: true,
                        ),
                        belowBarData: BarAreaData(
                          show: true,
                          color: Theme.of(context)
                              .colorScheme
                              .primary
                              .withOpacity(0.4),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      );
    });
  }
}

Widget bottomTitleWidgets(
    double value, Color c, TitleMeta meta, DateTime start) {
  final style = TextStyle(
    color: c,
    fontWeight: FontWeight.bold,
    fontSize: 12,
  );

  return SideTitleWidget(
    axisSide: meta.axisSide,
    space: 8.0,
    child: Text(
        DateFormat('dd/MM').format(start.add(Duration(days: value.toInt()))),
        style: style),
  );
}

Widget leftTitleWidgets(double value, Color c, TitleMeta meta) {
  final style = TextStyle(
    color: c,
    fontWeight: FontWeight.bold,
    fontSize: 12,
  );
  if (value < 0) {
    return Container();
  }
  return Text(
    value.toInt().toString(),
    style: style,
    textAlign: TextAlign.center,
  );
}
