import 'package:flutter/material.dart';
import 'package:koduko/components/header.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({Key? key}) : super(key: key);
  static const routeName = "/about";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: const [
            SizedBox(height: 25),
            ScreenHeader(
              text: "About",
              tag: "About",
            ),
            SizedBox(height: 25),
            Text("Something interesting about the app"),
          ],
        ),
      ),
    );
  }
}
