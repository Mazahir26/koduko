import 'package:flutter/material.dart';
import 'package:koduko/components/name_page_bottom_sheet.dart';
import 'package:koduko/models/task.dart';

class CreateRoutineBottomSheet extends StatefulWidget {
  const CreateRoutineBottomSheet({Key? key}) : super(key: key);

  @override
  State<CreateRoutineBottomSheet> createState() =>
      _CreateRoutineBottomSheetState();
}

class _CreateRoutineBottomSheetState extends State<CreateRoutineBottomSheet> {
  late final PageController _pageController;
  late final TextEditingController _nameController;

  static const chipList = <String, Duration>{
    "30 sec": Duration(seconds: 30),
    "1 min": Duration(minutes: 1),
    "2 min": Duration(minutes: 2),
    "5 min": Duration(minutes: 5),
    "10 min": Duration(minutes: 10),
    "15 mins": Duration(minutes: 15),
    "20 mins": Duration(minutes: 20),
    "25 mins": Duration(minutes: 25),
    "30 mins": Duration(minutes: 30),
  };
  static const colorList = [
    Colors.blue,
    Colors.amber,
    Colors.brown,
    Colors.yellow,
    Colors.teal,
    Colors.purple,
    Colors.red,
  ];

  String? _value;
  int? _selectedColor;
  int pageIndex = 0;
  bool pageComplected = false;
  @override
  void initState() {
    _pageController = PageController();
    _nameController = TextEditingController();
    super.initState();
  }

  void validateName(String _) {
    if (_nameController.text.length > 4) {
      if (!pageComplected) {
        setState(() {
          pageComplected = true;
        });
      }
    } else if (pageComplected) {
      setState(() {
        pageComplected = false;
      });
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
          top: 10,
          right: 10,
          left: 10,
          bottom: MediaQuery.of(context).viewInsets.bottom + 10),
      child: Wrap(
        children: [
          Center(
            child: Column(
              children: [
                const Icon(
                  Icons.drag_handle_rounded,
                  size: 26,
                ),
                Text(
                  "Create a Routine",
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(15),
            child: SizedBox(
              height: MediaQuery.of(context).size.height / 4,
              child: PageView(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  NamePage(
                    nameController: _nameController,
                    validateName: validateName,
                    pageComplected: pageComplected,
                    hintText: "ex. Gym",
                    title: "Routine Name",
                  )
                ],
              ),
            ),
          ),
          Buttons(
              text: pageIndex == 2 ? "Done" : null,
              pageIndex: pageIndex,
              onPrevious: () {
                setState(() {
                  pageIndex--;
                });
                if (pageIndex == 0) {
                  validateName("");
                }

                _pageController.previousPage(
                  duration: const Duration(milliseconds: 350),
                  curve: Curves.easeIn,
                );
              },
              onNext: pageComplected
                  ? () async {
                      // if (pageIndex == 3) {
                      //   Navigator.pop(
                      //       context,
                      //       Task.fromDuration(
                      //           duration: chipList[_value]!,
                      //           name: _nameController.text,
                      //           color: colorList[_selectedColor!]));
                      // }
                      await _pageController.nextPage(
                        duration: const Duration(milliseconds: 350),
                        curve: Curves.easeIn,
                      );
                      setState(() {
                        pageIndex++;
                      });
                    }
                  : null)
        ],
      ),
    );
  }
}

class Buttons extends StatelessWidget {
  const Buttons({
    Key? key,
    required this.pageIndex,
    required this.onNext,
    required this.onPrevious,
    required this.text,
  }) : super(key: key);

  final int pageIndex;
  final void Function()? onNext;
  final void Function() onPrevious;
  final String? text;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 3,
          child: pageIndex != 0
              ? ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    onPrimary:
                        Theme.of(context).colorScheme.onSecondaryContainer,
                    primary: Theme.of(context).colorScheme.secondaryContainer,
                  ).copyWith(elevation: ButtonStyleButton.allOrNull(0.0)),
                  onPressed: onPrevious,
                  icon: const Icon(Icons.chevron_left_sharp),
                  label: Text(
                    "Back",
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                )
              : TextButton(
                  onPressed: (() {
                    Navigator.pop(context);
                  }),
                  child: Text("Cancel",
                      style: Theme.of(context).textTheme.bodyLarge),
                ),
        ),
        const Spacer(
          flex: 2,
        ),
        Expanded(
          flex: 3,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              onPrimary: Theme.of(context).colorScheme.onSecondaryContainer,
              primary: Theme.of(context).colorScheme.secondaryContainer,
            ).copyWith(elevation: ButtonStyleButton.allOrNull(0.0)),
            onPressed: onNext,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  text ?? "Next",
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                text == null
                    ? const Icon(Icons.chevron_right_sharp)
                    : Container()
              ],
            ),
          ),
        )
      ],
    );
  }
}
