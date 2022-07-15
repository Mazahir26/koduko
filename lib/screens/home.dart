import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:koduko/models/task.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context)
        .textTheme
        .apply(displayColor: Theme.of(context).colorScheme.onSurface);
    return FutureBuilder(
        future: Hive.openBox<Task>("Tasks"),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text(
                "Oops! Try again later",
                style: Theme.of(context).textTheme.displayMedium,
              ),
            );
          } else if (snapshot.hasData) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                children: [
                  Header(textTheme: textTheme),
                  SizedBox(
                    height: 200,
                    child: Card(
                      child: Container(
                        padding: const EdgeInsets.all(30),
                        child: BarChart(
                          BarChartData(
                            borderData: FlBorderData(show: false),
                            gridData: FlGridData(show: false),
                            alignment: BarChartAlignment.spaceEvenly,
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
                                    width: 12,
                                    backDrawRodData: BackgroundBarChartRodData(
                                      color: Colors.grey.withOpacity(0.5),
                                      show: true,
                                      toY: 15,
                                    ),
                                    toY: 5,
                                    color: Colors.deepPurple,
                                  ),
                                ],
                              ),
                              BarChartGroupData(
                                x: 1,
                                barRods: [
                                  BarChartRodData(
                                    width: 12,
                                    backDrawRodData: BackgroundBarChartRodData(
                                      color: Colors.grey.withOpacity(0.5),
                                      show: true,
                                      toY: 15,
                                    ),
                                    toY: 10,
                                    color: Colors.deepPurple,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            );
          }
          return const Center(child: CircularProgressIndicator());
        });
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
    return Row(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Good Morning 👋",
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
                    color: Theme.of(context)
                        .colorScheme
                        .onSurface
                        .withOpacity(0.5)),
              ),
            ),
          ],
        )
      ],
    );
  }
}

Widget getTitles(double value, TitleMeta meta) {
  const style = TextStyle(
    color: Color(0xff7589a2),
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
