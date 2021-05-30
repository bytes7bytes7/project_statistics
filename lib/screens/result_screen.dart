import 'package:flutter/material.dart';
import 'package:project_statistics/bloc/bloc.dart';
import 'package:project_statistics/bloc/result_bloc.dart';
import 'package:project_statistics/constants.dart';
import 'package:project_statistics/models/result.dart';
import 'package:project_statistics/screens/widgets/flat_small_button.dart';

import '../screens/widgets/input_field.dart';
import 'widgets/loading_circle.dart';
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

class _Body extends StatefulWidget {
  const _Body({
    Key key,
  }) : super(key: key);

  @override
  __BodyState createState() => __BodyState();
}

class __BodyState extends State<_Body> {
  @override
  void dispose() {
    Bloc.bloc.resultBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: StreamBuilder(
        stream: Bloc.bloc.resultBloc.result,
        initialData: ResultInitState(),
        builder: (context, snapshot) {
          if (snapshot.data is ResultInitState) {
            Bloc.bloc.resultBloc.loadResult('', '');
            return SizedBox.shrink();
          } else if (snapshot.data is ResultLoadingState) {
            return _buildLoading();
          } else if (snapshot.data is ResultDataState) {
            ResultDataState state = snapshot.data;
            return _ContentList(result: state.result);
          } else {
            return _buildError();
          }
        },
      ),
    );
  }

  Widget _buildLoading() {
    return Center(
      child: LoadingCircle(),
    );
  }

  Widget _buildError() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Ошибка',
            style: Theme.of(context).textTheme.headline1,
          ),
          SizedBox(height: 20),
          FlatSmallButton(
            title: 'Обновить',
            onTap: () {
              Bloc.bloc.resultBloc.loadResult('', '');
            },
          ),
        ],
      ),
    );
  }
}

class _ContentList extends StatelessWidget {
  const _ContentList({
    Key key,
    @required this.result,
  }) : super(key: key);

  final Result result;

  @override
  Widget build(BuildContext context) {
    String amount, amountMeasure;
    MeasureBeautifier()
        .formatNumber(result.amount, MeasureLevel.unit, 'руб.')
        .reduce((a, b) {
      amount = a;
      amountMeasure = b;
      return;
    });

    String quantity, quantityMeasure;
    MeasureBeautifier()
        .formatNumber(result.quantity, MeasureLevel.unit, 'шт.')
        .reduce((a, b) {
      quantity = a;
      quantityMeasure = b;
      return;
    });

    String plan, planMeasure;
    MeasureBeautifier()
        .formatNumber(result.plan, MeasureLevel.thousands, 'руб.')
        .reduce((a, b) {
      plan = a;
      planMeasure = b;
      return;
    });

    String percent = result.percent.toString(), percentMeasure = '%';

    String until, untilMeasure;
    MeasureBeautifier()
        .formatNumber(result.until, MeasureLevel.unit, 'руб.')
        .reduce((a, b) {
      until = a;
      untilMeasure = b;
      return;
    });

    String prize, prizeMeasure;
    MeasureBeautifier()
        .formatNumber(result.prize, MeasureLevel.thousands, 'руб.')
        .reduce((a, b) {
      prize = a;
      prizeMeasure = b;
      return;
    });

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
          data: amount,
          measure: amountMeasure,
        ),
        ResultInfoLine(
          title: 'Количество\nзаключенных\nдоговоров',
          data: quantity,
          measure: quantityMeasure,
        ),
        ResultInfoLine(
          title: 'План',
          data: plan,
          measure: planMeasure,
        ),
        ResultInfoLine(
          title: 'Процент\nвыполнения',
          data: percent,
          measure: percentMeasure,
        ),
        ResultInfoLine(
          title: 'Сумма до\nвыполнения',
          data: until,
          measure: untilMeasure,
        ),
        ResultInfoLine(
          title: 'Премия',
          data: prize,
          measure: prizeMeasure,
        ),
      ],
    );
  }
}
