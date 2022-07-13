import 'package:flutter/material.dart';
import 'package:koduko/components/card.dart';

class StartRoutineScreen extends StatefulWidget {
  const StartRoutineScreen({Key? key}) : super(key: key);

  @override
  State<StartRoutineScreen> createState() => StartRoutineScreenState();
}

class StartRoutineScreenState extends State<StartRoutineScreen> {
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
          children: const [TaskCard()],
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
