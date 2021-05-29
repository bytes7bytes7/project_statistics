import 'project_bloc.dart';
import 'plan_bloc.dart';
import '../repositories/repository.dart';

class Bloc {
  Bloc._privateConstructor();

  static final Bloc bloc = Bloc._privateConstructor();

  static PlanBloc _planBloc;
  static ProjectBloc _projectBloc;

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
}
