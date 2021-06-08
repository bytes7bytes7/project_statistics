import 'package:flutter/material.dart';

import '../constants.dart';
import '../widgets/bottom_nav_bar.dart';
import '../global/global_parameters.dart';
import 'project_table_screen.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: GlobalParameters.currentPageIndex,
      builder: (context, currentIndex, child) {
        return Scaffold(
          body: (GlobalParameters.currentPageIndex.value == -1)
              ? ProjectTableScreen()
              : ConstantData
                  .appDestinations[GlobalParameters.currentPageIndex.value].screen,
          bottomNavigationBar: BottomNavBar(),
        );
      },
    );
  }
}
