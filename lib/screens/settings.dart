import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:koduko/screens/about.dart';
import 'package:koduko/screens/stats.dart';
import 'package:koduko/screens/tasks.dart';
import 'package:koduko/services/theme_provider.dart';
import 'package:provider/provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context)
        .textTheme
        .apply(displayColor: Theme.of(context).colorScheme.onSurface);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: ListView(
        children: [
          const SizedBox(height: 35),
          Text(
            "Settings",
            style: GoogleFonts.lato(
              fontWeight: FontWeight.bold,
              textStyle: textTheme.headlineLarge,
            ),
          ),
          const SizedBox(height: 30),
          Card(
            margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 8),
            child: InkWell(
              onTap: () => Navigator.pushNamed(context, TasksScreen.routeName),
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Hero(
                      tag: "My Tasks",
                      child: Text(
                        "My Tasks",
                        style: textTheme.titleLarge,
                      ),
                    ),
                    IconButton(
                        onPressed: () =>
                            Navigator.pushNamed(context, TasksScreen.routeName),
                        icon: const Icon(Icons.chevron_right_rounded)),
                  ],
                ),
              ),
            ),
          ),
          Card(
            margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 8),
            child: InkWell(
              onTap: () => Navigator.pushNamed(context, Statistics.routeName),
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Hero(
                      tag: "Statistics",
                      child: Text(
                        "Statistics",
                        style: textTheme.titleLarge,
                      ),
                    ),
                    IconButton(
                        onPressed: () =>
                            Navigator.pushNamed(context, Statistics.routeName),
                        icon: const Icon(Icons.chevron_right_rounded)),
                  ],
                ),
              ),
            ),
          ),
          Card(
            margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 8),
            child: InkWell(
              onTap: () {
                Provider.of<ThemeModel>(context, listen: false).toggleTheme();
              },
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Dark Mode",
                      style: textTheme.titleLarge,
                    ),
                    IconButton(
                      onPressed: () {
                        Provider.of<ThemeModel>(context, listen: false)
                            .toggleTheme();
                      },
                      icon: Consumer<ThemeModel>(
                          builder: (context, value, child) =>
                              value.getTheme == ThemeMode.dark
                                  ? const Icon(Icons.dark_mode_rounded)
                                  : const Icon(Icons.light_mode_rounded)),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Card(
            margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 8),
            child: InkWell(
              onTap: () {},
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Notifications ",
                      style: textTheme.titleLarge,
                    ),
                    IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.notifications_active_rounded)),
                  ],
                ),
              ),
            ),
          ),
          Card(
            margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 8),
            child: InkWell(
              onTap: () => Navigator.pushNamed(context, AboutScreen.routeName),
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "About ",
                      style: textTheme.titleLarge,
                    ),
                    IconButton(
                        onPressed: () =>
                            Navigator.pushNamed(context, AboutScreen.routeName),
                        icon: const Icon(Icons.person)),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 25),
          Center(
            child: Text(
              "Version: 0.1 beta",
              style: textTheme.labelMedium!
                  .apply(color: textTheme.labelMedium!.color!.withOpacity(0.5)),
            ),
          ),
          const SizedBox(height: 5),
          Center(
            child: Text(
              "Made in India with ❤️",
              style: textTheme.labelMedium!
                  .apply(color: textTheme.labelMedium!.color!.withOpacity(0.5)),
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}