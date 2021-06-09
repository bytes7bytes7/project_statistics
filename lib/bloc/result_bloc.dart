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

  void loadResult() async {
    _resultStreamController.sink.add(ResultState._resultLoading());
    _repository.getResult().then((result) {
      if (!_resultStreamController.isClosed)
        _resultStreamController.sink.add(ResultState._resultData(result));
    }).onError((error, stackTrace) {
      if (!_resultStreamController.isClosed)
        _resultStreamController.sink.add(ResultState._resultError(error,stackTrace));
    });
  }
}

class ResultState {
  ResultState();

  factory ResultState._resultData(Result result) = ResultDataState;

  factory ResultState._resultLoading() = ResultLoadingState;

  factory ResultState._resultError(Error error, StackTrace stackTrace) = ResultErrorState;
}

class ResultInitState extends ResultState {}

class ResultLoadingState extends ResultState {}

class ResultErrorState extends ResultState {
  ResultErrorState(this.error, this.stackTrace);

  final Error error;
  final StackTrace stackTrace;
}

class ResultDataState extends ResultState {
  ResultDataState(this.result);

  final Result result;
}
