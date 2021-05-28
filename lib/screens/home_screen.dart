import 'package:flutter/material.dart';
import 'global/global_parameters.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: GlobalParameters.currentPageIndex,
      builder: (context, currentIndex, child) {
        return Scaffold(
          body: GlobalParameters
              .appDestinations[GlobalParameters.currentPageIndex.value].screen,
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: GlobalParameters.currentPageIndex.value,
            type: BottomNavigationBarType.fixed,
            elevation: 10,
            showSelectedLabels: false,
            showUnselectedLabels: false,
            onTap: (int index) {
              GlobalParameters.currentPageIndex.value = index;
            },
            items: GlobalParameters.appDestinations.map((destination) {
              return BottomNavigationBarItem(
                icon: Icon(
                  destination.icon,
                  color: (GlobalParameters
                              .appDestinations[
                                  GlobalParameters.currentPageIndex.value]
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
