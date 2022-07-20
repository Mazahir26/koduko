import 'package:flutter/material.dart';
import 'package:koduko/components/card.dart';
import 'package:koduko/models/routine.dart';
import 'package:koduko/models/task.dart';
import 'package:koduko/utils/parse_duration.dart';

class RoutineScreen extends StatefulWidget {
  final Routine routine;
  const RoutineScreen({Key? key, required this.routine}) : super(key: key);

  @override
  State<RoutineScreen> createState() => RoutineScreenState();
}

class RoutineScreenState extends State<RoutineScreen>
    with TickerProviderStateMixin {
  late final AnimationController _controller;
  late final AnimationController _buttonController;

  bool _isPlaying = false;
  List<Task> tasks = [];
  bool _isComplete = false;

  @override
  void initState() {
    tasks = List.from(widget.routine.tasks);
    _controller = AnimationController(
        vsync: this, duration: parseDuration(tasks.first.duration));

    _buttonController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 250));
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() {
          _isComplete = true;
        });
      }
    });
    super.initState();
  }

  void onTap(TapUpDetails _) {
    if (_isPlaying) {
      setState(() {
        _isPlaying = false;
      });
      _controller.stop();
      _buttonController.reverse();
    } else {
      setState(() {
        _isPlaying = true;
      });
      _controller.forward();
      _buttonController.forward();
    }
  }

  void onDismiss(_) {
    setState(() {
      if (_isComplete) {
        _isComplete = false;
      }
      tasks.removeAt(0);
    });
    _controller.reset();
    if (tasks.isNotEmpty) {
      _controller.duration = parseDuration(tasks.first.duration);
    }
    if (_isPlaying) {
      _controller.forward();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _buttonController.dispose();

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
            Stack(
              alignment: AlignmentDirectional.center,
              children: [
                const SizedBox(
                  height: 300,
                  child: Center(
                      child: Text(
                    "Good Work",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                    ),
                  )),
                ),
                ...tasks
                    .asMap()
                    .entries
                    .map((e) => TaskCard(
                          isCompleted: _isComplete,
                          buttonController: _buttonController,
                          isPlaying: _isPlaying,
                          onTap: onTap,
                          name: e.value.name,
                          controller: e.key == 0 ? _controller : null,
                          color: Color(e.value.color),
                          index: (e.key) * 1.0,
                          onDismissed: onDismiss,
                        ))
                    .toList()
                    .reversed,
              ],
            )
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
