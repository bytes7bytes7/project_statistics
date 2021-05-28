import 'package:flutter/material.dart';
import '../screens/global/global_parameters.dart';
import '../screens/widgets/flat_wide_button.dart';
import '../screens/widgets/input_field.dart';
import '../screens/widgets/outlined_wide_button.dart';
import '../screens/widgets/plan_card.dart';

class StartScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            'Создание Плана',
            style: Theme.of(context).textTheme.headline1,
          ),
        ),
        body: _Body(),
      ),
    );
  }
}

class _Body extends StatelessWidget {
  const _Body({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      children: [
        PlanCard(
          title: 'Количество',
          children: [
            InputField(
              label: 'Запросы',
              controller: TextEditingController(),
            ),
            InputField(
              label: 'КП',
              controller: TextEditingController(),
            ),
            InputField(
              label: 'Тендеры',
              controller: TextEditingController(),
            ),
            InputField(
              label: 'Договоры',
              controller: TextEditingController(),
            ),
          ],
        ),
        PlanCard(
          title: 'Сумма',
          children: [
            InputField(
              label: 'Запросы',
              controller: TextEditingController(),
            ),
            InputField(
              label: 'КП',
              controller: TextEditingController(),
            ),
            InputField(
              label: 'Тендеры',
              controller: TextEditingController(),
            ),
            InputField(
              label: 'Договоры',
              controller: TextEditingController(),
            ),
          ],
        ),
        PlanCard(
          title: 'Дополнительно',
          children: [
            InputField(
              label: 'Срок',
              controller: TextEditingController(),
            ),
            InputField(
              label: 'Премия',
              controller: TextEditingController(),
            ),
          ],
        ),
        OutlinedWideButton(
          title: 'Импорт',
          onTap: () {},
        ),
        OutlinedWideButton(
          title: 'Экспорт',
          onTap: () {},
        ),
        FlatWideButton(
          title: 'Готово',
          onTap: () {
            GlobalParameters.currentPageIndex.value = 1;
          },
        ),
      ],
    );
  }
}
