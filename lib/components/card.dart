import 'package:flutter/material.dart';
import 'package:koduko/utils/duration_to_string.dart';

// class TaskCard extends StatelessWidget {
//   final String name;
//   final AnimationController? controller;
//   final Color color;
//   final double index;
//   final void Function(DismissDirection direction) onDismissed;
//   final bool isPlaying;
//   final AnimationController buttonController;
//   const TaskCard({
//     Key? key,
//     required this.name,
//     required this.controller,
//     required this.color,
//     required this.index,
//     required this.onDismissed,
//     required this.isPlaying, required this.buttonController,
//   }) : super(key: key);

// }

class TaskCard extends StatelessWidget {
  final String name;
  final AnimationController? controller;
  final Color color;
  final double index;
  final void Function(DismissDirection direction) onDismissed;
  final bool isPlaying;
  final AnimationController buttonController;
  final void Function(TapUpDetails details) onTap;
  final bool isCompleted;

  late final Tween<double> tween;
  late final Color textColor;

  TaskCard({
    Key? key,
    required this.name,
    required this.controller,
    required this.color,
    required this.index,
    required this.onDismissed,
    required this.isPlaying,
    required this.buttonController,
    required this.onTap,
    required this.isCompleted,
  }) : super(key: key) {
    if (controller != null) {
      tween = Tween(begin: 0, end: isCompleted ? -400 : 0);
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

    Duration duration = controller!.duration! * controller!.value;
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
            onDismissed(DismissDirection.vertical);
          },
          builder: (context, double value, child) => Transform.translate(
            offset: Offset(value, 0),
            child: child,
          ),
          child: AnimatedRotation(
            duration: const Duration(milliseconds: 100),
            curve: Curves.bounceIn,
            turns: index / 200,
            child: AnimatedPadding(
              duration: const Duration(milliseconds: 100),
              curve: Curves.easeInOutQuad,
              padding: EdgeInsets.only(left: index * 10, bottom: index * 10),
              child: Dismissible(
                key: Key(name),
                onDismissed: onDismissed,
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
                            color: Colors.grey[300]!,
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
                    Positioned(
                        top: 125,
                        left: 125,
                        child: Text(
                          name,
                          style: TextStyle(
                            fontSize: 40,
                            color: textColor,
                            fontWeight: FontWeight.w500,
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
