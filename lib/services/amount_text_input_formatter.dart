import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AmountTextInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue before, TextEditingValue after) {
    TextEditingValue _after = TextEditingValue(text: after.text);
    String newValue = '';
    int cursorPosition = after.selection.end;

    List<String> tmp = _after.text.split('');
    for (int i = tmp.length - 1; i >= 0; i--) {
      if (tmp[i] == ' ') {
        if (i < cursorPosition) {
          cursorPosition--;
        }
        tmp.removeAt(i);
      }
    }
    print(tmp.join('') + '#');
    print(' ' * cursorPosition + '#');

    if (tmp.length % 3 != 0) {
      newValue = tmp.sublist(0, tmp.length % 3).join('');
      for (int i = tmp.length % 3 - 1; i >= 0; i--) {
        tmp.removeAt(i);
      }
    }
    int parts = tmp.length ~/ 3;
    for (int i = 0; i < parts; i++) {
      if (newValue != '') {
        newValue += ' ';
        if (cursorPosition >= newValue.length) {
          cursorPosition++;
        }
      }
      newValue += tmp.sublist(i * 3, (i + 1) * 3).join('');
    }

    print(newValue + '#');
    print(' ' * cursorPosition + '#');

    // return TextEditingValue(
    //   text: after.text.toString(),
    //   selection: TextSelection.collapsed(offset: after.selection.end),
    // );
    return TextEditingValue(
      text: newValue,
      selection: TextSelection.collapsed(offset: cursorPosition),
    );
  }
}
