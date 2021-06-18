import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AmountTextInputFormatter extends TextInputFormatter {
  bool onlyOne(List<String> lst, String subStr) {
    return lst.indexOf(subStr) == lst.lastIndexOf(subStr) &&
        lst.indexOf(subStr) != -1;
  }

  int countCommaAndPoint(List<String> lst) {
    int quantity = 0;
    for (int i = 0; i < lst.length; i++) {
      if (lst[i] == '.' || lst[i] == ',') {
        quantity++;
      }
    }
    return quantity;
  }

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue before, TextEditingValue after) {
    String newValue = '';
    int cursorPosition = after.selection.end;

    // TODO: I can add condition to check if a space has been deleted

    List<String> integer = after.text.split('');
    String divider = '';
    List<String> fractional = [];

    if (onlyOne(integer, '.') && !integer.contains(',')) {
      fractional.addAll(integer.sublist(integer.indexOf('.') + 1));
      divider = '.';
      integer = integer.sublist(0, integer.indexOf('.'));
    } else if (onlyOne(integer, ',') && !integer.contains('.')) {
      fractional.addAll(integer.sublist(integer.indexOf(',') + 1));
      divider = ',';
      integer = integer.sublist(0, integer.indexOf(','));
    } else if (!integer.contains('.') && !integer.contains(',')) {
      // integer number
    } else {
      // To many dividers (comma & point)
      if(integer.contains('.') && !integer.contains(',')){
        fractional.addAll(integer.sublist(integer.indexOf('.') + 1));
        divider = '.';
        integer = integer.sublist(0, integer.indexOf('.'));
      }else if(integer.contains(',') && !integer.contains('.')){
        fractional.addAll(integer.sublist(integer.indexOf(',') + 1));
        divider = ',';
        integer = integer.sublist(0, integer.indexOf(','));
      }else{
        if(integer.indexOf('.') < integer.indexOf(',') && integer.indexOf('.')!= -1){
          fractional.addAll(integer.sublist(integer.indexOf('.') + 1));
          divider = '.';
          integer = integer.sublist(0, integer.indexOf('.'));
        }else{
          fractional.addAll(integer.sublist(integer.indexOf(',') + 1));
          divider = ',';
          integer = integer.sublist(0, integer.indexOf(','));
        }
      }
    }

    for (int i = fractional.length - 1; i >= 0; i--) {
      if (fractional[i] == ' ') {
        if (integer.length + 1 + i < cursorPosition) {
          cursorPosition--;
        }
        fractional.removeAt(i);
      }
    }

    for (int i = integer.length - 1; i >= 0; i--) {
      if (integer[i] == ' ') {
        if (i < cursorPosition) {
          cursorPosition--;
        }
        integer.removeAt(i);
      }
    }

    if (integer.length % 3 != 0) {
      newValue = integer.sublist(0, integer.length % 3).join('');
      for (int i = integer.length % 3 - 1; i >= 0; i--) {
        integer.removeAt(i);
      }
    }
    int parts = integer.length ~/ 3;
    for (int i = 0; i < parts; i++) {
      if (newValue != '') {
        newValue += ' ';
        if (cursorPosition >= newValue.length) {
          cursorPosition++;
        }
      }
      newValue += integer.sublist(i * 3, (i + 1) * 3).join('');
    }

    newValue += divider + fractional.join('');

    // print(newValue + '#');
    // print(' ' * cursorPosition + '#');

    return TextEditingValue(
      text: newValue,
      selection: TextSelection.collapsed(offset: cursorPosition),
    );
  }
}
