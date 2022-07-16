import 'package:flutter/material.dart';

class CreateTaskBottomSheet extends StatefulWidget {
  const CreateTaskBottomSheet({Key? key}) : super(key: key);

  @override
  State<CreateTaskBottomSheet> createState() => _CreateTaskBottomSheetState();
}

class _CreateTaskBottomSheetState extends State<CreateTaskBottomSheet> {
  late final PageController _pageController;
  late final TextEditingController _textController;
  static const chipList = [
    "30 sec",
    "1 min",
    "5 min",
    "10 min",
    "15 mins",
    "30 mins",
    "Custom",
  ];
  int? _value;
  int pageIndex = 0;
  bool pageComplected = false;
  @override
  void initState() {
    _pageController = PageController();
    _textController = TextEditingController();
    super.initState();
  }

  void validateName(String _) {
    if (_textController.text.length > 4) {
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
    _textController.dispose();
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
                  "Create a Task",
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(15),
            child: SizedBox(
              height: MediaQuery.of(context).size.height / 3,
              child: PageView(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Task Name",
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(
                        height: 25,
                      ),
                      TextField(
                        controller: _textController,
                        autofocus: true,
                        maxLength: 20,
                        onChanged: validateName,
                        decoration: InputDecoration(
                          suffixIcon:
                              pageComplected ? const Icon(Icons.check) : null,
                          filled: true,
                          hintText: "ex. push up",
                          errorText:
                              pageComplected || _textController.text.isEmpty
                                  ? null
                                  : "Invalid Name",
                        ),
                      )
                    ],
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Duration",
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      Wrap(
                          spacing: 8,
                          children: List<Widget>.generate(
                            chipList.length,
                            (index) => ChoiceChip(
                              label: Text(chipList[index]),
                              selected: _value == index,
                              selectedColor: Theme.of(context)
                                  .colorScheme
                                  .primary
                                  .withOpacity(0.5),
                              backgroundColor: Theme.of(context)
                                  .colorScheme
                                  .primary
                                  .withOpacity(0.15),
                              labelStyle:
                                  Theme.of(context).textTheme.labelLarge,
                              onSelected: (bool selected) {
                                setState(() {
                                  _value = selected ? index : null;
                                });
                              },
                            ),
                          )),
                      TextField(
                        controller: _textController,
                        autofocus: true,
                        maxLength: 20,
                        onChanged: validateName,
                        decoration: InputDecoration(
                          suffixIcon:
                              pageComplected ? const Icon(Icons.check) : null,
                          filled: true,
                          hintText: "ex. push up",
                          errorText:
                              pageComplected || _textController.text.isEmpty
                                  ? null
                                  : "Invalid Name",
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
          Buttons(
              pageIndex: pageIndex,
              onPrevious: () {
                setState(() {
                  pageIndex--;
                });
                _pageController.previousPage(
                  duration: const Duration(milliseconds: 350),
                  curve: Curves.easeIn,
                );
              },
              onNext: pageComplected
                  ? () {
                      setState(() {
                        pageIndex++;
                      });
                      _pageController.nextPage(
                        duration: const Duration(milliseconds: 350),
                        curve: Curves.easeIn,
                      );
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
  }) : super(key: key);

  final int pageIndex;
  final void Function()? onNext;
  final void Function() onPrevious;

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
                  "Next",
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                const Icon(Icons.chevron_right_sharp)
              ],
            ),
          ),
        )
      ],
    );
  }
}
