import 'package:flutter/material.dart';
import 'package:koduko/components/header.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});
  static const routeName = "/about";

  @override
  Widget build(BuildContext context) {
    Future<void> openUrl(url) async {
      if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
        throw 'Could not launch $url';
      }
    }

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 25),
              const ScreenHeader(
                text: "About",
                tag: "About",
              ),
              const SizedBox(height: 25),
              Padding(
                padding: const EdgeInsets.all(15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "This an Open source app made with flutter.",
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    const SizedBox(height: 10),
                    Center(
                        child: TextButton(
                            onPressed: () {
                              openUrl(Uri.parse(
                                  'https://github.com/Mazahir26/koduko'));
                            },
                            child: const Text("Source Code"))),
                    const SizedBox(height: 15),
                    Text(
                      'Developer Contact',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        TextButton(
                            onPressed: () {
                              openUrl(
                                  Uri.parse('https://github.com/Mazahir26'));
                            },
                            child: const Text("GitHub")),
                        TextButton(
                            onPressed: () {
                              openUrl(Uri.parse('https://t.me/mazahir26'));
                            },
                            child: const Text("Telegram"))
                      ],
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
