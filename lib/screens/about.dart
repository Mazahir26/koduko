import 'package:flutter/gestures.dart';
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
                    RichText(
                      text: TextSpan(
                          text:
                              "Koduko is an open source habit tracker app that helps users develop and maintain positive daily habits. Users can set personalized goals and track their progress towards achieving them, as well as receive reminders to stay on track. You can find the source code and releases ",
                          style: Theme.of(context).textTheme.bodyLarge,
                          children: [
                            TextSpan(
                              text: "here",
                              recognizer: TapGestureRecognizer()
                                ..onTap = () => openUrl(Uri.parse(
                                    'https://github.com/Mazahir26/koduko')),
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge!
                                  .copyWith(
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                  ),
                            )
                          ]),
                    ),
                    const SizedBox(height: 15),
                    Text(
                      'Developer Contact',
                      style: Theme.of(context)
                          .textTheme
                          .headlineMedium!
                          .copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      "For any questions or suggestions regarding Koduko's functionality or code, You can reach me out via telegram or github",
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
                    ),
                    const SizedBox(height: 30),
                    Center(
                      child: Text(
                        "Thank You ❤️",
                        style: Theme.of(context)
                            .textTheme
                            .headlineMedium!
                            .copyWith(fontWeight: FontWeight.bold),
                      ),
                    ),
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
