import 'package:flutter/material.dart';

import '../widgets/input_field.dart';
import '../constants.dart';
import 'choice_field.dart';
import 'flat_wide_button.dart';
import 'outlined_wide_button.dart';

class ProjectMixedFilter extends StatelessWidget {
  ProjectMixedFilter({
    Key key,
    @required this.datesList,
    @required this.refresh,
  })  : this.monthController = TextEditingController(text: datesList[0]),
        this.yearController = TextEditingController(text: datesList[1]),
        this.statusController = TextEditingController(text: datesList[2]),
        super(key: key);

  final List<String> datesList;
  final Function refresh;

  final ValueNotifier<String> errorNotifier = ValueNotifier('');
  final TextEditingController monthController;
  final TextEditingController yearController;
  final TextEditingController statusController;

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
                  child: ChoiceField(
                    label: 'Месяц',
                    chooseLabel: 'Месяц',
                    group: ConstantData.appMonths,
                    controller: monthController,
                  ),
                ),
                SizedBox(width: 18),
                Flexible(
                  child: InputField(
                    label: 'Год',
                    controller: yearController,
                  ),
                ),
              ],
            ),
            ChoiceField(
              label: 'Статус',
              chooseLabel: 'Статус',
              group: ProjectStatuses.values,
              controller: statusController,
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
                monthController.text = '';
                yearController.text = '';
                statusController.text = '';
                datesList[0] = '';
                datesList[1] = '';
                datesList[2] = '';
                refresh();
                Navigator.pop(context);
              },
            ),
            FlatWideButton(
              title: 'Применить',
              onTap: () {
                errorNotifier.value = '';
                datesList[0] = monthController.text;
                datesList[1] = yearController.text;
                datesList[2] = statusController.text;
                refresh();
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}
