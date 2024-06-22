import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:koduko/utils/duration_to_string.dart';

class TaskCard extends StatelessWidget {
  final String name;
  final AnimationController? controller;
  final Color color;
  final double index;
  final void Function(DismissDirection, BuildContext) onDismissed;
  final bool isPlaying;
  final AnimationController buttonController;
  final void Function(TapUpDetails details) onTap;
  final bool isCompleted;
  final bool isSkipped;

  late final Tween<double> tween;
  late final Color textColor;
  final bool isSwipeDisabled;
  TaskCard(
      {super.key,
      required this.name,
      required this.controller,
      required this.color,
      required this.index,
      required this.onDismissed,
      required this.isPlaying,
      required this.buttonController,
      required this.onTap,
      required this.isCompleted,
      required this.isSkipped,
      required this.isSwipeDisabled}) {
    if (controller != null) {
      if (isCompleted) {
        tween = Tween(
          begin: 0,
          end: 400,
        );
      } else if (isSkipped) {
        tween = Tween(
          begin: 0,
          end: -400,
        );
      } else {
        tween = Tween(begin: 0, end: 0);
      }
    } else {
      tween = Tween(begin: 0, end: 0);
    }

    textColor =
        color.computeLuminance() > 0.5 ? Colors.grey[800]! : Colors.white;
  }

  String get timerString {
    if (controller == null) {
      return "0:00";
    }

    Duration duration =
        controller!.duration! - (controller!.duration! * controller!.value);
    return durationToString(duration);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          minHeight: 300,
        ),
        child: TweenAnimationBuilder<double>(
          duration: const Duration(milliseconds: 300),
          tween: tween,
          onEnd: () {
            if (isSkipped) {
              onDismissed(DismissDirection.endToStart, context);
            } else if (isCompleted) {
              onDismissed(DismissDirection.startToEnd, context);
            }
          },
          builder: (context, double value, child) => Transform.translate(
            offset: Offset(value, 0),
            child: child,
          ),
          child: AnimatedRotation(
            duration: const Duration(milliseconds: 100),
            curve: Curves.easeInCirc,
            turns: index < 6 ? index / 200 : 5 / 200,
            child: AnimatedPadding(
              duration: const Duration(milliseconds: 100),
              curve: Curves.easeInCirc,
              padding: EdgeInsets.only(
                  left: index < 6 ? index * 10 : 5 * 10,
                  bottom: index < 6 ? index * 10 : 5 * 10),
              child: Dismissible(
                key: UniqueKey(),
                confirmDismiss: (direction) {
                  if (direction == DismissDirection.endToStart &&
                      isSwipeDisabled) {
                    return Future((() => false));
                  }
                  return Future((() => true));
                },
                onDismissed: ((direction) => onDismissed(direction, context)),
                child: Stack(
                  alignment: AlignmentDirectional.bottomEnd,
                  children: [
                    Container(
                      height: 300,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color:
                                Theme.of(context).shadowColor.withOpacity(0.4),
                            blurRadius: 4.0,
                            spreadRadius: 0.2,
                          )
                        ],
                      ),
                    ),
                    Container(
                      height: 300,
                      decoration: BoxDecoration(
                        color: color.withOpacity(0.4),
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    controller == null
                        ? Container(
                            height: 40,
                            decoration: BoxDecoration(
                              color: color,
                              borderRadius: BorderRadius.circular(20),
                            ),
                          )
                        : AnimatedBuilder(
                            animation: controller!,
                            builder: (context, child) {
                              return Container(
                                height: controller!.value * 260 + 40,
                                decoration: BoxDecoration(
                                  color: color,
                                  borderRadius: BorderRadius.only(
                                    bottomLeft: const Radius.circular(20),
                                    bottomRight: const Radius.circular(20),
                                    topLeft: Radius.circular(
                                      controller!.value * 15 + 5,
                                    ),
                                    topRight: Radius.circular(
                                      controller!.value * 15 + 5,
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                    // Display's the remaining time of the Task
                    Positioned(
                      bottom: 15,
                      left: 10,
                      child: controller == null
                          ? Text(
                              "0:00",
                              style: TextStyle(
                                  color: textColor,
                                  fontSize: 26,
                                  fontWeight: FontWeight.w500),
                            )
                          : AnimatedBuilder(
                              animation: controller!,
                              builder: ((context, child) => Text(
                                    timerString,
                                    style: TextStyle(
                                      color: textColor,
                                      fontSize: 26,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ))),
                    ),

                    // The Play-Pause Button on the Card
                    GestureDetector(
                      onTapUp: onTap,
                      child: Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: AnimatedIcon(
                          icon: AnimatedIcons.play_pause,
                          progress: buttonController,
                          color: textColor,
                          size: 45,
                        ),
                      ),
                    ),

                    // The Name of the Task
                    Positioned.fill(
                        child: Align(
                      child: Text(
                        name,
                        style: GoogleFonts.lato(
                          fontWeight: FontWeight.bold,
                          textStyle: Theme.of(context)
                              .textTheme
                              .apply(displayColor: textColor)
                              .displaySmall,
                        ),
                      ),
                    ))
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
