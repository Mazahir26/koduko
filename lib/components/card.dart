import 'package:vector_math/vector_math.dart' show radians;
import 'package:flutter/material.dart';

class TaskCard extends StatefulWidget {
  final String name;
  final AnimationController? controller;
  final Color color;
  final double index;
  final void Function(DismissDirection direction) onDismissed;

  const TaskCard({
    Key? key,
    required this.name,
    required this.controller,
    required this.color,
    required this.index,
    required this.onDismissed,
  }) : super(key: key);

  @override
  State<TaskCard> createState() => _TaskCardState();
}

class _TaskCardState extends State<TaskCard>
    with SingleTickerProviderStateMixin<TaskCard> {
  late AnimationController _buttonController;

  bool _isPlaying = false;
  @override
  void initState() {
    _buttonController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 250));
    super.initState();
  }

  @override
  void dispose() {
    _buttonController.dispose();
    super.dispose();
  }

  void onTap(TapUpDetails _) {
    if (widget.controller == null) {
      return;
    }
    if (_isPlaying) {
      setState(() {
        _isPlaying = false;
      });
      widget.controller!.stop();
      _buttonController.reverse();
    } else {
      setState(() {
        _isPlaying = true;
      });
      widget.controller!.forward();
      _buttonController.forward();
    }
  }

  String get timerString {
    if (widget.controller == null) {
      return "0:00";
    }
    Duration duration = widget.controller!.duration! * widget.controller!.value;
    return '${duration.inMinutes}:${(duration.inSeconds % 60).toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          minHeight: 300,
        ),
        child: Transform.rotate(
          angle: widget.controller != null
              ? radians(0)
              : -(radians((widget.index * 2.0))),
          child: Transform.translate(
            offset: Offset(-5.0 * widget.index.toDouble(), 0.0),
            child: Dismissible(
              key: Key(widget.name),
              onDismissed: widget.onDismissed,
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
                          ])),
                  Container(
                      height: 300,
                      decoration: BoxDecoration(
                        color: widget.color.withOpacity(0.4),
                        borderRadius: BorderRadius.circular(20),
                      )),
                  widget.controller == null
                      ? Container(
                          height: 40,
                          decoration: BoxDecoration(
                              color: widget.color,
                              borderRadius: BorderRadius.circular(20)))
                      : AnimatedBuilder(
                          animation: widget.controller!,
                          builder: (context, child) {
                            return Container(
                              height: widget.controller!.value * 260 + 40,
                              decoration: BoxDecoration(
                                  color: widget.color,
                                  borderRadius: BorderRadius.only(
                                    bottomLeft: const Radius.circular(20),
                                    bottomRight: const Radius.circular(20),
                                    topLeft: Radius.circular(
                                        widget.controller!.value * 15 + 5),
                                    topRight: Radius.circular(
                                        widget.controller!.value * 15 + 5),
                                  )),
                            );
                          }),
                  Positioned(
                    bottom: 15,
                    left: 10,
                    child: widget.controller == null
                        ? const Text(
                            "0:00",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 26,
                                fontWeight: FontWeight.w500),
                          )
                        : AnimatedBuilder(
                            animation: widget.controller!,
                            builder: ((context, child) => Text(
                                  timerString,
                                  style: const TextStyle(
                                    color: Colors.white,
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
                        progress: _buttonController,
                        color: Colors.white,
                        size: 45,
                      ),
                    ),
                  ),
                  Positioned(
                      top: 125,
                      left: 125,
                      child: Text(
                        widget.name,
                        style: const TextStyle(
                          fontSize: 40,
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                        ),
                      ))
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
