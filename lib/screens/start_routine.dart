import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:koduko/components/card.dart';
import 'package:koduko/models/routine.dart';
import 'package:koduko/models/task.dart';
import 'package:koduko/services/routines_provider.dart';
import 'package:koduko/services/theme_provider.dart';
import 'package:koduko/utils/colors_util.dart';
import 'package:koduko/utils/parse_duration.dart';
import 'package:provider/provider.dart';

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
  bool _isComplete = false;
  bool _isSkipped = false;
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (widget.routine.isCompleted) {
        Provider.of<RoutineModel>(context, listen: false)
            .replay(widget.routine.id);
        _controller.duration = parseDuration(
          Provider.of<RoutineModel>(context, listen: false)
              .getRoutine(widget.routine.id)!
              .tasks
              .first
              .duration,
        );
      } else {
        _controller.duration = parseDuration(
          Provider.of<RoutineModel>(context, listen: false)
              .getRoutine(widget.routine.id)!
              .inCompletedTasks
              .first
              .duration,
        );
      }
    });
    _controller =
        AnimationController(vsync: this, duration: const Duration(minutes: 1));
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

  void onTap(TapUpDetails? _) {
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

  void onDismiss(DismissDirection t, BuildContext context) {
    if (t == DismissDirection.endToStart) {
      Provider.of<RoutineModel>(context, listen: false)
          .skipTask(widget.routine.id);
      setState(() {
        _controller.reset();
        if (_isSkipped) {
          _isSkipped = false;
        }
      });
      var ts = Provider.of<RoutineModel>(context, listen: false)
          .getRoutine(widget.routine.id)!
          .inCompletedTasks;
      if (ts.isNotEmpty) {
        _controller.duration = parseDuration(ts.first.duration);
        if (_isPlaying) {
          _controller.forward();
        }
      }
    } else if (t == DismissDirection.startToEnd) {
      Provider.of<RoutineModel>(context, listen: false)
          .completeTask(widget.routine.id);
      _controller.reset();
      setState(() {
        if (_isComplete) {
          _isComplete = false;
        }
      });
      var ts = Provider.of<RoutineModel>(context, listen: false)
          .getRoutine(widget.routine.id)!
          .inCompletedTasks;
      if (ts.isNotEmpty) {
        _controller.duration = parseDuration(ts.first.duration);
        if (_isPlaying) {
          _controller.forward();
        }
      }
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
      appBar: AppBar(
        centerTitle: true,
        leading: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
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
        title: Selector<RoutineModel, String>(
          selector: (p0, p1) => p1.getRoutine(widget.routine.id)!.name,
          builder: (context, value, child) => Hero(
            tag: value,
            child: Text(
              value,
              style: GoogleFonts.lato(
                fontWeight: FontWeight.bold,
                textStyle: Theme.of(context)
                    .textTheme
                    .apply(
                        displayColor: Theme.of(context).colorScheme.onSurface)
                    .headlineLarge,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
        child: Selector<RoutineModel, List<Task>>(
          selector: (p0, p1) =>
              p1.getRoutine(widget.routine.id)!.inCompletedTasks,
          builder: ((context, value, child) => Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    flex: 7,
                    child: Stack(
                      alignment: AlignmentDirectional.center,
                      children: [
                        SizedBox(
                          height: 300,
                          child: Center(
                            child: Text("Good Work",
                                style: GoogleFonts.lato(
                                  fontWeight: FontWeight.bold,
                                  textStyle: Theme.of(context)
                                      .textTheme
                                      .displayMedium!
                                      .apply(
                                          color: Theme.of(context)
                                              .textTheme
                                              .bodyMedium!
                                              .color),
                                )),
                          ),
                        ),
                        ...value
                            .asMap()
                            .entries
                            .map((e) => Consumer<ThemeModel>(
                                  builder: (context, themeData, child) =>
                                      TaskCard(
                                    isSwipeDisabled: value.length == 1,
                                    isSkipped: _isSkipped,
                                    isCompleted: _isComplete,
                                    buttonController: _buttonController,
                                    isPlaying: _isPlaying,
                                    onTap: onTap,
                                    name: e.value.name,
                                    controller: e.key == 0 ? _controller : null,
                                    color: themeData.isDark()
                                        ? darken(Color(e.value.color))
                                        : Color(e.value.color),
                                    index: (e.key) * 1.0,
                                    onDismissed: onDismiss,
                                  ),
                                ))
                            .toList()
                            .reversed,
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: TweenAnimationBuilder<double>(
                        duration: const Duration(milliseconds: 350),
                        tween: Tween(begin: 0, end: value.isEmpty ? 300 : 0),
                        curve: Curves.easeInCirc,
                        builder: ((context, double value, child) =>
                            Transform.translate(
                              offset: Offset(0, value),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Expanded(
                                    flex: 1,
                                    child: TextButton(
                                      onPressed: () {
                                        setState(() {
                                          _isSkipped = true;
                                        });
                                      },
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: const [
                                          Icon(Icons.swipe_left_rounded),
                                          SizedBox(height: 10),
                                          Text("Skip"),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                      flex: 1,
                                      child: ElevatedButton(
                                        onPressed: () {
                                          onTap(null);
                                        },
                                        style: ButtonStyle(
                                          elevation:
                                              MaterialStateProperty.all<double>(
                                                  6),
                                          shape: MaterialStateProperty.all(
                                              const CircleBorder()),
                                          padding: MaterialStateProperty.all(
                                              const EdgeInsets.all(15)),
                                        ),
                                        child: AnimatedIcon(
                                          icon: AnimatedIcons.play_pause,
                                          progress: _buttonController,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .primary,
                                          size: 50,
                                        ),
                                      )),
                                  Expanded(
                                    flex: 1,
                                    child: TextButton(
                                      onPressed: () {
                                        setState(() {
                                          _isComplete = true;
                                        });
                                      },
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: const [
                                          Icon(Icons.swipe_right_rounded),
                                          SizedBox(height: 10),
                                          Text("Completed"),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ))),
                  )
                ],
              )),
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
