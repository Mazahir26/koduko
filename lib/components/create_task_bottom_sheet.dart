import 'package:flutter/material.dart';
import 'package:koduko/components/name_page_bottom_sheet.dart';
import 'package:koduko/models/task.dart';
import 'package:koduko/utils/parse_duration.dart';

class CreateTaskBottomSheet extends StatefulWidget {
  const CreateTaskBottomSheet({Key? key, this.task}) : super(key: key);
  final Task? task;
  @override
  State<CreateTaskBottomSheet> createState() => _CreateTaskBottomSheetState();
}

class _CreateTaskBottomSheetState extends State<CreateTaskBottomSheet> {
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
    if (widget.task != null) {
      _nameController.text = widget.task!.name;
      _value = chipList.keys.firstWhere((element) =>
          chipList[element] == parseDuration(widget.task!.duration));
      _selectedColor = colorList
          .indexWhere((element) => element.value == widget.task!.color);
      pageComplected = true;
    }
    super.initState();
  }

  void validateName(String _) {
    if (_nameController.text.length > 2) {
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

  void validateDuration() {
    if (_value == null) {
      setState(() {
        pageComplected = false;
      });
    } else {
      setState(() {
        pageComplected = true;
      });
    }
  }

  void validateColor() {
    if (_selectedColor == null) {
      setState(() {
        pageComplected = false;
      });
    } else {
      setState(() {
        pageComplected = true;
      });
    }
  }

  void onChangeChip(bool selected, int index) {
    setState(() {
      _value = selected ? chipList.keys.toList()[index] : null;
    });
    validateDuration();
  }

  void onChangeColor(int index) {
    setState(() {
      _selectedColor = index;
    });
    validateColor();
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
                  "Create a Task",
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
                    hintText: "ex. push up",
                    title: "Task Name",
                  ),
                  DurationPage(
                    onChange: onChangeChip,
                    chipList: chipList,
                    value: _value,
                  ),
                  ColorPage(
                    onChange: onChangeColor,
                    colorList: colorList,
                    selectedColor: _selectedColor,
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
                if (pageIndex == 1) {
                  validateDuration();
                }
                _pageController.previousPage(
                  duration: const Duration(milliseconds: 350),
                  curve: Curves.easeIn,
                );
              },
              onNext: pageComplected
                  ? () {
                      FocusScopeNode currentFocus = FocusScope.of(context);

                      if (!currentFocus.hasPrimaryFocus) {
                        currentFocus.unfocus();
                      }
                      setState(() {
                        pageIndex++;
                      });
                      if (pageIndex == 1) {
                        validateDuration();
                      }
                      if (pageIndex == 2) {
                        validateColor();
                      }
                      if (pageIndex == 3) {
                        Navigator.pop(
                            context,
                            Task.fromDuration(
                                duration: chipList[_value]!,
                                name: _nameController.text,
                                color: colorList[_selectedColor!]));
                      }
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

class DurationPage extends StatelessWidget {
  const DurationPage(
      {Key? key,
      required this.onChange,
      required this.chipList,
      required this.value})
      : super(key: key);

  final void Function(bool, int) onChange;
  final Map<String, Duration> chipList;
  final String? value;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Select a Duration",
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
              label: Text(chipList.keys.toList()[index]),
              selected: value == chipList.keys.toList()[index],
              selectedColor:
                  Theme.of(context).colorScheme.primary.withOpacity(0.7),
              backgroundColor:
                  Theme.of(context).colorScheme.primary.withOpacity(0.15),
              labelStyle: Theme.of(context).textTheme.labelLarge!.apply(
                  color: value == chipList.keys.toList()[index]
                      ? Theme.of(context).colorScheme.onSecondary
                      : Theme.of(context).colorScheme.onBackground),
              onSelected: (bool selected) => onChange(selected, index),
            ),
          ),
        ),
      ],
    );
  }
}

class ColorPage extends StatelessWidget {
  const ColorPage(
      {Key? key,
      required this.onChange,
      required this.colorList,
      required this.selectedColor})
      : super(key: key);
  final void Function(int) onChange;
  final List<Color> colorList;
  final int? selectedColor;
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Pick a Color",
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(
          height: 15,
        ),
        Wrap(
          spacing: 5,
          children: List<Widget>.generate(
              colorList.length,
              (index) => GestureDetector(
                    onTap: () => onChange(index),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.all(3),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: selectedColor == index
                              ? Colors.blueAccent
                              : Theme.of(context).colorScheme.background,
                          width: 3,
                        ),
                        shape: BoxShape.circle,
                      ),
                      child: Container(
                        height: selectedColor == index ? 25 : 20,
                        width: selectedColor == index ? 25 : 20,
                        decoration: BoxDecoration(
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.grey,
                              offset: Offset(0.0, 1.0), //(x,y)
                              blurRadius: 6.0,
                            ),
                          ],
                          color: colorList[index],
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                  )),
        ),
      ],
    );
  }
}
