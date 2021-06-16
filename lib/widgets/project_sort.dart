import 'package:flutter/material.dart';

import '../bloc/bloc.dart';
import '../global/global_parameters.dart';
import '../constants.dart';
import 'choice_field.dart';
import 'flat_wide_button.dart';

class ProjectSort extends StatelessWidget {
  final TextEditingController parameterController =
      TextEditingController(text: GlobalParameters.projectSortParamName);
  final TextEditingController directionController =
      TextEditingController(text: GlobalParameters.projectSortParamDirection);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      title: Center(
        child: Text(
          'Сортировка',
          style: Theme.of(context).textTheme.headline2,
        ),
      ),
      content: SingleChildScrollView(
        child: ListBody(
          children: <Widget>[
            ChoiceField(
              label: 'Параметр',
              chooseLabel: 'Параметр',
              group: ProjectParameterNames.values,
              controller: parameterController,
            ),
            ChoiceField(
              label: 'Порядок',
              chooseLabel: 'Порядок',
              group: ConstantData.appProjectParameterDirection,
              controller: directionController,
            ),
            SizedBox(height: 10),
            FlatWideButton(
              title: 'Применить',
              onTap: () async {
                GlobalParameters.projectSortParamName =
                    parameterController.text;
                GlobalParameters.projectSortParamDirection =
                    directionController.text;
                Bloc.bloc.projectBloc.loadAllProjects();
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}
