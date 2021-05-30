import 'package:flutter/material.dart';

import 'package:project_statistics/bloc/analysis_chart_bloc.dart';
import 'package:project_statistics/bloc/bloc.dart';
import 'package:project_statistics/constants.dart';
import 'package:project_statistics/models/analysis_chart.dart';
import 'package:project_statistics/screens/widgets/percent_bar.dart';
import 'global/global_parameters.dart';
import 'widgets/flat_small_button.dart';
import 'widgets/loading_circle.dart';

class AnalysisChartScreen extends StatelessWidget {
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
            'Диаграмма',
            style: Theme.of(context).textTheme.headline1,
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.filter_alt_outlined),
              onPressed: () {},
              tooltip: GlobalParameters.appToolTips['filter'],
            ),
          ],
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
    Bloc.bloc.analysisChartBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: Bloc.bloc.analysisChartBloc.analysisChart,
      initialData: AnalysisChartInitState(),
      builder: (context, snapshot) {
        if (snapshot.data is AnalysisChartInitState) {
          Bloc.bloc.analysisChartBloc.loadAnalysisChart('', '');
          return SizedBox.shrink();
        } else if (snapshot.data is AnalysisChartLoadingState) {
          return _buildLoading();
        } else if (snapshot.data is AnalysisChartDataState) {
          AnalysisChartDataState state = snapshot.data;
          return ContentList(analysisChart: state.analysisChart);
        } else {
          return _buildError();
        }
      },
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
              Bloc.bloc.projectBloc.loadAllProjects();
            },
          ),
        ],
      ),
    );
  }
}

class ContentList extends StatelessWidget {
  const ContentList({
    Key key,
    @required this.analysisChart,
  }) : super(key: key);

  final AnalysisChart analysisChart;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 15,vertical: 15),
      itemCount: analysisChart.planQuantity.length + 1,
      itemBuilder: (context, i) {
        if (i == 0) {
          return Container();
        } else {
          return _AnalysisChartCard(
            primary: (i == analysisChart.planQuantity.length),
            title: ConstantData.appStatus[i - 1] + ' (шт.)',
            subtitle1: 'Реальное кол-во:',
            subtitle2: 'Плановое кол-во:',
            real: analysisChart.realQuantity[i - 1],
            plan: analysisChart.planQuantity[i - 1],
          );
        }
      },
    );
  }
}

class _AnalysisChartCard extends StatelessWidget {
  const _AnalysisChartCard({
    Key key,
    this.primary = false,
    @required this.title,
    @required this.subtitle1,
    @required this.subtitle2,
    @required this.real,
    @required this.plan,
  }) : super(key: key);

  final bool primary;
  final String title;
  final String subtitle1;
  final String subtitle2;
  final int real;
  final int plan;

  @override
  Widget build(BuildContext context) {
    Color color;
    if (primary)
      color = Theme.of(context).errorColor;
    else
      color = Theme.of(context).shadowColor;
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(vertical: 5),
      padding: const EdgeInsets.symmetric(horizontal: 14,vertical: 8),
      decoration: BoxDecoration(
        color: Theme.of(context).focusColor,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).shadowColor.withOpacity(0.3),
            spreadRadius: 1,
            blurRadius: 4,
            offset: Offset(2, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.bodyText1.copyWith(color: color),
          ),
          Row(
            children: [
              Text(
                subtitle1,
                style: Theme.of(context)
                    .textTheme
                    .headline2
                    .copyWith(color: color),
              ),
              Spacer(),
              Text(
                real.toString(),
                style: Theme.of(context)
                    .textTheme
                    .headline2
                    .copyWith(color: color),
              ),
            ],
          ),
          Row(
            children: [
              Text(
                subtitle2,
                style: Theme.of(context)
                    .textTheme
                    .subtitle2
                    .copyWith(color: color),
              ),
              Spacer(),
              Text(
                plan.toString(),
                style: Theme.of(context)
                    .textTheme
                    .subtitle2
                    .copyWith(color: color),
              ),
            ],
          ),
          PercentBar(
            percent: int.parse((100 * real / plan).toStringAsFixed(0)),
            color: (primary) ? color : Theme.of(context).primaryColor,
          ),
        ],
      ),
    );
  }
}
