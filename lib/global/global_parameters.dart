import 'package:flutter/material.dart';

import '../constants.dart';
import '../database/database_helper.dart';
import '../models/plan.dart';

class GlobalParameters {
  static DateTime today = DateTime.now();
  static const halfRange = 4; // Must be even
  static List<String> _appYears;
  static int planStartYear;
  static int planEndYear;

  static get appYears {
    if (_appYears == null) {
      _appYears = _getAppYears();
      return _appYears;
    }
    return _appYears;
  }

  static get planYears {
    return _getPlanYears();
  }

  static List<String> _getAppYears() {
    List<String> result = [];
    for (int i = 0; i < halfRange; i++) {
      result.add((today.year + halfRange - i).toString());
    }
    for (int i = halfRange; i > 0; i--) {
      result.add((today.year - halfRange + i).toString());
    }

    return result;
  }

  static List<String> _getPlanYears() {
    if (planStartYear == null) {
      return null;
    } else {
      List<String> result = [];
      for (int i = planEndYear; i >= planStartYear; i--) {
        result.add(i.toString());
      }
      return result;
    }
  }

  static final ValueNotifier<int> currentPageIndex = ValueNotifier(null);
  static String projectSortParamName = ProjectParameterNames.title;
  static String projectSortParamDirection =
      ConstantData.appProjectParameterDirection[0];
  static List<String> projectFilterBorders = ['', ''];
  static List<String> chartFilterBorders = ['', ''];
  static List<String> resultFilterBorders = ['', ''];

  static Plan newPlan = Plan(quantity: [], amount: []);

  static Future<Plan> get originalPlan async {
    return await DatabaseHelper.db.getPlan();
  }
}
