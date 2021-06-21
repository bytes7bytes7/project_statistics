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

  static get values {
    return <String>[
      request,
      kp,
      hot,
      contract,
    ];
  }
}

class ProjectParameterNames {
  ProjectParameterNames._internal();

  static final ProjectParameterNames _singleton =
      ProjectParameterNames._internal();

  factory ProjectParameterNames() {
    return _singleton;
  }

  static const String title = 'Название';
  static const String price = 'Сумма';
  static const String status = 'Статус';
  static const String month = 'Месяц';
  static const String year = 'Год';
  static const String complete = 'Завершенность';

  static final length = 5;

  static int indexOf(String value) {
    switch (value) {
      case title:
        return 0;
      case price:
        return 1;
      case status:
        return 2;
      case month:
        return 3;
      case year:
        return 4;
      case complete:
        return 5;
      default:
        return -1;
    }
  }

  operator [](int index) {
    switch (index) {
      case 0:
        return title;
      case 1:
        return price;
      case 2:
        return status;
      case 3:
        return month;
      case 4:
        return year;
      case 5:
        return complete;
      default:
        return '';
    }
  }

  static get values {
    return <String>[
      title,
      price,
      status,
      month,
      year,
      complete,
    ];
  }
}

abstract class ConstantData {
  static const String forbiddenFileCharacters = r'\/:*?"<>|+%!@';
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
    'sort': 'Сортировка',
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
  ];
}

class TranslatableVar {
  const TranslatableVar({
    @required this.en,
    @required this.ru,
  });

  final String en;
  final String ru;
}

abstract class ConstDBData {
  static final databaseName = "data.db";

  // Increment this version when you need to change the schema.
  static final databaseVersion = 1;

  // Names of tables
  static const TranslatableVar planTableName = TranslatableVar(
    en: 'plan',
    ru: 'План',
  );
  static const TranslatableVar projectTableName = TranslatableVar(
    en: 'project',
    ru: 'Проекты',
  );

  // Special columns for plan
  static const TranslatableVar id = TranslatableVar(
    en: 'id',
    ru: 'id',
  );
  static const TranslatableVar quantity = TranslatableVar(
    en: 'quantity',
    ru: 'Количество',
  );
  static const TranslatableVar amount = TranslatableVar(
    en: 'amount',
    ru: 'Сумма',
  );
  static const TranslatableVar startMonth = TranslatableVar(
    en: 'startMonth',
    ru: 'Начало Месяц',
  );
  static const TranslatableVar startYear = TranslatableVar(
    en: 'startYear',
    ru: 'Начало Год',
  );
  static const TranslatableVar endMonth = TranslatableVar(
    en: 'endMonth',
    ru: 'Конец Месяц',
  );
  static const TranslatableVar endYear = TranslatableVar(
    en: 'endYear',
    ru: 'Конец Год',
  );
  static const TranslatableVar prize = TranslatableVar(
    en: 'prize',
    ru: 'Премия',
  );
  static const TranslatableVar percent = TranslatableVar(
    en: 'percent',
    ru: 'Процент',
  );
  static const TranslatableVar ratio = TranslatableVar(
    en: 'ratio',
    ru: 'Коэффициент',
  );

  // Special columns for project
  static const TranslatableVar title = TranslatableVar(
    en: 'title',
    ru: 'Название',
  );
  static const TranslatableVar status = TranslatableVar(
    en: 'status',
    ru: 'Статус',
  );
  static const TranslatableVar month = TranslatableVar(
    en: 'month',
    ru: 'Месяц',
  );
  static const TranslatableVar year = TranslatableVar(
    en: 'year',
    ru: 'Год',
  );
  static const TranslatableVar price = TranslatableVar(
    en: 'price',
    ru: 'Цена',
  );
  static const TranslatableVar complete = TranslatableVar(
    en: 'complete',
    ru: 'Завершенность',
  );
}
