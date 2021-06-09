import 'package:flutter/material.dart';

import '../bloc/bloc.dart';
import '../constants.dart';
import '../global/global_parameters.dart';
import 'choose_field.dart';
import 'flat_wide_button.dart';
import 'outlined_wide_button.dart';

class ChartFilter extends StatelessWidget {
  final TextEditingController startPeriodController =
      TextEditingController(text: GlobalParameters.chartFilterBorders[0]);
  final TextEditingController endPeriodController =
      TextEditingController(text: GlobalParameters.chartFilterBorders[1]);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      title: Center(
        child: Text(
          'Фильтр',
          style: Theme.of(context).textTheme.headline2,
        ),
      ),
      content: SingleChildScrollView(
        child: ListBody(
          children: <Widget>[
            ChooseField(
              label: 'Начало',
              chooseLabel: 'Начало срока',
              group: ConstantData.appMonths,
              controller: startPeriodController,
            ),
            ChooseField(
              label: 'Конец',
              chooseLabel: 'Конец срока',
              group: ConstantData.appMonths,
              controller: endPeriodController,
            ),
            SizedBox(height: 10),
            OutlinedWideButton(
              title: 'Сбросить',
              onTap: () {
                startPeriodController.text = '';
                endPeriodController.text = '';
                GlobalParameters.chartFilterBorders[0] = '';
                GlobalParameters.chartFilterBorders[1] = '';
                Bloc.bloc.analysisChartBloc.loadAnalysisChart();
                Navigator.pop(context);
              },
            ),
            FlatWideButton(
              title: 'Применить',
              onTap: () {
                GlobalParameters.chartFilterBorders[0] =
                    startPeriodController.text;
                GlobalParameters.chartFilterBorders[1] =
                    endPeriodController.text;
                Bloc.bloc.analysisChartBloc.loadAnalysisChart();
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}
