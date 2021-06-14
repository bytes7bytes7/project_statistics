import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../services/measure_beautifier.dart';
import '../widgets/show_info_snack_bar.dart';

class InputField extends StatelessWidget {
  InputField({
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
        inputFormatters: [
          AmountTextInputFormatter(),
        ],
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

class AmountTextInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue before, TextEditingValue after) {
    final StringBuffer newValue = StringBuffer();

    print(after.text);

    TextEditingValue _after =
        TextEditingValue(text: after.text.replaceAll(' ', ''));

    final int afterLength = _after.text.length;
    final int parts = afterLength ~/ 3;

    int cursorPosition = after.selection.end;

    List<String> lst = [];
    for (int i = 0; i < parts; i++) {
      String tmp =
          _after.text.substring(afterLength - 3 * (i + 1), afterLength - 3 * i);
      lst.add(tmp);
    }

    if (afterLength % 3 != 0) {
      lst.add(_after.text.substring(0, afterLength % 3));
    }
    lst = lst.reversed.toList();
    newValue.write(lst.join(' '));

    if (before.text.length > after.text.length && afterLength % 3 == 0) {
      cursorPosition--;
      String tmp = newValue.toString();
      newValue.clear();
      newValue.write(tmp.substring(0, tmp.length));
    }

    if ((before.text.replaceAll(' ', '').length / 3).ceil() <
        (_after.text.length / 3).ceil() && _after.text.length > 1) {
      cursorPosition++;
    }

    if (cursorPosition > newValue.length || cursorPosition < 0) {
      cursorPosition = 0;
    }
    return TextEditingValue(
      text: newValue.toString(),
      selection: TextSelection.collapsed(offset: cursorPosition),
    );
  }
}
