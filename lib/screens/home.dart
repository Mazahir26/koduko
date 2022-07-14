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
              padding: const EdgeInsets.only(top: 45, left: 20),
              child: Column(
                children: [
                  Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Good Morning",
                            style: GoogleFonts.lato(
                                fontWeight: FontWeight.bold,
                                textStyle: textTheme.headlineLarge),
                          ),
                          Text(
                            DateFormat.MMMMEEEEd().format(DateTime.now()),
                            style: GoogleFonts.lato(
                              fontWeight: FontWeight.w400,
                              textStyle: Theme.of(context)
                                  .textTheme
                                  .titleLarge!
                                  .apply(color: Colors.grey[700]),
                            ),
                          ),
                        ],
                      )
                    ],
                  )
                ],
              ),
            );
          }
          return const Center(child: CircularProgressIndicator());
        });
  }
}
