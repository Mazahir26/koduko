import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class WeeklyChart extends StatelessWidget {
  const WeeklyChart({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
        color: Theme.of(context).colorScheme.onSurface,
        child: SizedBox(
          height: 280,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: Text(
                    "Weekly Activity",
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium!
                        .apply(color: Colors.white),
                  ),
                ),
                SizedBox(
                  height: 200,
                  child: BarChart(
                    BarChartData(
                      borderData: FlBorderData(show: false),
                      gridData: FlGridData(show: false),
                      alignment: BarChartAlignment.spaceAround,
                      titlesData: FlTitlesData(
                        show: true,
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            reservedSize: 30,
                            getTitlesWidget: getTitles,
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
                      barGroups: [
                        BarChartGroupData(
                          x: 0,
                          barRods: [
                            BarChartRodData(
                              width: 15,
                              backDrawRodData: BackgroundBarChartRodData(
                                color: Colors.white.withOpacity(0.2),
                                show: true,
                                toY: 15,
                              ),
                              toY: 5,
                              color: Colors.white,
                            ),
                          ],
                        ),
                        BarChartGroupData(
                          x: 1,
                          barRods: [
                            BarChartRodData(
                              width: 15,
                              backDrawRodData: BackgroundBarChartRodData(
                                color: Colors.white.withOpacity(0.2),
                                show: true,
                                toY: 15,
                              ),
                              toY: 6,
                              color: Colors.white,
                            ),
                          ],
                        ),
                        BarChartGroupData(
                          x: 2,
                          barRods: [
                            BarChartRodData(
                              width: 15,
                              backDrawRodData: BackgroundBarChartRodData(
                                color: Colors.white.withOpacity(0.2),
                                show: true,
                                toY: 15,
                              ),
                              toY: 8,
                              color: Colors.white,
                            ),
                          ],
                        ),
                        BarChartGroupData(
                          x: 1,
                          barRods: [
                            BarChartRodData(
                              width: 15,
                              backDrawRodData: BackgroundBarChartRodData(
                                color: Colors.white.withOpacity(0.2),
                                show: true,
                                toY: 15,
                              ),
                              toY: 12,
                              color: Colors.white,
                            ),
                          ],
                        ),
                        BarChartGroupData(
                          x: 1,
                          barRods: [
                            BarChartRodData(
                              width: 15,
                              backDrawRodData: BackgroundBarChartRodData(
                                color: Colors.white.withOpacity(0.2),
                                show: true,
                                toY: 15,
                              ),
                              toY: 15,
                              color: Colors.white,
                            ),
                          ],
                        ),
                        BarChartGroupData(
                          x: 1,
                          barRods: [
                            BarChartRodData(
                              width: 15,
                              backDrawRodData: BackgroundBarChartRodData(
                                color: Colors.white.withOpacity(0.2),
                                show: true,
                                toY: 15,
                              ),
                              toY: 10,
                              color: Colors.white,
                            ),
                          ],
                        ),
                        BarChartGroupData(
                          x: 1,
                          barRods: [
                            BarChartRodData(
                              width: 15,
                              backDrawRodData: BackgroundBarChartRodData(
                                color: Colors.white.withOpacity(0.2),
                                show: true,
                                toY: 15,
                              ),
                              toY: 10,
                              color: Colors.white,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}

Widget getTitles(double value, TitleMeta meta) {
  const style = TextStyle(
    color: Colors.white,
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
