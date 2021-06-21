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
  final ValueNotifier<bool> viewFullNumber = ValueNotifier(false);

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
        body: _Body(
          viewFullNumber: viewFullNumber,
        ),
        floatingActionButton: ValueListenableBuilder(
          valueListenable: viewFullNumber,
          builder: (context, _, __) {
            return FloatingActionButton(
              child: viewFullNumber.value
                  ? Icon(Icons.close_fullscreen_outlined)
                  : Icon(Icons.open_in_full_outlined),
              onPressed: () {
                viewFullNumber.value = !viewFullNumber.value;
              },
            );
          },
        ),
      ),
    );
  }
}

class _Body extends StatefulWidget {
  const _Body({
    Key key,
    @required this.viewFullNumber,
  }) : super(key: key);

  final ValueNotifier<bool> viewFullNumber;

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
                viewFullNumber: widget.viewFullNumber,
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
    @required this.viewFullNumber,
  }) : super(key: key);

  final Result result;
  final ValueNotifier<bool> viewFullNumber;

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

    return ValueListenableBuilder(
      valueListenable: viewFullNumber,
      builder: (context, _, __) {
        return ListView(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          children: [
            SizedBox(height: 10),
            ResultInfoLine(
              title: 'Сумма\nзаключенных\nдоговоров',
              data: amount,
              measure: amountMeasure,
              viewFullNumber: viewFullNumber,
            ),
            ResultInfoLine(
              title: 'Количество\nзаключенных\nдоговоров',
              data: quantity,
              measure: quantityMeasure,
              viewFullNumber: viewFullNumber,
            ),
            ResultInfoLine(
              title: 'План',
              data: plan,
              measure: planMeasure,
              viewFullNumber: viewFullNumber,
            ),
            ResultInfoLine(
              title: 'Процент\nвыполнения',
              data: percent,
              measure: percentMeasure,
              viewFullNumber: viewFullNumber,
            ),
            ResultInfoLine(
              title: 'Сумма до\nвыполнения',
              data: until,
              measure: untilMeasure,
              viewFullNumber: viewFullNumber,
            ),
            ResultInfoLine(
              title: 'Премия',
              data: prize,
              measure: prizeMeasure,
              viewFullNumber: viewFullNumber,
            ),
          ],
        );
      }
    );
  }
}
