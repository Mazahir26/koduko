import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:koduko/components/weekly_chart.dart';
import 'package:koduko/utils/greetings.dart';
// import 'package:koduko/components/weekly_chart.dart';
// import 'package:koduko/models/task.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context)
        .textTheme
        .apply(displayColor: Theme.of(context).colorScheme.onSurface);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
      child: Column(
        children: [
          Header(textTheme: textTheme),
          const SizedBox(height: 30),
        ],
      ),
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
        const SizedBox(height: 20),
        Card(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Text("Weekly Activity",
                    style: Theme.of(context).textTheme.titleMedium!),
              ),
              SizedBox(
                height: 160,
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
                    barGroups: [
                      BarChartGroupData(
                        x: 0,
                        barRods: [
                          BarChartRodData(
                            width: 15,
                            backDrawRodData: BackgroundBarChartRodData(
                              color:
                                  Theme.of(context).colorScheme.surfaceVariant,
                              show: true,
                              toY: 15,
                            ),
                            toY: 5,
                            color: Theme.of(context).colorScheme.inversePrimary,
                          ),
                        ],
                      ),
                      BarChartGroupData(
                        x: 1,
                        barRods: [
                          BarChartRodData(
                            width: 15,
                            backDrawRodData: BackgroundBarChartRodData(
                              color:
                                  Theme.of(context).colorScheme.surfaceVariant,
                              show: true,
                              toY: 15,
                            ),
                            toY: 6,
                            color: Theme.of(context).colorScheme.inversePrimary,
                          ),
                        ],
                      ),
                      BarChartGroupData(
                        x: 2,
                        barRods: [
                          BarChartRodData(
                            width: 15,
                            backDrawRodData: BackgroundBarChartRodData(
                              color:
                                  Theme.of(context).colorScheme.surfaceVariant,
                              show: true,
                              toY: 15,
                            ),
                            toY: 8,
                            color: Theme.of(context).colorScheme.inversePrimary,
                          ),
                        ],
                      ),
                      BarChartGroupData(
                        x: 1,
                        barRods: [
                          BarChartRodData(
                            width: 15,
                            backDrawRodData: BackgroundBarChartRodData(
                              color:
                                  Theme.of(context).colorScheme.surfaceVariant,
                              show: true,
                              toY: 15,
                            ),
                            toY: 12,
                            color: Theme.of(context).colorScheme.inversePrimary,
                          ),
                        ],
                      ),
                      BarChartGroupData(
                        x: 1,
                        barRods: [
                          BarChartRodData(
                            width: 15,
                            backDrawRodData: BackgroundBarChartRodData(
                              color:
                                  Theme.of(context).colorScheme.surfaceVariant,
                              show: true,
                              toY: 15,
                            ),
                            toY: 15,
                            color: Theme.of(context).colorScheme.inversePrimary,
                          ),
                        ],
                      ),
                      BarChartGroupData(
                        x: 1,
                        barRods: [
                          BarChartRodData(
                            width: 15,
                            backDrawRodData: BackgroundBarChartRodData(
                              color:
                                  Theme.of(context).colorScheme.surfaceVariant,
                              show: true,
                              toY: 15,
                            ),
                            toY: 10,
                            color: Theme.of(context).colorScheme.inversePrimary,
                          ),
                        ],
                      ),
                      BarChartGroupData(
                        x: 1,
                        barRods: [
                          BarChartRodData(
                            width: 15,
                            backDrawRodData: BackgroundBarChartRodData(
                              color:
                                  Theme.of(context).colorScheme.surfaceVariant,
                              show: true,
                              toY: 15,
                            ),
                            toY: 10,
                            color: Theme.of(context).colorScheme.inversePrimary,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
}
