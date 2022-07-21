import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
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
