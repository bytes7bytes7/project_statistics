import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AmountTextInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue before, TextEditingValue after) {
    String newValue = '';
    int cursorPosition = after.selection.end;
    String replacedString = after.text;

    // Check if a space has been deleted
    if(before.text.length > 0 && cursorPosition != after.text.length && before.text[cursorPosition] == ' ' && after.text[cursorPosition] != ' '){
      List<String> tmp = replacedString.split('');
      tmp.removeAt(cursorPosition-1);
      replacedString = tmp.join('');
      cursorPosition--;
    }

    // Transform after to string without spaces
    for (int i = replacedString.length - 1; i >= 0; i--) {
      if (replacedString[i] == ' ') {
        if (i < cursorPosition) {
          cursorPosition--;
        }
        List<String> tmp = replacedString.split('');
        tmp.removeAt(i);
        replacedString = tmp.join('');
      }
    }

    TextEditingValue _after = TextEditingValue(text: replacedString);

    if (_after.text.length < 3) {
      newValue = _after.text;
    } else if (_after.text.length == 3) {
      newValue = _after.text;
    } else if (_after.text.length > 3) {
      for (int i = 0; i < _after.text.length ~/ 3; i++) {
        if (i == 0) {
          newValue = _after.text.substring(
              _after.text.length - 3 * (i + 1), _after.text.length - 3 * i);
        } else {
          newValue = _after.text.substring(_after.text.length - 3 * (i + 1),
                  _after.text.length - 3 * i) +
              ' ' +
              newValue;
          cursorPosition++;
        }
      }
      if (_after.text.length % 3 != 0) {
        newValue =
            _after.text.substring(0, _after.text.length % 3) + ' ' + newValue;
        cursorPosition++;
      }
    }

    print(newValue + '#');
    print(' ' * cursorPosition + '#');

    // return TextEditingValue(
    //   text: after.text.toString(),
    //   selection: TextSelection.collapsed(offset: after.selection.end),
    // );
    return TextEditingValue(
      text: newValue.toString(),
      selection: TextSelection.collapsed(offset: cursorPosition),
    );
  }
}