import 'package:flutter/material.dart';
import 'package:project_statistics/widgets/project_filter.dart';

import '../global/global_parameters.dart';
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
          actions: [
            IconButton(
              icon: const Icon(Icons.filter_alt_outlined),
              tooltip: ConstantData.appToolTips['filter'],
              onPressed: () {
                showDialog<void>(
                  context: context,
                  barrierDismissible: true,
                  builder: (BuildContext context) {
                    return ProjectFilter(
                      datesList: GlobalParameters.resultFilterBorders,
                      refresh: () {
                        Bloc.bloc.resultBloc.loadResult();
                      },
                    );
                  },
                );
              },
            ),
          ],
        ),
        body: _Body(),
      ),
    );
  }
}

class _Body extends StatefulWidget {
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
  }) : super(key: key);

  final Result result;

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
      level: MeasureLevel.unit,
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
      level: MeasureLevel.unit,
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
