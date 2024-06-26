import 'package:duration_picker/duration_picker.dart';
import 'package:flutter/material.dart';
import 'package:koduko/components/name_page_bottom_sheet.dart';
import 'package:koduko/models/task.dart';
import 'package:koduko/utils/duration_to_string.dart';
import 'package:koduko/utils/parse_duration.dart';

class CreateTaskBottomSheet extends StatefulWidget {
  const CreateTaskBottomSheet({super.key, this.task});
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
    "2 mins": Duration(minutes: 2),
    "5 mins": Duration(minutes: 5),
    "10 mins": Duration(minutes: 10),
    "15 mins": Duration(minutes: 15),
    "20 mins": Duration(minutes: 20),
    "25 mins": Duration(minutes: 25),
    "30 mins": Duration(minutes: 30),
    "Custom": Duration(minutes: 5),
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

  Duration customTime = const Duration(minutes: 5);
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

  void onChangeChip(bool selected, int index, BuildContext context) async {
    if (chipList.keys.toList()[index] == 'Custom') {
      final r = await showDurationPicker(
        context: context,
        initialTime: _value != null
            ? _value == 'Custom'
                ? customTime
                : chipList[_value] ?? customTime
            : customTime,
        baseUnit: BaseUnit.second,
        lowerBound: const Duration(seconds: 15),
        upperBound: const Duration(hours: 1),
      );

      if (r == null) {
        return;
      }
      setState(() {
        customTime = r;
        _value = 'Custom';
      });
      validateDuration();
      return;
    }
    setState(() {
      _value = selected ? chipList.keys.toList()[index] : null;
    });
    validateDuration();
  }

  // Future<bool> onCustomDurationSelect(BuildContext context) async {
  //   final result = await Picker(
  //     adapter: NumberPickerAdapter(data: <NumberPickerColumn>[
  //       const NumberPickerColumn(begin: 0, end: 30, suffix: Text(' minutes')),
  //       const NumberPickerColumn(begin: 5, end: 60, suffix: Text(' seconds')),
  //     ]),
  //     backgroundColor: Theme.of(context).colorScheme.surface,
  //     onBuilderItem: (context, text, child, selected, col, index) {
  //       String t = text == null
  //           ? ''
  //           : col == 0
  //               ? '$text min'
  //               : '$text sec';
  //       return Center(
  //         child: Row(
  //           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  //           children: [
  //             Text(
  //               t,
  //               style: selected
  //                   ? Theme.of(context)
  //                       .textTheme
  //                       .titleLarge!
  //                       .apply(color: Theme.of(context).colorScheme.primary)
  //                   : Theme.of(context).textTheme.titleMedium,
  //             )
  //           ],
  //         ),
  //       );
  //     },
  //     looping: true,
  //     magnification: 1.1,
  //     itemExtent: 50,
  //     hideHeader: true,
  //     confirmText: 'Select',
  //     title: const Text('Select duration'),
  //     onConfirm: (Picker picker, List<int> value) {
  //       Duration duration = Duration(
  //           minutes: picker.getSelectedValues()[0],
  //           seconds: picker.getSelectedValues()[1]);
  //       setState(() {
  //         customTime = duration;
  //       });
  //       validateDuration();
  //     },
  //   ).showDialog(context);
  //   if (result == null) {
  //     return false;
  //   } else {
  //     return true;
  //   }
  // }

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
                    customDuration: customTime,
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
                        final dur = _value! == 'Custom'
                            ? customTime
                            : chipList[_value]!;
                        Navigator.pop(
                            context,
                            Task.fromDuration(
                                duration: dur,
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
    super.key,
    required this.pageIndex,
    required this.onNext,
    required this.onPrevious,
    required this.text,
  });

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
                    foregroundColor:
                        Theme.of(context).colorScheme.onSecondaryContainer,
                    backgroundColor:
                        Theme.of(context).colorScheme.secondaryContainer,
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
              foregroundColor:
                  Theme.of(context).colorScheme.onSecondaryContainer,
              backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
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
      {super.key,
      required this.onChange,
      required this.chipList,
      required this.value,
      required this.customDuration});

  final void Function(bool, int, BuildContext) onChange;
  final Map<String, Duration> chipList;
  final String? value;
  final Duration customDuration;

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        Text(
          "Select a Duration",
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(
          height: 15,
        ),
        Wrap(
          spacing: 6,
          children: List<Widget>.generate(
            chipList.length,
            (index) => ChoiceChip(
              label: Text(
                  value == 'Custom' && chipList.keys.toList()[index] == 'Custom'
                      ? '${durationToString(customDuration)} min'
                      : chipList.keys.toList()[index]),
              selected: value == chipList.keys.toList()[index],
              selectedColor:
                  Theme.of(context).colorScheme.primary.withOpacity(0.7),
              backgroundColor:
                  Theme.of(context).colorScheme.primary.withOpacity(0.15),
              labelStyle: Theme.of(context).textTheme.labelLarge!.apply(
                  color: value == chipList.keys.toList()[index]
                      ? Theme.of(context).colorScheme.onSecondary
                      : Theme.of(context).colorScheme.onSurface),
              onSelected: (bool selected) => onChange(selected, index, context),
            ),
          ),
        ),
      ],
    );
  }
}

class ColorPage extends StatelessWidget {
  const ColorPage(
      {super.key,
      required this.onChange,
      required this.colorList,
      required this.selectedColor});
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
                              : Theme.of(context).colorScheme.surface,
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
