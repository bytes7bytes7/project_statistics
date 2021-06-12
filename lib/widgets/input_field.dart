import 'package:flutter/material.dart';

class InputField extends StatelessWidget {
  const InputField({
    Key key,
    @required this.label,
    @required this.controller,
    this.textInputType = TextInputType.text,
  }) : super(key: key);

  final String label;
  final TextEditingController controller;
  final TextInputType textInputType;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: TextField(
        controller: controller,
        style: Theme.of(context).textTheme.bodyText1,
        keyboardType: textInputType,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: Theme.of(context).textTheme.subtitle1,
          contentPadding: const EdgeInsets.symmetric(horizontal: 10),
          disabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(
              color: Theme.of(context).disabledColor,
            ),
          ),
        ),
      ),
    );
  }
}
