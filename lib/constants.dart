import 'package:flutter/material.dart';

import 'database/database_helper.dart';
import 'models/destination.dart';
import 'models/plan.dart';
import 'screens/analysis_chart_screen.dart';
import 'screens/project_list_screen.dart';
import 'screens/result_screen.dart';
import 'screens/start_screen.dart';

abstract class Permission {
  // static String filename = '/permission.txt';

  // static initApp() async {
  //   final path = await _localPath + filename;
  //   if (!(await File(path).exists())) {
  //     writeFile('1');
  //   }
  // }

  static Future planComplete() async {
    // bool permission = await checkPermission();
    // if (permission) {
    //   Plan _plan = await DatabaseHelper.db.getPlan();
    //   if (_plan.prize == null) return false;
    //   return true;
    // } else {
    //   return null;
    // }
    Plan _plan = await DatabaseHelper.db.getPlan();
    if (_plan.prize == null) return false;
    return true;
  }

  // static Future checkPermission() async {
  //   String uri = 'https://github.com/bytes7bytes7/project_statistics#readme';
  //   try {
  //     var response = await http.get(Uri.parse(uri));
  //     if (response.statusCode == 200) {
  //       if (response.body.contains('Use it for free.')) {
  //         return true;
  //       } else {
  //         writeFile('0');
  //         return false;
  //       }
  //     }
  //   } catch (error) {
  //     return await readFile().then((str) {
  //       if (str == '1')
  //         return true;
  //       else
  //         return false;
  //     });
  //   }
  // }

  // static Future<String> get _localPath async {
  //   final directory = await getApplicationDocumentsDirectory();
  //   return directory.path;
  // }
  //
  // static Future<File> localFile() async {
  //   final path = await _localPath + filename;
  //   return File(path);
  // }
  //
  // static Future<File> writeFile(String data) async {
  //   final file = await localFile();
  //   await file.writeAsString(data);
  //   return file;
  // }
  //
  // static Future<String> readFile() async {
  //   try {
  //     final file = await localFile();
  //     String str = await file.readAsString();
  //     return str;
  //   } catch (e) {
  //     return '1';
  //   }
  // }
}

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
    'filter': 'Фильтр',
  };
  static final ValueNotifier<int> currentPageIndex = ValueNotifier(0);
  static final List<Destination> appDestinations = [
    Destination(
      name: 'start',
      screen: StartScreen(),
      icon: Icons.not_started_outlined,
    ),
    Destination(
      name: 'project_list',
      screen: ProjectListScreen(),
      icon: Icons.table_chart_outlined,
    ),
    Destination(
      name: 'chart',
      screen: AnalysisChartScreen(),
      icon: Icons.bar_chart,
    ),
    Destination(
      name: 'result',
      screen: ResultScreen(),
      icon: Icons.list_alt_outlined,
    ),
    Destination(
      name: 'something',
      screen: Scaffold(),
      icon: Icons.help_outline_outlined,
    ),
  ];
}
