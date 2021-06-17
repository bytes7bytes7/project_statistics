import 'package:flutter/material.dart';

import '../models/plan.dart';
import '../database/database_helper.dart';
import '../constants.dart';
import '../widgets/bottom_nav_bar.dart';
import '../global/global_parameters.dart';
import 'project_table_screen.dart';

class HomeScreen extends StatelessWidget {
  checkPlan() async {
    Plan plan = await DatabaseHelper.db.getPlan();
    if (plan.id != null) {
      GlobalParameters.planStartYear = int.parse(plan.start.substring(plan.start.indexOf(' ')+1,plan.start.length));
      GlobalParameters.planEndYear = int.parse(plan.end.substring(plan.end.indexOf(' ')+1,plan.end.length));
      GlobalParameters.currentPageIndex.value = 1;
    }else{
      GlobalParameters.currentPageIndex.value = 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    checkPlan();
    return ValueListenableBuilder(
      valueListenable: GlobalParameters.currentPageIndex,
      builder: (context, _, __) {
        if (GlobalParameters.currentPageIndex.value == null) {
          return Scaffold();
        } else {
          return Scaffold(
            body: (GlobalParameters.currentPageIndex.value == -1)
                ? ProjectTableScreen()
                : ConstantData
                    .appDestinations[GlobalParameters.currentPageIndex.value]
                    .screen,
            bottomNavigationBar: BottomNavBar(),
          );
        }
      },
    );
  }
}
