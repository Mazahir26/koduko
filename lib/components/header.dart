import 'package:flutter/material.dart';

class ScreenHeader extends StatelessWidget {
  const ScreenHeader({super.key, required this.text, required this.tag});
  final String text;
  final String tag;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 1,
          child: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.arrow_back_ios,
              size: 30,
            ),
          ),
        ),
        Expanded(
          flex: 10,
          child: Hero(
            tag: tag,
            child: Text(
              text,
              style: Theme.of(context)
                  .textTheme
                  .headlineLarge!
                  .apply(color: Theme.of(context).colorScheme.onSurface),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ],
    );
  }
}
