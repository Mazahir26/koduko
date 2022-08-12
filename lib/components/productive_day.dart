import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:koduko/services/routines_provider.dart';
import 'package:provider/provider.dart';

class ProductiveDay extends StatelessWidget {
  const ProductiveDay({Key? key, required this.textTheme}) : super(key: key);
  final TextTheme textTheme;

  @override
  Widget build(BuildContext context) {
    return Card(
        child: Selector<RoutineModel, DateTime?>(
      selector: (p0, p1) => p1.getMostProductiveDay(),
      builder: (context, value, child) => Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            const SizedBox(height: 15),
            Text(
              "Most Productive Day",
              style: textTheme.titleSmall,
            ),
            const SizedBox(height: 10),
            Text(
              value == null ? 'NaN' : DateFormat('EEEE').format(value),
              style: textTheme.headlineLarge,
            ),
            const SizedBox(height: 15),
          ],
        ),
      ),
    ));
  }
}
