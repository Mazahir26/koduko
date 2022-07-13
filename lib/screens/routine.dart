import 'package:flutter/material.dart';
import 'package:koduko/components/card.dart';
import 'package:koduko/models/routine.dart';
import 'package:koduko/models/task.dart';

class RoutineScreen extends StatefulWidget {
  final Routine routine;
  const RoutineScreen({Key? key, required this.routine}) : super(key: key);

  @override
  State<RoutineScreen> createState() => RoutineScreenState();
}

class RoutineScreenState extends State<RoutineScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  List<Task> tasks = [];

  @override
  void initState() {
    _controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 10));

    tasks = widget.routine.tasks;

    super.initState();
  }

  void onDismiss(_) {
    setState(() {
      tasks.removeLast();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(80),
        child: MyAppBar(),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Stack(alignment: AlignmentDirectional.center, children: [
              const SizedBox(
                height: 300,
                child: Center(
                    child: Text(
                  "Good Work",
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 48,
                      fontWeight: FontWeight.bold),
                )),
              ),
              ...tasks
                  .asMap()
                  .entries
                  .map((e) => TaskCard(
                      name: e.value.name,
                      controller:
                          e.key == tasks.length - 1 ? _controller : null,
                      color: Color(e.value.color),
                      index: (tasks.length - 1 - e.key) * 1.0,
                      onDismissed: onDismiss))
                  .toList(),
            ])
          ],
        ),
      ),
    );
  }
}

class MyAppBar extends StatelessWidget {
  const MyAppBar({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      leadingWidth: 80,
      leading: Center(
        child: Container(
          decoration: BoxDecoration(
              border: Border.all(
                  color: Theme.of(context).primaryIconTheme.color!, width: 1),
              borderRadius: BorderRadius.circular(90)),
          child: IconButton(
            onPressed: () {},
            icon: const Icon(Icons.arrow_back_ios_new_rounded),
            color: Theme.of(context).primaryIconTheme.color,
            iconSize: 30,
          ),
        ),
      ),
      centerTitle: true,
      elevation: 0,
    );
  }
}
