import 'dart:async';

import '../models/analysis_chart.dart';
import '../repositories/analysis_chart_repository.dart';

class AnalysisChartBloc {
  AnalysisChartBloc(this._repository);

  final AnalysisChartRepository _repository;
  static StreamController _analysisChartStreamController;

  Stream<AnalysisChartState> get analysisChart {
    if (_analysisChartStreamController == null || _analysisChartStreamController.isClosed)
      _analysisChartStreamController = StreamController<AnalysisChartState>();
    return _analysisChartStreamController.stream;
  }

  void dispose() {
    _analysisChartStreamController.close();
  }

  void loadAnalysisChart() async {
    _analysisChartStreamController.sink.add(AnalysisChartState._analysisChartLoading());
    _repository.getAnalysisChart().then((analysisChart) {
      if (!_analysisChartStreamController.isClosed)
        _analysisChartStreamController.sink.add(AnalysisChartState._analysisChartData(analysisChart));
    }).onError((error, stackTrace) {
      if (!_analysisChartStreamController.isClosed)
        _analysisChartStreamController.sink.add(AnalysisChartState._analysisChartError(error,stackTrace));
    });
  }
}

class AnalysisChartState {
  AnalysisChartState();

  factory AnalysisChartState._analysisChartData(AnalysisChart analysisChart) = AnalysisChartDataState;

  factory AnalysisChartState._analysisChartLoading() = AnalysisChartLoadingState;

  factory AnalysisChartState._analysisChartError(Error error, StackTrace stackTrace) = AnalysisChartErrorState;
}

class AnalysisChartInitState extends AnalysisChartState {}

class AnalysisChartLoadingState extends AnalysisChartState {}

class AnalysisChartErrorState extends AnalysisChartState {
  AnalysisChartErrorState(this.error, this.stackTrace);

  final Error error;
  final StackTrace stackTrace;
}

class AnalysisChartDataState extends AnalysisChartState {
  AnalysisChartDataState(this.analysisChart);

  final AnalysisChart analysisChart;
}
