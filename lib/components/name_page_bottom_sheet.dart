import 'package:flutter/material.dart';

class NamePage extends StatelessWidget {
  const NamePage(
      {super.key,
      required this.nameController,
      required this.validateName,
      required this.pageComplected,
      required this.hintText,
      required this.title});
  final TextEditingController nameController;
  final void Function(String) validateName;
  final bool pageComplected;
  final String hintText;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(
          height: 25,
        ),
        TextField(
          controller: nameController,
          autofocus: true,
          maxLength: 20,
          onChanged: validateName,
          decoration: InputDecoration(
            suffixIcon: pageComplected ? const Icon(Icons.check) : null,
            filled: true,
            hintText: hintText,
            errorText:
                nameController.text.length > 2 || nameController.text.isEmpty
                    ? null
                    : "Invalid Name",
          ),
        )
      ],
    );
  }
}
