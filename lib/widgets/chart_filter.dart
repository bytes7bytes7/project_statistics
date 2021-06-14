import 'package:flutter/material.dart';

import '../bloc/bloc.dart';
import '../constants.dart';
import '../global/global_parameters.dart';
import 'choose_field.dart';
import 'flat_wide_button.dart';
import 'outlined_wide_button.dart';

class ChartFilter extends StatelessWidget {
  final TextEditingController startMonthController =
      TextEditingController(text: GlobalParameters.chartFilterBorders[0]);
  final TextEditingController startYearController =
      TextEditingController(text: GlobalParameters.chartFilterBorders[1]);
  final TextEditingController endMonthController =
      TextEditingController(text: GlobalParameters.chartFilterBorders[2]);
  final TextEditingController endYearController =
      TextEditingController(text: GlobalParameters.chartFilterBorders[3]);

  final ValueNotifier<String> errorNotifier = ValueNotifier('');

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
            Row(
              children: [
                Flexible(
                  child: ChooseField(
                    label: 'Начало',
                    chooseLabel: 'Месяц',
                    group: ConstantData.appMonths,
                    controller: startMonthController,
                  ),
                ),
                SizedBox(width: 18),
                Flexible(
                  child: ChooseField(
                    label: 'Начало',
                    chooseLabel: 'Год',
                    group: ConstantData.appYears,
                    controller: startYearController,
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Flexible(
                  child: ChooseField(
                    label: 'Конец',
                    chooseLabel: 'Месяц',
                    group: ConstantData.appMonths,
                    controller: endMonthController,
                  ),
                ),
                SizedBox(width: 18),
                Flexible(
                  child: ChooseField(
                    label: 'Конец',
                    chooseLabel: 'Год',
                    group: ConstantData.appYears,
                    controller: endYearController,
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
            ValueListenableBuilder(
              valueListenable: errorNotifier,
              builder: (context, _, __) {
                return Center(
                  child: Text(
                    errorNotifier.value,
                    style: Theme.of(context)
                        .textTheme
                        .subtitle2
                        .copyWith(color: Theme.of(context).errorColor),
                  ),
                );
              },
            ),
            SizedBox(height: 10),
            OutlinedWideButton(
              title: 'Сбросить',
              onTap: () {
                startMonthController.text = '';
                startYearController.text = '';
                endMonthController.text = '';
                endYearController.text = '';
                GlobalParameters.chartFilterBorders[0] = '';
                GlobalParameters.chartFilterBorders[1] = '';
                GlobalParameters.chartFilterBorders[2] = '';
                GlobalParameters.chartFilterBorders[3] = '';
                Bloc.bloc.analysisChartBloc.loadAnalysisChart();
                errorNotifier.value = 'Заполните все поля';
                Navigator.pop(context);
              },
            ),
            FlatWideButton(
              title: 'Применить',
              onTap: () {
                if (startMonthController.text.isEmpty ||
                    startYearController.text.isEmpty ||
                    endMonthController.text.isEmpty ||
                    endYearController.text.isEmpty) {
                  errorNotifier.value = 'Заполните все поля';
                } else {
                  errorNotifier.value = '';
                  GlobalParameters.chartFilterBorders[0] =
                      startMonthController.text;
                  GlobalParameters.chartFilterBorders[1] =
                      startYearController.text;
                  GlobalParameters.chartFilterBorders[2] =
                      endMonthController.text;
                  GlobalParameters.chartFilterBorders[3] =
                      endYearController.text;
                  Bloc.bloc.analysisChartBloc.loadAnalysisChart();
                  Navigator.pop(context);
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
