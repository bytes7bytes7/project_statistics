import 'package:flutter/material.dart';
import 'package:project_statistics/constants.dart';
import 'package:project_statistics/database/database_helper.dart';
import 'package:project_statistics/models/plan.dart';

class GlobalParameters {
  static final ValueNotifier<int> currentPageIndex = ValueNotifier(0);
  static String projectSortParamName = ConstantData.appProjectParameterNames[0];
  static String projectSortParamDirection =
      ConstantData.appProjectParameterDirection[0];

  static Plan newPlan = Plan(quantity: [], amount: []);

  static Future<Plan> get originalPlan async {
    return await DatabaseHelper.db.getPlan();
  }
}
