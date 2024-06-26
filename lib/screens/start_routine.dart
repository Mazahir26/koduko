import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:koduko/components/card.dart';
import 'package:koduko/models/task.dart';
import 'package:koduko/services/notification_service.dart';
import 'package:koduko/services/routines_provider.dart';
import 'package:koduko/services/theme_provider.dart';
import 'package:koduko/utils/colors_util.dart';
import 'package:koduko/utils/parse_duration.dart';
import 'package:provider/provider.dart';

class RoutineScreen extends StatefulWidget {
  final String routine;
  const RoutineScreen({super.key, required this.routine});

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

  DateTime _playedOn = DateTime.now();

  @override
  void initState() {
    _controller =
        AnimationController(vsync: this, duration: const Duration(minutes: 1));
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      var routine = Provider.of<RoutineModel>(context, listen: false)
          .getRoutine(widget.routine);
      if (routine == null) {
        return;
      }
      if (routine.isCompleted) {
        Provider.of<RoutineModel>(context, listen: false).replay(routine.id);
        _controller.duration = parseDuration(
          Provider.of<RoutineModel>(context, listen: false)
              .getRoutine(routine.id)!
              .tasks
              .first
              .duration,
        );
      } else {
        _controller.duration = parseDuration(
          Provider.of<RoutineModel>(context, listen: false)
              .getRoutine(routine.id)!
              .inCompletedTasks
              .first
              .duration,
        );
      }
      setState(() {
        _isPlaying = false;
      });
    });

    _buttonController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 250));
    _controller.addListener(() {
      if (_controller.status == AnimationStatus.forward) {
        final diff = DateTime.now().difference(_playedOn);

        //Check if the difference is more that 100 milliseconds
        if ((diff - (_controller.duration! * _controller.value))
                .abs()
                .inMilliseconds >
            100) {
          _controller.forward(
              from: (diff.inMilliseconds / _controller.duration!.inMilliseconds)
                  .clamp(0, 1));
        }
      }
    });

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        NotificationService().cancelNotificationWithId(777);
        setState(() {
          _isComplete = true;
        });
      }
    });
    super.initState();
  }

  void onTap(TapUpDetails? _) async {
    final task = Provider.of<RoutineModel>(context, listen: false)
        .getRoutine(widget.routine)!
        .inCompletedTasks
        .first;
    if (_isPlaying) {
      setState(() {
        _isPlaying = false;
      });

      NotificationService().cancelNotification(task.id + widget.routine);

      _controller.stop();
      _buttonController.reverse();
    } else {
      Duration d = (_controller.duration! * _controller.value);
      setState(() {
        _playedOn = DateTime.now().subtract(d);
        _isPlaying = true;
      });
      NotificationService().scheduledNotification((_controller.duration! - d),
          task.id + widget.routine, task.name, 'Completed!');
      _controller.forward();
      _buttonController.forward();
    }
  }

  void onDismiss(DismissDirection t, BuildContext context) {
    final task = Provider.of<RoutineModel>(context, listen: false)
        .getRoutine(widget.routine)!
        .inCompletedTasks
        .first;
    NotificationService().cancelNotification(task.id + widget.routine);
    if (t == DismissDirection.endToStart) {
      Provider.of<RoutineModel>(context, listen: false)
          .skipTask(widget.routine);
      setState(() {
        _controller.reset();
        if (_isSkipped) {
          _isSkipped = false;
          if (_isPlaying) {
            _isPlaying = false;
            _buttonController.reverse();
          }
        }
      });
      var ts = Provider.of<RoutineModel>(context, listen: false)
          .getRoutine(widget.routine)!
          .inCompletedTasks;
      if (ts.isNotEmpty) {
        _controller.duration = parseDuration(ts.first.duration);
      }
    } else if (t == DismissDirection.startToEnd) {
      Provider.of<RoutineModel>(context, listen: false)
          .completeTask(widget.routine);
      _controller.reset();
      setState(() {
        if (_isPlaying) {
          _isPlaying = false;
          _buttonController.reverse();
        }
        if (_isComplete) {
          _isComplete = false;
          _playedOn = DateTime.now();
        }
      });
      var ts = Provider.of<RoutineModel>(context, listen: false)
          .getRoutine(widget.routine)!
          .inCompletedTasks;
      if (ts.isNotEmpty) {
        _controller.duration = parseDuration(ts.first.duration);
      }
    }
  }

  @override
  void dispose() {
    NotificationService().cancelNotificationWithId(777);
    _controller.dispose();
    _buttonController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion(
      value: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        systemNavigationBarColor:
            Theme.of(context).brightness == Brightness.dark
                ? Colors.black
                : Colors.white,
        statusBarIconBrightness: Theme.of(context).brightness == Brightness.dark
            ? Brightness.light
            : Brightness.dark,
        systemNavigationBarIconBrightness:
            Theme.of(context).brightness == Brightness.dark
                ? Brightness.light
                : Brightness.dark,
      ),
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          leading: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: IconButton(
              onPressed: () {
                if (Provider.of<RoutineModel>(context, listen: false)
                    .getRoutine(widget.routine)!
                    .inCompletedTasks
                    .isNotEmpty) {
                  final task = Provider.of<RoutineModel>(context, listen: false)
                      .getRoutine(widget.routine)!
                      .inCompletedTasks
                      .first;
                  NotificationService()
                      .cancelNotification(task.id + widget.routine);
                }

                Navigator.pop(context);
              },
              icon: const Icon(
                Icons.arrow_back_ios,
                size: 30,
              ),
            ),
          ),
          title: Selector<RoutineModel, String>(
            selector: (p0, p1) => p1.getRoutine(widget.routine)!.name,
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
                p1.getRoutine(widget.routine)!.inCompletedTasks,
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
                              .map(
                                (e) => Consumer<ThemeModel>(
                                    builder: (context, themeData, child) {
                                  bool isSwipeDis = false;
                                  if (e.key == 0) {
                                    int count = 0;
                                    for (var element in value) {
                                      if (element.id == e.value.id) {
                                        count++;
                                      }
                                    }
                                    if (count == value.length) {
                                      isSwipeDis = true;
                                    }
                                  }
                                  return TaskCard(
                                    isSwipeDisabled:
                                        value.length == 1 || isSwipeDis,
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
                                  );
                                }),
                              )
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
                                        child: const Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
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
                                            elevation: WidgetStateProperty
                                                .all<double>(6),
                                            shape: WidgetStateProperty.all(
                                                const CircleBorder()),
                                            padding: WidgetStateProperty.all(
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
                                        child: const Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
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
      ),
    );
  }
}

class MyAppBar extends StatelessWidget {
  const MyAppBar({
    super.key,
  });

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
