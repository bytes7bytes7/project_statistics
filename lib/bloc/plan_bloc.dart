import 'dart:async';

import '../models/plan.dart';
import '../repositories/plan_repository.dart';

class PlanBloc {
  PlanBloc(this._repository);

  final PlanRepository _repository;
  static StreamController _planStreamController;

  Stream<PlanState> get plan {
    if (_planStreamController == null || _planStreamController.isClosed)
      _planStreamController = StreamController<PlanState>();
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
}

class PlanState {
  PlanState();

  factory PlanState._planData(Plan plan) = PlanDataState;

  factory PlanState._planLoading() = PlanLoadingState;
}

class PlanInitState extends PlanState {}

class PlanLoadingState extends PlanState {}

class PlanDataState extends PlanState {
  PlanDataState(this.plan);

  final Plan plan;
}
