import 'dart:async';

import '../global/global_parameters.dart';
import '../models/project.dart';
import '../models/plan.dart';
import '../repositories/plan_repository.dart';

class PlanBloc {
  PlanBloc(this._repository);

  final PlanRepository _repository;
  static StreamController _planStreamController;

  Stream<PlanState> get plan {
    if (_planStreamController == null || _planStreamController.isClosed)
      _planStreamController = StreamController<PlanState>.broadcast();
    return _planStreamController.stream;
  }

  void dispose() {
    _planStreamController.close();
  }

  void loadPlan() async {
    _planStreamController.sink.add(PlanState._planLoading());
    _repository.getPlan().then((plan) {
      if (!_planStreamController.isClosed)
        _planStreamController.sink.add(PlanState._planData(plan));
    }).onError((error, stackTrace) {
      if (!_planStreamController.isClosed)
        _planStreamController.sink.add(PlanState._planError(error,stackTrace));
    });
  }

  Future deletePlan(int id) async{
    _planStreamController.sink.add(PlanState._planLoading());
    _repository.deletePlan(id).then((value) {
      loadPlan();
    }).onError((error, stackTrace) {
      if (!_planStreamController.isClosed)
        _planStreamController.sink.add(PlanState._planError(error,stackTrace));
    });
  }

  void updatePlan(Plan plan) async{
    _planStreamController.sink.add(PlanState._planLoading());
    _repository.updatePlan(plan).then((value) {
      loadPlan();
      GlobalParameters.planStartYear = int.parse(plan.start.substring(plan.start.indexOf(' ')+1,plan.start.length));
      GlobalParameters.planEndYear = int.parse(plan.end.substring(plan.end.indexOf(' ')+1,plan.end.length));
    }).onError((error, stackTrace) {
      if (!_planStreamController.isClosed)
        _planStreamController.sink.add(PlanState._planError(error,stackTrace));
    });
  }

  Future importExcel(Plan plan, List<Project> projects)async{
    _planStreamController.sink.add(PlanState._planLoading());
    await _repository.importExcel(plan, projects).then((value)async {
      loadPlan();
    }).onError((error, stackTrace) {
      if (!_planStreamController.isClosed)
        _planStreamController.sink.add(PlanState._planError(error,stackTrace));
    });
  }
}

class PlanState {
  PlanState();

  factory PlanState._planData(Plan plan) = PlanDataState;

  factory PlanState._planLoading() = PlanLoadingState;

  factory PlanState._planError(Error error, StackTrace stackTrace) = PlanErrorState;
}

class PlanInitState extends PlanState {}

class PlanLoadingState extends PlanState {}

class PlanErrorState extends PlanState {
  PlanErrorState(this.error, this.stackTrace);

  final Error error;
  final StackTrace stackTrace;
}

class PlanDataState extends PlanState {
  PlanDataState(this.plan);

  final Plan plan;
}
