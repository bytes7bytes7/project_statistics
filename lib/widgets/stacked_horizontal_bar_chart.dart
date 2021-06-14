import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;

import '../constants.dart';

class _ChartColumn {
  _ChartColumn({
    @required this.title,
    @required this.value,
    @required this.color,
  });

  final String title;
  final dynamic value;
  final Color color;
}

class StackedHorizontalBarChart extends StatelessWidget {
  StackedHorizontalBarChart({
    Key key,
    @required List<dynamic> r,
    @required List<dynamic> p,
    @required this.colors,
  }){
    List<dynamic> tmp=[];
    r.forEach((element) {
      tmp.add(element);
    });
    real = tmp;
    List<dynamic> tmp2=[];
    p.forEach((element) {
      tmp2.add(element);
    });
    plan = tmp2;
  }

  List<dynamic> real, plan;
  List<Color> colors;

  @override
  Widget build(BuildContext context) {
    for(int i =0;i<plan.length;i++){
      plan[i]-=real[i];
      if(plan[i]<0) plan[i]=0;
    }

    List<_ChartColumn> chartRealData =
        List<_ChartColumn>.generate(real.length, (i) {
      return _ChartColumn(
        title: ProjectStatuses()[i],
        value: real[i],
        color: colors[i],
      );
    });

    List<_ChartColumn> chartPlanData =
        List<_ChartColumn>.generate(plan.length, (i) {
      return _ChartColumn(
        title: ProjectStatuses()[i],
        value: plan[i],
        color: colors[i].withOpacity(0.5),
      );
    });

    List<charts.Series<_ChartColumn, String>> chartData = [];

    for (int i = 0; i < chartPlanData.length; i++) {
      chartData.add(charts.Series<_ChartColumn, String>(
        id: 'plan $i',
        domainFn: (_, __) => ProjectStatuses()[i],
        measureFn: (_, __) => plan[i],
        data: [chartPlanData[i]],
        seriesColor: charts.Color(
          r: chartPlanData[i].color.red,
          g: chartPlanData[i].color.green,
          b: chartPlanData[i].color.blue,
          a: chartPlanData[i].color.alpha,
        ),
      ));
    }

    for (int i = 0; i < chartRealData.length; i++) {
      chartData.add(charts.Series<_ChartColumn, String>(
        id: 'real $i',
        domainFn: (_, __) => ProjectStatuses()[i],
        measureFn: (_, __) => real[i],
        data: [chartRealData[i]],
        seriesColor: charts.Color(
          r: chartRealData[i].color.red,
          g: chartRealData[i].color.green,
          b: chartRealData[i].color.blue,
          a: chartRealData[i].color.alpha,
        ),
      ));
    }

    return RotationTransition(
      turns: AlwaysStoppedAnimation(90 / 360),
      child: charts.BarChart(
        chartData,
        animate: false,
        barGroupingType: charts.BarGroupingType.stacked,
        vertical: true,
        domainAxis: charts.OrdinalAxisSpec(
          showAxisLine: true,
          renderSpec: charts.SmallTickRendererSpec(
            labelAnchor: charts.TickLabelAnchor.centered,
            tickLengthPx: 0,
            labelOffsetFromAxisPx: 7,
          ),
        ),
      ),
    );
  }
}
