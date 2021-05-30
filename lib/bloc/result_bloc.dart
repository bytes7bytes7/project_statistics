import 'dart:async';

import '../models/result.dart';
import '../repositories/result_repository.dart';

class ResultBloc {
  ResultBloc(this._repository);

  final ResultRepository _repository;
  static StreamController _resultStreamController;

  Stream<ResultState> get result {
    if (_resultStreamController == null || _resultStreamController.isClosed)
      _resultStreamController = StreamController<ResultState>();
    return _resultStreamController.stream;
  }

  void dispose() {
    _resultStreamController.close();
  }

  void loadResult(String startPeriod, String endPeriod) async {
    _resultStreamController.sink.add(ResultState._resultLoading());
    _repository.getResult(startPeriod,endPeriod).then((result) {
      if (!_resultStreamController.isClosed)
        _resultStreamController.sink.add(ResultState._resultData(result));
    });
  }
}

class ResultState {
  ResultState();

  factory ResultState._resultData(Result result) = ResultDataState;

  factory ResultState._resultLoading() = ResultLoadingState;
}

class ResultInitState extends ResultState {}

class ResultLoadingState extends ResultState {}

class ResultDataState extends ResultState {
  ResultDataState(this.result);

  final Result result;
}
