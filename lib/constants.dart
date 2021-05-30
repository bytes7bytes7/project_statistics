import 'package:flutter/material.dart';

abstract class ConstantColors {
  static const Color primaryColor = Color(0xFF1B97F3);
  static const Color focusColor = Colors.white;
  static const Color disabledColor = Color(0xFF898989);
  static const Color shadowColor = Colors.black;
  static const Color errorColor = Color(0xFFFF0000);
}

enum MeasureLevel {
  unit,
  thousands,
  millions,
}

class MeasureBeautifier {
  MeasureBeautifier([this.level]);

  MeasureLevel level;

  @override
  String toString() {
    if (level == MeasureLevel.unit) return '';
    if (level == MeasureLevel.thousands) return 'тыс.\n';
    if (level == MeasureLevel.millions) return 'млн.\n';
    return '-';
  }

  String truncateZero(String str) {
    if (str.substring(str.indexOf('.') + 1) == '0')
      str = str.substring(0, str.indexOf('.'));
    return str;
  }

  List<String> formatNumber(
      dynamic number, MeasureLevel level, String measure) {
    String result = number.toString();
    MeasureBeautifier resultMeasure = MeasureBeautifier(level);
    if (number is int || number is double) {
      if (number >= 1000000 && level == MeasureLevel.unit) {
        result = (number / 1000000).toStringAsFixed(1);
        resultMeasure.level = MeasureLevel.millions;
      } else if (number >= 1000) {
        if (level == MeasureLevel.unit) {
          result = (number / 1000).toStringAsFixed(1);
          resultMeasure.level = MeasureLevel.thousands;
        } else if (level == MeasureLevel.thousands) {
          result = (number / 1000).toStringAsFixed(1);
          resultMeasure.level = MeasureLevel.millions;
        }
      }
    }
    result = truncateZero(result);
    return [result, resultMeasure.toString() + measure];
  }
}

abstract class ConstantData {
  static const List<String> appMonths = [
    'Январь',
    'Февраль',
    'Март',
    'Апрель',
    'Май',
    'Июнь',
    'Июль',
    'Август',
    'Сентябрь',
    'Октябрь',
    'Ноябрь',
    'Декабрь',
  ];
  static const List<String> appStatus = [
    'Запросы',
    'КП',
    'Тендеры',
    'Договоры',
  ];
}
