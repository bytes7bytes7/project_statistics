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
    return <String>[request, kp, hot, contract];
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
  static const String period = 'Срок';
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
      case period:
        return 3;
      case complete:
        return 4;
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
        return period;
      case 4:
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
      period,
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
  static final DateTime today = DateTime.now();
  static final List<String> appYears = List.generate(50, (index) {
    return (today.year - index).toString();
  });
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
  static String locale = 'en';
  static final databaseName = "data.db";

  // Increment this version when you need to change the schema.
  static final databaseVersion = 1;

  // Names of tables
  static const TranslatableVar _planTableName = TranslatableVar(
    en: 'plan',
    ru: 'План',
  );
  static const TranslatableVar _projectTableName = TranslatableVar(
    en: 'project',
    ru: 'Проекты',
  );

  // Special columns for plan
  static const TranslatableVar _id = TranslatableVar(
    en: 'id',
    ru: 'id',
  );
  static const TranslatableVar _quantity = TranslatableVar(
    en: 'quantity',
    ru: 'Кол-во',
  );
  static const TranslatableVar _amount = TranslatableVar(
    en: 'amount',
    ru: 'Сумма',
  );
  static const TranslatableVar _startMonth = TranslatableVar(
    en: 'startMonth',
    ru: 'Начало - Месяц',
  );
  static const TranslatableVar _startYear = TranslatableVar(
    en: 'startYear',
    ru: 'Начало - Год',
  );
  static const TranslatableVar _endMonth = TranslatableVar(
    en: 'endMonth',
    ru: 'Конец - Месяц',
  );
  static const TranslatableVar _endYear = TranslatableVar(
    en: 'endYear',
    ru: 'Конец - Год',
  );
  static const TranslatableVar _prize = TranslatableVar(
    en: 'prize',
    ru: 'Премия',
  );
  static const TranslatableVar _percent = TranslatableVar(
    en: 'percent',
    ru: 'Процент',
  );
  static const TranslatableVar _ratio = TranslatableVar(
    en: 'ratio',
    ru: 'Коэффициент',
  );

  // Special columns for project
  static const TranslatableVar _title = TranslatableVar(
    en: 'title',
    ru: 'Название',
  );
  static const TranslatableVar _status = TranslatableVar(
    en: 'status',
    ru: 'Статус',
  );
  static const TranslatableVar _price = TranslatableVar(
    en: 'price',
    ru: 'Цена',
  );
  static const TranslatableVar _month = TranslatableVar(
    en: 'month',
    ru: 'Месяц',
  );
  static const TranslatableVar _year = TranslatableVar(
    en: 'year',
    ru: 'Год',
  );
  static const TranslatableVar _complete = TranslatableVar(
    en: 'complete',
    ru: 'Завершенность',
  );

  // Getters
  static String get planTableName {
    if (locale == 'en') {
      return _planTableName.en;
    } else if (locale == 'ru') {
      return _planTableName.ru;
    } else {
      return 'undefined locale';
    }
  }

  static String get projectTableName {
    if (locale == 'en') {
      return _projectTableName.en;
    } else if (locale == 'ru') {
      return _projectTableName.ru;
    } else {
      return 'undefined locale';
    }
  }

  // Special columns for plan
  static String get id {
    if (locale == 'en') {
      return _id.en;
    } else if (locale == 'ru') {
      return _id.ru;
    } else {
      return 'undefined locale';
    }
  }

  static String get quantity {
    if (locale == 'en') {
      return _quantity.en;
    } else if (locale == 'ru') {
      return _quantity.ru;
    } else {
      return 'undefined locale';
    }
  }

  static String get amount {
    if (locale == 'en') {
      return _amount.en;
    } else if (locale == 'ru') {
      return _amount.ru;
    } else {
      return 'undefined locale';
    }
  }

  static String get prize {
    if (locale == 'en') {
      return _prize.en;
    } else if (locale == 'ru') {
      return _prize.ru;
    } else {
      return 'undefined locale';
    }
  }

  static String get percent {
    if (locale == 'en') {
      return _percent.en;
    } else if (locale == 'ru') {
      return _percent.ru;
    } else {
      return 'undefined locale';
    }
  }

  static String get ratio {
    if (locale == 'en') {
      return _ratio.en;
    } else if (locale == 'ru') {
      return _ratio.ru;
    } else {
      return 'undefined locale';
    }
  }

  // Special columns for project
  static String get title {
    if (locale == 'en') {
      return _title.en;
    } else if (locale == 'ru') {
      return _title.ru;
    } else {
      return 'undefined locale';
    }
  }

  static String get status {
    if (locale == 'en') {
      return _status.en;
    } else if (locale == 'ru') {
      return _status.ru;
    } else {
      return 'undefined locale';
    }
  }

  static String get startMonth {
    if (locale == 'en') {
      return _startMonth.en;
    } else if (locale == 'ru') {
      return _startMonth.ru;
    } else {
      return 'undefined locale';
    }
  }

  static String get startYear {
    if (locale == 'en') {
      return _startYear.en;
    } else if (locale == 'ru') {
      return _startYear.ru;
    } else {
      return 'undefined locale';
    }
  }

  static String get endMonth {
    if (locale == 'en') {
      return _endMonth.en;
    } else if (locale == 'ru') {
      return _endMonth.ru;
    } else {
      return 'undefined locale';
    }
  }

  static String get endYear {
    if (locale == 'en') {
      return _endYear.en;
    } else if (locale == 'ru') {
      return _endYear.ru;
    } else {
      return 'undefined locale';
    }
  }

  static String get price {
    if (locale == 'en') {
      return _price.en;
    } else if (locale == 'ru') {
      return _price.ru;
    } else {
      return 'undefined locale';
    }
  }

  static String get month {
    if (locale == 'en') {
      return _month.en;
    } else if (locale == 'ru') {
      return _month.ru;
    } else {
      return 'undefined locale';
    }
  }

  static String get year {
    if (locale == 'en') {
      return _year.en;
    } else if (locale == 'ru') {
      return _year.ru;
    } else {
      return 'undefined locale';
    }
  }

  static String get complete {
    if (locale == 'en') {
      return _complete.en;
    } else if (locale == 'ru') {
      return _complete.ru;
    } else {
      return 'undefined locale';
    }
  }
}
