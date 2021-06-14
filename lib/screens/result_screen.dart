import 'package:flutter/material.dart';

import '../global/global_parameters.dart';
import '../widgets/choose_field.dart';
import '../widgets/empty_label.dart';
import '../widgets/loading_circle.dart';
import '../widgets/error_label.dart';
import '../widgets/result_info_line.dart';
import '../bloc/bloc.dart';
import '../bloc/result_bloc.dart';
import '../services/measure_beautifier.dart';
import '../constants.dart';
import '../models/result.dart';

class ResultScreen extends StatelessWidget {
  final TextEditingController startPeriodController =
      TextEditingController(text: GlobalParameters.resultFilterBorders[0]);
  final TextEditingController endPeriodController =
      TextEditingController(text: GlobalParameters.resultFilterBorders[1]);

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
          leading: IconButton(
            icon: const Icon(Icons.delete),
            tooltip: ConstantData.appToolTips['throw'],
            onPressed: () {
              startPeriodController.text = '';
              endPeriodController.text = '';
              GlobalParameters.resultFilterBorders[0] = '';
              GlobalParameters.resultFilterBorders[1] = '';
              Bloc.bloc.resultBloc.loadResult();
            },
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.refresh_outlined),
              tooltip: ConstantData.appToolTips['refresh'],
              onPressed: () {
                GlobalParameters.resultFilterBorders[0] =
                    startPeriodController.text ?? '';
                GlobalParameters.resultFilterBorders[1] =
                    endPeriodController.text ?? '';
                Bloc.bloc.resultBloc.loadResult();
              },
            ),
          ],
        ),
        body: _Body(
          startPeriodController: startPeriodController,
          endPeriodController: endPeriodController,
        ),
      ),
    );
  }
}

class _Body extends StatefulWidget {
  const _Body({
    Key key,
    @required this.startPeriodController,
    @required this.endPeriodController,
  }) : super(key: key);

  final TextEditingController startPeriodController;
  final TextEditingController endPeriodController;

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
            Bloc.bloc.resultBloc.loadResult();
            return SizedBox.shrink();
          } else if (snapshot.data is ResultLoadingState) {
            return LoadingCircle();
          } else if (snapshot.data is ResultDataState) {
            ResultDataState state = snapshot.data;
            if (state.result.amount != null) {
              return _ContentList(
                result: state.result,
                startPeriodController: widget.startPeriodController,
                endPeriodController: widget.endPeriodController,
              );
            } else {
              return EmptyLabel();
            }
          } else {
            return ErrorLabel(
              error: snapshot.data.error,
              stackTrace: snapshot.data.stackTrace,
              onPressed: () {
                Bloc.bloc.resultBloc.loadResult();
              },
            );
          }
        },
      ),
    );
  }
}

class _ContentList extends StatelessWidget {
  _ContentList({
    Key key,
    @required this.result,
    @required this.startPeriodController,
    @required this.endPeriodController,
  }) : super(key: key);

  final Result result;
  final TextEditingController startPeriodController;
  final TextEditingController endPeriodController;

  @override
  Widget build(BuildContext context) {
    String amount, amountMeasure;
    MeasureBeautifier()
        .formatNumber(
      number: result.amount,
      level: MeasureLevel.unit,
      measure: 'руб.',
    )
        .reduce((a, b) {
      amount = a;
      amountMeasure = b;
      return;
    });

    String quantity, quantityMeasure;
    MeasureBeautifier()
        .formatNumber(
      number: result.quantity,
      level: MeasureLevel.unit,
      measure: 'шт.',
    )
        .reduce((a, b) {
      quantity = a;
      quantityMeasure = b;
      return;
    });

    String plan, planMeasure;
    MeasureBeautifier()
        .formatNumber(
      number: result.plan,
      level: MeasureLevel.millions,
      measure: 'руб.',
    )
        .reduce((a, b) {
      plan = a;
      planMeasure = b;
      return;
    });

    String percent = result.percent.toString(), percentMeasure = '%';

    String until, untilMeasure;
    MeasureBeautifier()
        .formatNumber(
      number: result.until,
      level: MeasureLevel.unit,
      measure: 'руб.',
    )
        .reduce((a, b) {
      until = a;
      untilMeasure = b;
      return;
    });

    String prize, prizeMeasure;
    MeasureBeautifier()
        .formatNumber(
      number: result.prize,
      level: MeasureLevel.thousands,
      measure: 'руб.',
    )
        .reduce((a, b) {
      prize = a;
      prizeMeasure = b;
      return;
    });

    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      children: [
        SizedBox(height: 10),
        Row(
          children: [
            Flexible(
              child: ChooseField(
                label: 'Начало',
                chooseLabel: 'Начало срока',
                group: ConstantData.appMonths,
                controller: startPeriodController,
              ),
            ),
            SizedBox(width: 18),
            Flexible(
              child: ChooseField(
                label: 'Конец',
                chooseLabel: 'Конец срока',
                group: ConstantData.appMonths,
                controller: endPeriodController,
              ),
            ),
          ],
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
