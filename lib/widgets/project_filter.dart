import 'package:flutter/material.dart';

import '../constants.dart';
import 'choose_field.dart';
import 'flat_wide_button.dart';
import 'outlined_wide_button.dart';

class ProjectFilter extends StatelessWidget {
  ProjectFilter({
    Key key,
    @required this.datesList,
    @required this.refresh,
  })  : this.startMonthController = TextEditingController(text: datesList[0]),
        this.startYearController = TextEditingController(text: datesList[1]),
        this.endMonthController = TextEditingController(text: datesList[2]),
        this.endYearController = TextEditingController(text: datesList[3]),
        super(key: key);

  final List<String> datesList;
  final Function refresh;

  final ValueNotifier<String> errorNotifier = ValueNotifier('');
  final TextEditingController startMonthController;
  final TextEditingController startYearController;
  final TextEditingController endMonthController;
  final TextEditingController endYearController;

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
                datesList[0] = '';
                datesList[1] = '';
                datesList[2] = '';
                datesList[3] = '';
                refresh();
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
                  datesList[0] = startMonthController.text;
                  datesList[1] = startYearController.text;
                  datesList[2] = endMonthController.text;
                  datesList[3] = endYearController.text;
                  refresh();
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
