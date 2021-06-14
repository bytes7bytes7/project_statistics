import 'package:flutter/material.dart';

import '../constants.dart';
import 'choose_field.dart';
import 'flat_wide_button.dart';
import 'outlined_wide_button.dart';

class ProjectFilter extends StatelessWidget {
  ProjectFilter({
    Key key,
    @required this.staticList,
    @required this.refresh,
  })  : this.startMonthController = TextEditingController(text: staticList[0]),
        this.startYearController = TextEditingController(text: staticList[1]),
        this.endMonthController = TextEditingController(text: staticList[2]),
        this.endYearController = TextEditingController(text: staticList[3]),
        super(key: key);

  final List<String> staticList;
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
                staticList[0] = '';
                staticList[1] = '';
                staticList[2] = '';
                staticList[3] = '';
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
                  staticList[0] = startMonthController.text;
                  staticList[1] = startYearController.text;
                  staticList[2] = endMonthController.text;
                  staticList[3] = endYearController.text;
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
