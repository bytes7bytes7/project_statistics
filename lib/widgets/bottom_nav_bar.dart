import 'package:flutter/material.dart';

import '../database/database_helper.dart';
import '../models/plan.dart';
import '../bloc/bloc.dart';
import '../constants.dart';
import '../global/global_parameters.dart';
import 'show_no_yes_dialog.dart';
import 'show_info_snack_bar.dart';

class BottomNavBar extends StatelessWidget {
  const BottomNavBar({
    Key key,
  }) : super(key: key);

  Future planComplete() async {
    Plan _plan = await DatabaseHelper.db.getPlan();
    if (_plan.prize == null) return false;
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: (GlobalParameters.currentPageIndex.value == -1) ? 1 : GlobalParameters.currentPageIndex.value,
      type: BottomNavigationBarType.fixed,
      elevation: 10,
      showSelectedLabels: false,
      showUnselectedLabels: false,
      onTap: (int index) async {
        bool result = await planComplete();
        bool equal = true;
        if (result && equal) {
          if(GlobalParameters.currentPageIndex.value != 1 && GlobalParameters.currentPageIndex.value!= -1 && Bloc.bloc.projectBloc.project != null){
            Bloc.bloc.projectBloc.dispose();
          }
          GlobalParameters.currentPageIndex.value = index;
        } else if (!result) {
          showInfoSnackBar(
            context: context,
            info: 'Заполните все поля',
            icon: Icons.warning_amber_outlined,
          );
        } else if (!equal) {
          showNoYesDialog(
            context: context,
            title: 'Изменения будут утеряны',
            subtitle: 'Покинуть карту плана?',
            noAnswer: () {
              Navigator.pop(context);
            },
            yesAnswer: () {
              Navigator.pop(context);
              GlobalParameters.currentPageIndex.value = index;
            },
          );
        }
      },
      items: ConstantData.appDestinations.map((destination) {
        return BottomNavigationBarItem(
          icon: Icon(
            destination.icon,
            size: 22,
            color: (ConstantData
                        .appDestinations[(GlobalParameters.currentPageIndex.value==-1) ? 1 : GlobalParameters.currentPageIndex.value]
                        .name ==
                    destination.name)
                ? Theme.of(context).primaryColor
                : Theme.of(context).shadowColor,
          ),
          label: '',
        );
      }).toList(),
    );
  }
}
