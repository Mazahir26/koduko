import 'package:flutter/material.dart';
import 'package:koduko/components/name_page_bottom_sheet.dart';
import 'package:koduko/models/task.dart';
import 'package:koduko/utils/duration_to_string.dart';
import 'package:koduko/utils/parse_duration.dart';

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

  void onTap(bool selected, int index) {
    if (selected) {
      setState(() {
        selectedTask.removeAt(index);
      });
    } else {
      setState(() {
        selectedTask.add(widget.tasks[index]);
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
                  ),
                  ListView.builder(
                    itemCount: widget.tasks.length,
                    itemBuilder: (context, index) => ListTile(
                      selected: selectedTask.indexWhere((element) =>
                              element.id.compareTo(widget.tasks[index].id) ==
                              0) >
                          -1,
                      onTap: () => onTap(
                          selectedTask.indexWhere((element) =>
                                  element.id
                                      .compareTo(widget.tasks[index].id) ==
                                  0) >
                              -1,
                          index),
                      subtitle: Text(
                        durationToString(
                            parseDuration(widget.tasks[index].duration)),
                        style: Theme.of(context).textTheme.labelLarge!.apply(
                            color: Theme.of(context)
                                .colorScheme
                                .onBackground
                                .withOpacity(0.8)),
                      ),
                      title: Text(
                        widget.tasks[index].name,
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    ),
                  ),
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
                      FocusScopeNode currentFocus = FocusScope.of(context);

                      if (!currentFocus.hasPrimaryFocus) {
                        currentFocus.unfocus();
                      }
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
