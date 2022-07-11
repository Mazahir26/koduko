import 'package:flutter/material.dart';

class StartRoutineScreen extends StatefulWidget {
  const StartRoutineScreen({Key? key}) : super(key: key);

  @override
  State<StartRoutineScreen> createState() => StartRoutineScreenState();
}

class StartRoutineScreenState extends State<StartRoutineScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(
          onPressed: () {},
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          color: Colors.grey,
          iconSize: 35,
        ),
        centerTitle: true,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.clear_rounded),
            color: Colors.grey,
            iconSize: 35,
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 5),
        child: Column(
          children: const [],
        ),
      ),
    );
  }
}
