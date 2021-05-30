import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:project_statistics/constants.dart';

class _ChartColumn {
  _ChartColumn({
    @required this.title,
    @required this.value,
    @required this.color,
  });

  final String title;
  final int value;
  final Color color;
}

class StackedHorizontalBarChart extends StatelessWidget {
  const StackedHorizontalBarChart({
    Key key,
    @required this.realQuantity,
    @required this.planQuantity,
    @required this.colors,
  }) : super(key: key);

  final List<int> realQuantity, planQuantity;
  final List<Color> colors;

  @override
  Widget build(BuildContext context) {
    List<_ChartColumn> chartRealData =
        List<_ChartColumn>.generate(realQuantity.length, (i) {
      return _ChartColumn(
        title: ConstantData.appStatus[i],
        value: realQuantity[i],
        color: colors[i],
      );
    });

    List<_ChartColumn> chartPlanData =
        List<_ChartColumn>.generate(planQuantity.length, (i) {
      return _ChartColumn(
        title: ConstantData.appStatus[i],
        value: planQuantity[i],
        color: colors[i].withOpacity(0.5),
      );
    });

    List<charts.Series<_ChartColumn, String>> chartData =
        List.generate(chartRealData.length, (i) {
      return charts.Series<_ChartColumn, String>(
        id: 'real $i',
        domainFn: (_, __) => ConstantData.appStatus[i],
        measureFn: (_, __) => realQuantity[i],
        data: [chartRealData[i]],
        seriesColor: charts.Color(
          r: chartRealData[i].color.red,
          g: chartRealData[i].color.green,
          b: chartRealData[i].color.blue,
          a: chartRealData[i].color.alpha,
        ),
      );
    });

    for (int i = 0; i < chartPlanData.length; i++) {
      chartData.add(charts.Series<_ChartColumn, String>(
        id: 'plan $i',
        domainFn: (_, __) => ConstantData.appStatus[i],
        measureFn: (_, __) => planQuantity[i],
        data: [chartPlanData[i]],
        seriesColor: charts.Color(
          r: chartPlanData[i].color.red,
          g: chartPlanData[i].color.green,
          b: chartPlanData[i].color.blue,
          a: chartPlanData[i].color.alpha,
        ),
      ));
    }

    return charts.BarChart(
      chartData,
      animate: true,
      barGroupingType: charts.BarGroupingType.stacked,
      vertical: false,
    );
  }
}
