import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/adapters.dart';

class OnBoarding extends StatefulWidget {
  const OnBoarding({super.key});
  static const routeName = "/onBoarding";

  @override
  State<OnBoarding> createState() => _OnBoardingState();
}

class _OnBoardingState extends State<OnBoarding> {
  int _index = 0;
  late final PageController _pageController;

  final okColors = [
    const Color.fromRGBO(251, 187, 91, 1),
    const Color.fromRGBO(44, 155, 243, 1),
    const Color.fromRGBO(67, 60, 85, 1),
  ];

  @override
  void initState() {
    _pageController = PageController();
    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<Color?>(
      tween: ColorTween(
          begin: const Color.fromRGBO(251, 187, 91, 1), end: okColors[_index]),
      duration: const Duration(milliseconds: 250),
      builder: (context, value, child) => Scaffold(
        backgroundColor: value,
        body: SafeArea(
          child: Container(
            color: value,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  flex: 10,
                  child: PageView(
                    controller: _pageController,
                    onPageChanged: (value) => setState(() {
                      _index = value;
                    }),
                    children: [
                      Page(
                        color: value,
                        title: "Koduko",
                        imagePath: 'assets/onboarding/person.png',
                        des:
                            "Hey There! Yes, this is an habit tracker don't let the name fool you. It will help you manage your daily or weekly habits with ease.",
                      ),
                      Page(
                        color: value,
                        title: "You ask features?",
                        imagePath: 'assets/onboarding/gymTime.png',
                        des:
                            "It has a lot of them. You add a routine which can contain multiple tasks, Select a time and you are done. It will remind you at the specified time. Also there are statistics ",
                      ),
                      Page(
                        color: value,
                        title: "Ready?",
                        imagePath: 'assets/onboarding/watch.png',
                        des: "We hope you are! \n Have fun.",
                      ),
                    ],
                  ),
                ),
                Expanded(
                    child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Buttons(
                    onSkip: () {
                      setState(() {
                        _index = 2;
                      });
                      _pageController.animateToPage(2,
                          curve: Curves.easeIn,
                          duration: const Duration(milliseconds: 250));
                    },
                    pageIndex: _index,
                    onNext: () {
                      if (_index == 2) {
                        final box = Hive.box<bool>('Theme');

                        if (box.isOpen) {
                          box.put('isNewUser', false);
                        }
                        Navigator.pushReplacementNamed(context, '/');
                      }
                      if (_index > 1) {
                        return;
                      }
                      setState(() {
                        _index++;
                      });
                      _pageController.nextPage(
                        duration: const Duration(milliseconds: 250),
                        curve: Curves.easeIn,
                      );
                    },
                    onPrevious: () {
                      if (_index <= 0) {
                        return;
                      }
                      setState(() {
                        _index--;
                      });
                      _pageController.previousPage(
                        duration: const Duration(milliseconds: 250),
                        curve: Curves.easeIn,
                      );
                    },
                    text: _index == 2 ? 'Start' : null,
                    color: value,
                  ),
                )),
                const SizedBox(height: 10)
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class Page extends StatelessWidget {
  const Page({
    super.key,
    required this.imagePath,
    required this.title,
    required this.des,
    required this.color,
  });
  final String imagePath;
  final String title;
  final String des;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Image(image: AssetImage(imagePath)),
        Text(
          title,
          style: GoogleFonts.catamaran(
              fontWeight: FontWeight.bold,
              textStyle: Theme.of(context).textTheme.headlineLarge!.apply(
                  color: (color?.computeLuminance() ?? 0.1) > 0.5
                      ? Colors.black
                      : Colors.white)),
        ),
        const SizedBox(height: 10),
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Text(
            des,
            style: GoogleFonts.raleway(
                textStyle: Theme.of(context).textTheme.titleMedium!.apply(
                    color: (color?.computeLuminance() ?? 0.1) > 0.5
                        ? Colors.black
                        : Colors.white)),
            textAlign: TextAlign.center,
          ),
        )
      ],
    );
  }
}

class Buttons extends StatelessWidget {
  const Buttons({
    super.key,
    required this.pageIndex,
    required this.onNext,
    required this.onPrevious,
    required this.onSkip,
    required this.text,
    this.color,
  });
  final Color? color;
  final int pageIndex;
  final void Function() onNext;
  final void Function() onPrevious;
  final void Function() onSkip;

  final String? text;

  @override
  Widget build(BuildContext context) {
    final Color textColor =
        (color?.computeLuminance() ?? 0.1) > 0.5 ? Colors.black : Colors.white;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          AnimatedCrossFade(
              alignment: Alignment.center,
              firstChild: TextButton.icon(
                icon: const Icon(Icons.chevron_left_rounded),
                style: TextButton.styleFrom(
                  foregroundColor: textColor,
                ),
                label: Text(
                  'Back',
                  style: Theme.of(context).textTheme.titleSmall!.apply(
                        color: textColor,
                      ),
                ),
                onPressed: onPrevious,
              ),
              secondChild: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey[900],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    )),
                onPressed: onSkip,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Text(
                    'Skip',
                    style: Theme.of(context).textTheme.titleSmall!.apply(
                          color: Colors.white,
                        ),
                  ),
                ),
              ),
              crossFadeState: pageIndex == 0
                  ? CrossFadeState.showSecond
                  : CrossFadeState.showFirst,
              duration: const Duration(milliseconds: 250)),
          AnimatedCrossFade(
            alignment: Alignment.center,
            firstChild: TextButton.icon(
              label: text == null
                  ? const Icon(Icons.chevron_right_rounded)
                  : Container(),
              style: TextButton.styleFrom(
                foregroundColor: textColor,
              ),
              icon: Text(
                'Next',
                style: Theme.of(context).textTheme.titleSmall!.apply(
                      color: textColor,
                    ),
              ),
              onPressed: onNext,
            ),
            secondChild: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
              onPressed: onNext,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5),
                child: Text(
                  text ?? 'Done',
                  style: Theme.of(context).textTheme.titleSmall!.apply(
                        color: Colors.grey[900],
                      ),
                ),
              ),
            ),
            crossFadeState: text == null
                ? CrossFadeState.showFirst
                : CrossFadeState.showSecond,
            duration: const Duration(milliseconds: 250),
          ),
        ],
      ),
    );
  }
}
