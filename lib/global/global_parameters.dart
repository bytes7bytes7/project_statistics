import 'package:flutter/material.dart';

import '../constants.dart';
import '../database/database_helper.dart';
import '../models/plan.dart';

class GlobalParameters {
  static final ValueNotifier<int> currentPageIndex = ValueNotifier(0);
  static String projectSortParamName = ConstantData.appProjectParameterNames[0];
  static String projectSortParamDirection =
      ConstantData.appProjectParameterDirection[0];
  static List<String> chartFilterBorders = ['', ''];

  static Plan newPlan = Plan(quantity: [], amount: []);

  static Future<Plan> get originalPlan async {
    return await DatabaseHelper.db.getPlan();
  }
}
