import 'dart:async';

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

  void deletePlan(int id) async{
    _planStreamController.sink.add(PlanState._planLoading());
    _repository.deletePlan(id).then((value) {
      loadPlan();
    });
  }

  void updatePlan(Plan plan) async{
    _repository.updatePlan(plan);
  }

  void importExcel(Plan plan, List<Project> projects)async{
    _planStreamController.sink.add(PlanState._planLoading());
    await _repository.importExcel(plan, projects).then((value) {
      loadPlan();
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
