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

class ProjectCompleteStatuses {
  static const String notCompleted = 'не завершен';
  static const String canceled = 'отменен';
}

class ProjectStatuses {
  ProjectStatuses._internal();

  static final ProjectStatuses _singleton = ProjectStatuses._internal();

  factory ProjectStatuses() {
    return _singleton;
  }

  static const String request = 'Запросы';
  static const String kp = 'КП';
  static const String hot = 'Горячие!!!';
  static const String contract = 'Договоры';

  static final length = 4;

  static int indexOf(String value) {
    switch (value) {
      case request:
        return 0;
      case kp:
        return 1;
      case hot:
        return 2;
      case contract:
        return 3;
      default:
        return -1;
    }
  }

  operator [](int index) {
    switch (index) {
      case 0:
        return request;
      case 1:
        return kp;
      case 2:
        return hot;
      case 3:
        return contract;
      default:
        return '';
    }
  }

  static List<String> values() {
    return <String>[request, kp, hot, contract];
  }
}

abstract class ConstantData {
  static const String forbiddenFileCharacters = r'\/:*?"<>|+%!@';
  static const List<String> appProjectParameterNames = [
    'Название',
    'Сумма',
    'Статус',
    'Срок',
    'Завершенность',
  ];
  static const List<String> appProjectParameterDirection = [
    'По возрастанию',
    'По убыванию'
  ];
  static const List<String> appProjectSortDirection = [
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
  static final Map<String, String> appToolTips = {
    'add': 'Добавить',
    'table': 'Таблица',
    'list': 'Список',
    'filter': 'Фильтр',
    'refresh': 'Обновить',
    'throw': 'Сбросить',
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
    // Destination(
    //   name: 'something',
    //   screen: Scaffold(),
    //   icon: NavigationBarIcons.question_circle,
    // ),
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
