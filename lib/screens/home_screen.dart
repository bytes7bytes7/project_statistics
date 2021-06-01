import 'package:flutter/material.dart';
import 'package:project_statistics/screens/widgets/show_info_snack_bar.dart';
import '../constants.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: ConstantData.currentPageIndex,
      builder: (context, currentIndex, child) {
        return Scaffold(
          body: ConstantData
              .appDestinations[ConstantData.currentPageIndex.value].screen,
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: ConstantData.currentPageIndex.value,
            type: BottomNavigationBarType.fixed,
            elevation: 10,
            showSelectedLabels: false,
            showUnselectedLabels: false,
            onTap: (int index) async {
              bool result = await Permission.planComplete();
              if (result == true)
                ConstantData.currentPageIndex.value = index;
              else if (result == false)
                showInfoSnackBar(
                  context: context,
                  info: 'Заполните все поля',
                  icon: Icons.warning_amber_outlined,
                );
            },
            items: ConstantData.appDestinations.map((destination) {
              return BottomNavigationBarItem(
                icon: Icon(
                  destination.icon,
                  size: 22,
                  color: (ConstantData
                              .appDestinations[
                                  ConstantData.currentPageIndex.value]
                              .name ==
                          destination.name)
                      ? Theme.of(context).primaryColor
                      : Theme.of(context).shadowColor,
                ),
                label: '',
              );
            }).toList(),
          ),
        );
      },
    );
  }
}
