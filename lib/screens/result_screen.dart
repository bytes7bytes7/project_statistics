import 'package:flutter/material.dart';

import '../screens/widgets/input_field.dart';
import 'widgets/result_info_line.dart';

class ResultScreen extends StatelessWidget {
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
            'Результат',
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
        SizedBox(height: 10),
        InputField(
          label: 'Период',
          controller: TextEditingController(),
        ),
        SizedBox(height: 10),
        ResultInfoLine(
          title: 'Сумма\nзаключенных\nдоговоров',
          data: '10',
          measure: 'млн.\nруб.',
        ),
        ResultInfoLine(
          title: 'Количество\nзаключенных\nдоговоров',
          data: '5',
          measure: 'шт.',
        ),
        ResultInfoLine(
          title: 'План',
          data: '12',
          measure: 'млн.\nруб.',
        ),
        ResultInfoLine(
          title: 'Процент\nвыполнения',
          data: '78',
          measure: '%',
        ),
        ResultInfoLine(
          title: 'Сумма до\nвыполнения',
          data: '2',
          measure: 'млн.\nруб.',
        ),
        ResultInfoLine(
          title: 'Премия',
          data: '10',
          measure: 'тыс.\nруб.',
        ),
      ],
    );
  }
}

