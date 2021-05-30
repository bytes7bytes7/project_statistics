import 'package:flutter/material.dart';
import 'package:project_statistics/models/destination.dart';
import 'package:project_statistics/screens/analysis_chart_screen.dart';
import 'package:project_statistics/screens/project_list_screen.dart';
import 'package:project_statistics/screens/result_screen.dart';
import 'package:project_statistics/screens/start_screen.dart';

class GlobalParameters {
  static final Map<String, String> appToolTips = {
    'add': 'Добавить',
    'table' : 'Таблица',
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
