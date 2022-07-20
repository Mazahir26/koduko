import 'package:flutter/material.dart';
import 'package:koduko/components/name_page_bottom_sheet.dart';
import 'package:koduko/models/routine.dart';
import 'package:koduko/models/task.dart';
import 'package:koduko/utils/duration_to_string.dart';
import 'package:koduko/utils/parse_duration.dart';

enum RepeatType {
  daily,
  onlyOn,
}

class CreateRoutineBottomSheet extends StatefulWidget {
  const CreateRoutineBottomSheet({Key? key, required this.tasks})
      : super(key: key);
  final List<Task> tasks;
  @override
  State<CreateRoutineBottomSheet> createState() =>
      _CreateRoutineBottomSheetState();
}

class _CreateRoutineBottomSheetState extends State<CreateRoutineBottomSheet> {
  late final PageController _pageController;
  late final TextEditingController _nameController;

  final List<Task> selectedTask = [];
  Map<String, bool> selectedDays = {
    "Monday": true,
    "Tuesday": true,
    "Wednesday": true,
    "Thursday": true,
    "Friday": true,
    "Saturday": true,
    "Sunday": true,
  };
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

  void onChangeRepeatType(RepeatType r) {
    if (r == RepeatType.daily) {
      setState(() {
        selectedDays = selectedDays.map((key, value) => MapEntry(key, true));
      });
    } else {
      setState(() {
        pageComplected = false;
        selectedDays = selectedDays.map((key, value) => MapEntry(key, false));
      });
    }
  }

  void onDayChange(String e, bool value) {
    setState(() {
      selectedDays[e] = value;
      if (selectedDays.values.contains(true)) {
        pageComplected = true;
      } else {
        pageComplected = false;
      }
    });
  }

  void onTap(bool selected, int index) {
    if (selected) {
      if (selectedTask.length == 1) {
        setState(() {
          selectedTask
              .removeWhere((element) => element.id == widget.tasks[index].id);
          pageComplected = false;
        });
      } else {
        setState(() {
          selectedTask
              .removeWhere((element) => element.id == widget.tasks[index].id);
        });
      }
    } else {
      setState(() {
        selectedTask.add(widget.tasks[index]);
        pageComplected = true;
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
              height: MediaQuery.of(context).size.height *
                  (pageIndex == 1 ? 0.6 : 0.3),
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
                  ),
                  TaskSelectPage(
                    selectedTask: selectedTask,
                    tasks: widget.tasks,
                    onTap: onTap,
                  ),
                  RepeatPage(
                    onDayChange: onDayChange,
                    selectedDays: selectedDays,
                    onChangeRepeatType: onChangeRepeatType,
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
                  setState(() {
                    pageComplected = selectedTask.isNotEmpty;
                  });
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
                      if (pageIndex == 2) {
                        List<String> temp = [];
                        selectedDays.forEach((key, value) {
                          if (value) {
                            temp.add(key);
                          }
                        });
                        Navigator.pop(
                          context,
                          Routine.create(
                            name: _nameController.text,
                            tasks: selectedTask,
                            days: temp,
                          ),
                        );
                      }

                      _pageController.nextPage(
                        duration: const Duration(milliseconds: 350),
                        curve: Curves.easeIn,
                      );
                      if (pageIndex == 0) {
                        if (selectedTask.isEmpty) {
                          setState(() {
                            pageIndex++;
                            pageComplected = false;
                          });
                          return;
                        }
                      }
                      if (pageIndex == 1) {
                        if (!selectedDays.values.contains(true)) {
                          setState(() {
                            pageComplected = false;
                            pageIndex++;
                          });
                          return;
                        }
                      }
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

class TaskSelectPage extends StatelessWidget {
  const TaskSelectPage(
      {Key? key,
      required this.selectedTask,
      required this.tasks,
      required this.onTap})
      : super(key: key);
  final List<Task> selectedTask;
  final List<Task> tasks;
  final void Function(bool, int) onTap;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: tasks.length,
        itemBuilder: (context, index) {
          bool isSelected = selectedTask.indexWhere(
                  (element) => element.id.compareTo(tasks[index].id) == 0) >
              -1;
          Widget card = Card(
            child: ListTile(
              selected: isSelected,
              onTap: () => onTap(isSelected, index),
              trailing: isSelected
                  ? const Icon(Icons.check_box_rounded)
                  : const Icon(Icons.check_box_outline_blank_rounded),
              subtitle: Text(
                'Duration : ${durationToString(parseDuration(tasks[index].duration))} Min',
                style: Theme.of(context).textTheme.bodyMedium!.apply(
                    color: Theme.of(context)
                        .colorScheme
                        .onBackground
                        .withOpacity(0.8)),
              ),
              title: Text(
                tasks[index].name,
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
          );
          if (index == 0) {
            return Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Select Tasks',
                        style: Theme.of(context).textTheme.titleLarge!),
                    AnimatedCrossFade(
                      firstChild: TextButton.icon(
                        onPressed: () {},
                        icon: const Icon(Icons.add),
                        label: Text(
                          'Add Task',
                          style: Theme.of(context).textTheme.titleMedium!.apply(
                              color: Theme.of(context).colorScheme.primary),
                        ),
                      ),
                      secondChild: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Text(
                          'Selected (${selectedTask.length})',
                          style: Theme.of(context).textTheme.titleMedium!.apply(
                              color: Theme.of(context).colorScheme.primary),
                        ),
                      ),
                      crossFadeState: selectedTask.isEmpty
                          ? CrossFadeState.showFirst
                          : CrossFadeState.showSecond,
                      duration: const Duration(milliseconds: 250),
                    )
                  ],
                ),
                const SizedBox(height: 10),
                card
              ],
            );
          }
          return card;
        });
  }
}

class RepeatPage extends StatelessWidget {
  const RepeatPage(
      {Key? key,
      required this.onDayChange,
      required this.selectedDays,
      required this.onChangeRepeatType})
      : super(key: key);
  final void Function(String, bool) onDayChange;
  final Map<String, bool> selectedDays;
  final void Function(RepeatType) onChangeRepeatType;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Repeat",
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(
          height: 25,
        ),
        Wrap(
          spacing: 8,
          children: [
            ChoiceChip(
              elevation: 5,
              label: const Text("Daily"),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5),
              ),
              selected: !selectedDays.values.contains(false),
              backgroundColor: Theme.of(context).colorScheme.onInverseSurface,
              onSelected: (value) => onChangeRepeatType(RepeatType.daily),
              selectedColor: Theme.of(context).colorScheme.inversePrimary,
              labelStyle: Theme.of(context).textTheme.labelLarge,
            ),
            ChoiceChip(
              elevation: 5,
              label: const Text("Only on"),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5),
              ),
              selected: selectedDays.values.contains(false),
              backgroundColor: Theme.of(context).colorScheme.onInverseSurface,
              onSelected: (value) => onChangeRepeatType(RepeatType.onlyOn),
              selectedColor: Theme.of(context).colorScheme.inversePrimary,
              labelStyle: Theme.of(context).textTheme.labelLarge,
            ),
          ],
        ),
        selectedDays.values.contains(false)
            ? Wrap(
                spacing: 4,
                children: selectedDays.keys
                    .map(
                      (e) => ChoiceChip(
                        elevation: 5,
                        label: Text(e),
                        selected: selectedDays[e] ?? false,
                        backgroundColor:
                            Theme.of(context).colorScheme.onInverseSurface,
                        onSelected: (value) => onDayChange(e, value),
                        selectedColor:
                            Theme.of(context).colorScheme.inversePrimary,
                        labelStyle: Theme.of(context).textTheme.labelMedium,
                      ),
                    )
                    .toList())
            : Container()
      ],
    );
  }
}
