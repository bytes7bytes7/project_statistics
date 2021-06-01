import 'package:flutter/material.dart';
import 'package:project_statistics/bloc/bloc.dart';
import 'package:project_statistics/constants.dart';
import 'package:project_statistics/screens/global/global_parameters.dart';
import 'package:project_statistics/screens/widgets/show_no_yes_dialog.dart';
import 'show_info_snack_bar.dart';

class BottomNavBar extends StatelessWidget {
  const BottomNavBar({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: (GlobalParameters.currentPageIndex.value == -1) ? 1 : GlobalParameters.currentPageIndex.value,
      type: BottomNavigationBarType.fixed,
      elevation: 10,
      showSelectedLabels: false,
      showUnselectedLabels: false,
      onTap: (int index) async {
        bool result = await Permission.planComplete();
        bool equal = true;
        // Plan originalPlan = await GlobalParameters.originalPlan;
        // Plan newPlan = GlobalParameters.newPlan;
        // if(newPlan.quantity.isEmpty && newPlan.amount.isEmpty && newPlan.startPeriod == null && newPlan.endPeriod == null && newPlan.prize == null){
        //   print('ok');
        // }else if (!(GlobalParameters.newPlan == originalPlan) && ConstantData.currentPageIndex.value == 0)
        //   equal = false;
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
