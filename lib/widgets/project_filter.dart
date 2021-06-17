import 'package:flutter/material.dart';

import '../widgets/double_choice_field.dart';
import '../global/global_parameters.dart';
import '../constants.dart';
import 'flat_wide_button.dart';
import 'outlined_wide_button.dart';

class ProjectFilter extends StatelessWidget {
  ProjectFilter({
    Key key,
    @required this.datesList,
    @required this.refresh,
  })  : this.startController = TextEditingController(text: datesList[0]),
        this.endController = TextEditingController(text: datesList[1]),
        super(key: key);

  final List<String> datesList;
  final Function refresh;

  final ValueNotifier<String> errorNotifier = ValueNotifier('');
  final TextEditingController startController;
  final TextEditingController endController;

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
            DoubleChoiceField(
              label: 'Начало',
              choiceLabel1: 'Месяц',
              choiceLabel2: 'Год',
              group1: ConstantData.appMonths,
              group2: GlobalParameters.planYears,
              controller: startController,
            ),
            DoubleChoiceField(
              label: 'Конец',
              choiceLabel1: 'Месяц',
              choiceLabel2: 'Год',
              group1: ConstantData.appMonths,
              group2: GlobalParameters.planYears,
              controller: endController,
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
                startController.text = '';
                endController.text = '';
                datesList[0] = '';
                datesList[1] = '';
                refresh();
                Navigator.pop(context);
              },
            ),
            FlatWideButton(
              title: 'Применить',
              onTap: () {
                errorNotifier.value = '';
                datesList[0] = startController.text;
                datesList[1] = endController.text;
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
