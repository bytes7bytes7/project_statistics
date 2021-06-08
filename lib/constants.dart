import 'package:flutter/material.dart';

import 'screens/analysis_chart_screen.dart';
import 'screens/project_list_screen.dart';
import 'screens/result_screen.dart';
import 'screens/start_screen.dart';
import 'models/destination.dart';
import 'custom_icons/navigation_bar_icons.dart';

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
    if (str.contains('.')) {
      if (str.substring(str.indexOf('.') + 1) == '0')
        str = str.substring(0, str.indexOf('.'));
    }
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
  static const List<String> projectCompleteStatuses = [
    'не завершен',
    'завершен',
    'отменен',
  ];
  static const List<String> appProjectParameterNames = [
    'Название',
    'Сумма',
    'Статус',
    'Срок',
  ];
  static const List<String> appProjectParameterDirection = [
    'По возрастанию',
    'По убыванию'
  ];
  static const List<String> appProjectSortDirection =[
    '↑',
    '↓',
  ];
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
  static final Map<String, String> appToolTips = {
    'add': 'Добавить',
    'table': 'Таблица',
    'list': 'Список',
    'filter': 'Фильтр',
  };
  static final List<Destination> appDestinations = [
    Destination(
      name: 'start',
      screen: StartScreen(),
      icon: NavigationBarIcons.play_circled,
    ),
    Destination(
      name: 'project_list',
      screen: ProjectListScreen(),
      icon: NavigationBarIcons.clipboard_list,
    ),
    Destination(
      name: 'chart',
      screen: AnalysisChartScreen(),
      icon: NavigationBarIcons.chart_bar,
    ),
    Destination(
      name: 'result',
      screen: ResultScreen(),
      icon: NavigationBarIcons.checklist,
    ),
    Destination(
      name: 'something',
      screen: Scaffold(),
      icon: NavigationBarIcons.question_circle,
    ),
  ];
}

abstract class ConstDBData {
  static final databaseName = "data.db";
  // Increment this version when you need to change the schema.
  static final databaseVersion = 1;

  // Names of tables
  static const String planTableName = 'plan';
  static const String projectTableName = 'project';

  // Special columns for plan
  static const String id = 'id';
  static const String quantity = 'quantity';
  static const String amount = 'amount';
  static const String startPeriod = 'startPeriod';
  static const String endPeriod = 'endPeriod';
  static const String prize = 'prize';
  static const String percent = 'percent';
  static const String ratio = 'ratio';

  // Special columns for project
  static const String title = 'title';
  static const String status = 'status';
  static const String price = 'price';
  static const String complete = 'complete';
}
