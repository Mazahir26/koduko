import 'package:flutter/material.dart';

class TaskCard extends StatefulWidget {
  const TaskCard({Key? key}) : super(key: key);

  @override
  State<TaskCard> createState() => _TaskCardState();
}

class _TaskCardState extends State<TaskCard>
    with TickerProviderStateMixin<TaskCard> {
  late AnimationController _controller;
  late AnimationController _buttonController;

  bool _isPlaying = false;
  @override
  void initState() {
    _controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 15));
    _buttonController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 250));

    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    _buttonController.dispose();
    super.dispose();
  }

  String get timerString {
    Duration duration = _controller.duration! * _controller.value;
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
          child: Stack(
            alignment: AlignmentDirectional.bottomEnd,
            children: [
              Container(
                  height: 300,
                  decoration: BoxDecoration(
                    color: Colors.redAccent.withOpacity(0.4),
                    borderRadius: BorderRadius.circular(20),
                  )),
              AnimatedBuilder(
                  animation: _controller,
                  builder: (context, child) {
                    return Container(
                      height: _controller.value * 260 + 40,
                      decoration: BoxDecoration(
                          color: Colors.redAccent,
                          borderRadius: BorderRadius.only(
                            bottomLeft: const Radius.circular(20),
                            bottomRight: const Radius.circular(20),
                            topLeft:
                                Radius.circular(_controller.value * 15 + 5),
                            topRight:
                                Radius.circular(_controller.value * 15 + 5),
                          )),
                    );
                  }),
              Positioned(
                bottom: 15,
                left: 10,
                child: AnimatedBuilder(
                    animation: _controller,
                    builder: ((context, child) => Text(
                          timerString,
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 26,
                              fontWeight: FontWeight.w500),
                        ))),
              ),
              GestureDetector(
                onTapUp: (_) {
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
                },
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
            ],
          ),
        ));
  }
}
