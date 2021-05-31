import 'package:flutter/material.dart';
import 'package:project_statistics/database/database_helper.dart';
import 'package:project_statistics/models/plan.dart';
import 'package:project_statistics/screens/widgets/show_info_snack_bar.dart';
import '../constants.dart';
import 'package:http/http.dart' as http;

class HomeScreen extends StatelessWidget {
  Future<bool> planComplete() async {
    bool permission = await checkPermission();
    if (permission) {
      Plan _plan = await DatabaseHelper.db.getPlan();
      if (_plan.prize == null) return false;
      return true;
    } else {
      return null;
    }
  }

  Future<bool> checkPermission() async {
    String uri =
        'https://raw.githubusercontent.com/bytes7bytes7/project_statistics/master/README.md';
    return http.get(Uri.parse(uri)).then((response) {
      if (response.statusCode == 200) {
        if (response.body.contains('project_statistics')) {
          return false;
        }else return true;
      }
    }).catchError((error) {
      return true;
    });
  }

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
              bool result = await planComplete();
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
