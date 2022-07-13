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
        leadingWidth: 80,
        leading: Center(
          child: Container(
            decoration: BoxDecoration(
                border: Border.all(color: Colors.grey, width: 1.5),
                borderRadius: BorderRadius.circular(90)),
            child: IconButton(
              onPressed: () {},
              icon: const Icon(Icons.arrow_back_ios_new_rounded),
              color: Colors.grey,
              iconSize: 35,
            ),
          ),
        ),
        centerTitle: true,
        elevation: 0,
        actions: [
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
                border: Border.all(color: Colors.grey, width: 1.5),
                borderRadius: BorderRadius.circular(90)),
            child: IconButton(
              onPressed: () {},
              icon: const Icon(Icons.clear_rounded),
              color: Colors.grey,
              iconSize: 35,
            ),
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
