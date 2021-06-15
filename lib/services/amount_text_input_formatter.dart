import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AmountTextInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue before, TextEditingValue after) {
    String newValue = '';
    int cursorPosition = after.selection.end;
    String replacedString = after.text;
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

    return TextEditingValue(
      text: newValue.toString(),
      selection: TextSelection.collapsed(offset: cursorPosition),
    );
  }
}

// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
//
// class AmountTextInputFormatter extends TextInputFormatter {
//   @override
//   TextEditingValue formatEditUpdate(TextEditingValue before,
//       TextEditingValue after) {
//     final StringBuffer newValue = StringBuffer();
//
//     TextEditingValue _after =
//     TextEditingValue(text: after.text.replaceAll(' ', ''));
//     TextEditingValue _before =
//     TextEditingValue(text: before.text.replaceAll(' ', ''));
//     int cursorPosition = after.selection.end;
//
//     String fractionalBefore = '';
//     if (_before.text.contains('.')) {
//       fractionalBefore =
//           _before.text.substring(_before.text.indexOf('.')).replaceAll(' ', '');
//     } else if (_before.text.contains(',')) {
//       fractionalBefore =
//           _before.text.substring(_before.text.indexOf(',')).replaceAll(' ', '');
//     }
//
//     String fractionalAfter = '';
//     if (_after.text.contains('.')) {
//       fractionalAfter =
//           _after.text.substring(_after.text.indexOf('.')).replaceAll(' ', '');
//       _after = TextEditingValue(
//           text: _after.text.substring(0, _after.text.indexOf('.')));
//     } else if (_after.text.contains(',')) {
//       fractionalAfter =
//           _after.text.substring(_after.text.indexOf(',')).replaceAll(' ', '');
//       _after = TextEditingValue(
//           text: _after.text.substring(0, _after.text.indexOf(',')));
//     }
//
//     if (fractionalBefore != fractionalAfter && _after.text == _before.text) {
//
//     } else if (fractionalBefore == '' && (fractionalAfter=='.' || fractionalAfter==',')) {
//
//     }
//     else {
//       final int afterLength = _after.text.length;
//       final int parts = afterLength ~/ 3;
//
//       List<String> lst = [];
//       for (int i = 0; i < parts; i++) {
//         String tmp = _after.text
//             .substring(afterLength - 3 * (i + 1), afterLength - 3 * i);
//         lst.add(tmp);
//       }
//
//       if (afterLength % 3 != 0) {
//         lst.add(_after.text.substring(0, afterLength % 3));
//       }
//       lst = lst.reversed.toList();
//       newValue.write(lst.join(' '));
//
//       if (before.text.length > after.text.length && afterLength % 3 == 0) {
//         cursorPosition--;
//         String tmp = newValue.toString();
//         newValue.clear();
//         newValue.write(tmp.substring(0, tmp.length));
//       }
//
//       if ((before.text
//           .replaceAll(' ', '')
//           .length / 3).ceil() <
//           (_after.text.length / 3).ceil() &&
//           _after.text.length > 1) {
//         cursorPosition++;
//       }
//
//       newValue.write(fractionalAfter);
//
//       if (cursorPosition > newValue.length || cursorPosition < 0) {
//         cursorPosition = 0;
//       }
//     }
//
//     return TextEditingValue(
//       text: newValue.toString(),
//       selection: TextSelection.collapsed(offset: cursorPosition),
//     );
//   }
// }
