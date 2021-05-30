import 'result_bloc.dart';
import 'project_bloc.dart';
import 'plan_bloc.dart';
import '../repositories/repository.dart';

class Bloc {
  Bloc._privateConstructor();

  static final Bloc bloc = Bloc._privateConstructor();

  static PlanBloc _planBloc;
  static ProjectBloc _projectBloc;
  static ResultBloc _resultBloc;

  PlanBloc get planBloc {
    if (_planBloc != null) return _planBloc;
    _planBloc = PlanBloc(Repository.planRepository);
    return _planBloc;
  }

  ProjectBloc get projectBloc {
    if (_projectBloc != null) return _projectBloc;
    _projectBloc = ProjectBloc(Repository.projectRepository);
    return _projectBloc;
  }

  ResultBloc get resultBloc {
    if (_resultBloc != null) return _resultBloc;
    _resultBloc = ResultBloc(Repository.resultRepository);
    return _resultBloc;
  }
}
